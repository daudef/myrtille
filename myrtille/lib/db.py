import contextlib
import time
import typing

import asyncmy
import pydantic

from myrtille.lib import cfg

ParamsType: typing.TypeAlias = typing.Collection[typing.Any]
Querriable: typing.TypeAlias = "Database | Connection"


def _format_request(stmt: str, *, params: ParamsType | None = None):
    if params is not None:
        try:
            stmt = stmt % tuple(params)
        except Exception:
            if len(params) == 0:
                param_part = "no params"
            else:
                param_part = f"params {', '.join(map(repr, params))}"
            stmt = f"Invalid stmt '{stmt}' with {param_part}"
    return f"Request '{' '.join(stmt.split())}'"


class Database(pydantic.BaseModel):
    model_config = pydantic.ConfigDict(arbitrary_types_allowed=True)

    config: cfg.Database
    pool: asyncmy.pool.Pool = pydantic.Field(exclude=True)

    @contextlib.asynccontextmanager
    async def acquire(self):
        async with self.pool.acquire() as cnx:
            yield Connection(database=self, cnx=cnx)
            await cnx.rollback()

    async def execute(
        self,
        stmt: str,
        *,
        params: ParamsType | None = None,
    ):
        async with self.acquire() as cnx:
            await cnx.execute(stmt, params=params)
            await cnx.commit()

    async def fetch_all(
        self,
        stmt: str,
        *,
        params: typing.Sequence[typing.Any] | None = None,
    ):
        async with self.acquire() as cnx:
            return await cnx.fetch_all(stmt, params=params)

    async def fetch_optional(
        self,
        stmt: str,
        *,
        params: typing.Sequence[typing.Any] | None = None,
    ):
        async with self.acquire() as cnx:
            return await cnx.fetch_optional(stmt, params=params)


class Connection(pydantic.BaseModel):
    model_config = pydantic.ConfigDict(arbitrary_types_allowed=True)

    database: Database
    cnx: asyncmy.connection.Connection

    async def execute(self, stmt: str, *, params: ParamsType | None = None):
        t0 = time.perf_counter()
        try:
            async with self.cnx.cursor() as cursor:
                await cursor.execute(stmt, params)
                if self.database.config.echo:
                    print(
                        f"Log: {_format_request(stmt, params=params)}: {time.perf_counter() - t0:2.2f}s"
                    )
        except Exception as e:
            e.add_note(f"In {_format_request(stmt, params=params)}")
            raise

    async def fetch_all(
        self, stmt: str, params: typing.Sequence[typing.Any] | None = None
    ):
        t0 = time.perf_counter()
        try:
            async with self.cnx.cursor() as cursor:
                await cursor.execute(stmt, params)
                rows = await cursor.fetchall()
                if self.database.config.echo:
                    print(
                        f"Log: {_format_request(stmt, params=params)}: {time.perf_counter() - t0:2.2f}s"
                    )
                return rows
        except Exception as e:
            e.add_note(f"In {_format_request(stmt, params=params)}")
            raise

    async def fetch_optional(
        self, stmt: str, params: typing.Sequence[typing.Any] | None = None
    ):
        rows = await self.fetch_all(stmt, params)
        if len(rows) > 1:
            raise Exception(
                f"{_format_request(stmt, params=params)} returned {len(rows)} (!= 1) rows"
            )
        elif len(rows) == 0:
            return None
        return rows[0]

    async def commit(self):
        await self.cnx.commit()


@contextlib.asynccontextmanager
async def make_database(db_config: cfg.Database):
    async with asyncmy.pool.create_pool(
        host=db_config.host,
        port=db_config.port,
        user=db_config.user,
        password=db_config.password,
        autocommit=False,
        echo=db_config.echo or False,
        connect_timeout=db_config.timeout.total_seconds()
        if db_config.timeout is not None
        else 31536000,
        minsize=db_config.pool_size or 1,
        maxsize=db_config.pool_size or 1,
    ) as pool:
        try:
            yield Database(config=db_config, pool=pool)
        finally:
            pool.close()
            await pool.wait_closed()

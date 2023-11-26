import asyncio
import datetime
import pathlib
import sys
import typing
import re

import typer
import pydantic

from myrtille.lib import db, cfg, util


class Table(pydantic.BaseModel):
    schema_name: str
    table_name: str

    async def get_ddl(self, database: db.Database):
        show_create_response = await database.fetch_optional(
            f"SHOW CREATE TABLE `{self.schema_name}`.`{self.table_name}`"
        )
        assert show_create_response is not None
        (_, ddl) = show_create_response
        assert isinstance(ddl, str)
        return ddl


def correct_ddl(ddl: str):
    # Removes display width on interer types
    # Removes floating point precision on time functions
    for s in [
        "tinyint",
        "smallint",
        "int",
        "bigint",
        "DEFAULT CURRENT_TIMESTAMP",
        "ON UPDATE CURRENT_TIMESTAMP",
    ]:
        ddl = re.sub(rf" {s}\([0-9]*\)", f" {s}", ddl, flags=re.IGNORECASE)

    # Removes non standart float precision
    for s in ["float", "double"]:
        ddl = re.sub(rf" {s}\([0-9]*,[0-9]*\)", f" {s}", ddl, flags=re.IGNORECASE)

    return ddl


async def main(
    user: str,
    password: str,
    host: str,
    port: int,
    echo: bool,
    timeout: datetime.timedelta | None,
    output_file: typing.TextIO,
):
    async with db.make_database(
        cfg.Database(
            user=user,
            password=password,
            host=host,
            port=port,
            echo=echo,
            pool_size=1,
            timeout=timeout,
        )
    ) as database:
        schema_names = [
            schema_name
            for (schema_name,) in await database.fetch_all(
                """
                    SELECT SCHEMA_NAME
                    FROM INFORMATION_SCHEMA.SCHEMATA
                """
            )
        ]

        schema_name = util.print_choose(schema_names, file=sys.stderr)
        assert isinstance(schema_name, str)

        tables = [
            Table(schema_name=schema_name, table_name=table_name)
            for (table_name,) in await database.fetch_all(
                """
                SELECT TABLE_NAME
                    FROM INFORMATION_SCHEMA.TABLES
                    WHERE TABLE_TYPE = "BASE TABLE"
                    AND TABLE_SCHEMA = %s
                """,
                params=[schema_name],
            )
        ]

        ddls = await util.gather_i_future([table.get_ddl(database) for table in tables])
        output_file.write("\n\n\n".join(correct_ddl(ddl) for ddl in ddls))


def _main(
    user: str,
    password: str,
    host: str = "localhost",
    port: int = 3306,
    echo: bool = False,
    timeout_s: typing.Optional[float] = None,
    output_path: typing.Optional[pathlib.Path] = None,
):
    with util.optional_ctx(
        output_path.open(mode="w", encoding="utf-8")
        if output_path is not None
        else None
    ) as output_file:
        asyncio.run(
            main(
                user=user,
                password=password,
                host=host,
                port=port,
                echo=echo,
                timeout=datetime.timedelta(seconds=timeout_s)
                if timeout_s is not None
                else None,
                output_file=output_file or sys.stdout,
            )
        )


if __name__ == "__main__":
    typer.run(_main)

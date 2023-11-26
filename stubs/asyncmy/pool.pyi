import typing

from .cursor import Cursor
from .connection import Connection

class Pool:
    def close(self) -> None: ...
    async def wait_closed(self) -> None: ...
    def acquire(self) -> typing.AsyncContextManager[Connection]: ...

def create_pool(
    user: str = ...,
    password: str = ...,
    host: str = ...,
    database: str | None = ...,
    unix_socket: str | None = ...,
    port: int = ...,
    cursor_cls: Cursor = ...,
    init_command: str | None = ...,
    connect_timeout: float | None = ...,
    autocommit: bool = ...,
    read_timeout: float | None = ...,
    ssl: bool | None = ...,
    minsize: int = ...,
    maxsize: int = ...,
    echo: bool = ...,
    pool_recycle: float = ...,
    **kwargs: typing.Any
) -> typing.AsyncContextManager[Pool]:
    pass

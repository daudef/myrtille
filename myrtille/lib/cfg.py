import datetime
import pydantic


class Database(pydantic.BaseModel):
    user: str
    password: str
    host: str
    port: int
    echo: bool | None = None
    pool_size: int | None = None
    timeout: datetime.timedelta | None = None

import pydantic
import typing
import enum


###############
### General ###
###############


class TextLiteral(pydantic.BaseModel):
    charset: str | None
    text: str


class NullLiteral(pydantic.BaseModel):
    pass


Literal: typing.TypeAlias = TextLiteral | NullLiteral


class QualIdentifier(pydantic.BaseModel):
    qualification: str | None
    identifier: str


class BinaryCharset(pydantic.BaseModel):
    pass


class Direction(enum.Enum):
    ASC = enum.auto()
    DESC = enum.auto()


#################
### Data Type ###
#################


class Tinyint(pydantic.BaseModel):
    unsigned: bool
    auto_increment: bool


class Smallint(pydantic.BaseModel):
    unsigned: bool
    auto_increment: bool


class Mediumint(pydantic.BaseModel):
    unsigned: bool
    auto_increment: bool


class Int(pydantic.BaseModel):
    unsigned: bool
    auto_increment: bool


class Bigint(pydantic.BaseModel):
    unsigned: bool
    auto_increment: bool


class Decimal(pydantic.BaseModel):
    precision: int | None
    scale: int | None


class Float(pydantic.BaseModel):
    pass


class Double(pydantic.BaseModel):
    pass


class Bit(pydantic.BaseModel):
    length: int | None


class Datetime(pydantic.BaseModel):
    precision: int | None
    default_now: bool
    on_update_now: bool


class Timestamp(pydantic.BaseModel):
    precision: int | None
    default_now: bool
    on_update_now: bool


class Time(pydantic.BaseModel):
    precision: int | None


class Date(pydantic.BaseModel):
    pass


class Year(pydantic.BaseModel):
    pass


class Char(pydantic.BaseModel):
    length: int
    charset: str | None
    collate: str | None


class Varchar(pydantic.BaseModel):
    length: int
    charset: str | None
    collate: str | None


class TinyText(pydantic.BaseModel):
    charset: str | None
    collate: str | None


class Text(pydantic.BaseModel):
    charset: str | None
    collate: str | None


class MediumText(pydantic.BaseModel):
    charset: str | None
    collate: str | None


class LongText(pydantic.BaseModel):
    charset: str | None
    collate: str | None


class Enum(pydantic.BaseModel):
    values: list[str]
    charset: str | None
    collate: str | None


class Set(pydantic.BaseModel):
    values: list[str]
    charset: str | None
    collate: str | None


class Binary(pydantic.BaseModel):
    length: int


class Varbinary(pydantic.BaseModel):
    length: int


class TinyBlob(pydantic.BaseModel):
    pass


class Blob(pydantic.BaseModel):
    pass


class MediumBlob(pydantic.BaseModel):
    pass


class LongBlob(pydantic.BaseModel):
    pass


class Geometry(pydantic.BaseModel):
    srid: int | None


class Point(pydantic.BaseModel):
    srid: int | None


class Linestring(pydantic.BaseModel):
    srid: int | None


class Polygon(pydantic.BaseModel):
    srid: int | None


class Geometrycollection(pydantic.BaseModel):
    srid: int | None


class Multipoint(pydantic.BaseModel):
    srid: int | None


class Multilinestring(pydantic.BaseModel):
    srid: int | None


class Multipolygon(pydantic.BaseModel):
    srid: int | None


class Json(pydantic.BaseModel):
    pass


IntegerDataType: typing.TypeAlias = Tinyint | Smallint | Mediumint | Int | Bigint
TextDataType: typing.TypeAlias = (
    Char | Varchar | TinyText | Text | MediumText | LongText | Enum | Set
)
SpatialDataType: typing.TypeAlias = (
    Geometry
    | Point
    | Linestring
    | Polygon
    | Geometrycollection
    | Multipoint
    | Multilinestring
    | Multipolygon
)

DataType: typing.TypeAlias = (
    IntegerDataType
    | Decimal
    | Float
    | Double
    | Bit
    | Datetime
    | Timestamp
    | Time
    | Date
    | Year
    | TextDataType
    | Binary
    | Varbinary
    | TinyBlob
    | Blob
    | MediumBlob
    | LongBlob
    | SpatialDataType
    | Json
)


##################
### Attributes ###
##################


class ColumnFormat(enum.Enum):
    FIXED = enum.auto()
    DYNAMIC = enum.auto()
    DEFAULT = enum.auto()


class StorageMedia(enum.Enum):
    DISK = enum.auto()
    MEMORY = enum.auto()
    DEFAULT = enum.auto()


class GenerationType(enum.Enum):
    VIRTUAL = enum.auto()
    STORED = enum.auto()


class NonNullableAttribute(pydantic.BaseModel):
    pass


class NullableAttribute(pydantic.BaseModel):
    pass


class LiteralDefaultAttribute(pydantic.BaseModel):
    value: Literal


class ExprDefaultAttribute(pydantic.BaseModel):
    expr: str


class NowDefaultAttribute(pydantic.BaseModel):
    pass


class GeneratedAttribute(pydantic.BaseModel):
    expr: str
    type: GenerationType


class OnUpdateNowAttribute(pydantic.BaseModel):
    pass


class CommentAttribute(pydantic.BaseModel):
    comment: TextLiteral


class InvisibleAttribute(pydantic.BaseModel):
    pass


class AutoIncrementAttribute(pydantic.BaseModel):
    pass


class UnsignedAttribute(pydantic.BaseModel):
    pass


class CharsetAttribute(pydantic.BaseModel):
    charset: str | BinaryCharset


class CollateAttribute(pydantic.BaseModel):
    collate: str


class SridAttribute(pydantic.BaseModel):
    srid: int


Attribute: typing.TypeAlias = (
    NonNullableAttribute
    | NullableAttribute
    | LiteralDefaultAttribute
    | ExprDefaultAttribute
    | NowDefaultAttribute
    | GeneratedAttribute
    | OnUpdateNowAttribute
    | CommentAttribute
    | ColumnFormat
    | StorageMedia
    | InvisibleAttribute
    | AutoIncrementAttribute
    | UnsignedAttribute
    | CharsetAttribute
    | CollateAttribute
    | SridAttribute
)

DefaultValue: typing.TypeAlias = ExprDefaultAttribute | LiteralDefaultAttribute


######################
### Create Options ###
######################


class Rowformat(enum.Enum):
    DEFAULT = enum.auto()
    DYNAMIC = enum.auto()
    FIXED = enum.auto()
    COMPRESSED = enum.auto()
    REDUNDANT = enum.auto()
    COMPACT = enum.auto()


class InsertMethod(enum.Enum):
    NO = enum.auto()
    FIRST = enum.auto()
    LAST = enum.auto()


class StorageType(enum.Enum):
    DISK = enum.auto()
    MEMORY = enum.auto()


class EngineCreateOption(pydantic.BaseModel):
    name: str


class AutoIncrementCreateOption(pydantic.BaseModel):
    value: int


class CommentCreateOption(pydantic.BaseModel):
    comment: TextLiteral


class StatsPersistentCreateOption(pydantic.BaseModel):
    option: bool


class RowFormatCreateOption(pydantic.BaseModel):
    format: Rowformat


class CharsetCreateOption(pydantic.BaseModel):
    charset: str | BinaryCharset


class CollateCreateOption(pydantic.BaseModel):
    collate: str


class TablespaceCreateOption(pydantic.BaseModel):
    name: str


CreateOption: typing.TypeAlias = (
    EngineCreateOption
    | AutoIncrementCreateOption
    | CommentCreateOption
    | StatsPersistentCreateOption
    | RowFormatCreateOption
    | CharsetCreateOption
    | CollateCreateOption
    | TablespaceCreateOption
)


class CreateOptions(pydantic.BaseModel):
    engine: str | None
    max_rows: int | None
    min_rows: int | None
    avg_row_length: int | None
    password: TextLiteral | None
    comment: str | None
    compression: TextLiteral | None
    encryption: TextLiteral | None
    auto_increment: int | None
    pack_keys: bool | None
    stats_auto_recalc: bool | None
    stats_persistent: bool | None
    stats_sample_pages: bool | None
    checksum: int | None
    delay_key_write: int | None
    row_format: Rowformat | None
    union: list[QualIdentifier] | None
    charset: str | None
    collate: str | None
    insert_method: InsertMethod | None
    data_directory: TextLiteral | None
    index_directory: TextLiteral | None
    tablespace: str | None
    storage: StorageType | None
    connection: TextLiteral | None
    key_block_size: int | None


##################
### Constraint ###
##################


class IdentifierKeyPart(pydantic.BaseModel):
    identifier: str
    length: int | None
    direction: Direction | None


KeyPart: typing.TypeAlias = IdentifierKeyPart


class IndexType(enum.Enum):
    BTREE = enum.auto()
    RTREE = enum.auto()
    HASH = enum.auto()


class ConstraintEnforcement(enum.Enum):
    ENFORCED = enum.auto()
    NOT_ENFORCED = enum.auto()


class IndexOptions(pydantic.BaseModel):
    key_block_size: int | None
    comment: str | None
    invisible: bool


class RefAction(enum.Enum):
    RESTRICT = enum.auto()
    CASCADE = enum.auto()
    SET_NULL = enum.auto()


class OnDeleteRefRule(pydantic.BaseModel):
    action: RefAction


class OnUpdateRefRule(pydantic.BaseModel):
    action: RefAction


RefRule: typing.TypeAlias = OnDeleteRefRule | OnUpdateRefRule


class References(pydantic.BaseModel):
    ref_table: QualIdentifier
    ref_columns: list[str]
    on_update: RefAction | None
    on_delete: RefAction | None


class PrimaryConstraint(pydantic.BaseModel):
    type: IndexType | None
    key_list: list[KeyPart]
    options: IndexOptions


class UniqueConstraint(pydantic.BaseModel):
    name: str | None
    type: IndexType | None
    key_list: list[KeyPart]
    options: IndexOptions


class IndexConstraint(pydantic.BaseModel):
    name: str | None
    type: IndexType | None
    key_list: list[KeyPart]
    options: IndexOptions


class FulltextConstraint(pydantic.BaseModel):
    name: str | None
    key_list: list[KeyPart]
    parser: str | None
    options: IndexOptions


class SpatialConstraint(pydantic.BaseModel):
    name: str | None
    key_list: list[KeyPart]
    options: IndexOptions


class ForeignConstraint(pydantic.BaseModel):
    name: str | None
    columns: list[str]
    references: References


class CheckConstraint(pydantic.BaseModel):
    name: str | None
    expr: str
    enforcement: ConstraintEnforcement


Constraint: typing.TypeAlias = (
    PrimaryConstraint
    | UniqueConstraint
    | IndexConstraint
    | FulltextConstraint
    | SpatialConstraint
    | ForeignConstraint
    | CheckConstraint
)


############
### Main ###
############


class Column(pydantic.BaseModel):
    name: str
    data_type: DataType

    non_nullable: bool | None
    default_value: DefaultValue | None
    comment: str | None
    invisible: bool

    format: ColumnFormat  # Default is ColumnFormat.DEFAULT
    storage_media: StorageMedia  # Default is StorageMedia.DEFAULT
    generated: GeneratedAttribute | None


class Table(pydantic.BaseModel):
    name: str
    columns: list[Column]
    constraints: list[Constraint]
    options: CreateOptions

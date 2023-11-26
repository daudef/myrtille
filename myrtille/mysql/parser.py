import dataclasses
import itertools
import pathlib
import typing

import lark
import pydantic

from myrtille.mysql import types


Terminal: typing.TypeAlias = lark.lexer.Token
Meta: typing.TypeAlias = lark.tree.Meta


def v_args[
    R, **P
](inline: bool = False, meta: bool = False) -> typing.Callable[
    [typing.Callable[P, R]], typing.Callable[P, R]
]:
    # type ignore because original lark.v_args typing does not work
    return lark.v_args(inline=inline, meta=meta, tree=False)  # type: ignore


def inline[R, **P](f: typing.Callable[P, R]) -> typing.Callable[P, R]:
    return v_args(inline=True)(f)


def get_child[R](children: typing.Sequence[R], *, position: int | None) -> R:
    if position is None:
        assert len(children) == 1
        return children[0]
    else:
        return children[position]


def through(position: int | None = None):
    def _handler(self: typing.Any, children: typing.Sequence[typing.Any]):
        return get_child(children, position=position)

    return _handler


def list_(self: typing.Any, children: list[typing.Any]):
    return children


def wrap_pydantic(model: type[pydantic.BaseModel], position: int | None = None):
    field_name = next(iter(model.model_fields))

    def _handler(self: typing.Any, children: typing.Sequence[typing.Any]):
        return model(**{field_name: get_child(children, position=position)})

    return _handler


def call(f: typing.Callable[[Terminal], typing.Any]):
    @inline
    def _handler(self: typing.Any, child: Terminal):
        return f(child)

    return _handler


def const(v: typing.Any):
    def _handler(self: typing.Any, children: typing.Any):
        return v

    return _handler


def const_call(f: typing.Callable[[], typing.Any]):
    def _handler(self: typing.Any, children: typing.Any):
        return f()

    return _handler


class Transformer(lark.Transformer[typing.Any, types.Table]):
    def __init__(
        self,
        original_text: str,
        visit_tokens: bool = True,
    ) -> None:
        self.original_text = original_text

        super().__init__(visit_tokens)

    ### Main

    @inline
    def column_definition(
        self, name: str, data_type: types.DataType, *attributes: types.Attribute
    ):
        column = types.Column(
            name=name,
            data_type=data_type,
            non_nullable=None,
            default_value=None,
            comment=None,
            invisible=False,
            format=types.ColumnFormat.DEFAULT,
            storage_media=types.StorageMedia.DEFAULT,
            generated=None,
        )
        for attribute in attributes:
            match attribute:
                case types.NonNullableAttribute():
                    column.non_nullable = True
                case types.NullableAttribute():
                    column.non_nullable = False
                case types.LiteralDefaultAttribute():
                    column.default_value = attribute
                case types.ExprDefaultAttribute():
                    column.default_value = attribute
                case types.NowDefaultAttribute():
                    assert isinstance(
                        column.data_type, (types.Datetime, types.Timestamp)
                    )
                    column.data_type.default_now = True
                case types.GeneratedAttribute():
                    column.generated = attribute
                case types.OnUpdateNowAttribute():
                    assert isinstance(
                        column.data_type, (types.Datetime, types.Timestamp)
                    )
                    column.data_type.on_update_now = True
                case types.CommentAttribute():
                    column.comment = attribute.comment.text
                case types.ColumnFormat():
                    column.format = attribute
                case types.StorageMedia():
                    column.storage_media = attribute
                case types.InvisibleAttribute():
                    column.invisible = True
                case types.AutoIncrementAttribute():
                    assert isinstance(column.data_type, types.IntegerDataType)
                    column.data_type.auto_increment = True
                case types.UnsignedAttribute():
                    assert isinstance(column.data_type, types.IntegerDataType)
                    column.data_type.unsigned = True
                case types.CharsetAttribute():
                    assert isinstance(column.data_type, types.TextDataType)
                    if isinstance(attribute.charset, types.BinaryCharset):
                        column.data_type.charset = "binary"
                    else:
                        column.data_type.charset = attribute.charset
                case types.CollateAttribute():
                    assert isinstance(column.data_type, types.TextDataType)
                    column.data_type.collate = attribute.collate
                case types.SridAttribute():
                    assert isinstance(column.data_type, types.SpatialDataType)
                    column.data_type.srid = attribute.srid
        return column

    table_element = through()
    table_element_list = list_

    @inline
    def create_table(
        self,
        name: str,
        elements: list[types.Column | types.Constraint],
        options: types.CreateOptions,
        _partition: typing.Any | None,
    ):
        return types.Table(
            name=name,
            columns=[e for e in elements if isinstance(e, types.Column)],
            constraints=[e for e in elements if isinstance(e, types.Constraint)],
            options=options,
        )

    ### Types

    tinyint_data_type = const_call(
        lambda: types.Tinyint(unsigned=False, auto_increment=False)
    )
    smallint_data_type = const_call(
        lambda: types.Smallint(unsigned=False, auto_increment=False)
    )
    mediumint_data_type = const_call(
        lambda: types.Mediumint(unsigned=False, auto_increment=False)
    )
    int_data_type = const_call(lambda: types.Int(unsigned=False, auto_increment=False))
    bigint_data_type = const_call(
        lambda: types.Bigint(unsigned=False, auto_increment=False)
    )

    @inline
    def fixed_point_data_type(self, _: typing.Any, args: tuple[int, int]):
        return types.Decimal(precision=args[0], scale=args[1])

    float_data_type = const_call(types.Float)
    double_data_type = const_call(types.Double)

    @inline
    def bit_data_type(self, length: int | None):
        return types.Bit(length=length or 1)

    @inline
    def datetime_data_type(self, precision: int | None):
        return types.Datetime(
            precision=precision, default_now=False, on_update_now=False
        )

    @inline
    def timestamp_data_type(self, precision: int | None):
        return types.Timestamp(
            precision=precision, default_now=False, on_update_now=False
        )

    date_data_type = const_call(types.Date)

    @inline
    def time_data_type(self, precision: int | None):
        return types.Time(precision=precision)

    year_data_type = const_call(types.Year)

    @inline
    def char_data_type(self, _char: Terminal, length: int | None):
        return types.Char(length=length or 1, charset=None, collate=None)

    @inline
    def varchar_data_type(self, _char: Terminal, length: int):
        return types.Varchar(length=length, charset=None, collate=None)

    @inline
    def binary_data_type(self, _: Terminal, length: int | None):
        return types.Binary(length=length or 1)

    @inline
    def varbinary_data_type(self, length: int):
        return types.Varbinary(length=length)

    tinytext_data_type = const_call(lambda: types.TinyText(charset=None, collate=None))
    text_data_type = const_call(lambda: types.Text(charset=None, collate=None))
    mediumtext_data_type = const_call(
        lambda: types.MediumText(charset=None, collate=None)
    )
    longtext_data_type = const_call(lambda: types.LongText(charset=None, collate=None))
    tinyblob_data_type = const_call(types.TinyBlob)
    blob_data_type = const_call(types.Blob)
    mediumblob_data_type = const_call(types.MediumBlob)
    longblob_data_type = const_call(types.LongBlob)

    @inline
    def enum_data_type(self, values: list[str]):
        return types.Enum(values=values, charset=None, collate=None)

    @inline
    def set_data_type(self, values: list[str]):
        return types.Set(values=values, charset=None, collate=None)

    geometry_data_type = const_call(lambda: types.Geometry(srid=None))
    point_data_type = const_call(lambda: types.Point(srid=None))
    linestring_data_type = const_call(lambda: types.Linestring(srid=None))
    polygon_data_type = const_call(lambda: types.Polygon(srid=None))
    geometrycollection_data_type = const_call(
        lambda: types.Geometrycollection(srid=None)
    )
    multipoint_data_type = const_call(lambda: types.Multipoint(srid=None))
    multilinestring_data_type = const_call(lambda: types.Multilinestring(srid=None))
    multipolygon_data_type = const_call(lambda: types.Multipolygon(srid=None))

    json_data_type = const_call(types.Json)

    ### Attributes

    virtual_generation_type = const(types.GenerationType.VIRTUAL)
    stored_generation_type = const(types.GenerationType.STORED)

    non_nullable_attribute = const_call(types.NonNullableAttribute)
    nullable_attribute = const_call(types.NullableAttribute)
    literal_default_attribute = wrap_pydantic(types.LiteralDefaultAttribute)
    expr_default_attribute = wrap_pydantic(types.ExprDefaultAttribute)
    now_default_attribute = const_call(types.NowDefaultAttribute)

    @inline
    def generated_attribute(self, expr: str, type: types.GenerationType | None):
        return types.GeneratedAttribute(
            expr=expr, type=type if type is not None else types.GenerationType.VIRTUAL
        )

    on_update_attribute = const_call(types.OnUpdateNowAttribute)
    comment_attribute = wrap_pydantic(types.CommentAttribute)

    dynamic_column_format = const(types.ColumnFormat.DYNAMIC)
    fixed_column_format = const(types.ColumnFormat.FIXED)
    column_format_attribute = through()

    disk_storage_media = const(types.StorageMedia.DISK)
    memory_storage_media = const(types.StorageMedia.MEMORY)
    storage_attribute = through()

    auto_increment_attribute = const_call(types.AutoIncrementAttribute)
    unsigned_attribute = const_call(types.UnsignedAttribute)

    charset_attribute = wrap_pydantic(types.CharsetAttribute, position=1)
    collate_attribute = wrap_pydantic(types.CollateAttribute)

    custom_charset = through()
    binary_charset = const_call(types.BinaryCharset)

    invisible_attribute = const_call(types.InvisibleAttribute)
    srid_attribute = wrap_pydantic(types.SridAttribute)

    ### Constraints

    @inline
    def identifier_key_part(
        self, identifier: str, length: int | None, direction: types.Direction | None
    ):
        return types.IdentifierKeyPart(
            identifier=identifier, length=length, direction=direction
        )

    constraint_name = through()

    btree_index_type = const(types.IndexType.BTREE)
    rtree_index_type = const(types.IndexType.RTREE)
    hash_index_type = const(types.IndexType.HASH)
    index_type_clause = through()
    type_index_option = through()

    restrict_ref_action = const(types.RefAction.RESTRICT)
    cascade_ref_action = const(types.RefAction.CASCADE)
    set_null_ref_action = const(types.RefAction.SET_NULL)
    no_action_ref_action = const(None)

    on_delete_ref_rule = wrap_pydantic(types.OnDeleteRefRule)
    on_update_ref_rule = wrap_pydantic(types.OnUpdateRefRule)

    @inline
    def primary_constraint(
        self,
        _constraint_name: str | None,
        _name: str | None,
        index_type_clause: types.IndexType | None,
        key_list: list[types.KeyPart],
        *index_options: typing.Any,
    ):
        return types.PrimaryConstraint(
            type=index_type_clause,
            key_list=key_list,
            options=types.IndexOptions(
                key_block_size=None, comment=None, invisible=False
            ),
        )

    @inline
    def unique_constraint(
        self,
        constraint_name: str | None,
        _key_or_index: typing.Any,
        name: str | None,
        index_type_clause: types.IndexType | None,
        key_list: list[types.KeyPart],
        *index_options: typing.Any,
    ):
        return types.UniqueConstraint(
            name=(name if name is not None else constraint_name),
            type=index_type_clause,
            key_list=key_list,
            options=types.IndexOptions(
                key_block_size=None, comment=None, invisible=False
            ),
        )

    @inline
    def index_constraint(
        self,
        _key_or_index: typing.Any,
        name: str | None,
        index_type_clause: types.IndexType | None,
        key_list: list[types.KeyPart],
        *index_options: typing.Any,
    ):
        return types.IndexConstraint(
            name=name,
            type=index_type_clause,
            key_list=key_list,
            options=types.IndexOptions(
                key_block_size=None, comment=None, invisible=False
            ),
        )

    @inline
    def fulltext_constraint(
        self,
        _key_or_index: typing.Any,
        name: str | None,
        key_list: list[types.KeyPart],
        *index_option: typing.Any,
    ):
        return types.FulltextConstraint(
            name=name,
            key_list=key_list,
            parser=None,
            options=types.IndexOptions(
                key_block_size=None, comment=None, invisible=False
            ),
        )

    @inline
    def spatial_constraint(
        self,
        _key_or_index: typing.Any,
        name: str | None,
        key_list: list[types.KeyPart],
        *index_option: typing.Any,
    ):
        return types.SpatialConstraint(
            name=name,
            key_list=key_list,
            options=types.IndexOptions(
                key_block_size=None, comment=None, invisible=False
            ),
        )

    @inline
    def references(
        self,
        ref_table: types.QualIdentifier,
        ref_columns: list[str] | None,
        _match: typing.Any,
        *ref_rules: types.RefRule,
    ):
        on_update = None
        on_delete = None
        for ref_rule in ref_rules:
            if isinstance(ref_rule, types.OnUpdateRefRule):
                on_update = ref_rule.action
            else:
                on_delete = ref_rule.action
        return types.References(
            ref_table=ref_table,
            ref_columns=ref_columns or [],
            on_update=on_update,
            on_delete=on_delete,
        )

    @inline
    def foreign_contraint(
        self,
        constraint_name: str | None,
        name: str | None,
        key_list: list[types.KeyPart],
        references: types.References,
    ):
        return types.ForeignConstraint(
            name=name if name is not None else constraint_name,
            columns=[k.identifier for k in key_list],
            references=references,
        )

    @inline
    def check_contraint(
        self,
        constraint_name: str | None,
        expr: str,
        enforcement: types.ConstraintEnforcement | None,
    ):
        return types.CheckConstraint(
            name=constraint_name,
            expr=expr,
            enforcement=enforcement
            if enforcement is not None
            else types.ConstraintEnforcement.ENFORCED,
        )

    ### Create Options

    zero_ternary_option = const(False)
    one_ternary_option = const(True)
    default_row_format = const(types.Rowformat.DEFAULT)
    dynamic_row_format = const(types.Rowformat.DYNAMIC)
    fixed_row_format = const(types.Rowformat.FIXED)
    compressed_row_format = const(types.Rowformat.COMPRESSED)
    redundant_row_format = const(types.Rowformat.REDUNDANT)
    compact_row_format = const(types.Rowformat.COMPACT)

    engine_create_option = wrap_pydantic(types.EngineCreateOption)
    comment_create_option = wrap_pydantic(types.CommentCreateOption)
    auto_increment_create_option = wrap_pydantic(types.AutoIncrementCreateOption)
    stats_persistent_create_option = wrap_pydantic(types.StatsPersistentCreateOption)
    row_format_create_option = wrap_pydantic(types.RowFormatCreateOption)
    charset_create_option = wrap_pydantic(types.CharsetCreateOption, position=1)
    collate_create_option = wrap_pydantic(types.CollateCreateOption)
    tablespace_create_option = wrap_pydantic(types.TablespaceCreateOption)

    def create_table_options(self, options: list[types.CreateOption]):
        create_options = types.CreateOptions(
            engine=None,
            max_rows=None,
            min_rows=None,
            avg_row_length=None,
            password=None,
            comment=None,
            compression=None,
            encryption=None,
            auto_increment=None,
            pack_keys=None,
            stats_auto_recalc=None,
            stats_persistent=None,
            stats_sample_pages=None,
            checksum=None,
            delay_key_write=None,
            row_format=None,
            union=None,
            charset=None,
            collate=None,
            insert_method=None,
            data_directory=None,
            index_directory=None,
            tablespace=None,
            storage=None,
            connection=None,
            key_block_size=None,
        )
        for option in options:
            match option:
                case types.EngineCreateOption():
                    create_options.engine = option.name
                case types.AutoIncrementCreateOption():
                    create_options.auto_increment = option.value
                case types.CommentCreateOption():
                    create_options.comment = option.comment.text
                case types.StatsPersistentCreateOption():
                    create_options.stats_persistent = option.option
                case types.RowFormatCreateOption():
                    create_options.row_format = option.format
                case types.CharsetCreateOption():
                    if isinstance(option.charset, types.BinaryCharset):
                        create_options.charset = "binary"
                    else:
                        create_options.charset = option.charset
                case types.CollateCreateOption():
                    create_options.collate = option.collate
                case types.TablespaceCreateOption():
                    create_options.tablespace = option.name

        return create_options

    ### General

    int_arg = through()

    @inline
    def int_pair_arg(self, i1: int, i2: int):
        return (i1, i2)

    key_list = list_
    text_list = list_
    expr_list = list_

    desc_direction = const(types.Direction.DESC)
    asc_direction = const(types.Direction.ASC)

    ### Keywords

    charset = const(True)
    varchar = const(True)
    binary = const(True)
    varbinary = const(True)
    key_or_index = const(True)

    ### Identifier

    unquoted_identifier = through()
    back_tick_text = call(lambda t: t[1:-1])
    identifier = through()
    dot_identifier = through()
    identifier_list = list_
    identifier_list_with_par = through()

    @inline
    def qual_identifier(self, identifier: str, dot_identifier: str | None):
        if dot_identifier is None:
            return types.QualIdentifier(qualification=None, identifier=identifier)
        else:
            return types.QualIdentifier(
                qualification=identifier, identifier=dot_identifier
            )

    ### Literal

    literal = through()

    int_literal = call(int)
    real_literal = call(float)

    @inline
    def text_literal(self, charset_text: types.TextLiteral, *texts: str):
        return types.TextLiteral(
            charset=charset_text.charset,
            text="".join(itertools.chain([charset_text.text], texts)),
        )

    @inline
    def charset_text(self, underscore_charset: Terminal | None, text: str):
        return types.TextLiteral(
            charset=underscore_charset[1:] if underscore_charset is not None else None,
            text=text,
        )

    quoted_text = call(lambda t: t[1:-1])

    @inline
    def underscore_charset_text(self, underscore_charset: Terminal | None, text: str):
        return types.TextLiteral(
            charset=underscore_charset[1:] if underscore_charset is not None else None,
            text=text,
        )

    null_literal = const_call(types.NullLiteral)

    # Expression

    expr_with_par = through()

    @v_args(inline=False, meta=True)
    def expr(self, meta: Meta, children: typing.Any):
        return self.original_text[meta.start_pos : meta.end_pos]

    simple_expr = const(True)
    bit_expr = const(True)
    predicate = const(True)
    bool_pri = const(True)
    field_identifier = const(True)
    when_expression = const(True)
    then_expression = const(True)
    else_expression = const(True)
    comp_op = const(True)


@dataclasses.dataclass
class DDLParser:
    lark: lark.Lark

    @staticmethod
    def make():
        with (pathlib.Path(__file__).parent / "grammar.lark").open(
            mode="r", encoding="utf-8"
        ) as f:
            return DDLParser(
                lark=lark.Lark(
                    f.read(),
                    start="create_table",
                    debug=True,
                    strict=True,
                    maybe_placeholders=True,
                    propagate_positions=True,
                ),
            )

    def parse(self, ddl: str, transformer_cls: type[Transformer] | None = None):
        transformer = (transformer_cls or Transformer)(original_text=ddl)
        tree = self.lark.parse(ddl)
        return transformer.transform(tree)

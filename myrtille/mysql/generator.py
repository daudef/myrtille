from myrtille.mysql import types


def generate_ternary_option(option: bool):
    return "1" if option else "0"


def generate_ref_action(action: types.RefAction):
    match action:
        case types.RefAction.RESTRICT:
            return "RESTRICT"
        case types.RefAction.CASCADE:
            return "CASCADE"
        case types.RefAction.SET_NULL:
            return "SET NULL"


def generate_key_part(key: types.KeyPart):
    res = f"`{key.identifier}`"
    if key.direction is not None:
        res += f" {key.direction.name}"
    return res


def generate_data_type(data_type: types.DataType):
    arguments: list[str] = []

    if (
        isinstance(data_type, types.Datetime | types.Timestamp | types.Time)
        and data_type.precision is not None
    ):
        arguments = [f"{data_type.precision}"]

    if isinstance(
        data_type,
        types.Bit | types.Char | types.Varchar | types.Binary | types.Varbinary,
    ):
        arguments = [f"{data_type.length}"]

    if isinstance(data_type, types.Set | types.Enum):
        arguments = [f"'{v}'" for v in data_type.values]

    match data_type:
        case types.Tinyint():
            data_types_name = "tinyint"
        case types.Smallint():
            data_types_name = "smallint"
        case types.Mediumint():
            data_types_name = "mediumint"
        case types.Int():
            data_types_name = "int"
        case types.Bigint():
            data_types_name = "bigint"
        case types.Decimal():
            data_types_name = "decimal"
            if data_type.precision is not None:
                arguments = [f"{data_type.precision}", f"{data_type.scale or 0}"]
        case types.Float():
            data_types_name = "float"
        case types.Double():
            data_types_name = "double"
        case types.Bit():
            data_types_name = "bit"
        case types.Datetime():
            data_types_name = "datetime"
        case types.Timestamp():
            data_types_name = "timestamp"
        case types.Time():
            data_types_name = "time"
        case types.Date():
            data_types_name = "date"
        case types.Year():
            data_types_name = "year"
        case types.Char():
            data_types_name = "char"
        case types.Varchar():
            data_types_name = "varchar"
        case types.TinyText():
            data_types_name = "tinytext"
        case types.Text():
            data_types_name = "text"
        case types.MediumText():
            data_types_name = "mediumtext"
        case types.LongText():
            data_types_name = "longtext"
        case types.Enum():
            data_types_name = "enum"
        case types.Set():
            data_types_name = "set"
        case types.Binary():
            data_types_name = "binary"
        case types.Varbinary():
            data_types_name = "varbinary"
        case types.TinyBlob():
            data_types_name = "tinyblob"
        case types.Blob():
            data_types_name = "blob"
        case types.MediumBlob():
            data_types_name = "mediumblob"
        case types.LongBlob():
            data_types_name = "longblob"
        case types.Json():
            data_types_name = "json"
        case types.Geometry():
            data_types_name = "geometry"
        case types.Point():
            data_types_name = "point"
        case types.Linestring():
            data_types_name = "linestring"
        case types.Polygon():
            data_types_name = "polygon"
        case types.Geometrycollection():
            data_types_name = "geomcollection"
        case types.Multipoint():
            data_types_name = "multipoint"
        case types.Multilinestring():
            data_types_name = "multilinestring"
        case types.Multipolygon():
            data_types_name = "multipolygon"
    return data_types_name + (f"({','.join(arguments)})" if len(arguments) > 0 else "")


def generate_literal(literal: types.Literal):
    match literal:
        case types.TextLiteral():
            text = f"'{literal.text}'"
            return text
        case types.NullLiteral():
            return "NULL"


def generate_default(default_value: types.DefaultValue):
    match default_value:
        case types.ExprDefaultAttribute():
            return f"({default_value.expr})"
        case types.LiteralDefaultAttribute():
            return generate_literal(default_value.value)


def generate_column(column: types.Column):
    attributes: list[str] = []

    if (
        isinstance(column.data_type, types.IntegerDataType)
        and column.data_type.unsigned
    ):
        attributes.append("unsigned")

    if isinstance(column.data_type, types.TextDataType):
        if column.data_type.charset is not None:
            attributes.append(f"CHARACTER SET {column.data_type.charset}")
        if column.data_type.collate is not None:
            attributes.append(f"COLLATE {column.data_type.collate}")

    if column.format != types.ColumnFormat.DEFAULT:
        attributes.append(f"/*!50606 COLUMN_FORMAT {column.format.name} */")

    if column.storage_media != types.StorageMedia.DEFAULT:
        attributes.append(f"/*!50606 STORAGE {column.storage_media.name} */")

    if column.non_nullable is not None:
        attributes.append(("NOT " if column.non_nullable else "") + "NULL")

    if (
        isinstance(column.data_type, types.SpatialDataType)
        and column.data_type.srid is not None
    ):
        attributes.append(f"/*!80003 SRID {column.data_type.srid} */")

    if (
        isinstance(column.data_type, types.IntegerDataType)
        and column.data_type.auto_increment
    ):
        attributes.append("AUTO_INCREMENT")

    if column.default_value is not None:
        attributes.append(f"DEFAULT {generate_default(column.default_value)}")

    if isinstance(column.data_type, types.Datetime | types.Timestamp):
        if column.data_type.default_now:
            attributes.append("DEFAULT CURRENT_TIMESTAMP")
        if column.data_type.on_update_now:
            attributes.append("ON UPDATE CURRENT_TIMESTAMP")

    if column.comment is not None:
        attributes.append(f"COMMENT '{column.comment}'")
    if column.invisible:
        attributes.append("/*!80023 INVISIBLE */")
    if column.generated is not None:
        attributes.append(
            f"GENERATED ALWAYS AS ({column.generated.expr}) {column.generated.type.name}"
        )

    return f"`{column.name}` {generate_data_type(column.data_type)}" + "".join(
        f" {a}" for a in attributes
    )


def generate_constraint(constraint: types.Constraint):
    match constraint:
        case types.ForeignConstraint():
            col_names = f"({','.join(f'`{c}`' for c in constraint.columns)})"
            ref_col_names = (
                f"({','.join(f'`{c}`' for c in constraint.references.ref_columns)})"
            )
            parts = [
                f"CONSTRAINT `{constraint.name}` FOREIGN KEY {col_names}",
                f"REFERENCES `{constraint.references.ref_table.identifier}` {ref_col_names}",
            ]
            if constraint.references.on_delete is not None:
                parts.append(
                    f"ON DELETE {generate_ref_action(constraint.references.on_delete)}"
                )
            if constraint.references.on_update is not None:
                parts.append(
                    f"ON UPDATE {generate_ref_action(constraint.references.on_update)}"
                )
            return " ".join(parts)
        case types.CheckConstraint():
            return f"CONSTRAINT `{constraint.name}` CHECK ({constraint.expr})"
        case _:
            key_list = (
                f"({','.join(generate_key_part(key) for key in constraint.key_list)})"
            )
            match constraint:
                case types.PrimaryConstraint():
                    return f"PRIMARY KEY {key_list}"
                case types.UniqueConstraint():
                    return f"UNIQUE KEY `{constraint.name}` {key_list}"
                case types.IndexConstraint():
                    return f"KEY `{constraint.name}` {key_list}"
                case types.FulltextConstraint():
                    return f"FULLTEXT KEY `{constraint.name}` {key_list}"
                case types.SpatialConstraint():
                    return f"SPATIAL KEY `{constraint.name}` {key_list}"


def generate_create_options(create_options: types.CreateOptions):
    attributes: list[str] = []
    if create_options.tablespace is not None:
        attributes.append(f"/*!50100 TABLESPACE `{create_options.tablespace}` */")
    if create_options.engine is not None:
        attributes.append(f"ENGINE={create_options.engine}")
    if create_options.auto_increment is not None:
        attributes.append(f"AUTO_INCREMENT={create_options.auto_increment}")
    if create_options.charset is not None:
        attributes.append(f"DEFAULT CHARSET={create_options.charset}")
    if create_options.collate is not None:
        attributes.append(f"COLLATE={create_options.collate}")
    if create_options.stats_persistent is not None:
        attributes.append(
            f"STATS_PERSISTENT={generate_ternary_option(create_options.stats_persistent)}"
        )
    if create_options.row_format is not None:
        attributes.append(f"ROW_FORMAT={create_options.row_format.name}")
    if create_options.comment is not None:
        attributes.append(f"COMMENT='{create_options.comment}'")

    return " ".join(attributes)


def generate(table: types.Table):
    elements = [generate_column(c) for c in table.columns] + [
        generate_constraint(c) for c in table.constraints
    ]
    options = generate_create_options(table.options)
    return f"CREATE TABLE `{table.name}` (\n{',\n'.join(f'  {e}' for e in elements)}\n) {options}"

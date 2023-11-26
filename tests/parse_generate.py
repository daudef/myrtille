import pathlib
import sys
import typing

import rich
import rich.highlighter

from myrtille.mysql import parser, generator


DATA_DIR = pathlib.Path(__file__).parent / "data" / "ddl"


class TestTransormer(parser.Transformer):
    def __init__(self, original_text: str, visit_tokens: bool = True):
        super().__init__(original_text, visit_tokens)

    def __default__(self, data: typing.Any, children: typing.Any, meta: typing.Any):
        raise RuntimeError(f"Parser case not handled: {data}")


def main(file_name: str | None = None):
    if file_name is not None:
        schema_paths = [DATA_DIR / file_name]
    else:
        schema_paths = DATA_DIR.iterdir()

    ddl_parser = parser.DDLParser.make()

    for schema_path in schema_paths:
        print(f"In {schema_path.name}")
        with schema_path.open(mode="r", encoding="utf-8") as file:
            for ddl in file.read().split("\n\n\n"):
                if len(ddl.strip()) == 0:
                    continue
                try:
                    table = ddl_parser.parse(ddl)
                except Exception:
                    print(ddl)
                    raise

                generated_ddl = generator.generate(table)
                if ddl != generated_ddl:
                    i_diff = min(
                        (
                            i
                            for (i, (c1, c2)) in enumerate(zip(ddl, generated_ddl))
                            if c1 != c2
                        ),
                        default=min(len(ddl), len(generated_ddl)),
                    )
                    rich.get_console().highlighter = rich.highlighter.NullHighlighter()
                    rich.print(
                        f"{ddl[:i_diff]}[on red]{ddl[i_diff]}[/on red]{ddl[i_diff+1:]}"
                        if i_diff < len(ddl)
                        else ddl
                    )
                    print()
                    rich.print(
                        f"{generated_ddl[:i_diff]}[on red]{generated_ddl[i_diff]}[/on red]{generated_ddl[i_diff+1:]}"
                        if i_diff < len(generated_ddl)
                        else generated_ddl
                    )

                assert ddl == generated_ddl


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) >= 2 else None)

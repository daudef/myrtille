import sys
import typing
import contextlib
import asyncio


def choose[
    T
](items: list[T], prompt: str | None = None, file: typing.TextIO | None = None) -> T:
    file = file or sys.stdout
    assert len(items) > 0
    if len(items) == 1:
        return items[0]
    while True:
        print("\n", prompt or "choice : ", end="", file=file)
        user_input = input()
        with contextlib.suppress(ValueError, IndexError):
            return items[int(user_input)]
        print(
            f"\nInvalid choice: input must be an integer between {0} and {len(items)-1}",
            file=file,
        )


def print_choose[
    T
](
    items: list[T],
    prompt: str | None = None,
    formater: typing.Callable[[T], str] | None = None,
    choice_formater: typing.Callable[[T], str] | None = None,
    headers: list[str] | None = None,
    file: typing.TextIO | None = None,
):
    formater = formater or str
    choice_formater = choice_formater or formater
    file = file or sys.stdout

    max_index = len(str(len(items) - 1))

    if headers is not None:
        for header in headers:
            print(f" {'':>{max_index}}   {header}", file=file)

    for i, item in enumerate(items):
        print(f" {i:>{max_index}} - {formater(item)}", file=file)

    choice = choose(items, prompt, file=file)
    print(f"\nYou chosed {choice_formater(choice)}", file=file)
    return choice


type FutureLike[T] = (
    typing.Coroutine[typing.Any, typing.Any, T] | asyncio.futures.Future[T]
)


async def gather_i_future[T](futures: typing.Iterable[FutureLike[T]]) -> list[T]:
    return await asyncio.gather(*futures)


@contextlib.contextmanager
def optional_ctx[
    T
](context_manager: typing.ContextManager[T] | None,) -> typing.Iterator[T | None]:
    if context_manager is not None:
        with context_manager as value:
            yield value
    else:
        yield None

import os

import typer

import base


def all():
    import parse_generate

    parse_generate.main()


def main(*, with_coverage: bool = False):
    if with_coverage:
        import coverage

        coverage_dir = base.BASE_PATH / "coverage"
        html_dir = coverage_dir / "html"
        measurements_path = coverage_dir / "measurements.cov"
        html_dir.mkdir(parents=True, exist_ok=True)
        cov = coverage.Coverage(data_file=measurements_path)
        cov.start()
        all()
        cov.stop()
        cov.save()
        cov.html_report(
            title="Myrtille test coverage",
            directory=str(html_dir),
            omit=[str(p) for p in (base.BASE_PATH / "test" / "*",)],
        )
        os.system(f"open {html_dir / 'index.html'}")
    else:
        all()


if __name__ == "__main__":
    typer.run(main)

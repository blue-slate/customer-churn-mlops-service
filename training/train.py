from pathlib import Path


def main() -> None:
    models_dir = Path("models")
    reports_dir = Path("reports")

    models_dir.mkdir(parents=True, exist_ok=True)
    reports_dir.mkdir(parents=True, exist_ok=True)

    print("Training pipeline placeholder: dataset loading, training and artifact export will be added next.")


if __name__ == "__main__":
    main()
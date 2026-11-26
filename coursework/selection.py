"""Select required items and order them by priority, then by weight."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Item:
    name: str
    priority: int
    category: str
    weight: int


def ordered_main(items):
    return sorted(
        (item for item in items if item.category == "main"),
        key=lambda item: (item.priority, -item.weight),
    )


if __name__ == "__main__":
    items = [
        Item("label", 2, "main", 1),
        Item("base", 1, "main", 2),
        Item("optional", 0, "bonus", 5),
        Item("bracket", 2, "main", 4),
    ]
    for item in ordered_main(items):
        print(item.name)

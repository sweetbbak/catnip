#!/bin/env python3
# from rich import print
from rich.panel import Panel
from rich.console import Console
from rich.layout import Layout
from rich.table import Table

# from time import sleep
from rich.live import Live
import os
import blessed

term = blessed.Terminal()
# from rich import box
# from rich.align import Align


console = Console()
home = os.getenv("HOME")
pics = os.path.join(home, "Pictures")
cwd = os.getcwd()


def walkimg(dir):
    images = []
    for root, subdirs, files in os.walk(dir):
        for filename in files:
            img = os.path.join(root, filename)
            if img.endswith("png") and os.path.exists(img):
                images.append(img)
            elif img.endswith("jpg") and os.path.exists(img):
                images.append(img)
            elif img.endswith("gif") and os.path.exists(img):
                images.append(img)
    return images


# image path and dimensions
def refresh(image, x, y, w):
    os.system(
        f'kitty +kitten icat --clear --scale-up --place {w}x{w}@{x}x{y} "{image}"'
    )


def make_layout() -> Layout:
    layout = Layout(name="Pictures")

    layout.split(
        Layout(name="Title", size=3),
        Layout(name="main"),
        Layout(name="command", size=3),
        Layout(name="command2", size=3),
    )
    return layout


class Header:
    """Display Image Title"""

    def __rich__(self) -> Panel:
        grid = Table.grid(expand=True)
        grid.add_column(justify="center", ratio=1)
        grid.add_column(justify="right")
        grid.add_row("[b]Catnip[/b]")
        return Panel(grid, style="blue")


def update_pan(layout, image):
    layout["main"].update(
        Panel(f"[bold blue]{image}", border_style="blue", title_align="right")
    )
    layout["command"].update(
        Panel(
            f"[bold blue]{image}",
            border_style="blue",
        )
    )


def get_input(layout):
    # console = Console()
    # command = console.input("> ")
    # inp = input()
    os.system("stty echo")
    layout["command2"].update(Panel(f"[bold green]{input()}"))
    # type = []
    # val = term.inkey()
    # while val != "KEY_ENTER":
    # val = term.inkey()
    # type.append(val)
    # layout["command2"].update(Panel(f"[bold green]{type1}"))


def main():
    images = walkimg(pics)
    # array = len(images)

    layout = make_layout()
    layout["Title"].update(Header())
    layout["main"].update(Panel("[bold blue]:3", border_style="blue"))
    layout["command"].update(Panel(f"[bold blue]{images[0]}", border_style="blue"))
    layout["command2"].update(Panel("[bold blue]cmd", border_style="blue"))

    with term.cbreak(), term.hidden_cursor():
        val = ""
        i = 0
        x = 1
        y = 5
        w = 30

        with Live(layout, refresh_per_second=10, screen=True):
            while val.lower() != "q":
                # term.clear()
                val = term.inkey()
                if val.name == "KEY_DOWN" or val == "j":
                    i -= 1
                if val.name == "KEY_UP" or val == "k":
                    i += 1
                if val == "J":
                    i -= 5
                if val == "K":
                    i += 5
                if val == "n":
                    w -= 5
                if val == "m":
                    w += 5
                if val == "h":
                    if x > 0:
                        x -= 5
                if val == "l":
                    x += 5
                if val == "f":
                    os.system(f"feh --no-fehbg --bg-fill {images[i]}")
                if val == "F":
                    os.system(f"feh --bg-fill {images[i]}")
                if val == "/":
                    # os.system("printf '\e[30;0H' ")
                    get_input(layout)

                refresh(images[i], x, y, w)
                update_pan(layout, images[i])


main()

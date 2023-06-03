# catnip

## an img picker for cool cats

---

## ![](images/out.gif)

- pick images from any directory (cn ~/Pictures/backgrounds || cn .)

---

## ![](images/out1.gif)

- open in an external program (swww, feh, nitrogen, swayimg, nsxiv etc...)

---

## ![](images/out2.gif)

- Run commands on an image - :fzf - lets you fuzzy find through your selected images
- integration with other TUI's and CLI's (fzf, fd, ripgrep/grep, imagemagick)

---

## Installation

```

> curl https://raw.githubusercontent.com/sweetbbak/catnip/main/cn > ~/bin/cn && chmod +x ~/bin/cn

```

## Features

- pick an image lol
- set an image as a background/wallpaper
- open it up in Krita
- adding custom functions and image magick operations

| Key | Action          |
| --- | --------------- |
| j   | up              |
| k   | down            |
| h   | move left       |
| l   | move right      |
| F   | set as bg       |
| m   | make bigger     |
| n   | make smaller    |
| i   | insert command  |
| o   | open externally |

I wanted to make a simple menu, similar to Fzf but that caters to images specifically.
So many want and need a nice and easy way to view and manage images in the terminal
yet we are lacking in any meaningful way to interface with the tools we have today
like fzf, kitty's icat, chafa, sixel etc...

## Requirements

- Kitty or Sixel capable terminal (icat and chafa currently used, will phase out later)
- bash coreutils
- Perl (to be removed, used twice for actually fast Unicode printing lmk if you know a better way)
- Ncurses
- Linux core utilities
- tput (currently phasing out in favor of ANSI escape codes)
- <3

### Optional

- fzf
- Nsxiv, Sxiv, Swayimg, etc...
- swwww, feh, nitrogen, mpv

## To do

- rewrite in completely POSIX compliant shell (or generally portable bash)
- potential rewrite in a compiled language
- add more comprehensive error checking
- optimization of drawing unicode characters and everything else
- add support for more external programs

## DISCLAIMER

I've only been programming for less than one year and I still have no idea what the hell
I'm doing most of the time. As such this code is subject to be absolute garbage. Still,
thanks for visiting <3

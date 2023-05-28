package main

import (
	"flag"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/gdamore/tcell"
	// "seehuhn.de/go/ncurses"
)

// note that its var type in (var type) and return type (var type) return_type
func visit(path string, di fs.DirEntry, err error) error {
	fmt.Printf(path)
	return nil
}

// example of counting all files in a root directory
func countFiles(root string) []string {
	// array := make(map[string][]string)
	// use this because idk what that make map shit was lol
	var array []string
	filepath.WalkDir(root, func(path string, file fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !file.IsDir() {
			// Get the file extension
			ext := filepath.Ext(path)

			// match file extension
			switch ext {
			case ".jpg":
				array = append(array, path)
			case ".png":
				array = append(array, path)
			case ".webp":
				array = append(array, path)
			case ".gif":
				array = append(array, path)
			}
		}
		return nil
	})
	// return nil
	return array
}

func find(root, ext string) []string {
	var a []string
	filepath.WalkDir(root, func(s string, d fs.DirEntry, e error) error {
		if e != nil {
			return e
		}
		if filepath.Ext(d.Name()) == ext {
			a = append(a, s)
		}
		return nil
	})
	return a
}

func show_image(path string) {
	cmd := exec.Command("kitty", "+kitten", "icat", path)
	out, err := cmd.Output()
	if err != nil {
		fmt.Println("could not run command", err)
	}
	fmt.Println(string(out))
}

func prep_terminal() {
	// disable input buffering
	exec.Command("stty", "-F", "/dev/tty", "cbreak", "min", "1").Run()
	// do not display entered characters on the screen
	exec.Command("stty", "-F", "/dev/tty", "-echo").Run()
}

func garbage_keys() {
	var b []byte = make([]byte, 1)
	for {
		os.Stdin.Read(b)
		fmt.Println("I got the byte", b, "("+string(b)+")")
	}
}

func main() {
	flag.Parse()
	root := flag.Arg(0)
	if root == "" {
		root = os.Getenv("HOME") + "/Pictures"
	}
	x := countFiles(root)
	for z := range x {
		println(x[z])
	}
	// win := ncurses.Init()
	// defer ncurses.EndWin()

	i := 0
	s, err := tcell.NewScreen()
	if err != nil {
		fmt.Println(err)
	}

	if err := s.Init(); err != nil {
		fmt.Println(err)
	}

	// clear screen
	s.Clear()

	quit := func() { s.Fini(); os.Exit(0) }
	defer quit()

	// var key rune
	for {
		s.Show()
		ev := s.PollEvent()
		show_image(x[i])
		switch ev := ev.(type) {
		case *tcell.EventResize:
			s.Sync()
		case *tcell.EventKey:
			if ev.Key() == tcell.KeyEscape || ev.Key() == tcell.KeyCtrlC {
				return
			} else if ev.Key() == tcell.KeyCtrlL {
				s.Sync()
			} else if ev.Rune() == 'C' || ev.Rune() == 'c' {
				s.Clear()
			} else if ev.Rune() == 'j' || ev.Rune() == 'j' {
				s.Clear()
				i++
				fmt.Println(x[i])
				// show_image(x[i])
			} else if ev.Rune() == 'k' || ev.Rune() == 'K' {
				s.Clear()
				i++
				fmt.Println(x[i])
				// show_image(x[i])
			}

		}

	}
}

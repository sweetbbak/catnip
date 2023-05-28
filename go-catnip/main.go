package main

import (
	"embed"
	"flag"
	"fmt"
	"time"

	// "image"
	// "image/gif"
	// "image/png"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	// "github.com/dolmen-go/kittyimg"
	"github.com/gdamore/tcell"
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

var files embed.FS

func show_image(path string) {
	path = filepath.Clean(path)
	// path = regexp.MustCompile(`[^a-zA-Z0-9 ]+`).ReplaceAllString(path, "")/[/\\?%*:|"<>]/g, '-'
	// path = regexp.MustCompile(`/([^a-z0-9]+)/gi, '-'`).ReplaceAllString(path, "")
	path = regexp.MustCompile(`/[/\\?%*:|'"<>]/g, '-'`).ReplaceAllString(path, "")
	path = strings.ReplaceAll(path, "U+0022", "")
	path = strings.TrimSuffix(path, "\n")
	// path = strings.TrimSuffix(path, "")
	// path = strings.Replace("/^\n|\n$/g", '')
	// cmd := exec.Command("kitty", "+kitten", "icat", "--clear", "--scale-up", "--place", "80x80@0x2", path, ">", "/dev/tty")
	// cmd := exec.Command("kitty", "+kitten", "icat", "--clear", "--scale-up", "--place", "80x80@0x2", path)
	// cmd := exec.Command("bash", "-c", "kitty", "+kitten", "icat", "--clear", path)
	cmd := exec.Command("chafa", "-f", "kitty", path)
	fmt.Println(cmd)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		fmt.Println(err)
	}
	// if err := cmd.Start(); err != nil {
	// 	fmt.Println(err)
	// }
	// fmt.Println(stdout)
	// out, err := cmd.Output()
	// if err != nil {
	// 	fmt.Println("could not run command", err)
	// }
	// fmt.Println(string(out))

	// f, err := files.Open(path)
	// f, err := os.Open("/home/sweet/ssd/gallery-dl/twitter/050_37458/1645038571349491712_1.jpg")
	// if err != nil {
	// 	fmt.Println(err)
	// }
	// defer f.Close()
	// img, _, err := image.Decode(f)
	// if err != nil {
	// 	fmt.Println(err)
	// }
	// kittyimg.Fprintln(os.Stdout, img)
	// kittyimg.Fprint(os.Stdout, img)

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

	show_image(x[1])
	time.Sleep(10)
	i := 0
	s, err := tcell.NewScreen()
	if err != nil {
		fmt.Println(err)
	}

	if err := s.Init(); err != nil {
		fmt.Println(err)
	}

	// clear screen
	// s.Clear()

	quit := func() { s.Fini(); os.Exit(0) }
	defer quit()
	for {
		// s.Show()
		ev := s.PollEvent()
		// show_image(x[i])
		switch ev := ev.(type) {
		// case *tcell.EventResize:
		// s.Sync()
		case *tcell.EventKey:
			if ev.Key() == tcell.KeyEscape || ev.Key() == tcell.KeyCtrlC {
				return
			} else if ev.Key() == tcell.KeyCtrlL {
				// s.Sync()
			} else if ev.Rune() == 'C' || ev.Rune() == 'c' {
				// s.Clear()
			} else if ev.Rune() == 'j' || ev.Rune() == 'j' {
				// s.Clear()
				i--
				// fmt.Println(x[i])
				show_image(x[i])
			} else if ev.Rune() == 'k' || ev.Rune() == 'K' {
				s.Clear()
				i++
				// fmt.Println(x[i])
				show_image(x[i])
			}

		}

	}
}

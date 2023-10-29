package main

import (
	"bufio"
	"fmt"
	"os"
	"os/signal"
	"strings"
	"syscall"
)

var (
	wscol int
	wsrow int
)

func render(str string) {
	// setup
	fmt.Print("\x1b[H")
	fmt.Print("\x1b7")       // save the cursor position
	fmt.Print("\x1b[2k")     // erase the current line
	defer fmt.Print("\x1b8") // restore the cursor position

	strlen := len(str)
	bglen := wscol - strlen
	bgline := strings.Repeat(" ", bglen)

	// header
	fmt.Printf("\x1b[48;5;62m%s%s\x1b[0m", str, bgline)

	for i := 0; i < wsrow+1; i++ {
		// fmt.Printf("\x1b[48;5;62m\x1b[1B%s", " ")
		// fmt.Printf("\x1b[%d;1f\x1b[48;5;62m%s", i, " ")
		fmt.Printf("\x1b[%d;1f\x1b[48;5;62m%s", i, " ")
		fmt.Printf("\x1b[%d;%df\x1b[48;5;62m%s", i, wscol, " ")
	}

}

func updateSize() {
	x, _ := os.Open("/dev/tty")
	defer x.Close()
	wscol, wsrow = get_term_size(x.Fd())
}

func clear() {
	fmt.Print("\x1b[2J") // clear screen
}

func cup() {
	fmt.Print("\x1b[2J") // clear screen
}

func cdown() {
	fmt.Print("\x1b[2J") // clear screen
}

func unhide_cursor() {
	fmt.Printf("\x1b[?25h")
}

func hide_cursor() {
	fmt.Printf("\x1b[?25l")
}

func readStdin() []string {
	m := []string{}
	s := bufio.NewScanner(os.Stdin)
	for s.Scan() {
		m = append(m, s.Text())
	}
	return m
}

func inc(i int, arrayLen int) int {
	if i == arrayLen-1 {
		return 0
	} else {
		return i + 1
	}
}

func dec(i int, arrayLen int) int {
	if i == 0 {
		return arrayLen - 1
	} else {
		return i - 1
	}
}

func showImage(img string) {
	cols := wscol / 2
	stwing := fmt.Sprintf("--place=%vx%v@%vx0", cols, cols, cols)
	kit := strings.Join([]string{"kitten icat --transfer-mode=stream --clear --stdin=no", stwing, img}, " ")
	System(kit)
}

func main() {
	// chan for sigwinch to redraw
	sigwinch := make(chan os.Signal, 1)
	defer close(sigwinch)
	signal.Notify(sigwinch, syscall.SIGWINCH)
	go func() {
		for {
			if _, ok := <-sigwinch; !ok {
				return
			}
			updateSize()
		}
	}()

	oldState, err := makeRaw(os.Stdin.Fd())
	if err != nil {
		fmt.Println(err)
	}

	// check for ctrl-c signal
	signalChan := make(chan os.Signal)
	signal.Notify(signalChan, os.Interrupt, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)
	go func() {
		<-signalChan
		restoreTerminal(os.Stdin.Fd(), oldState)
		os.Exit(1)
	}()

	fmt.Print("\x1b[H\x1b[2J") // clear screen
	x, _ := os.Open("/dev/tty")
	defer x.Close()

	wscol, wsrow = get_term_size(x.Fd())
	fmt.Print("\x1b[H\x1b[2J") // clear screen
	hide_cursor()

	defer restoreTerminal(os.Stdin.Fd(), oldState)
	defer unhide_cursor()

	imgs := readStdin()
	arrayLen := len(imgs)
	index := 0

	var a int
	a = 100
	for a != 27 {
		render(imgs[index])
		showImage(imgs[index])

		a, _, _ = getChar()
		switch a {
		case int('j'):
			index = dec(index, arrayLen)
		case int('k'):
			index = inc(index, arrayLen)
		}

	}

}

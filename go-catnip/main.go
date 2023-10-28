package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

var (
	wscol = 20
	wsrow = 20
)

func init() {
	err := updateWSCol()
	if err != nil {
		panic(err)
	}
}

func render() {
	fmt.Print("\x1b7")       // save the cursor position
	fmt.Print("\x1b[2k")     // erase the current line
	defer fmt.Print("\x1b8") // restore the cursor position

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
			_ = updateWSCol()
			// render here
		}
	}()

	oldState, err := makeRaw(os.Stdin.Fd())
	if err != nil {
		fmt.Println(err)
	}

	defer restoreTerminal(os.Stdin.Fd(), oldState)
	var ps string
	fmt.Scanln(&ps)
	fmt.Println(ps)

}

package main

import (
	"fmt"
	"github.com/pkg/term"
	"golang.org/x/sys/unix"
	"os"
	"os/exec"
	"syscall"
	"unsafe"
)

func rawer() {
	STDINFILENO := 0
	raw, err := unix.IoctlGetTermios(STDINFILENO, unix.TCGETA)
	if err != nil {
		panic(err)
	}
	rawState := *raw
	rawState.Lflag &^= unix.ECHO

	// err = unix.IoctlSetTermios(STDINFILENO, unix.TCSAFLUSH, &rawState)
	err = unix.IoctlSetTermios(STDINFILENO, unix.TCSETA, &rawState)
	// err = unix.IoctlSetTermios(STDINFILENO, unix.BPF_TCP_CLOSE, &rawState)

	if err != nil {
		panic(err)
	}
}

func System(cmd string) int {
	c := exec.Command("sh", "-c", cmd)
	c.Stdin = os.Stdin
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr

	err := c.Run()
	if err == nil {
		return 0
	}

	// Figure out the exit code
	if ws, ok := c.ProcessState.Sys().(syscall.WaitStatus); ok {
		if ws.Exited() {
			return ws.ExitStatus()
		}

		if ws.Signaled() {
			return -int(ws.Signal())
		}
	}
	return -1
}

// Returns either an ascii code, or (if input is an arrow) a Javascript key code.
func getChar() (ascii int, keyCode int, err error) {
	t, _ := term.Open("/dev/tty")

	term.RawMode(t)
	bytes := make([]byte, 3)

	var numRead int
	numRead, err = t.Read(bytes)
	if err != nil {
		return
	}
	if numRead == 3 && bytes[0] == 27 && bytes[1] == 91 {
		// Three-character control sequence, beginning with "ESC-[".

		// Since there are no ASCII codes for arrow keys, we use
		// Javascript key codes.
		if bytes[2] == 65 {
			// Up
			keyCode = 38
		} else if bytes[2] == 66 {
			// Down
			keyCode = 40
		} else if bytes[2] == 67 {
			// Right
			keyCode = 39
		} else if bytes[2] == 68 {
			// Left
			keyCode = 37
		}
	} else if numRead == 1 {
		ascii = int(bytes[0])
	} else {
		// Two characters read??
	}
	t.Restore()
	t.Close()
	return
}

type winsize struct {
	rows    uint16
	cols    uint16
	xpixels uint16
	ypixels uint16
}

func get_term_size(fd uintptr) (int, int) {
	var sz winsize
	_, _, _ = syscall.Syscall(syscall.SYS_IOCTL,
		fd, uintptr(syscall.TIOCGWINSZ), uintptr(unsafe.Pointer(&sz)))
	return int(sz.cols), int(sz.rows)
}

func updateWSCol() error {
	ws, err := unix.IoctlGetWinsize(syscall.Stdout, unix.TIOCGWINSZ)
	if err != nil {
		return err
	}
	wscol = int(ws.Col)
	wsrow = int(ws.Row)
	return nil
}

// example
func xmain() {
	fmt.Print("Enter your secret password: ")

	oldState, err := makeRaw(os.Stdin.Fd())
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	defer restoreTerminal(os.Stdin.Fd(), oldState)

	// Read the password
	var password string
	_, _ = fmt.Scanln(&password)
	fmt.Printf("\nYou entered: %s\n", password)
}

func makeRaw(fd uintptr) (*unix.Termios, error) {
	var oldState unix.Termios
	_, _, err := syscall.Syscall(syscall.SYS_IOCTL, fd, uintptr(unix.TCGETS), uintptr(unsafe.Pointer(&oldState)))
	if err != 0 {
		return nil, err
	}

	newState := oldState
	newState.Lflag &^= unix.ECHO
	newState.Lflag &= unix.ECHO

	_, _, err = syscall.Syscall(syscall.SYS_IOCTL, fd, uintptr(unix.TCSETS), uintptr(unsafe.Pointer(&newState)))
	if err != 0 {
		return nil, err
	}

	return &oldState, nil
}

func restoreTerminal(fd uintptr, oldState *unix.Termios) {
	_, _, _ = syscall.Syscall(syscall.SYS_IOCTL, fd, uintptr(unix.TCSETS), uintptr(unsafe.Pointer(oldState)))
}
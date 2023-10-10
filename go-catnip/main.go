package main

import (
	"bufio"
	"bytes"
	"fmt"
	"github.com/pkg/term"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"syscall"
	"unsafe"
)

var intbuf = make([]byte, 0, 16)

type winsize struct {
	rows    uint16
	cols    uint16
	xpixels uint16
	ypixels uint16
}

func main() {
	m := []string{}
	s := bufio.NewScanner(os.Stdin)
	for s.Scan() {
		m = append(m, s.Text())
	}

	fmt.Println()
	write_cursor(10, 10)
	x, _ := os.Open("/dev/tty")
	col, _ := get_term_size(x.Fd())
	cols := int(float64(col) * 0.5)
	System("clear")

	a := 100
	// i := 0
	arrayLen := len(m)
	index := 0
	// b := 0
	// kit := strings.Join([]string{"kitten icat --transfer-mode=memory --clear --stdin=no", stwing, m[index]}, " ")
	// stwing := fmt.Sprintf("--place=%vx%v@%vx0", cols, cols, cols)
	// kit := strings.Join([]string{"kitten icat --transfer-mode=stream --clear --stdin=no", stwing, m[index]}, " ")

	for a != 27 {
		a, _, _ = getChar()
		switch a {
		case int('j'):
			index = dec(index, arrayLen)
			fmt.Println(index)
			stwing := fmt.Sprintf("--place=%vx%v@%vx0", cols, cols, cols)
			kit := strings.Join([]string{"kitten icat --transfer-mode=stream --clear --stdin=no", stwing, m[index]}, " ")
			System(kit)
			fmt.Println("j")
		case int('k'):
			index = inc(index, arrayLen)
			stwing := fmt.Sprintf("--place=%vx%v@%vx0", cols, cols, cols)
			kit := strings.Join([]string{"kitten icat --transfer-mode=stream --clear --stdin=no", stwing, m[index]}, " ")
			System(kit)
			fmt.Println("k")
		}
	}

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

func write_cursor(x, y int) {
	outbuf := new(bytes.Buffer)
	outbuf.WriteString("\033[")
	outbuf.Write(strconv.AppendUint(intbuf, uint64(y+1), 10))
	outbuf.WriteString(";")
	outbuf.Write(strconv.AppendUint(intbuf, uint64(x+1), 10))
	outbuf.WriteString("H")
}

func get_term_size(fd uintptr) (int, int) {
	var sz winsize
	_, _, _ = syscall.Syscall(syscall.SYS_IOCTL,
		fd, uintptr(syscall.TIOCGWINSZ), uintptr(unsafe.Pointer(&sz)))
	return int(sz.cols), int(sz.rows)
}

func char_c(t *term.Term) {
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

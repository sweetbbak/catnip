#include <curses.h>
#include <ncurses.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

char* concat(const char *s1, const char *s2)
{
    char *result = malloc(strlen(s1) + strlen(s2) + 1); // +1 for the null-terminator
    // in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}

int startx = 0;
int starty = 0;

char *choices[] = {
  "/home/sweet/Pictures/anime-icons/watashi.jpg",
  "/home/sweet/Pictures/anime-icons/pika.jpg",
  "/home/sweet/Pictures/anime-icons/pinkcute.jpg",
  "/home/sweet/Pictures/anime-icons/read.jpg",
  "/home/sweet/Pictures/anime-icons/reliable.jpg",
  "/home/sweet/Pictures/anime-icons/shy.jpg",
  "/home/sweet/Pictures/anime-icons/silver.jpg",
  "/home/sweet/Pictures/anime-icons/smoking.jpg",
  "/home/sweet/Pictures/anime-icons/sparkler.jpg",
  "/home/sweet/Pictures/anime-icons/sparkles.jpg",
  "/home/sweet/Pictures/anime-icons/sweet.jpg",
  "/home/sweet/Pictures/anime-icons/tired.jpg",
  "/home/sweet/Pictures/anime-icons/viper.jpg",
};

int num_choices = sizeof(choices) / sizeof(char *);
void print_menu(WINDOW *menu_win, int cursor);

void icat_old(char index_menu) {
    char* cmd = concat("chafa -f kitty ", &index_menu);
    // system(cmd);
    printf("%s\n", cmd);
    free(cmd);
}

void icat(char *dir) {
    static char prefix[] = "kitty +kitten icat --clear --place 69x69@2x2 ";
    // Use sizeof to allow for null char at end.
    char *cmd = malloc(sizeof (prefix) + strlen (dir));
    if (cmd != NULL) {
        strcpy (cmd, prefix);
        strcat (cmd, dir);
        system (cmd);
        free (cmd);
    }
}

char inputs() {
    // Define the maximum number of lines to read (adjust as needed)
    int max_lines = 100;

    // Create an array of strings to store the lines
    char *C[max_lines];

    // Read input from stdin line by line
    int i = 0;
    char buffer[1024];  // Assuming lines are not longer than 1024 characters

    while (i < max_lines && fgets(buffer, sizeof(buffer), stdin)) {
        // Remove trailing newline character if present
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len - 1] == '\n') {
            buffer[len - 1] = '\0';
        }

        // Allocate memory and store the line in the arread stdin pipe newline to array "C"ray
        C[i] = strdup(buffer);

        if (C[i] == NULL) {
            perror("Memory allocation failed");
            exit(EXIT_FAILURE);
        }

        i++;
    }

    // Print the array (optional)
    for (int j = 0; j < i; j++) {
        printf("C[%d]: %s\n", j, C[j]);
    }

    return **C;

    // Free allocated memory
    // for (int j = 0; j < i; j++) {
    //     free(C[j]);
    // }

    // return 0;
}

int main() {
    WINDOW *terminal;
    int cursor = 1;
    int choice = 0;
    int max_x;
    int max_y;
    int c;
    int i;

    initscr();
    clear();
    noecho();
    cbreak();
    startx = 0;
    starty = 0;
    max_x = getmaxx(stdscr);
    max_y = getmaxy(stdscr);
    // printf("startx %d -- starty %d -- max_x %d -- max_y %d", startx, starty, max_x, max_y);
    // terminal = newwin(80, 80, 0, 0);
    // printw("Horizontal line             "); addch(ACS_HLINE); printw("\n");
    keypad(stdscr, TRUE);
    refresh();

    i = 0;
    // mvprintw(50, 50, "Hello World %s\n", choices[i]);
    box(stdscr, 0, 0);
    refresh();

    while (1) {
        c = wgetch(stdscr);
        if (c == EOF) {
            break;
        }
        switch (c) {
            case KEY_UP:
                i++;
                // icat(*choices[i]);
                icat(choices[i]);
                box(stdscr, 0, 0);
                refresh();
                break;
            case KEY_DOWN:
                i--;
                // icat(*choices[i]);
                icat(choices[i]);
                box(stdscr, 0, 0);
                refresh();
                break;
            case 'k':
                i++;
                // icat(*choices[i]);
                icat(choices[i]);
                box(stdscr, 0, 0);
                refresh();
                break;
            case 'j':
                i--;
                // icat(*choices[i]);
                icat(choices[i]);
                box(stdscr, 0, 0);
                refresh();
                break;
            case 'q':
                break;
            default:
                refresh();
                break;
        }
        mvprintw(2, 2, "%s", choices[i]);
        box(stdscr, 0, 0);
        refresh();
        if (c == KEY_ENTER)
            break;
    }
    clrtoeol();
    refresh();
    endwin();
    return 0;
}

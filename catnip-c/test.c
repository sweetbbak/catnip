#include <locale.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#include <bits/getopt_core.h>
#include <ncurses.h>
#include <sys/wait.h>

int system(const char *command);

// clear screen string
void clearScreen() { printf("\033[2J\033[1;1H"); }

void runSH() {
  // this is an option alongside execv and popen i think
  execl("kitty +kitten icat ~/Pictures/036jfvmghbxa1.jpg", "C-test");
}

void icat() { system("kitty +kitten icat ~/Pictures/036jfvmghbxa1.jpg"); }

void prinBold(char ch) {
  attron(A_BOLD);
  attron(A_COLOR);
  printw("%c", ch);
  attroff(A_BOLD);
}

char *cwd = NULL;
char *homedir = NULL;

void get_home(void) { char *s = getenv("HOME"); }

void run_cmd(char *cmd) {
  clear();
  refresh();
  endwin();

  if (!fork()) {
    execvp("sh", (char *[]){"sh", "-c", cmd, NULL});
    exit(0);
  }
  wait(NULL);

  puts("\nPress enter to continue");
  while (fgetc(stdin) != '\n')
    ;

  initscr();
  clear();
  refresh();
}

void help() {
  printf("\nUsage: catnip [args] <path> \n"
         "A CLI tool for browsing images"
         "-c | --config"
         "-h | --help"
         "path | PWD"

  );
}

void argies(int argc, char *argv[]) {
  if (argc > 1) {
    bool parse_opts = true;
    bool negate_next = false;
    bool oneshot = false;

    for (int i = 1; i < argc; i++) {
      if (parse_opts && argv[i][0] == '-') {
        if (argv[i][0] != '\0' && argv[i][1] == '-') {
          if (argv[i][2] == '\0')
            parse_opts = false;
          else if (!strcmp(argv[i] + 2, "help"))
            help();
          else if (!strcmp(argv[i] + 2, "oneshot"))
            oneshot = true;
          else {
            fprintf(stderr, "Unknown option: %s\n", argv[i]);
            exit(1);
          }
        }
      }
    }
  }
}

int main(int argc, char *argv[]) {
  if (!setlocale(LC_ALL, "") || !initscr() || curs_set(0) == ERR)
    return 1;

  // printf("You've entered %d arguments", argc);

  // for (int i = 0; i < argc; i++) {
  //   printf("%s\n", argv[i]);
  // }

  if (argc > 1) {
    bool parse_opts = true;
    bool negate_next = false;
    bool oneshot = false;

    for (int i = 1; i < argc; i++) {
      if (parse_opts && argv[i][0] == '-') {
        if (argv[i][0] != '\0' && argv[i][1] == '-') {
          if (argv[i][2] == '\0')
            parse_opts = false;
          else if (!strcmp(argv[i] + 2, "help"))
            help();
          else if (!strcmp(argv[i] + 2, "oneshot"))
            oneshot = true;
          else {
            fprintf(stderr, "Unknown option: %s\n", argv[i]);
            exit(1);
          }
        } else if (S_ISDIR()) {
          cwd = argv[i];
        }
      }
    }
  }

  // for(int i = 0; i < 334; i++) {
  //   clearScreen();
  //   printf("Counting: %d", i);
  //   fflush(stdout);
  //   // usleep(50000);
  //   usleep(5000);
  //  }

  // int ch; initscr();
  // raw(); keypad(stdscr, TRUE);
  // noecho();
  // printw("Type to see char in bold\n");
  // ch = getch();
  // if(ch == KEY_F(2))
  //   printw("F2 pressed");

  // else {
  // printw("The pressed key is ");
  // // attron(A_BOLD);
  // // printw("%c", ch);
  // // attroff(A_BOLD);
  //   prinBold(ch);
  //   }

  // mvprintw(0, 0, "THIS IS A TEST");
  // usleep(100000);
  // mvprintw(30, 30, "THIS IS A TEST");
  // usleep(100000);
  // icat(); usleep(100000);

  // refresh();
  // getch();
  // endwin();
  return 0;
}

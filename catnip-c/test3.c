#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int isDirectory(const char *path) {
  DIR *dir = opendir(path);
  if (dir != NULL) {
    closedir(dir);
    return 1; // It's a directory
  }
  return 0; // Not a directory
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Usage: %s <directory>\n", argv[0]);
    return 1;
  }

  const char *directory = argv[1];
  if (strcmp(directory, "--help") == 0) {
    printf("Help message goes here.\n");
    return 0;
  }

  if (isDirectory(directory)) {
    printf("%s is a valid directory.\n", directory);
  } else {
    printf("%s is not a valid directory.\n", directory);
  }

  return 0;
}

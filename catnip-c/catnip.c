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

void scanDirectory(const char *dirPath) {
  DIR *dir = opendir(dirPath);
  if (!dir) {
    printf("Failed to open directory: %s\n", dirPath);
    return;
  }

  struct dirent *entry;
  while ((entry = readdir(dir)) != NULL) {
    if (entry->d_type == DT_DIR) {
      // Skip directories "." and ".."
      if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
        continue;

      // Recursively scan subdirectories
      char subDirPath[256];
      snprintf(subDirPath, sizeof(subDirPath), "%s/%s", dirPath, entry->d_name);
      scanDirectory(subDirPath);
    } else {
      // Check if file ends with the desired extensions
      const char *extensions[] = {".jpg", ".png", ".gif", ".webp"};
      for (int i = 0; i < sizeof(extensions) / sizeof(extensions[0]); i++) {
        size_t extensionLength = strlen(extensions[i]);
        size_t fileNameLength = strlen(entry->d_name);

        if (fileNameLength >= extensionLength) {
          const char *fileExtension =
              entry->d_name + fileNameLength - extensionLength;
          if (strcmp(fileExtension, extensions[i]) == 0) {
            // File matches the extension, do something
            printf("%s/%s\n", dirPath, entry->d_name);
          }
        }
      }
    }
  }

  closedir(dir);
}

int main(int argc, char *argv[]) {

  // printf("%s", base_dir);
  char hd[256];
  if (argc != 2) {
    strcpy(hd, getenv("HOME"));
    strcat(hd, "/Pictures");
    printf("%s\n", hd);
  } else if (argc > 3 || argc < 1) {
    printf("Usage: %s <directory>\n", argv[0]);
    return 1;
  } else {
    strcpy(hd, argv[1]);
  }

  // const char *directory = argv[1];
  if (strcmp(hd, "--help") == 0) {
    printf("Help message goes here.\n");
    return 0;
  } else if (isDirectory(hd) == 0) {
    exit(1);
  }

  // const char *dirdir = "/home/sweet/Pictures";
  // if (isDirectory(hd)) {
  //   printf("\n%s IS VALID BITCH", hd);
  // } else {
  //   printf("NOT");
  // }
  scanDirectory(hd);

  return 0;

  // struct dirent **namelist;
  // int n;

  // n = scandir(hd, &namelist, parse_ext, alphasort);
  // if (n < 0) {
  //   perror("scandir");
  //   return 1;
  // } else {
  //   while (n--) {
  //     printf("%s\n", namelist[n]->d_name);
  //     free(namelist[n]);
  //   }
  //   free(namelist);
  // }

  return 0;
}

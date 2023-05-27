#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void scanDirectory(const char *dirPath, char **filePaths, int *numFiles,
                   int *maxFiles) {
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
      scanDirectory(subDirPath, filePaths, numFiles, maxFiles);
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
            // File matches the extension, add it to the array
            if (*numFiles >= *maxFiles) {
              // Increase the size of the array if necessary
              *maxFiles *= 2;
              *filePaths = realloc(*filePaths, (*maxFiles) * sizeof(char *));
            }
            (*filePaths)[*numFiles] = malloc(
                (strlen(dirPath) + strlen(entry->d_name) + 2) * sizeof(char));
            snprintf((*filePaths)[*numFiles],
                     strlen(dirPath) + strlen(entry->d_name) + 2, "%s/%s",
                     dirPath, entry->d_name);
            (*numFiles)++;
          }
        }
      }
    }
  }

  closedir(dir);
}

int main() {
  const char *directoryPath = "/home/sweet/ssd/gallery-dl";
  int maxFiles = 10; // Initial capacity of the array
  int numFiles = 0;
  char **filePaths = malloc(maxFiles * sizeof(char *));
  scanDirectory(directoryPath, &filePaths, &numFiles, &maxFiles);

  // Print the file paths
  for (int i = 0; i < numFiles; i++) {
    printf("File %d: %s\n", i + 1, filePaths[i]);
  }

  // Free the memory
  for (int i = 0; i < numFiles; i++) {
    free(filePaths[i]);
  }
  free(filePaths);

  return 0;
}

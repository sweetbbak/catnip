package main

import (
	"flag"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
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
	// Create a map to store the file extensions and their corresponding paths
	// fileExtensions := make(map[string][]string)

	// // Walk through the directories and sub-directories
	// err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
	// 	if err != nil {
	// 		return err
	// 	}

	// 	// Check if the current path is a file
	// 	if !info.IsDir() {
	// 		// Get the file extension
	// 		ext := filepath.Ext(path)

	// 		switch ext {
	// 		case ".jpg":
	// 			fileExtensions[ext] = append(fileExtensions[ext], path)
	// 		case ".png":
	// 			fileExtensions[ext] = append(fileExtensions[ext], path)
	// 		case ".webp":
	// 			fileExtensions[ext] = append(fileExtensions[ext], path)
	// 		case ".gif":
	// 			fileExtensions[ext] = append(fileExtensions[ext], path)

	// 		}
	// 	}

	// 	return nil
	// })

	// if err != nil {
	// 	fmt.Println(err)
	// }

	// // Print out the file extensions and their corresponding paths
	// for ext, paths := range fileExtensions {
	// 	fmt.Printf("%s:\n", ext)
	// 	for _, path := range paths {
	// 		fmt.Printf("\t%s\n", path)
	// 	}
	// }
	// // for _, s := range find(root, ".png") {
	// // 	println(s)
	// }
}

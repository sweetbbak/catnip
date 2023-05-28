// use glob::glob;
// use clap::{Parser, Subcommand};
use core::panic;
use std::env;
use std::error::Error;
// use std::io::Result;
use std::fs;
use std::path::PathBuf;
// use std::ffi::OsStr;
// use std::path::Path;
use walkdir::WalkDir;

fn get_images_old(in_dir: PathBuf) -> Result<(), Box<dyn Error>> {
    // fn get_images(in_dir: PathBuf) -> std::result::Result<(), std::io::Error> {
    for entry in WalkDir::new(in_dir)
        .follow_links(false)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let f_name = entry.file_name().to_string_lossy();
        // let sec = entry.metadata()?.modified()?;

        if f_name.ends_with(".png") || f_name.ends_with(".jpg") || f_name.ends_with(".gif") {
            println!("{}", f_name);
        }
    }

    Ok(())
}

fn get_images(in_dir: &PathBuf) -> Result<Vec<PathBuf>, Box<dyn Error>> {
    // fn get_images(in_dir: PathBuf) -> Result<(), Box<dyn Error>> {
    // fn get_images(in_dir: PathBuf) -> std::result::Result<(), std::io::Error> {
    for entry in WalkDir::new(in_dir)
        .follow_links(false)
        .into_iter()
        .filter_map(|e| e.ok())
        // FUCK I have no idea what Im doing lmao
        .filter_map(|path| {
            if path.file_name().to_string_lossy().ends_with(".png") {
                Some(path)
            } else {
                None
            }
        })
    {
        let f_name = entry.file_name().to_string_lossy();

        if f_name.ends_with(".png") || f_name.ends_with(".jpg") || f_name.ends_with(".gif") {
            // let xxxx = std::fs::canonicalize(&f_name);
            let xxxx = fs::canonicalize(f_name);
            // fs::canonicalize(&in_dir + &f_name);

            println!("{}", f_name);
        }
    }

    Ok(())
}

fn get_csv_paths(dir: &PathBuf) -> Result<Vec<PathBuf>, Box<dyn Error>> {
    let paths = std::fs::read_dir(dir)?
        // Filter out all those directory entries which couldn't be read
        .filter_map(|res| res.ok())
        // Map the directory entries to paths
        .map(|dir_entry| dir_entry.path())
        // Filter out all paths with extensions other than `csv`
        .filter_map(|path| {
            if path.extension().map_or(false, |ext| ext == "csv") {
                Some(path)
            } else {
                None
            }
        })
        .collect::<Vec<_>>();
    Ok(paths)
}

fn main() {
    // collect single arg as dir if exists
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args);
    println!("Binary: {:?}", &args[0]);
    println!("Argument: {:?}", &args[1]);

    // if args is not empty (dumb check tbh) and less than 2
    if !args.is_empty() && !args.len() > 2 {
        let in_dir = PathBuf::from(&args[1]);
        if !in_dir.is_dir() {
            panic!("Path is not a directory: {:?}", in_dir)
        }
        // let list_images = args.get(2).map_or(false, |arg| arg == "--list-images");
        // let download_images = args.get(2).map_or(false, |arg| arg == "--download-images");
        // let output_dir = args.get(3).map_or("", |arg| arg.as_str());
        get_images(in_dir);
    }
}

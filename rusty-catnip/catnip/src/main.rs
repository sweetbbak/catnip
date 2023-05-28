// use glob::glob;
use clap::{Parser, Subcommand};
use core::panic;
// use std::error::Error;
// use std::io::Result;
use std::{path::PathBuf, time::SystemTime};
// use std::ffi::OsStr;
// use std::path::Path;
use walkdir::WalkDir;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]

struct Cli {
    /// View images in the current directory
    #[command(subcommand)]
    command: Option<Commands>,

    /// Disable kitty image protocol
    #[arg(short, long, default_value_t = false)]
    disable_kitty: bool,
}

#[derive(Subcommand)]
enum Commands {
    /// Sorts files based on file extension matching our database
    Sort {
        /// The input directory
        #[arg(short, long)]
        inputdir: String,
    },
    /// Updates FileSorterX to the latest version based on the github repo
    Update {},
    /// Note: Only run in a new empty directory. Runs a benchmark test
    Benchmark {},
}

// fn glob_pngs() -> Result<(), Box<dyn Error>> {
//     for entry in glob("**/*.png")? {
//         println!("{}", entry?.display());
//     }

//     Ok(())
// }

// fn get_images(in_dir: PathBuf) -> Result<(), Box<dyn Error>> {
fn get_images(in_dir: PathBuf) -> std::result::Result<(), std::io::Error> {
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

fn main() {
    let cli = Cli::parse();
    let start = SystemTime::now();
    match &cli.command {
        Some(Commands::Sort { inputdir }) => {
            let in_dir = PathBuf::from(inputdir);

            if !in_dir.is_dir() {
                panic!(
                    "Provided path is not a valid directory: '{:?}' {:?}",
                    in_dir, start
                )
            }

            // sort_files(in_dir)
            let end = SystemTime::now();
            let duration = end.duration_since(start).unwrap();
            println!("Time taken: {:?}", duration);
            get_images(in_dir);
        }

        Some(Commands::Update { .. }) => {
            println!("Updating... (JK not really)");
        }

        Some(Commands::Benchmark { .. }) => {
            // let time = benchmark();
            println!("Benchmarking")
        }
        None => println!("No command provided, use catnip --help for more information."),
    }
}

# Overview

This project is an end-to-end pipeline for downloading, parsing, and reformatting [Hansard](https://www.aph.gov.au/Parliamentary_Business/Hansard) data into machine-readable CSV files. Everything is driven from a single repo, [ParlinfoSpeechScraper](https://github.com/Australian-Parliamentary-Speech/ParlinfoSpeechScraper), which pulls in three git submodules that each handle one stage of the pipeline:

- **PSSSourceXML** — downloads the XML files directly from the Parlinfo roadmap.
- **PSSSourceSGML** — downloads the SGML files and converts them into XML, for the years where XML is missing.
- **PSSConvert** — parses the XML files and produces the final CSV files containing all speech information.

A fourth submodule, **PSSUtils**, provides shared utilities used by the others. All of this is orchestrated through the `Makefile` in ParlinfoSpeechScraper, so you don't need to clone or run the submodules individually.

The detailed documentation is on the documentation page [here](https://australian-parliamentary-speech.github.io/ParlinfoSpeechScraper/).

# Windows users

All commands here work natively for Mac and Linux users.

Since this project uses `make` and bash scripts under the hood, Windows users need a bash environment to run these commands. One option is to install [Git for Windows](https://git-scm.com/downloads/win) to create a bash shell environment. Once installed, right click "Git Bash Here" and run the commands below there.

# Install Julia

To run the package, Julia needs to be installed. For help see https://julialang.org/install/

# Clone the repo

In your preferred directory, clone ParlinfoSpeechScraper with HTTP or SSH:

```
git clone https://github.com/Australian-Parliamentary-Speech/ParlinfoSpeechScraper.git
```

Go into the directory:

```
cd ParlinfoSpeechScraper
```

You don't need to clone the submodules (PSSSourceXML, PSSSourceSGML, PSSConvert, PSSUtils) yourself — `make install` (below) fetches them for you via `git submodule update --init --recursive`.

# Install and set up

From inside the `ParlinfoSpeechScraper` directory:

```
make install
```

This checks that Julia is available, pulls in the submodules, and instantiates the Julia project dependencies (`Pkg.instantiate()`).

If you already have the repo installed and want to pull the latest changes for it and all submodules, and refresh Julia dependencies, run:

```
make update
```

This runs `git pull --recurse-submodules` followed by a submodule sync (`git submodule update --init --recursive`), and updates Julia packages (`Pkg.update()`).

If you want to do both an install and an update in one go, run:

```
make setup
```

# Run the pipeline

Once installed, run the whole pipeline with:

```
make run all
```

This downloads, converts, and parses both the House and the Senate, producing CSVs for both.

To run just one chamber:

```
make run house
```

or

```
make run senate
```

Each of these runs the full pipeline (download XML, download/convert SGML, parse to CSV) for that chamber only.

# Output

Once a run finishes, you'll find:

- Downloaded/converted XML in `output/source_xml/<house|senate>` and `output/source_sgml/<house|senate>`
- The final CSV files in `output/source_csv/house` or `output/source_csv/senate`

# Configuring year ranges and parsing options

To run a different year range or tweak parsing options, edit `examples/house.toml` or `examples/senate.toml` (e.g. the `year = [1901, 2026]` field under `general_options`). Details on the available options are documented [here](https://australian-parliamentary-speech.github.io/ParlinfoSpeechScraper/).

# Other useful commands

Run `make` (or `make help`) with no arguments from the `ParlinfoSpeechScraper` directory to see a self-documenting list of all available targets.

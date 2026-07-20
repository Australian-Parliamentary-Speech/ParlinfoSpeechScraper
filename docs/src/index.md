# ParlinfoSpeechScraper  

This project downloads, parses, and reformats Hansard data into machine-readable CSV files. It's a single repo (a "monorepo") made up of four submodules under `src/`:

- **PSSSourceXML** downloads Hansard XML files directly from Parlinfo's sitemap. See [Download the XML files](download.md).
- **PSSSourceSGML** downloads and converts to XML the older SGML-only Hansard records (1981-1997) that were never published as XML. See [Download the SGML files and convert them to XML files](sgml2xml.md).
- **PSSConvert** parses the raw XML files and produces the CSV files containing all processed speech information.
- **PSSUtils** holds shared utilities (downloading, compression) used by the other three.

These are no longer separate repos you clone individually - cloning `ParlinfoSpeechScraper` (with submodules) gets you all of them.

# Windows users

All commands here work natively for Mac and Linux users.

Since this project is driven by `make` and bash scripts, Windows users need a bash environment with `make` available to run these commands. One option is to install [Git Windows](https://git-scm.com/downloads/win) to create a bash shell environment. Once installed, right click "Git Bash Here" and run the commands below there.

# Install Julia

To run the package, Julia needs to be installed. For help see https://julialang.org/install/

# Installation

Clone the repo along with its submodules:
```
git clone --recurse-submodules https://github.com/Australian-Parliamentary-Speech/ParlinfoSpeechScraper.git
cd ParlinfoSpeechScraper
```

Then install everything (checks Julia is available, pulls in any submodules you didn't clone with `--recurse-submodules`, and instantiates the Julia environment):
```
make install
```

# Running the pipeline

From the root of the repo:
```
make run house
```
or
```
make run senate
```
or, to run both:
```
make run all
```

This runs the full pipeline for the given house: downloading XML (`PSSSourceXML`), downloading and converting SGML (`PSSSourceSGML`), parsing everything into CSVs (`PSSConvert`), then compressing all of it. See [Download the XML files](download.md), [Download the SGML files and convert them to XML files](sgml2xml.md), [Usage](usage.md#section-heading), and [Advanced usage](advusage.md#section-heading) for what each stage produces and how to configure it.

# Make targets

Run `make help` (or just `make`, since `help` is the default target) from the repo root to see this list. Commands you'd normally run directly:

| Target | What it does |
|---|---|
| `make help` | Prints this list of targets. |
| `make install` | Checks Julia is installed, ensures submodules are checked out (`git submodule update --init --recursive`), and runs `Pkg.instantiate()`. Run this once after cloning. |
| `make update` | Pulls the latest changes (`git pull --recurse-submodules`) and re-syncs submodules. This only updates the *code* - it does not re-download or refresh any of the scraped data in `output/`. To refresh the data itself, re-run `make run house`/`senate`/`all` (see below). |
| `make setup` | Runs `install` then `update` - the one-shot "get me fully up to date" command. |
| `make run <house\|all>` | Runs the full pipeline (see above) for `house`, `senate`, or `all`. Any extra arguments are forwarded down to `PSSConvert`. |

A few smaller targets exist that the ones above call internally, and aren't normally run by hand: `julia`/`dependencies`/`installcheck` (verify Julia is on `PATH`), `jl-init` (`Pkg.instantiate()`), `jl-update` (`Pkg.update()`), and `git-submodules`/`git-pull` (the underlying git operations).

#(# Overall structure 
The documentation page is arranged as follows:
Normal usage in terms of inputs and outputs is explained in [Usage](usage.md#section-heading), and more advanced interaction that includes adding a node or phase type is explained in [Advanced usage](advusage.md#section-heading). The current implementation of different nodes in all phases is shown in [Nodes](nodes.md#section-heading). [Function references](functionreference.md#section-heading) shows all the docstrings in the program.)


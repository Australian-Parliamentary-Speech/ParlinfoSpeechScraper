# Download the SGML files and convert them to XML files

Hansard was not published in XML before 1998 - only SGML is available for that earlier period. This step downloads the SGML files for 1981-1997 and converts each one to XML, so it can be processed the same way as the rest of the corpus. It's implemented by the `PSSSourceSGML` package, which lives at `src/PSSSourceSGML` as a submodule of this repo.

## Output layout

Given an output directory `output/` (the default), files land in:

```
output/source_sgml/<house>/
├── sgmls/<year>/<year>_<month>_<day>.sgm   # step 1: downloaded sgml files
├── xmls/...xml                              # step 2: converted xml files
└── logs/                                    # log output
```

Once a run is compressed, this entire `<house>/` directory is archived to `output/source_sgml/<house>.tar.zst` and the directory is deleted. If a `<house>.tar.zst` from a previous run already exists when a new run starts, it's decompressed automatically before processing continues.

## Required files

Two files ship alongside the code in `src/PSSSourceSGML/src/`:

- **`HansardSGML.csv`**: the master list of SGML download links (`Sitting Day,Senate Link,Reps Link`) for 1981-1997. If this file is missing, it's generated automatically (see Step 0 below) - but that's slow, since it means probing thousands of individual dates, so it should rarely need to happen.
- **`hansard.dtd`**: referenced by the `DOCTYPE` declaration that gets written into every converted XML file.

## A hidden dependency worth knowing about

Converting SGML to XML goes through Python, not pure Julia: each `.sgm` file is reparsed with `bs4.BeautifulSoup` (using the `lxml` parser) via `PythonCall`, then the DOCTYPE line is patched to point at `hansard.dtd`. This means a working, resolvable Python environment (with `beautifulsoup4` and `lxml` available) is a real prerequisite, even though the rest of the pipeline is Julia.

## Implementation details (steps)

The pipeline is implemented in `src/PSSSourceSGML/src/PSSSourceSGML.jl`:

### Step 0: Build the SGML link list (only runs if `HansardSGML.csv` is missing)

For every day from 1981 to 1997, for both houses, probes whether a Hansard SGML file exists at a predictable URL and records it if so, building `HansardSGML.csv`. This is a brute-force scan over roughly 6,000 dates x 2 houses, so it's slow and only intended to run once, the first time this file doesn't exist.

### Step 1: Download the SGML files

Downloads every link in `HansardSGML.csv` for the requested house into `sgmls/<year>/<year>_<month>_<day>.sgm`.

### Step 2: Convert SGML to XML

Runs each downloaded `.sgm` file through BeautifulSoup/lxml and writes the result into `xmls/`, patching the DOCTYPE line to reference `hansard.dtd`.

### Step 3: Compress (optional)

If compression was requested, archives everything under `source_sgml/<house>/` into `source_sgml/<house>.tar.zst` and removes the uncompressed directory.

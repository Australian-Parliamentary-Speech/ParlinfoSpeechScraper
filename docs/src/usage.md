# Usage

Here we describe the user interface regarding inputs and outputs for `PSSConvert`, the submodule that parses raw Hansard XML into CSV.

## Running PSSConvert

The normal way to run the full pipeline (downloading XML, downloading and converting SGML, then parsing into CSVs) is from the root of the repo:

```console
make run house
```
or
```console
make run senate
```
or, to run both:
```console
make run all
```

This uses the TOML file at `examples/house.toml` or `examples/senate.toml` to drive `PSSConvert`.

To re-run just the CSV parsing/editing step against a custom TOML file, without re-downloading anything, run it from `src/PSSConvert`:

```console
cd src/PSSConvert
make run <path-to-your-toml-file>
```

which forwards to `bin/run <path-to-your-toml-file>`. Useful flags (pass them after the TOML path):

* `-c`, `--should_compress` - compress the output directory into a `.tar.zst` once processing finishes
* `-s`, `--skip` - skip processing entirely (typically combined with `-c` to just compress an already-completed run)
* `-v`, `--verbose` - increase logging verbosity

### Input TOML file

The input TOML file defines all configuration for a `PSSConvert` run. This section documents every available option, and points to ready-to-use starter TOML files for both the Senate and the House.

Any relative path written inside the TOML file (`output_path`, and the `path`/`filename` under `XML_DIR`/`XML`) is resolved relative to the **directory containing the TOML file itself**, not the directory you ran the command from.

* output\_path (under [global]):
    - where to save the final CSV files after processing
    - Example: if set to "../output/source_csv/house" and the TOML file lives in `examples/`, the output files are saved to `output/source_csv/house` at the repo root

* path (under [[ XML\_DIR ]]):
    - a directory to process. All XML files under its year subdirectories are processed
    - Example: "../output/source_xml/house/xmls" processes every year subdirectory found there
    - You can list multiple `[[ XML_DIR ]]` blocks to process several directories (e.g. XML downloaded via `PSSSourceXML` alongside XML converted from SGML via `PSSSourceSGML`)

* filename (under [[ XML ]]):
    - use this instead of `XML_DIR` to process a single file rather than a whole directory
    - Example: "house_xmls/1983/1983_11_09.xml" processes just that one file

* which\_house (under [general\_options] )
    - Options: "house" for House of Representatives, "senate" for Senate

* year (under [general\_options])
    - Which years to process
    - Example: [1996,1997] processes years 1996 and 1997
    - Example: [2000,2000] processes only year 2000

* xml\_parsing (under [general\_options])
    - Whether to skip scraping
    - true = extract data from XML files
    - false = skip scraping, assuming there exists outputs. This is for runs that require editting only.

* edit (under [general\_options])
    - Processing steps to clean and format the CSV files after parsing
    - These run in the order listed - each step processes the output of the previous step
    - Common steps: "speaker\_time", "re", "free\_node", "flatten", "column\_decorate" (more explanation see below)
    - The order matters. It is strongly recommended to use the list provided in the sample file for the best outcome

* csv\_edit
    - Whether to apply editing operations to CSV files
    - true = apply edits
    - false = skip edits, keep raw extracted data

* run\_xml\_toggle
    - Master switch for all XML processing functions
    - true = run all XML processing steps normally. This is the recommended option.
    - false = skip all XML functions, only write samples or remove processing steps.

* sample
    - Optional; defaults to false if omitted
    - Whether to create sample output files for testing
    - true = create smaller sample files to check if processing works correctly
    - false = process all data without creating samples

* remove\_nums
    - Which intermediate CSV files to delete after processing (to save disk space)
    - The program creates files named like "data\_step\_0.csv", "data\_step\_1.csv", etc. This setting deletes those intermediate files, keeping only the final result
    - Default: [0,1,2,3,4,5,6,7] deletes everything except the final step.
    - Example: [0,1,2,3,4,5,6] deletes steps 0 through 6 (keeps only the final step)
    - Example: [0,1,2] deletes only the first 3 intermediate files
    - Example: [] keeps all intermediate files (uses more disk space)

* xml\_name\_clean
    - Whether to clean up XML filenames for inconsistent date formats
    - true = rename files to standard format. This is the recommended option.
    - false = keep original filenames

### Quick start input files

Ready-to-use starter files live at the repo root in `examples/house.toml` and `examples/senate.toml`, and are what `make run house`/`senate` use by default.

For the House:
```toml
[global]
output_path = "../output/source_csv/house"

[[ XML_DIR ]]
path = "../output/source_xml/house/xmls"

[[ XML_DIR ]]
path = "../output/source_sgml/house/xmls"

[ general_options ]
    which_house = "house"
    year = [1901,2026]
    xml_parsing = true
    edit = ["speaker_time","re","stage_direction","free_node","flatten","flatten","column_decorate","final_re"]
    csv_edit = true
    run_xml_toggle = true
    remove_nums = [0,1,2,3,4,5,6,7]
    xml_name_clean = false
```

For the Senate:
```toml
[global]
output_path = "../output/source_csv/senate"

[[ XML_DIR ]]
path = "../output/source_xml/senate/xmls"

[[ XML_DIR ]]
path = "../output/source_sgml/senate/xmls"

[ general_options ]
    which_house = "senate"
    year = [1901,2026]
    xml_parsing = true
    edit = ["speaker_time","re","stage_direction","free_node","flatten","flatten","column_decorate","final_re"]
    csv_edit = true
    run_xml_toggle = true
    remove_nums = [0,1,2,3,4,5,6,7]
    xml_name_clean = false
```

To process a single XML file instead of a whole directory, swap the `[[ XML_DIR ]]` block(s) for a single `[[ XML ]]` block:

```toml
[[ XML ]]
filename = "house_reserve_xmls/2010/2010_02_10.xml"
```

Note that if the date for the single XML is out of range from the `year` defined, the program might not run.

## Output: how dates are determined

Every XML file has a date associated with two independent sources, which don't always agree:

- **Filename date** — parsed from the XML file's name, which is expected to follow the `YYYY_MM_DD.xml` pattern (e.g. `2020_02_12.xml`). This is the date used to name output files: the final CSV for a given sitting is written as `<filename_date>_edit_step<N>.csv`.
- **XML date** — parsed from the date recorded inside the XML content itself, either from `session.header/date` or the `hansard/@date` attribute, depending on the document format.

Both dates are extracted for every file processed (see `get_date` in `RunModule.jl`). When they disagree, a warning is logged (`XML and Filename do not agree on dates`), but this does not stop processing — the **filename date** is always the one used for naming output files and detecting which processing phase applies.

To keep both pieces of information available for auditing rather than discarding the XML-derived date once the filename date is chosen, every run writes `date_comparison.csv` to the top of `output_path`, with one row per XML file processed and two columns, `Filename Date` and `XML Date`. This lets you find every file where the two disagree after the fact, without having to re-parse the XML. The dates summary test (see [Dates summary test](test.md#dates-summary-test)) checks this file automatically and reports any mismatches.

## Edit steps

Edit step implementations live in `src/PSSConvert/src/edit_funcs/`.

### stage\_direction

Identifies the parliamentary stage directions.

- Detects parliamentary stage directions using known procedural phrases
- Set speaker to "N/A".


### speaker\_time
Extracts timing and auxiliary information from speech rows. This is an early feature that was later deemed not very useful.

- Separates embedded time markers from speech content into a dedicated time column
- Adds new columns for speaker label, time, and other extracted metadata

### re

Extracts speaker information and cleans speech text.

- Identifies speaker names embedded in speech content and moves them to the speaker column
- Detects and labels interjections
- Makes an attempt to infer missing speaker names from structured text
- Removes speaker prefixes and formatting noise from speech content
- Drops rows with empty speech content

### free\_node

There are many unauthored speeches from the raw processing of XML. This step resolves unattributed ("free-flowing") rows within a debate.

- Assigns free or missing speaker names to the most recent valid speaker in the same debate
- Attributes quoted or continued speech to the correct speaker where possible
- Does not cross debate or sub-debate boundaries
- Removes placeholder speaker labels from the output

### flatten

Flattens multi-row speeches into single rows.

- Merges consecutive speech rows from the same speaker into one row
- Stops merging when a new speaker, debate context, or stage direction is encountered

### final\_re

Applies final cleaning and standardisation to the CSV output.

- Reclassifies rows with speaker information as speech
- Cleans speech text by removing leading punctuation and excess whitespace
- Drops rows with empty speech content

# Download the XML files

This step downloads all the available Hansard XML files directly, by crawling the sitemap on the Parlinfo website. It's implemented by the `PSSSourceXML` package, which lives at `src/PSSSourceXML` as a submodule of this repo.

## Output layout

Given an output directory `output/` (the default), files land in:

```
output/source_xml/<house>/
├── sitemaps/                                # step 1: raw sitemap XML pages
├── htmls/                                   # step 4: downloaded Hansard HTML pages
├── interim/                                 # step 2/3/5: intermediate url and link-diff files
├── xmls/<year>/<year>_<month>_<day>.xml     # step 6: the XML output
└── logs/                                    # log output
```

Once a run is compressed, this entire `<house>/` directory is archived to `output/source_xml/<house>.tar.zst` and the directory is deleted. If a `<house>.tar.zst` from a previous run already exists when a new run starts, it's decompressed automatically before processing continues.

## Re-running / incremental updates

Most steps check whether their own output already exists and skip themselves if so, which makes re-running mostly incremental - with two exceptions worth knowing about:

- **Step 1 always re-runs.** The sitemap index page gets overwritten in place on the server each time, so a cached local copy can't be trusted as "already downloaded."
- **Steps 2, 3 and 5 key their working files off *today's date*.** Each run diffs today's freshly-extracted link list against the accumulated list from all previous runs (`interim/urls.txt`) to find what's new, then merges the new links back in for next time. There's no explicit same-day lock or error if it's run twice in one day - it just re-extracts today's links and diffs again, which is a no-op if nothing changed on the server since the last run that day.

## Implementation details (steps)

The pipeline is a chain of steps implemented in `src/PSSSourceXML/src/PSSSourceXML.jl`, each one invoking the next:

### Step 1: Download the sitemap index pages

Downloads `https://parlinfo.aph.gov.au/sitemap/sitemapindex.xml`, then downloads each individual sitemap page it references into `sitemaps/`.

### Step 2: Extract Hansard links

Reads every sitemap page in `sitemaps/`, filters to links that look like Hansard content for the requested house (matched via a `hansardr`/`hansards` substring), and writes the deduplicated list to `interim/<today>_urls.txt`.

### Step 3: Diff against the existing link list

Compares `interim/<today>_urls.txt` against the accumulated `interim/urls.txt`, writes anything new to `interim/missing_urls.txt`, and merges it into `interim/urls.txt` so future runs treat it as already known.

### Step 4: Download the HTML pages

Downloads every URL listed in `missing_urls.txt` into `htmls/`, named by the page's query string.

### Step 5: Extract XML and PDF links

Parses each downloaded HTML page to find its Hansard document's XML and PDF download links, writing `date`, `xml_link`, `pdf_link`, `file` to `interim/<today>_xmls.csv`.

### Step 6: Download the XML files

Downloads every XML link listed in `interim/<today>_xmls.csv` into `xmls/<year>/<year>_<month>_<day>.xml`.

### Step 7: Compress (optional)

If compression was requested, archives everything under `source_xml/<house>/` into `source_xml/<house>.tar.zst` and removes the uncompressed directory.

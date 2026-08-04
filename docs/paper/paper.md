---
title: "ParlinfoSpeechScraper: A Julia package to scrape Hansard speech data"
date: {{ DD Month YYYY }}
authors:
    - name: "Eve Cheng"
      affiliation: "1" # Affiliations
      orcid: "0000-0003-3108-4000"
      corresponding: true # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
    - name: "Patrick Armstrong"
      affiliation: "2, 3, 4"
      orcid: "0000-0003-1997-3649"
      corresponding: false # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
affiliations:
    - name: "The Mathematical Sciences Institute, The Australian National University, Canberra, ACT 2611, Australia"
      index: 1
    - name: "The Research School of Astronomy and Astrophysics, The Australian National University, Canberra, ACT 2611, Australia"
      index: 2
    - name: "Department of Physics, University of California Berkeley, Berkeley, CA 94720, USA"
      index: 3
    - name: "E.O. Lawrence Berkeley National Laboratory, 1 Cyclotron Rd., Berkeley, CA, 94720, USA"
      index: 4
tags:
    - "julia"
    - "python"
    - "political science"
bibliography: "paper.bib"
---

# Summary
ParlinfoSpeechScraper is an open-source pipeline for acquiring and transforming Australian parliamentary speech records from the ParlInfo repository into structured, analysis-ready tabular data. Hansard — the official verbatim transcript of parliamentary debates in the House of Representatives and Senate — is a rich resource for political science, linguistics, and historical research, but the raw data is distributed across thousands of files in inconsistent formats that are not directly suitable for computational analysis. ParlinfoSpeechScraper bridges this gap by automating the full process of retrieval and conversion, from raw web files to clean tabular data.

The pipeline operates in two stages: downloading raw Hansard files from ParlInfo and converting legacy SGML-format records (1981-1997) to XML, and parsing all XML into CSV. The output is a set of CSV files — one per parliamentary sitting — where each row represents a single contribution and columns capture the speaker's name, party affiliation, electorate, role, debate context, and speech text from 1901 to the present.

# Statement of need

`ParlinfoSpeechScraper` was written to provide a complete, computationally readable record of Hansard debates for the analysis of debate quality under the Australian Research Council (ARC) Discovery Project *Australian Parliamentary Speech: How Deliberative? How Representative?* (DP230100864). Answering questions of this kind — how deliberative parliamentary debate is, and how representative it is of the electorate — requires speech-level data spanning the full history of the Australian Parliament, with consistent speaker, party, electorate, and debate-context metadata attached to every contribution.

The target audience is researchers in political science, linguistics, and computational social science who need machine-readable parliamentary speech data rather than the original web-published transcripts. It is also aimed at users who need the pipeline to stay usable as ParlInfo's published records grow and change over time, since new parsing modes, or small edits to existing ones, can be incorporated into the existing framework with minimal re-writing required.

# State of the field

An earlier point of comparison is *Digitization of the Australian Parliamentary Debates, 1998–2022*, which scraped Hansard over a similar period using XPath-based extraction [@katz2023digitization]. ParlinfoSpeechScraper improves on this with broader coverage, spanning 1901 to the present rather than 1998–2022, and a more flexible design that adapts to changes in ParlInfo's format.

A more recent project, *Hansard DB* [@chadwick2026hansarddb], releases a relational database of Australian parliamentary speech with question-answer pairing, typed interjections, and career-spanning speaker identity — but built by nine era-specific parsers that must be reworked from scratch if ParlInfo's XML format were to change again in the future. 

ParlinfoSpeechScraper, on the other hand, isolates period-specific parsing behind Julia's multiple dispatch: each feature is modular, in the sense that no existing file needs to be rewritten to accommodate a new era or a schema change — only a new module needs to be added. The speaker-identity resolution used by Hansard DB was developed by @leslie2024ausph, a member of our own project team, and can be used to extend ParlinfoSpeechScraper's output. A database like Hansard DB is one possible product of running this software, not a substitute for having it. 

Unlike Hansard DB, which is distributed as a static local database, the database produced from ParlinfoSpeechScraper's output will be hosted and maintained on the cloud, allowing it to be kept up to date as new Hansard records are published without requiring users to re-download or rebuild it themselves.

# Software design

The download stage retrieves Hansard files from ParlInfo by walking the site's sitemap index and fetching only files not present in previous runs, making incremental updates efficient as new parliamentary sessions are added. For records from 1981 to 1997, a separate conversion step transforms the SGML files into XML before they enter the main pipeline.

The scraping stage makes a single top-to-bottom pass through each XML file, reading nodes in order and writing any text content it finds — along with the speaker's name, affiliation, and contextual metadata — directly to CSV. Differences in XML structure across historical periods are handled by the same core algorithm, which is aware of the phase associated with each historical period.

{{ software_design }} # An explanation of the trade-offs you weighed, the design/architecture you chose, and why it matters for your research application. This should demonstrate meaningful design thinking beyond a superficial code structure description.

# Research impact statement

As part of the ARC Discovery Project, a Hansard database built from the output of this software, along with papers on parliamentary representation and deliberation, will be produced by the project team.

# AI usage disclosure

The Claude API was used to generate the documentation page for the program, to assist in structuring parts of the test suite, and to assist in drafting this manuscript. All AI-generated documentation, tests, and manuscript text were reviewed by the developers for accuracy and correctness before publication.

# Acknowledgments

This work was supported by the Australian Research Council Discovery Project *Australian Parliamentary Speech: How Deliberative? How Representative?* (DP230100864).

We thank Marija Taflaga, Patrick Leslie, Keith Dowding, Rohan Alexander, and Kenneth Benoit for their project management, advice, and general assistance. We are also grateful to research assistants Declan Thomas, Sofya Kalashnikova, Angela Gao, and Nicole Lawder for producing the gold-standard speech files used in the testing suite.

# References

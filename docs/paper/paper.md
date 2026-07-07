---
title: {{ ParlinfoSpeechScraper: A Julia package to scrape Hansard speech data}} # Title of the paper
date: {{ DD Month YYYY }} # Submission date
authors:
    - name: {{ Eve Cheng }} # Name. See [here](https://joss.readthedocs.io/en/latest/paper.html#author-names)
      affiliation: "{{ affiliation_1 }}, {{ affiliation_2 }}" # Affiliations
      orcid: {{ orcid_1 }} # Orcid
      corresponding: true # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
    - name: {{ Patrick Armstrong }} # Name
      affiliation: "{{ affiliation_1 }}, {{ affiliation_2 }}" # Affiliations
      orcid: {{ orcid_2 }} # Orcid
      corresponding: false # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
    - ...
affiliations:
    - name: {{ name_1 }} # Affiliation name
      index: 1
tags:
    - {{ Julia }} # Primary programming language
    - {{ Python }} # Other programming languages
    - ...
    - {{ Political science }} # Primary research field
    - {{ field_2 }} # Other research fields
    - ...
bibliography: paper.bib
---

# Summary
ParlinfoSpeechScraper is an open-source pipeline for acquiring and transforming Australian parliamentary speech records from the ParlInfo repository into structured, analysis-ready tabular data. Hansard — the official verbatim transcript of parliamentary debates in the House of Representatives and Senate — is a rich resource for political science, linguistics, and historical research, but the raw data is distributed across thousands of files in legacy and modern markup formats that are not directly suitable for computational analysis. ParlinfoSpeechScraper bridges this gap by automating the full process of retrieval and conversion, from raw web files to clean tabular data, without requiring users to handle the complexities of the underlying markup formats.

The pipeline operates in two stages: downloading raw Hansard files from ParlInfo and converting legacy SGML-format records (pre-1998) to XML, and parsing all XML into CSV. The output is a set of CSV files — one per parliamentary sitting — where each row represents a single contribution and columns capture the speaker's name, party affiliation, electorate, role, debate context, and speech text from 1901 to the present.

# Statement of need

Rohan's paper and some guy's scrape of all the dates?
{{ statement_of_need }} # A section that clearly illustrates the research purpose of the software and places it in the context of related work. This should clearly state what problems the software is designed to solve, who the target audience is, and its relation to other work.

# State of the field

The closest existing work is *Digitization of the Australian Parliamentary Debates, 1998–2022*, which scraped Hansard over a similar period using XPath-based extraction. ParlinfoSpeechScraper extends and improves on this in several respects. In terms of coverage, the existing work is limited to 1998–2022, whereas this software covers the full record from 1901 to the present and is designed to keep updating incrementally as new sittings are added, with no manual intervention required from the user. In terms of reliability, XPath-only extraction is sensitive to structural variation in the XML. For example, XPath-only extraction produces output where the ordering of speeches can be unreliable; the node-based traversal used here processes the document in document order, preserving the original sequence of contributions. In terms of extensibility, the existing code does not support multiple XML phases within a single run and is not structured for collaborative development or reuse. Because ParlinfoSpeechScraper isolates period-specific behaviour through Julia's multiple dispatch, a new phase can be added as a self-contained module when ParlInfo's XML schema changes in the future, without modifying the core pipeline. The existing approach would require significant reworking to accommodate such changes.

{{ state_of_the_field }} # A description of how this software compares to other commonly-used packages in the research area. If related tools exist, provide a clear “build vs. contribute” justification explaining your unique scholarly contribution and why existing alternatives are insufficient.

# Software design

The download stage retrieves Hansard files from ParlInfo by walking the site's sitemap index and fetching only files not present in previous runs, making incremental updates efficient as new parliamentary sessions are added. For records predating 1998, a separate conversion step transforms legacy SGML files into XML before they enter the main pipeline.

The scraping stage makes a single top-to-bottom pass through each XML file, reading nodes in order and writing any text content it finds — along with the speaker's name, affiliation, and contextual metadata — directly to CSV. Differences in XML structure across historical periods are handled simultaneously within the same pass by leveraging Julia's multiple dispatch, allowing period-specific behaviour to be defined without branching the core traversal logic.

{{ software_design }} # An explanation of the trade-offs you weighed, the design/architecture you chose, and why it matters for your research application. This should demonstrate meaningful design thinking beyond a superficial code structure description.

# Research impact statement

publication: ask Pat and Marija
material: all parlifo speech data, potentially upload to database. 

{{ research_impact_statement }} # Evidence of realized impact (publications, external use, integrations) or credible near-term significance (benchmarks, reproducible materials, community-readiness signals). The evidence should be compelling and specific, not aspirational.

# AI usage disclosure

Claude API was used to generate the documentation page for the program. The documentation page has been checked by the developers before publication. 

{{ ai_usage_disclosure }} # Transparent disclosure of any use of generative AI in the software creation, documentation, or paper authoring. If no AI tools were used, state this explicitly. If AI tools were used, describe how they were used and how the quality and correctness of AI-generated content was verified.

# Acknowledgments

Australian Research Council Discovery Project, Australian Parliamentary Speech: How Deliberative? How Representative? (DP230100864)

# References

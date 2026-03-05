---
title: {{ title }} # Title of the paper
date: {{ DD Month YYYY }} # Submission date
authors:
    - name: {{ name_1 }} # Name. See [here](https://joss.readthedocs.io/en/latest/paper.html#author-names)
      affiliation: "{{ affiliation_1 }}, {{ affiliation_2 }}" # Affiliations
      orcid: {{ orcid_1 }} # Orcid
      corresponding: true # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
    - name: {{ name_2 }} # Name
      affiliation: "{{ affiliation_1 }}, {{ affiliation_2 }}" # Affiliations
      orcid: {{ orcid_2 }} # Orcid
      corresponding: false # Is this the corresponding author?
      equal-contrib: true # Did this author contribute the same as other `equal-contrib` authors?
    - ...
affiliations:
    - name: {{ name_1 }} # Affiliation name
      index: 1
tags:
    - {{ language_1 }} # Primary programming language
    - {{ language_2 }} # Other programming languages
    - ...
    - {{ field_1 }} # Primary research field
    - {{ field_2 }} # Other research fields
    - ...
bibliography: paper.bib
---

# Summary

{{ summary }} # A description of the high-level functionality and purpose of the software for a diverse, non-specialist audience.

# Statement of need

{{ statement_of_need }} # A section that clearly illustrates the research purpose of the software and places it in the context of related work. This should clearly state what problems the software is designed to solve, who the target audience is, and its relation to other work.

# State of the field

{{ state_of_the_field }} # A description of how this software compares to other commonly-used packages in the research area. If related tools exist, provide a clear “build vs. contribute” justification explaining your unique scholarly contribution and why existing alternatives are insufficient.

# Software design

{{ software_design }} # An explanation of the trade-offs you weighed, the design/architecture you chose, and why it matters for your research application. This should demonstrate meaningful design thinking beyond a superficial code structure description.

# Research impact statement

{{ research_impact_statement }} # Evidence of realized impact (publications, external use, integrations) or credible near-term significance (benchmarks, reproducible materials, community-readiness signals). The evidence should be compelling and specific, not aspirational.

# AI usage disclosure

{{ ai_usage_disclosure }} # Transparent disclosure of any use of generative AI in the software creation, documentation, or paper authoring. If no AI tools were used, state this explicitly. If AI tools were used, describe how they were used and how the quality and correctness of AI-generated content was verified.

# Acknowledgments

{{ acknowledgments }} # Acknowledgement of any financial support.

# References

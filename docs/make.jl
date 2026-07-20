using Documenter
using DocStringExtensions
using PSSConvert

#DocMeta.setdocmeta!(
#    PSSConvert,
#    :DocTestSetup,
#    :(using PSSConvert);
#    recursive = true,
#    )

makedocs(
    sitename = "ParlinfoSpeechScraper Documentation",
    modules = [PSSConvert],
    pages = [
    "ParlinfoSpeechScraper" => "index.md",
    "XML download" => "download.md",
    "XML download (1981-1997)" => "sgml2xml.md",
    "Usage" => "usage.md",
    "Advanced Usage" => "advusage.md",
    "Nodes" => "nodes.md",
    "Function references" => "functionreference.md",
    "Testing" => "test.md",
    "Common errors and warnings" => "common_errors.md"
    ]
    )

deploydocs(repo = "github.com/Australian-Parliamentary-Speech/Scraper.git")

#python3 -m http.server --bind localhost

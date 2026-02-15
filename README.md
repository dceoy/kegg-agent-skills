# kegg-agent-skills

Agent Skills for the [KEGG REST API](https://www.kegg.jp/kegg/rest/keggapi.html).

## Skills

### kegg-api

Query the KEGG (Kyoto Encyclopedia of Genes and Genomes) REST API for biological
pathway, gene, compound, drug, disease, and reaction data.

Supports all 7 KEGG REST API operations:

| Operation | Purpose                                                     |
| --------- | ----------------------------------------------------------- |
| `info`    | Database release information                                |
| `list`    | List database entries                                       |
| `find`    | Search by keywords or chemical properties                   |
| `get`     | Retrieve entries (flat file, sequences, structures, images) |
| `conv`    | Convert identifiers between KEGG and external databases     |
| `link`    | Find cross-references between databases                     |
| `ddi`     | Drug-drug interaction lookup                                |

## Structure

```
kegg-api/
├── SKILL.md                       # Skill definition and instructions
├── scripts/
│   └── kegg_fetch.sh              # Helper script for API calls
└── references/
    └── api-reference.md           # Full API reference documentation
```

## Usage

Install as a Claude Agent Skill and use natural language to query KEGG, e.g.:

- "Find human pathways related to cancer"
- "Get the amino acid sequence for gene hsa:10458"
- "Convert these gene IDs to UniProt identifiers"
- "Check drug-drug interactions between D00564 and D00123"
- "What compounds are linked to enzyme ec:1.1.1.1?"

## License

[GNU AGPL v3](LICENSE)

---
name: kegg-api
description: Query the KEGG (Kyoto Encyclopedia of Genes and Genomes) REST API for biological pathway, gene, compound, drug, disease, and reaction data. Use when the user wants to (1) look up KEGG database entries such as genes, pathways, compounds, drugs, diseases, enzymes, or reactions, (2) search KEGG by keywords or chemical properties, (3) convert identifiers between KEGG and external databases (NCBI, UniProt, PubChem, ChEBI), (4) find cross-references between KEGG databases, (5) check drug-drug interactions, or (6) retrieve sequences, structures, pathway maps, or other KEGG data.
---

# KEGG REST API

Query biological data from KEGG via `https://rest.kegg.jp`.

**Constraints:** Max 3 requests/second. Academic use only.

## Quick Reference

Use `scripts/kegg_fetch.sh` for all API calls:

```bash
# Database info
scripts/kegg_fetch.sh info pathway

# List entries
scripts/kegg_fetch.sh list pathway hsa
scripts/kegg_fetch.sh list organism

# Search
scripts/kegg_fetch.sh find compound sugar
scripts/kegg_fetch.sh find compound 300-310 mol_weight

# Retrieve entries (max 10, flat file by default)
scripts/kegg_fetch.sh get hsa:10458 aaseq
scripts/kegg_fetch.sh get C00001

# Convert IDs
scripts/kegg_fetch.sh conv uniprot hsa
scripts/kegg_fetch.sh conv genes ncbi-geneid:948068

# Cross-references
scripts/kegg_fetch.sh link pathway hsa:10458
scripts/kegg_fetch.sh link drug disease

# Drug-drug interactions
scripts/kegg_fetch.sh ddi D00564+D00123
```

## Operations Summary

| Operation | Purpose | Pattern |
|---|---|---|
| `info` | Database release info | `info <database>` |
| `list` | List entries | `list <database> [org]` or `list <entries>` |
| `find` | Search by keyword/property | `find <database> <query> [option]` |
| `get` | Retrieve entry data | `get <entries> [option]` |
| `conv` | Convert identifiers | `conv <target> <source>` |
| `link` | Cross-references | `link <target> <source>` |
| `ddi` | Drug-drug interactions | `ddi <entries>` |

## Common Databases

- **Organisms**: 3/4-letter codes (e.g., `hsa` = human, `eco` = E. coli, `sce` = yeast)
- **Pathways**: `pathway` (reference) or with org code (e.g., `list pathway hsa`)
- **Genes**: organism-specific (e.g., `hsa:10458`) or `genes` (composite)
- **Chemicals**: `compound`, `glycan`, `drug`, or `ligand` (composite)
- **Functions**: `ko`, `enzyme`, `reaction`, `rclass`, `module`
- **Health**: `disease`, `drug`, `dgroup`, `network`, `variant`
- **External**: `ncbi-geneid`, `ncbi-proteinid`, `uniprot`, `pubchem`, `chebi`

## Entry ID Formats

- Gene: `hsa:10458` (org:id)
- Pathway: `map00010` (reference) or `hsa00010` (organism-specific)
- Compound: `C00001`
- Drug: `D00001`
- Disease: `H00001`
- Enzyme: `ec:1.1.1.1`
- Reaction: `rn:R00001`
- KO: `ko:K00001`
- Multiple entries: join with `+`

## get Options

| Option | For | Returns |
|---|---|---|
| `aaseq` | genes | Amino acid FASTA |
| `ntseq` | genes | Nucleotide FASTA |
| `mol` | compound/glycan/drug | MOL structure |
| `kcf` | compound/glycan/drug | KCF structure |
| `image` | compound/glycan/drug/pathway | PNG (1 entry only) |
| `kgml` | pathway | KEGG XML (1 entry only) |
| `json` | pathway | JSON (1 entry only) |
| *(none)* | all | Flat file |

## find Options (compound/drug only)

| Option | Description |
|---|---|
| `formula` | Chemical formula (partial match, e.g., `C7H10O5`) |
| `exact_mass` | Exact mass, range with `-` (e.g., `174.05-174.06`) |
| `mol_weight` | Molecular weight, range with `-` (e.g., `300-310`) |

## Workflow Examples

### Find genes in a pathway
```bash
# List human pathways
scripts/kegg_fetch.sh list pathway hsa
# Get genes linked to a pathway
scripts/kegg_fetch.sh link hsa hsa05130
# Get gene details
scripts/kegg_fetch.sh get hsa:10458
```

### Search compound and get structure
```bash
scripts/kegg_fetch.sh find compound aspirin
scripts/kegg_fetch.sh get C01405/mol
```

### Convert gene IDs to UniProt
```bash
scripts/kegg_fetch.sh conv uniprot hsa:10458+hsa:150
```

### Check drug interactions
```bash
scripts/kegg_fetch.sh ddi D00564
scripts/kegg_fetch.sh ddi D00564+D00123
```

### Find diseases related to a drug
```bash
scripts/kegg_fetch.sh link disease D00564
```

For full API details including all database names, identifier formats, and options, see [references/api-reference.md](references/api-reference.md).

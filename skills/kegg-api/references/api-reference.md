# KEGG REST API Reference

Base URL: `https://rest.kegg.jp`

Rate limit: Maximum 3 requests per second. Exceeding this will result in access being blocked.

Access restriction: Academic use only.

## Databases

### Internal Databases

| Database   | Content                                                                                   |
| ---------- | ----------------------------------------------------------------------------------------- |
| `pathway`  | KEGG pathway maps                                                                         |
| `brite`    | BRITE functional hierarchies                                                              |
| `module`   | KEGG modules                                                                              |
| `ko`       | KEGG Orthology                                                                            |
| `<org>`    | Genes for a specific organism (3/4-letter code, e.g., `hsa` for human, `eco` for E. coli) |
| `vg`       | Viral genes                                                                               |
| `vp`       | Viral proteins                                                                            |
| `ag`       | Addendum genes                                                                            |
| `genome`   | KEGG genome                                                                               |
| `compound` | Chemical compounds                                                                        |
| `glycan`   | Glycans                                                                                   |
| `reaction` | Biochemical reactions                                                                     |
| `rclass`   | Reaction classes                                                                          |
| `enzyme`   | Enzyme nomenclature                                                                       |
| `network`  | Disease/drug network                                                                      |
| `variant`  | Human gene variants                                                                       |
| `disease`  | Human diseases                                                                            |
| `drug`     | Drugs                                                                                     |
| `dgroup`   | Drug groups                                                                               |

Composite databases:

- `genes` = all organism gene databases (`<org>`, `vg`, `vp`, `ag`)
- `ligand` = chemical databases (`compound`, `glycan`, `reaction`, `enzyme`)
- `kegg` = all databases

### Outside Databases (for conv/link)

| Database         | Used in    |
| ---------------- | ---------- |
| `ncbi-geneid`    | conv, link |
| `ncbi-proteinid` | conv, link |
| `uniprot`        | conv, link |
| `pubchem`        | conv, link |
| `chebi`          | conv, link |
| `pubmed`         | link only  |
| `atc`            | link only  |
| `jtc`            | link only  |
| `ndc`            | link, ddi  |
| `yj`             | link, ddi  |
| `yk`             | link only  |

## Entry Identifier Formats

| Format          | Example         | Description               |
| --------------- | --------------- | ------------------------- |
| `<org>:<gene>`  | `hsa:10458`     | Gene in an organism       |
| `map<number>`   | `map00010`      | Reference pathway         |
| `<org><number>` | `hsa00010`      | Organism-specific pathway |
| `ko:<id>`       | `ko:K00001`     | KEGG Orthology            |
| `ec:<id>`       | `ec:1.1.1.1`    | Enzyme                    |
| `rn:<id>`       | `rn:R00001`     | Reaction                  |
| `C<number>`     | `C00001`        | Compound                  |
| `G<number>`     | `G00001`        | Glycan                    |
| `D<number>`     | `D00001`        | Drug                      |
| `H<number>`     | `H00001`        | Disease                   |
| `br:<id>`       | `br:ko00001`    | BRITE hierarchy           |
| `md:<id>`       | `md:hsa_M00002` | Module                    |
| `T<number>`     | `T01001`        | Genome                    |

Multiple entries: join with `+` (e.g., `hsa:10458+ece:Z5100`).

## Operations

### 1. info -- Database Information

```
/info/<database>
```

`<database>` = `kegg | pathway | brite | module | ko | genes | <org> | vg | vp | ag | genome | ligand | compound | glycan | reaction | rclass | enzyme | network | variant | disease | drug | dgroup`

Examples:

```
/info/kegg
/info/pathway
/info/hsa
/info/compound
```

### 2. list -- Entry Listing

```
/list/<database>
/list/<database>/<org>
/list/<dbentries>
```

The special database name `organism` is allowed only in this operation.

`<database>/<org>` form is used for `pathway` and `module` only.

Examples:

```
/list/pathway
/list/pathway/hsa
/list/module/hsa
/list/organism
/list/hsa
/list/compound
/list/T01001
/list/hsa:10458+ece:Z5100
```

### 3. find -- Search

```
/find/<database>/<query>
/find/<database>/<query>/<option>
```

`<database>` = `pathway | module | disease | drug | environ | ko | genome | compound | glycan | reaction | rclass | enzyme | genes | ligand`

Note: `brite` is not supported.

`<option>` (compound/drug only) = `formula | exact_mass | mol_weight | nop`

- `formula`: chemical formula search (partial match, any atom order)
- `exact_mass`: exact mass search; range with `-` (e.g., `174.05-174.06`)
- `mol_weight`: molecular weight search; range with `-` (e.g., `300-310`)

Examples:

```
/find/compound/sugar
/find/compound/C7H10O5/formula
/find/compound/174.05/exact_mass
/find/compound/300-310/mol_weight
/find/drug/aspirin
/find/genes/shiga+toxin
/find/pathway/cancer
```

### 4. get -- Data Retrieval

```
/get/<dbentries>[/<option>]
```

Input limit: up to 10 entries. For `image`/`kgml`: 1 entry only.

`<option>`:

| Option   | Applicable to                   | Description                 |
| -------- | ------------------------------- | --------------------------- |
| `aaseq`  | genes                           | Amino acid sequence (FASTA) |
| `ntseq`  | genes                           | Nucleotide sequence (FASTA) |
| `mol`    | compound, glycan, drug          | MOL format structure        |
| `kcf`    | compound, glycan, drug          | KCF format structure        |
| `image`  | compound, glycan, drug, pathway | PNG image                   |
| `conf`   | compound, glycan, drug          | Configuration data          |
| `kgml`   | pathway                         | KEGG Markup Language XML    |
| `json`   | pathway                         | JSON format                 |
| _(none)_ | all except brite                | Flat file                   |

Examples:

```
/get/hsa:10458+ece:Z5100
/get/hsa:10458/aaseq
/get/hsa:10458/ntseq
/get/C01290/mol
/get/C01290/image
/get/hsa05130/image
/get/hsa05130/kgml
/get/hsa05130/json
/get/ko:K00001
/get/ec:1.1.1.1
/get/D00001/mol
```

### 5. conv -- ID Conversion

```
/conv/<target_db>/<source_db>[/<option>]
/conv/<target_db>/<dbentries>[/<option>]
```

Gene identifiers: `<org>` ↔ `ncbi-geneid | ncbi-proteinid | uniprot`

Chemical identifiers: `compound | glycan | drug` ↔ `pubchem | chebi`

`<option>` = `turtle | n-triple` (RDF output)

Examples:

```
/conv/eco/ncbi-geneid
/conv/ncbi-geneid/eco
/conv/ncbi-proteinid/hsa:10458+ece:Z5100
/conv/uniprot/hsa
/conv/compound/pubchem
/conv/pubchem/compound
/conv/chebi/compound
/conv/genes/ncbi-geneid:948068
```

### 6. link -- Cross-references

```
/link/<target_db>/<source_db>[/<option>]
/link/<target_db>/<dbentries>[/<option>]
```

`<target_db>` / `<source_db>` = any internal database + `pubmed | atc | jtc | ndc | yj | yk`

`<option>` = `turtle | n-triple` (RDF output)

Examples:

```
/link/pathway/hsa
/link/pathway/hsa:10458+ece:Z5100
/link/ko/hsa:10458
/link/compound/pathway
/link/pathway/compound
/link/enzyme/compound
/link/reaction/enzyme
/link/drug/disease
/link/pubmed/hsa
```

### 7. ddi -- Drug-Drug Interaction

```
/ddi/<dbentries>
```

`<dbentries>` = drug D numbers, or `ndc`/`yj` codes.

Single entry: all known interactions for that drug.
Multiple entries (joined with `+`): checks interactions between given drugs.

Contains CI (contraindication) and P (precaution) interactions.

Examples:

```
/ddi/D00564
/ddi/D00564+D00123
```

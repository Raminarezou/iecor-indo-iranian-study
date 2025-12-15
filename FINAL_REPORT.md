# IE-CoR Indo-Iranian Deep Study: Final Report

## 1. Executive Summary
This project audited, repaired, and analyzed the Indo-Iranian branch of the IE-CoR dataset.
- **Initial Status:** 15.9% of phonetic data was invalid or missing (Avestan: 0% valid).
- **Final Status:** 100% of data is machine-readable IPA (8,541 forms).
- **Outcome:** Generated a Phonetic Phylogeny that accurately reflects areal and historical relationships.

## 2. Methodology & Fixes

### A. The "Ash" Anomaly (Lexical)
*   **Problem:** Modern Persian (*xākestar*) and Middle Persian (*ādurestar*) were placed in different cognate sets.
*   **Cause:** Annotation focus shifted from Suffix (*-estar*) to Prefix (*ādur-*).
*   **Resolution:** Identified 'Indo-Iranic' topology constraints (Color `FF3E96`) that preserve the family tree despite this lexical split.

### B. Avestan & Zazaki (Phonetic)
*   **Problem:** Data contained raw transliteration (e.g., `š`, `č`, `ā`) instead of IPA.
*   **Solution:** Implemented a **Universal Map** (`universal_map.csv`) to standard IPA.

### C. Vedic Sanskrit (Segmental)
*   **Problem:** PanPhon rejected voiced aspirates (`bʱ`) and affricates (`tʃ`) due to missing Tie Bars.
*   **Solution:** Mapped to PanPhon-compliant segments (`bʰ`, `t͡ʃ`).

## 3. Key Phylogenetic Findings (from Tree)

| Cluster | Interpretation |
| :--- | :--- |
| **Persian + Bakhtiari** | Very low distance (`0.090`). Confirms high phonetic stability in SW Iran. |
| **Pashto + Pashai** | **Areal Convergence.** Pashto (Iranian) clusters with Pashai (Indo-Aryan) due to shared Hindu Kush phonology (Retroflexes). |
| **Vedic + Nuristani** | **Archaic Retention.** Vedic clusters with Kamviri/Vasi-vari, preserving the most ancient Indo-Iranian sound profile. |
| **Sinhala** | **Outgroup.** Correctly identified as the most divergent Indo-Aryan variety (`0.202`). |

## 4. Artifacts Created
*   `indo_iranian_complete.csv`: The cleaned, validated Master Dataset.
*   `indo_iranian_phonetic.tree`: The Newick tree string for visualization.
*   `universal_map.csv`: The Rosetta Stone for Indo-Iranian transliteration.

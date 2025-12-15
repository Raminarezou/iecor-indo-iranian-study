# Indo-Iranian Phonetic Standardization (IE-CoR Deep Study)

**A machine-readable, phonetically standardized dataset of the Indo-Iranian language family.**

This repository contains the artifacts of a deep audit and repair of the [IE-CoR](https://github.com/lexibank/iecor) dataset. It solves critical issues regarding phonetic segmentation (Avestan/Vedic), lexical anomalies (Persian), and phylogenetic topology.

## 📂 Key Artifacts

| File | Description |
| :--- | :--- |
| **[`indo_iranian_complete.csv`](./indo_iranian_complete.csv)** | **The Gold Standard Data.** 8,541 validated, space-delimited IPA forms covering the entire branch. |
| **[`IECOR_LOGIC_MAP.psc`](./IECOR_LOGIC_MAP.psc)** | **System Architecture (v3.0).** Exhaustive pseudocode specification of the logic, filters, and fixes used. |
| **[`indo_iranian_phonetic.tree`](./indo_iranian_phonetic.tree)** | **Phylogeny.** Newick tree generated from PanPhon feature distances. |
| **[`universal_map.csv`](./universal_map.csv)** | **Rosetta Stone.** The transliteration rules used to standardize Zazaki, Avestan, and Sinhala. |

## 🛠️ Tools & Usage

### The Standardizer Engine
We developed a custom Python module to clean linguistic data:
```python
from standardizer import UniversalStandardizer
std = UniversalStandardizer()

# Handles Zazaki transliteration AND PanPhon validation
clean_ipa = std.clean("pišt") 
# Output: "p i ʃ t"

### 2. Verify `README_ENVIRONMENT.md`
Earlier, we had a directory error (`fatal: pathspec...`) when trying to add this file. Let's re-generate it **right here** to ensure it is definitely included in the update.

```powershell
@'
# Environment & Technical Context

## System Requirements
*   **OS:** Windows (Requires `python -X utf8` flag)
*   **Python:** 3.10+
*   **Dependencies:** `panphon`, `lexibank_iecor`, `pycldf`

## Critical Patches
To run this code against the raw IE-CoR repository, you must apply the following fix:
1.  **Fix Entry Points:** Create an empty file at `iecorcommands/__init__.py`.
2.  **Install Editable:** Run `pip install -e .` in the root directory.

## Directory Layout
*   `cldf/` - Raw Source Data
*   `standardizer.py` - The Custom Cleaning Engine
*   `universal_map.csv` - Config for Standardizer
*   `indo_iranian_complete.csv` - The Output Data

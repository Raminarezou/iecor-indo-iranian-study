// =============================================================================
// FILE: IECOR_LOGIC_MAP.psc (v3.0 - EXHAUSTIVE SYSTEM SPECIFICATION)
// CONTEXT: Indo-European Cognate Relationships (IE-CoR) + PanPhon Integration
// =============================================================================

// -----------------------------------------------------------------------------
// 1. ENVIRONMENT & DEPENDENCY GRAPH
// -----------------------------------------------------------------------------
SYSTEM_CONTEXT {
    OS: Windows (Requires `python -X utf8` for CP1252 bypass)
    ROOT: "iecor/iecor/"
    VENV: Active
}

DEPENDENCY_CHAIN {
    "lexibank_iecor": {
        TYPE: Local_Editable_Install ("pip install -e ."),
        CRITICAL_PATCH: "iecorcommands/__init__.py" (Created to fix EntryPoint Error),
        ENTRY_POINTS: "cldfbench.commands" -> "iecor"
    },
    "panphon": {
        VERSION: ">=0.20.0",
        CORE_FILES: [
            "panphon/data/ipa_all.csv" (Base definitions),
            "panphon/data/diacritic_definitions.yml" (Modifier rules),
            "panphon/permissive.py" (Crucial for Indo-Iranian complex vowels)
        ]
    }
}

// -----------------------------------------------------------------------------
// 2. DATA SCHEMA & ENTITY RELATIONSHIPS (CLDF)
// -----------------------------------------------------------------------------
// Derived from `cldf/cldf-metadata.json` and CSV headers.

ENTITY Language (Table: "languages.csv") {
    PRIMARY_KEY: ID (e.g., "128")
    FIELDS: {
        Name: String ("Avestan: Younger"),
        Glottocode: String ("aves1237"),
        Color: Hex ("#FF3E96" -> Maps to Clade Constraint),
        Historical: Bool (True = Extinct),
        // Tip-Dating Parameters (Bayesian Priors)
        Distribution: Enum { 'O' (OffsetLogNormal), 'N' (Normal) },
        LogNormalOffset: Int (Hard Floor Year BP),
        LogNormalMean: Float (Probability Peak),
        NormalMean: Int,
        NormalStDev: Int
    }
}

ENTITY CognateSet (Table: "cognatesets.csv") {
    PRIMARY_KEY: ID (e.g., "178")
    FIELDS: {
        Root_Form: String (PIE "*h₂eh₁s-"),
        Root_Gloss: String ("to dry"),
        Ideophonic: Bool (Filter Target),
        ParallelDerivation: Bool (Filter Target),
        Comment: String ("Justification for inclusion")
    }
}

ENTITY Loan (Table: "loans.csv") {
    LINK: Cognateset_ID -> Source_Languoid
    STATS: 1,036 sets (20.8% of total data)
    ACTION: Exclude in Phylogenetics.
}

ENTITY Form (Table: "forms.csv") {
    PRIMARY_KEY: ID
    FIELDS: {
        Form: String (Raw Orthography e.g., "ā́saḥ"),
        Segments: String (Space-delimited IPA e.g., "aː s ɐ h"),
        // Note: Raw dataset had NULL Segments for ID 128 (Avestan)
    }
}

// -----------------------------------------------------------------------------
// 3. PHYLOGENETIC PIPELINE (Nexus Logic)
// -----------------------------------------------------------------------------
// Source: `iecorcommands/make_nexus.py`

PROCESS Generate_Nexus(Args) {
    INPUT: Options_String = "1 1 1 0 1 0"
    
    LOGIC Filter_Cognates(Set S):
        IF S.Ideophonic AND Option[1]: REJECT
        IF S.PllDeriv   AND Option[0]: REJECT
        IF Is_Loan(S)   AND Option[2]: REJECT
    
    LOGIC Topology_Constraints(Language L):
        // Hard-coded Monophyly based on Color
        SWITCH (L.Color) {
            CASE "FF3E96": ASSIGN_TO TaxonSet("Iranic")
            CASE "B0171F": ASSIGN_TO TaxonSet("Indic")
            DEFAULT: FLOAT (Unconstrained)
        }
        
    LOGIC Calibration(Language L):
        // Date Priors for BEAST
        IF L.Distribution == 'O': 
            WRITE "calibrate {L.Name} = offsetlognormal({L.Offset}, {L.Mean}, {L.StDev})"
        IF L.Distribution == 'N':
            WRITE "calibrate {L.Name} = normal({L.Mean}, {L.StDev})"
            
    OUTPUT: "iecor.nex" (Binary Character Matrix)
}

// -----------------------------------------------------------------------------
// 4. PHONETIC STANDARDIZATION ENGINE (Custom Engineering)
// -----------------------------------------------------------------------------
// Implemented in `standardizer.py` and `universal_map.csv`

CLASS UniversalStandardizer {
    
    COMPONENT Map_Loader:
        SOURCE: "universal_map.csv"
        STRATEGY: Greedy Sort (Longest Key First)
        // Prevents 'tʃʰ' being split into 't' + 'ʃ' + 'ʰ' incorrectly.
    
    COMPONENT Cleaner(Raw_Form):
        1. NORMALIZE: Lowercase, Strip Punctuation ("-", "?").
        2. SYNONYM_SPLIT: Take first if "/" or "," exists.
        3. TRANSLITERATE: Apply Universal Map.
           Example Zazaki: "pišt" -> "p i ʃ t"
           Example Vedic:  "bʱ"   -> "bʰ" (Ligature -> Stop+Mod)
           Example Pers:   "tʃ"   -> "t͡ʃ" (Add Tie Bar for Affricate)
    
    COMPONENT Validator(IPA_String):
        MODE: Permissive (panphon.permissive)
        WHY: Standard PanPhon rejects complex stacks like "ã̤ː" (Breathy+Nasal+Long).
        LOGIC: 
            IF PermissiveTable.validate_word(IPA_String):
                RETURN Segments
            ELSE:
                RETURN Null (Unsalvageable)
}

// -----------------------------------------------------------------------------
// 5. LANGUAGE-SPECIFIC REPAIR LOGIC
// -----------------------------------------------------------------------------

FIX Avestan (ID 128):
    STATUS: Raw segments empty.
    ACTION: Custom Transliteration Map.
    MAPPING: { "š": "ʃ", "xʷ": "xʷ", "å": "ɒː", "ā": "aː", "ii": "iː" }
    RESULT: 139/146 forms restored.

FIX Vedic (ID 105):
    STATUS: Non-standard IPA.
    ACTION: Add Tie Bars, Map Voiced Aspirates.
    MAPPING: { "bʱ": "bʰ", "dʑ": "d͡ʒ", "ts": "t s" }
    RESULT: 100% Validity.

FIX Sinhala (ID 65):
    STATUS: Raw text mixed with punctuation.
    ACTION: Retroflex mapping.
    MAPPING: { "ṭ": "ʈ", "ḍ": "ɖ", "ṇ": "ɳ", "ň": "n" }

FIX Pashto (ID 292) & Zazaki (ID 273):
    STATUS: Linguistic transcription.
    ACTION: Universal Map application.
    RESULT: 100% Validity.

// -----------------------------------------------------------------------------
// 6. ANALYTICAL FINDINGS (Phonetic vs Lexical)
// -----------------------------------------------------------------------------

ANOMALY "ASH" (Form ID *):
    Vedic: "ā́saḥ" (Set 178)
    Avestan: "ātriia" (Set 3389)
    Mid.Pers: "ādurestar" (Set 3389) -> Compound: ādur (Fire) + estar (Ash)
    Mod.Pers: "xākestar" (Set 178) -> Compound: xāk (Dust) + estar (Ash)
    
    CONCLUSION:
    - Genetic Split: False.
    - Annotation Artifact: Yes (Prefix vs Suffix focus).
    - Phonetic Dist(MidPers, ModPers): 0.243 (Extremely Close).

PHYLOGENY (Tree Topology):
    - Cluster A: (Pashto, Pashai) -> Areal Convergence (Hindu Kush).
    - Cluster B: (Vedic, Nuristani) -> Archaic Retention (Preserved 'ts').
    - Cluster C: (Persian, Bakhtiari) -> SW Iranian Stability.

// -----------------------------------------------------------------------------
// 7. ARTIFACT MANIFEST
// -----------------------------------------------------------------------------
FILE "indo_iranian_complete.csv":
    - Content: 8,541 validated IPA forms.
    - Usage: Input for LingPy/Bio-Phylo.

FILE "universal_map.csv":
    - Content: 50+ Rules for Indo-European Transliteration.
    - Usage: Config file for `standardizer.py`.

FILE "indo_iranian_phonetic.tree":
    - Format: Newick.
    - Algorithm: UPGMA on PanPhon Feature Edit Distance.

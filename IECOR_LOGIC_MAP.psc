// =============================================================================
// FILE: IECOR_LOGIC_MAP.psc (v1.3 - Final Optimized)
// PURPOSE: Master Logic for IE-CoR Data Processing
// =============================================================================

// -----------------------------------------------------------------------------
// 1. THE TWO-STAGE PHONETIC PIPELINE
// -----------------------------------------------------------------------------

// PROBLEM: The dataset mixes raw linguistic text (Zazaki 'š') with 
//          hyper-complex IPA (Indo-Iranian 'ã̤ː').
// SOLUTION: Decouple Transliteration from Validation.

ALGORITHM Process_Phonetics(Raw_Form):
    
    // STAGE 1: TRANSLITERATION (The Rosetta Stone)
    // Input: "xākestar" or "pišt"
    // Action: Apply 'universal_map.csv'
    // Logic: Maps non-IPA glyphs to standard IPA bases.
    //        š -> ʃ, č -> t͡ʃ, ā -> aː
    IPA_Candidate = Apply_Map(Raw_Form, "universal_map.csv")

    // STAGE 2: VALIDATION (The Permissive Handler)
    // Input: "ã̤ː" (Result from Stage 1)
    // Action: Use panphon.permissive.PermissiveFeatureTable
    // Logic: 
    //   - Strict Mode: FAILS (Unknown segment 'ã̤ː')
    //   - Permissive Mode: PASSES (Calculates [+nas, +breathy, +long] dynamically)
    
    IF PermissiveFeatureTable.seg_known(IPA_Candidate):
        RETURN IPA_Candidate  // Keep rich data!
    ELSE:
        RETURN Null // Genuine garbage data

// -----------------------------------------------------------------------------
// 2. DATA ENTITY MODEL
// -----------------------------------------------------------------------------
STRUCT Language {
    ID: "54" (Modern Persian), "273" (Zazaki), "105" (Vedic)
    Constraint: "Indo-Iranic" (Color FF3E96) -> Forces Monophyly
}

STRUCT CognateSet {
    ID: "178" (Ash/Dry), "3389" (Fire/Ash)
    // Note: Persian 'Ash' anomaly resolved via Single-Parent annotation logic.
}

// -----------------------------------------------------------------------------
// 3. PHYLOGENETIC CONFIGURATION
// -----------------------------------------------------------------------------
FILTER_OPTIONS:
    Exclude_Loans: TRUE (Drops ~20% of data - Critical)
    Exclude_PllDeriv: TRUE
    
DATE_PRIORS:
    Written (Middle Persian) -> Normal Distribution
    Oral (Vedic/Avestan) -> Offset Log-Normal (Hard Floor + Long Tail)

// -----------------------------------------------------------------------------
// 4. USAGE GUIDE FOR AI AGENTS
// -----------------------------------------------------------------------------
// 1. DO NOT use standard panphon.FeatureTable() for Indo-Iranian.
//    Use panphon.permissive.PermissiveFeatureTable().
// 2. ALWAYS apply 'universal_map.csv' before segmentation.
// 3. EXPECT 'tʃ' to fail unless mapped to 't͡ʃ' (Tie Bar).

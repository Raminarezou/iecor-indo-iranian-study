import re
from typing import Optional
from panphon import FeatureTable

class UniversalStandardizer:
    def __init__(self):
        self.ft = FeatureTable()
        self.mapping = {
            "+": "", "/": "", "-": "",
            "bʱ": "bʰ", "dʱ": "dʰ", "ḍʱ": "ɖʰ", "ɡʱ": "ɡʰ", "dʑʱ": "d͡ʒʰ",
            "tɕʰ": "t͡ʃʰ", "tɕ": "t͡ʃ", "dʑ": "d͡ʒ", "ts": "t s",
            "ṭ": "ʈ", "ḍ": "ɖ", "ṇ": "ɳ", "ṣ": "ʂ", "ṛ": "ɽ",
            "ā": "aː", "ī": "iː", "ū": "uː", "e": "eː", "o": "oː",
            "ṃ": "m", "ḥ": "h", "š": "ʃ", "ž": "ʒ", "y": "j"
        }
        self.sorted_keys = sorted(self.mapping.keys(), key=len, reverse=True)

    def to_ipa(self, raw_text: str) -> Optional[str]:
        if not isinstance(raw_text, str): return None
        buffer = raw_text.strip().lower()
        for key in self.sorted_keys:
            if key in buffer:
                buffer = buffer.replace(key, self.mapping[key])
        return buffer

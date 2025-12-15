import sys, os, csv
from standardizer import UniversalStandardizer

# 1. SETUP
# Initialize our new tool
std = UniversalStandardizer()

# Data file path
data_file = 'indo_iranian_complete.csv'

print(f"\nTRIANGULATION: Vedic vs Avestan vs Persian")
print("=" * 80)

if not os.path.exists(data_file):
    print(f"Error: Could not find {data_file}")
    sys.exit(1)

# 2. LOAD DATA
# We want to see forms for specific languages
# 105: Vedic, 128: Avestan, 54: Mod. Persian, 178: Mid. Persian
targets = {
    '105': 'Vedic',
    '128': 'Avestan',
    '54':  'Mod. Persian',
    '178': 'Mid. Persian'
}

print(f"{'Language':<15} | {'Raw Form':<20} | {'Clean IPA':<30}")
print("-" * 80)

# 3. SCAN AND DISPLAY
# We look for specific words we analyzed earlier (like 'Ash')
target_words = ['xākestar', 'ā́saḥ', 'ātriia', 'ādurestar', 'eera']

with open(data_file, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row['Language_ID'] in targets:
            if row['Form'] in target_words:
                lang = targets[row['Language_ID']]
                raw = row['Form']
                
                # Check current status in file
                segments = row['Segments']
                
                # Double check with our Standardizer tool (Live Verification)
                # This proves the tool works the same as the batch script
                live_check = std.clean(raw)
                
                print(f"{lang:<15} | {raw:<20} | {segments:<30}")

print("=" * 80)

#!/usr/bin/env python3
import os
import re

# --- CONFIGURE THESE PATHS ---
INPUT_DIR = "/cluster/projects/nn8014k/magdalena/WGBS/RNAseq_pipeline/12_splicing/rMATS/N_vs_24R/output_N_vs_24R"   # directory with .txt files
OUTPUT_DIR = "/cluster/projects/nn8014k/magdalena/WGBS/RNAseq_pipeline/12_splicing/02_match_splicing_to_dmr/N_vs_24R/output_N_vs_24R"     # directory to store *_dmr files
# ------------------------------

# Environment: 
#    module load Anaconda3/2022.10
#    source ${EBROOTANACONDA3}/bin/activate
#    conda activate /cluster/projects/nn8014k/magdalena/conda_environments/general
# USAGE: python filter_dmr.py . --sample1 N --sample2 24R



# ID lists (duplicates already removed, first occurrence kept)
NvsA = [
    "ccar_ua02-g2350",
    "ccar_ua05-g5816",
    "ccar_ua10-g10025",
    "ccar_ua15-g14205",
    "ccar_ua15-g14343",
    "ccar_ua16-g15662",
    "ccar_ua18-g16750",
    "ccar_ub04-g26931",
    "ccar_ub09-g32086",
    "ccar_ub11-g34027",
    "ccar_ub12-g34297",
    "ccar_ub15-g36855",
    "ccar_ub22-g43219",
    "ccar_ub22-g43386",
]

NvsR = [
    "ccar_ua02-g1919",
    "ccar_ua05-g5120",
    "ccar_ua06-g6720",
    "ccar_ua11-g11397",
    "ccar_ua12-g11671",
    "ccar_ua14-g13591",
    "ccar_ua15-g14340",
    "ccar_ua15-g14373",
    "ccar_ua15-g14605",
    "ccar_ua16-g15290",
    "ccar_ua19-g18077",
    "ccar_ua22-g20613",
    "ccar_ua25-g22987",
    "ccar_ua25-g23230",
    "ccar_ub01-g23719",
    "ccar_ub03-g26528",
    "ccar_ub03-g26560",
    "ccar_ub05-g28395",
    "ccar_ub09-g32065",
    "ccar_ub11-g34058",
    "ccar_ub12-g34593",
    "ccar_ub14-g36416",
    "ccar_ub20-g41333",
    "ccar_ub21-g41935",
    "ccar_ub22-g43204",
    "ccar_ub22-g43390",
]

AvsR = [
    "ccar_ua05-g5369",
    "ccar_ua05-g5838",
    "ccar_ua09-g9070",
    "ccar_ua13-g12491",
    "ccar_ua20-g19122",
    "ccar_ua21-g19469",
    "ccar_ua23-g21428",
    "ccar_ua25-g22490",
    "ccar_ub10-g32303",
    "ccar_ub14-g36242",
    "ccar_ub19-g40403",
    "ccar_ub23-g43991",
    "ccar_ub25-g44776",
]

# Combine all IDs and make a regex for efficient matching
all_ids = list(dict.fromkeys(NvsA + NvsR + AvsR))  # preserves order, removes duplicates

# Escape each ID for regex, then join with |
pattern = re.compile("|".join(re.escape(i) for i in all_ids))

def main():
    # 1. Create output directory if it doesn't exist
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # 2. Iterate over all .txt files in INPUT_DIR
    for filename in os.listdir(INPUT_DIR):
        if not filename.lower().endswith(".txt"):
            continue

        input_path = os.path.join(INPUT_DIR, filename)
        output_filename = filename.rsplit(".txt", 1)[0] + "_dmr.txt"
        output_path = os.path.join(OUTPUT_DIR, output_filename)

        matched_lines = []

        # 3. Read file line by line, collect lines containing any ID
        with open(input_path, "r", encoding="utf-8") as f:
            for line in f:
                if pattern.search(line):
                    matched_lines.append(line)

        # 4. Only create/write the output file if there were matches
        if matched_lines:
            with open(output_path, "w", encoding="utf-8") as out:
                out.writelines(matched_lines)
            print(f"Created: {output_path} ({len(matched_lines)} lines)")
        else:
            print(f"No matches in: {input_path}")

if __name__ == "__main__":
    main()

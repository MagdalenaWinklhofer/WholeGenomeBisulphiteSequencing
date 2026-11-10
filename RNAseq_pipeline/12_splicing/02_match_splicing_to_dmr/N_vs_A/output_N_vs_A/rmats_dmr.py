#!/usr/bin/env python3
import argparse
import os
import csv
import sys

# USAGE: python rmats_dmr.py . --sample1 N --sample2 A --out N_vs_A_dmr.html


# Fixed colors and human-readable labels for common rMATS event types
EVENT_META = {
    "SE":   {"label": "Skipped Exon",           "color": "#3d7ebf"},
    "RI":   {"label": "Retained Intron",        "color": "#2aa876"},
    "A3SS": {"label": "Alt 3′ Splice Site",     "color": "#c65d9e"},
    "A5SS": {"label": "Alt 5′ Splice Site",     "color": "#e8a020"},
    "MXE":  {"label": "Mutually Excl. Exons",   "color": "#888888"},
}
DISPLAY_ORDER = ["SE", "RI", "A3SS", "A5SS", "MXE"]

# HTML template: ONE panel (filtered events per type)
HTML_TEMPLATE = """\
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>rMATS · {s1} vs {s2} Alternative Splicing</title>
<link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,500;0,700;1,400&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>
<style>
  *, *::before, *::after {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: #f5f2ec;
    font-family: 'DM Mono', monospace;
    min-height: 100vh;
    display: flex; align-items: center; justify-content: center;
    padding: 40px 20px;
  }}
  .figure {{
    background: #fff; width: 100%; max-width: 780px;
    border: 1.5px solid #d8d2c8; border-radius: 4px; overflow: hidden;
    box-shadow: 0 8px 40px rgba(0,0,0,0.08);
  }}
  .fig-header {{
    background: #1a1a2e; padding: 24px 32px 20px;
    border-bottom: 3px solid #e8623a;
  }}
  .fig-label {{
    font-size: 10px; font-weight: 500; letter-spacing: 0.18em;
    color: #e8623a; text-transform: uppercase; margin-bottom: 8px;
  }}
  .fig-title {{
    font-family: 'Lora', serif; font-size: 20px; font-weight: 700;
    color: #fff; line-height: 1.3;
  }}
  .fig-subtitle {{
    font-family: 'Lora', serif; font-style: italic;
    font-size: 13px; color: #8a8aaa; margin-top: 6px;
  }}
  .fig-body {{ padding: 28px 32px 18px; }}
  .chart-section {{ margin-bottom: 0; }}
  .section-label {{
    font-size: 9px; letter-spacing: 0.16em; text-transform: uppercase;
    color: #aaa09a; margin-bottom: 14px; padding-bottom: 6px;
    border-bottom: 1px solid #ede9e3;
  }}
  .lollipop-row {{
    display: flex; align-items: center; margin-bottom: 14px;
    opacity: 0; transform: translateX(-12px);
    animation: slideIn 0.5s ease forwards;
  }}
  @keyframes slideIn {{ to {{ opacity:1; transform:translateX(0); }} }}
  .event-tag {{
    width: 60px; flex-shrink: 0; font-size: 11px;
    font-weight: 500; letter-spacing: 0.04em; color: #1a1a2e;
  }}
  .bar-track {{
    flex: 1; height: 8px; background: #f0ece6;
    border-radius: 4px; position: relative; overflow: visible;
  }}
  .bar-total {{
    position: absolute; left:0; top:0; height:100%;
    background: #ede9e3; border-radius: 4px;
  }}
  .bar-sig {{
    position: absolute; left:0; top:0; height:100%; border-radius: 4px;
  }}
  .count-label {{
    width: 70px; flex-shrink: 0; text-align: right;
    font-size: 11px; color: #555; padding-left: 8px;
  }}
  .fig-footer {{
    padding: 12px 32px 18px; border-top: 1px solid #ede9e3;
    background: #faf8f5; display: flex; gap: 24px;
    flex-wrap: wrap; align-items: flex-start;
  }}
  .legend-group {{ display: flex; flex-direction: column; gap: 5px; }}
  .legend-item  {{ display: flex; align-items: center; gap: 6px; font-size: 10.5px; color: #555; }}
  .legend-swatch {{ width:20px; height:7px; border-radius:3px; flex-shrink:0; }}
  .caption {{
    flex: 1; min-width: 200px;
    font-family: 'Lora', serif; font-style: italic;
    font-size: 11.5px; color: #888; line-height: 1.65;
  }}
</style>
</head>
<body>
<div class="figure">

  <div class="fig-header">
    <div class="fig-label">Figure — Alternative Splicing Analysis</div>
    <div class="fig-title">Differential Splicing Events: {s1} vs {s2}</div>
    <div class="fig-subtitle">rMATS · Junction Counts · Filtered Events</div>
  </div>

  <div class="fig-body">
    <div class="chart-section">
      <div class="section-label">Filtered events per type (JC)</div>
      {panel_a}
    </div>
  </div>

  <div class="fig-footer">
    <div class="legend-group">
      <div class="legend-item">
        <div class="legend-swatch" style="background:#3d7ebf"></div>
        Filtered events (JC)
      </div>
    </div>
    <div class="caption">{caption}</div>
  </div>

</div>
</body>
</html>
"""

# --------------------------------------------------------------------
# Build a summary dict from *.MATS.JC_dmr.txt files
# --------------------------------------------------------------------

def build_summary_from_dir(outdir):
    """
    Scan 'outdir' for files matching *.MATS.JC_dmr.txt.
    Use the prefix before '.MATS.JC_dmr.txt' as the event type.
    Count lines in each file = number of filtered events.
    """
    summary = {}

    for fname in os.listdir(outdir):
        if not fname.endswith(".MATS.JC_dmr.txt"):
            continue
        path = os.path.join(outdir, fname)
        if not os.path.isfile(path):
            continue

        # Event type is the part before ".MATS.JC_dmr.txt", e.g. "SE", "A3SS"
        ev = fname.split(".MATS.JC_dmr.txt")[0]

        count = 0
        with open(path, newline="") as fh:
            reader = csv.reader(fh, delimiter="\t")
            for row in reader:
                if not row:
                    continue
                count += 1

        if count == 0:
            continue

        # Add or update event type entry
        current = summary.get(ev, None)
        if current is None:
            # Initialize
            label = EVENT_META.get(ev, {}).get("label", ev)
            color = EVENT_META.get(ev, {}).get("color", "#999")
            summary[ev] = {
                "label":    label,
                "color":    color,
                "total_jc": count,
                "sig_jc":   count,  # all filtered, treat as "significant"
            }
        else:
            # If for some reason multiple JC files per type exist, sum them
            current["total_jc"] += count
            current["sig_jc"]   += count

    if not summary:
        raise FileNotFoundError(
            f"No *.MATS.JC_dmr.txt files with events found in {outdir}"
        )

    return summary

# --------------------------------------------------------------------
# Build HTML from summary_data
# --------------------------------------------------------------------

def build_figure(summary_data, s1_name, s2_name):
    # Use DISPLAY_ORDER first, then any extra event types found
    events = [e for e in DISPLAY_ORDER if e in summary_data]
    for e in summary_data:
        if e not in events:
            events.append(e)

    if not events:
        raise ValueError("No event types found in summary_data")

    max_total = max(
        (summary_data[e]["total_jc"] for e in events if summary_data[e]["total_jc"] > 0),
        default=1
    )

    panel_a_rows = []
    for i, ev in enumerate(events):
        d = summary_data[ev]
        col = d.get("color", "#999")
        w_total = d["total_jc"] / max_total * 100 if max_total else 0
        w_sig   = d["sig_jc"]   / max_total * 100 if max_total else 0
        delay   = i * 0.1
        panel_a_rows.append(f"""
      <div class="lollipop-row" style="animation-delay:{delay:.1f}s">
        <div class="event-tag">{ev}</div>
        <div class="bar-track">
          <div class="bar-total" style="width:{w_total:.1f}%"></div>
          <div class="bar-sig"   style="width:{w_sig:.1f}%; background:{col}"></div>
        </div>
        <div class="count-label">{d['sig_jc']:,}</div>
      </div>""")

    total_sig = sum(summary_data[e]["sig_jc"] for e in events)
    top_event = max(events, key=lambda e: summary_data[e]["sig_jc"])
    caption = (
        f"This figure summarizes the number of filtered junction-count events per splicing type "
        f"derived from rMATS output files (*.MATS.JC_dmr.txt). "
        f"{top_event} ({summary_data[top_event]['label']}) contributes "
        f"{summary_data[top_event]['sig_jc']:,} filtered events out of "
        f"{total_sig:,} total across all event types."
    )

    return HTML_TEMPLATE.format(
        s1=s1_name,
        s2=s2_name,
        panel_a="\n".join(panel_a_rows),
        caption=caption,
    )

# --------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Generate an HTML figure (Panel A only) from filtered rMATS *.MATS.JC_dmr.txt files."
    )
    parser.add_argument("outdir", help="Directory containing *.MATS.JC_dmr.txt")
    parser.add_argument(
        "--out", default="rmats_filtered_panelA_only.html",
        help="Output HTML file (default: rmats_filtered_panelA_only.html)"
    )
    parser.add_argument(
        "--sample1", default="Sample 1",
        help="Name for sample 1 / condition 1 (default: 'Sample 1')"
    )
    parser.add_argument(
        "--sample2", default="Sample 2",
        help="Name for sample 2 / condition 2 (default: 'Sample 2')"
    )
    args = parser.parse_args()

    outdir = os.path.abspath(args.outdir)
    print(f"Scanning *.MATS.JC_dmr.txt files in: {outdir}")

    summary_data = build_summary_from_dir(outdir)
    print(f"  Found event types: {', '.join(summary_data.keys())}")

    html = build_figure(summary_data, args.sample1, args.sample2)

    out_path = os.path.abspath(args.out)
    with open(out_path, "w") as fh:
        fh.write(html)
    print(f"Figure written to: {out_path}")

if __name__ == "__main__":
    main()

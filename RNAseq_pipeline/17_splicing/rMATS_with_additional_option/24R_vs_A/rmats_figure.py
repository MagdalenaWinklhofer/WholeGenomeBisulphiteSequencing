#!/usr/bin/env python3
"""
rmats_figure.py
---------------
Generate a self-contained HTML figure from an rMATS output directory.

Usage:
    python rmats_figure.py <rmats_output_dir> [--fdr 0.05] [--out figure.html]
                           [--sample1 N] [--sample2 24R]

Example:
    python rmats_figure.py ./output_24R_vs_A --sample1 24R --sample2 A

Environment: 
    module load Anaconda3/2022.10
    source ${EBROOTANACONDA3}/bin/activate
    conda activate /cluster/projects/nn8014k/magdalena/conda_environments/general
"""

import argparse
import os
import csv
import sys


# ── helpers ──────────────────────────────────────────────────────────────────

def parse_summary(path):
    """Parse rMATS summary.txt → dict keyed by EventType."""
    data = {}
    with open(path, newline="") as fh:
        reader = csv.DictReader(fh, delimiter="\t")
        for row in reader:
            et = row["EventType"].strip()
            data[et] = {
                "label":       row["EventTypeDescription"].strip(),
                "total_jc":    int(row["TotalEventsJC"]),
                "total_jcec":  int(row["TotalEventsJCEC"]),
                "sig_jc":      int(row["SignificantEventsJC"]),
                "s1_jc":       int(row["SigEventsJCSample1HigherInclusion"]),
                "s2_jc":       int(row["SigEventsJCSample2HigherInclusion"]),
                "sig_jcec":    int(row["SignificantEventsJCEC"]),
                "s1_jcec":     int(row["SigEventsJCECSample1HigherInclusion"]),
                "s2_jcec":     int(row["SigEventsJCECSample2HigherInclusion"]),
            }
    return data


def find_summary(outdir):
    candidate = os.path.join(outdir, "summary.txt")
    if os.path.isfile(candidate):
        return candidate
    # rMATS sometimes nests it one level deeper
    for root, dirs, files in os.walk(outdir):
        for f in files:
            if f == "summary.txt":
                return os.path.join(root, f)
    return None


# ── HTML template ─────────────────────────────────────────────────────────────

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
  .fig-body {{ padding: 28px 32px 24px; }}
  .chart-section {{ margin-bottom: 28px; }}
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
    width: 46px; flex-shrink: 0; font-size: 11px;
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
  .split-track {{
    flex: 1; height: 10px; display: flex;
    border-radius: 4px; overflow: hidden;
  }}
  .split-n   {{ background: #5b8db8; }}
  .split-24r {{ background: #e8623a; }}
  .count-label {{
    width: 52px; flex-shrink: 0; text-align: right;
    font-size: 11px; color: #888; padding-left: 8px;
  }}
  .summary-strip {{
    display: grid; grid-template-columns: repeat({n_events}, 1fr);
    gap: 1px; background: #ede9e3;
    border-top: 1px solid #ede9e3; margin-top: 4px;
  }}
  .strip-cell {{
    background: #fff; padding: 14px 10px 12px; text-align: center;
    opacity: 0; animation: fadeUp 0.4s ease forwards;
  }}
  @keyframes fadeUp {{
    from {{ opacity:0; transform:translateY(6px); }}
    to   {{ opacity:1; transform:translateY(0); }}
  }}
  .strip-event {{
    display: inline-block; font-size: 11px; font-weight: 500;
    letter-spacing: 0.06em; color: #fff; padding: 2px 7px;
    border-radius: 3px; margin-bottom: 8px;
  }}
  .strip-sig {{
    font-family: 'Lora', serif; font-size: 22px; font-weight: 700;
    color: #1a1a2e; line-height: 1; margin-bottom: 2px;
  }}
  .strip-total {{ font-size: 9px; color: #aaa; letter-spacing: 0.06em; }}
  .strip-pct  {{ font-size: 10px; font-weight: 500; margin-top: 5px; }}
  .fig-footer {{
    padding: 16px 32px 22px; border-top: 1px solid #ede9e3;
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
    <div class="fig-subtitle">rMATS · Junction Counts · FDR &lt; 0.05</div>
  </div>

  <div class="fig-body">
    <div class="chart-section">
      <div class="section-label">A &nbsp;·&nbsp; Significant events per type (JC)</div>
      {panel_a}
    </div>
    <div class="chart-section" style="margin-bottom:0">
      <div class="section-label">B &nbsp;·&nbsp; Inclusion direction: {s1} (higher) vs {s2} (higher)</div>
      {panel_b}
    </div>
  </div>

  <div class="summary-strip">
    {strip}
  </div>

  <div class="fig-footer">
    <div class="legend-group">
      <div class="legend-item"><div class="legend-swatch" style="background:#e0dbd4"></div> All detected events</div>
      <div class="legend-item"><div class="legend-swatch" style="background:#3d7ebf"></div> Significant (FDR &lt; 0.05)</div>
    </div>
    <div class="legend-group">
      <div class="legend-item"><div class="legend-swatch" style="background:#5b8db8"></div> Higher inclusion in {s1}</div>
      <div class="legend-item"><div class="legend-swatch" style="background:#e8623a"></div> Higher inclusion in {s2}</div>
    </div>
    <div class="caption">{caption}</div>
  </div>

</div>
</body>
</html>
"""

# Fixed display order and colours per event type
EVENT_META = {
    "SE":   {"label": "Skipped Exon",           "color": "#3d7ebf"},
    "RI":   {"label": "Retained Intron",         "color": "#2aa876"},
    "A3SS": {"label": "Alt 3′ Splice Site",      "color": "#c65d9e"},
    "A5SS": {"label": "Alt 5′ Splice Site",      "color": "#e8a020"},
    "MXE":  {"label": "Mutually Excl. Exons",    "color": "#888888"},
}
DISPLAY_ORDER = ["SE", "RI", "A3SS", "A5SS", "MXE"]


def build_figure(summary_data, s1_name, s2_name):
    # Use display order, skip any event type not in summary
    events = [e for e in DISPLAY_ORDER if e in summary_data]
    # Fall back: add any extra events not in our fixed order
    for e in summary_data:
        if e not in events:
            events.append(e)

    max_total = max(summary_data[e]["total_jc"] for e in events)

    # ── Panel A ──
    panel_a_rows = []
    for i, ev in enumerate(events):
        d = summary_data[ev]
        col = EVENT_META.get(ev, {}).get("color", "#999")
        w_total = d["total_jc"] / max_total * 100
        w_sig   = d["sig_jc"]   / max_total * 100
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

    # ── Panel B ──
    panel_b_rows = []
    for i, ev in enumerate(events):
        d = summary_data[ev]
        tot = d["s1_jc"] + d["s2_jc"]
        w_s1  = (d["s1_jc"] / tot * 100) if tot else 50
        w_s2  = (d["s2_jc"] / tot * 100) if tot else 50
        delay = 0.5 + i * 0.1
        panel_b_rows.append(f"""
      <div class="lollipop-row" style="animation-delay:{delay:.1f}s">
        <div class="event-tag">{ev}</div>
        <div class="split-track">
          <div class="split-n"   style="width:{w_s1:.1f}%"></div>
          <div class="split-24r" style="width:{w_s2:.1f}%"></div>
        </div>
        <div class="count-label" style="color:#aaa;font-size:10px">
          {d['s1_jc']} / {d['s2_jc']}
        </div>
      </div>""")

    # ── Strip ──
    strip_cells = []
    for i, ev in enumerate(events):
        d   = summary_data[ev]
        col = EVENT_META.get(ev, {}).get("color", "#999")
        pct = d["sig_jc"] / d["total_jc"] * 100 if d["total_jc"] else 0
        delay = 0.9 + i * 0.08
        strip_cells.append(f"""
    <div class="strip-cell" style="animation-delay:{delay:.2f}s">
      <div><span class="strip-event" style="background:{col}">{ev}</span></div>
      <div class="strip-sig">{d['sig_jc']:,}</div>
      <div class="strip-total">/ {d['total_jc']:,} total</div>
      <div class="strip-pct" style="color:{col}">{pct:.1f}%</div>
    </div>""")

    # ── Caption ──
    total_sig = sum(summary_data[e]["sig_jc"] for e in events)
    total_s2  = sum(summary_data[e]["s2_jc"]  for e in events)
    bias_pct  = total_s2 / total_sig * 100 if total_sig else 50
    top_event = max(events, key=lambda e: summary_data[e]["sig_jc"])
    caption = (
        f"Panel A shows all detected (grey) vs significant (coloured) splicing events for each type. "
        f"Panel B shows the directional split among significant events. "
        f"{top_event} ({EVENT_META.get(top_event,{}).get('label','')}) events dominate with "
        f"{summary_data[top_event]['sig_jc']:,} significant changes. "
        f"Across all types, {s2_name} shows {bias_pct:.0f}% of directional events with higher inclusion "
        f"compared to {s1_name}."
    )

    return HTML_TEMPLATE.format(
        s1=s1_name,
        s2=s2_name,
        n_events=len(events),
        panel_a="\n".join(panel_a_rows),
        panel_b="\n".join(panel_b_rows),
        strip="\n".join(strip_cells),
        caption=caption,
    )


# ── CLI ───────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Generate a newsletter-ready HTML figure from rMATS output."
    )
    parser.add_argument("outdir",          help="Path to rMATS output directory")
    parser.add_argument("--fdr",  type=float, default=0.05,
                        help="FDR threshold label (display only, rMATS pre-filters; default 0.05)")
    parser.add_argument("--out",  default="rmats_figure.html",
                        help="Output HTML file path (default: rmats_figure.html)")
    parser.add_argument("--sample1", default="Sample 1",
                        help="Name for sample 1 / condition 1 (default: 'Sample 1')")
    parser.add_argument("--sample2", default="Sample 2",
                        help="Name for sample 2 / condition 2 (default: 'Sample 2')")
    args = parser.parse_args()

    summary_path = find_summary(args.outdir)
    if not summary_path:
        sys.exit(f"ERROR: could not find summary.txt in {args.outdir}")

    print(f"Reading: {summary_path}")
    summary_data = parse_summary(summary_path)
    print(f"  Found event types: {', '.join(summary_data.keys())}")

    html = build_figure(summary_data, args.sample1, args.sample2)

    with open(args.out, "w") as fh:
        fh.write(html)
    print(f"Figure written to: {args.out}")


if __name__ == "__main__":
    main()


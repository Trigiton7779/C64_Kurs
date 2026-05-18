#!/usr/bin/env python3
"""Apply neutral redesign: unify colors, remove per-page theme overrides."""
import re, os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def read(f):
    with open(os.path.join(BASE, f), encoding='utf-8') as fh:
        return fh.read()

def write(f, content):
    with open(os.path.join(BASE, f), 'w', encoding='utf-8') as fh:
        fh.write(content)
    print(f"  ✓ {f}")

# ── 1. stufe_13: Replace huge inline CSS with c64-base.css + page-specific ──

STUFE13_STYLE = '''  <link rel="stylesheet" href="assets/c64-base.css">
  <style>
    pre .instr { color: #88ffcc; }
    pre .reg   { color: #ffaa44; }
    .register-table thead th { background: var(--theme-dark); }
    .reu-diagram {
      background: var(--c64-dark); color: #e0cca0;
      font-family: 'Courier New', monospace; font-size: 13px;
      padding: 18px 22px; border-radius: 6px;
      border-left: 4px solid var(--theme-color);
      margin: 20px 0; white-space: pre; line-height: 1.5;
    }
    .bank-diagram {
      background: var(--c64-dark); color: #aaddff;
      font-family: 'Courier New', monospace; font-size: 13px;
      padding: 18px 22px; border-radius: 6px;
      border-left: 4px solid var(--c64-light-blue);
      margin: 20px 0; white-space: pre; line-height: 1.5;
    }
    .hardware-banner {
      background: linear-gradient(135deg, var(--theme-dark) 0%, var(--theme-color) 100%);
      border: 1px solid var(--c64-light-blue);
      border-radius: 8px; padding: 24px 28px; margin: 32px 0 24px; color: white;
    }
    .hardware-banner h2 { color: var(--c64-green); border: none; margin-top: 0; font-size: 20px; letter-spacing: 1px; }
    .hardware-banner p  { color: #aaccee; margin: 0; }
  </style>'''

def fix_stufe13():
    content = read('stufe_13_hardware_erweiterungen.html')
    # Replace the entire <style>...</style> block (before c64-interactive link) + add base link
    content = re.sub(r'  <style>.*?  </style>', STUFE13_STYLE, content, count=1, flags=re.DOTALL)
    write('stufe_13_hardware_erweiterungen.html', content)

# ── 2. stufe_14: Replace huge inline CSS ──

STUFE14_STYLE = '''  <link rel="stylesheet" href="assets/c64-base.css">
  <style>
    pre .instr      { color: #88ffcc; }
    pre .key        { color: #aaffbb; }
    pre .string     { color: #ffcc88; }
    pre .sh-comment { color: #668866; }
    .vscode-block {
      background: #1e1e1e; color: #d4d4d4;
      font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.55;
      padding: 20px 24px; border-radius: 6px;
      border-left: 4px solid var(--c64-light-blue); margin: 20px 0; overflow-x: auto;
    }
    .vscode-block .js-key     { color: #9cdcfe; }
    .vscode-block .js-str     { color: #ce9178; }
    .vscode-block .js-num     { color: #b5cea8; }
    .vscode-block .js-bool    { color: #569cd6; }
    .vscode-block .js-comment { color: #6a9955; }
    .makefile-block {
      background: #0d1117; color: #c9d1d9;
      font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.6;
      padding: 20px 24px; border-radius: 6px;
      border-left: 4px solid var(--theme-color); margin: 20px 0; overflow-x: auto;
    }
    .makefile-block .mk-target  { color: #79c0ff; font-weight: bold; }
    .makefile-block .mk-var     { color: #ffa657; }
    .makefile-block .mk-comment { color: #8b949e; }
    .file-tree {
      background: #0d1117; color: #8b949e;
      font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.7;
      padding: 16px 20px; border-radius: 6px;
      border-left: 4px solid var(--theme-color); margin: 16px 0;
    }
    .file-tree .ft-dir     { color: #79c0ff; font-weight: bold; }
    .file-tree .ft-file    { color: #c9d1d9; }
    .file-tree .ft-comment { color: #555f6d; }
    .pipeline-flow {
      display: flex; align-items: center; flex-wrap: wrap; gap: 4px;
      font-family: 'Courier New', monospace; font-size: 13px;
      background: var(--c64-dark); padding: 16px 20px; border-radius: 6px; margin: 16px 0;
      overflow-x: auto;
    }
    .pipeline-step  { background: var(--theme-color); color: white; padding: 6px 12px; border-radius: 4px; white-space: nowrap; font-size: 12px; }
    .pipeline-arrow { color: var(--c64-green); font-size: 18px; padding: 0 4px; }
  </style>'''

def fix_stufe14():
    content = read('stufe_14_modern_workflow.html')
    content = re.sub(r'  <style>.*?  </style>', STUFE14_STYLE, content, count=1, flags=re.DOTALL)
    write('stufe_14_modern_workflow.html', content)

# ── 3. stufe_15: Replace huge inline CSS ──

STUFE15_STYLE = '''  <link rel="stylesheet" href="assets/c64-base.css">
  <style>
    pre .instr   { color: #88ffcc; }
    pre .reg     { color: #ffaa44; }
    pre .monitor { color: #ff9988; }
    .monitor-session {
      background: #0a0a0a; color: #dddddd;
      font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.6;
      padding: 18px 22px; border-radius: 6px;
      border-left: 4px solid var(--c64-light-blue); margin: 20px 0; overflow-x: auto;
    }
    .monitor-session .mon-prompt  { color: #ff9988; font-weight: bold; }
    .monitor-session .mon-output  { color: #aaaaaa; }
    .monitor-session .mon-comment { color: #555566; }
    .vice-cmd {
      display: inline-block; background: #1e1e2e; color: #aaddff;
      font-family: 'Courier New', monospace; font-size: 13px;
      padding: 2px 7px; border-radius: 3px; border: 1px solid var(--theme-color);
    }
    .bug-card {
      border-left: 4px solid var(--theme-color);
      background: var(--paper-dark); border-radius: 0 6px 6px 0; padding: 16px 20px; margin: 16px 0;
    }
    .bug-card h4          { color: var(--theme-color); margin: 0 0 8px; font-family: 'Courier New', monospace; }
    .bug-card .bug-symptom { font-style: italic; color: var(--text-light); margin-bottom: 8px; }
    .bug-card .bug-fix    { font-weight: bold; color: var(--text); }
    .cycle-table thead th { background: var(--theme-dark); }
    .debug-banner {
      background: linear-gradient(135deg, var(--theme-dark) 0%, var(--theme-color) 100%);
      border: 1px solid var(--c64-light-blue);
      border-radius: 8px; padding: 24px 28px; margin: 32px 0 24px; color: white;
    }
    .debug-banner h2 { color: var(--c64-green); border: none; margin-top: 0; font-size: 20px; letter-spacing: 1px; }
    .debug-banner p  { color: #aaccee; margin: 0; }
  </style>'''

def fix_stufe15():
    content = read('stufe_15_debugging_deep_dive.html')
    content = re.sub(r'  <style>.*?  </style>', STUFE15_STYLE, content, count=1, flags=re.DOTALL)
    write('stufe_15_debugging_deep_dive.html', content)

# ── 4. stufe_10: Remove gold theme override ──

def fix_stufe10():
    content = read('stufe_10_meisterschaft.html')
    # Remove the :root override line
    content = content.replace(
        "    :root { --theme-color: #cc8800; --theme-dark: #332200; --theme-light: #ffee88; }\n",
        ""
    )
    # Update mastery-banner to use neutral colors
    content = content.replace(
        ".mastery-banner { background: linear-gradient(135deg, #001166 0%, #0033aa 50%, #001166 100%);",
        ".mastery-banner { background: linear-gradient(135deg, #0d1f40 0%, #1a3f80 50%, #0d1f40 100%);"
    )
    write('stufe_10_meisterschaft.html', content)

# ── 5. stufe_11: Remove teal theme override + fix hardcoded gold ──

def fix_stufe11():
    content = read('stufe_11_spielentwicklung_workflow.html')
    content = content.replace(
        "    :root { --theme-color: #005588; --theme-dark: #001a33; --theme-light: #88ccff; }\n",
        ""
    )
    # Fix hardcoded gold border in pipeline-ascii
    content = content.replace(
        "    .pipeline-ascii { background: var(--c64-dark); color: #aaddff; font-family: 'Courier New', monospace; font-size: 13px; padding: 20px 24px; border-radius: 6px; margin: 20px 0; border-left: 4px solid #cc8800; }",
        "    .pipeline-ascii { background: var(--c64-dark); color: #aaddff; font-family: 'Courier New', monospace; font-size: 13px; padding: 20px 24px; border-radius: 6px; margin: 20px 0; border-left: 4px solid var(--theme-color); }"
    )
    # Fix walkthrough-banner gradient
    content = content.replace(
        "    .walkthrough-banner { background: linear-gradient(135deg, #001a33 0%, var(--theme-color) 100%);",
        "    .walkthrough-banner { background: linear-gradient(135deg, var(--theme-dark) 0%, var(--theme-color) 100%);"
    )
    write('stufe_11_spielentwicklung_workflow.html', content)

# ── 6. stufe_12: Remove purple theme + sidebar overrides ──

def fix_stufe12():
    content = read('stufe_12_demo_entwicklung_workflow.html')
    # Remove :root override
    content = content.replace(
        "    :root { --theme-color: #6633aa; --theme-dark: #1a0033; --theme-light: #cc99ff; }\n",
        ""
    )
    # Remove sidebar color overrides
    content = content.replace(
        "    .sidebar { scrollbar-color: var(--theme-color) var(--c64-darker); }\n",
        ""
    )
    content = content.replace(
        "    .sidebar::-webkit-scrollbar-thumb { background: var(--theme-color); }\n",
        ""
    )
    content = content.replace(
        "    .sidebar-header { background: var(--theme-color); }\n",
        ""
    )
    # Neutralize sync-beat highlight
    content = content.replace(
        "    .sync-beat { background: rgba(200,100,255,0.15) !important; font-weight: bold; }",
        "    .sync-beat { background: rgba(26,63,128,0.15) !important; font-weight: bold; }"
    )
    # Neutralize pal-ntsc header
    content = content.replace(
        "    .pal-ntsc-compare table thead { background: #333366; }",
        "    .pal-ntsc-compare table thead { background: var(--theme-color); }"
    )
    # Fix walkthrough-banner
    content = content.replace(
        "    .walkthrough-banner { background: linear-gradient(135deg, #1a0033 0%, var(--theme-color) 100%);",
        "    .walkthrough-banner { background: linear-gradient(135deg, var(--theme-dark) 0%, var(--theme-color) 100%);"
    )
    content = content.replace(
        "    .walkthrough-banner p { color: #bb99ee; margin: 0; }",
        "    .walkthrough-banner p { color: #aaccee; margin: 0; }"
    )
    # Fix scene-banner
    content = content.replace(
        "    .scene-banner { background: linear-gradient(135deg, #001144 0%, #0033aa 100%); border: 1px solid var(--theme-color);",
        "    .scene-banner { background: linear-gradient(135deg, var(--theme-dark) 0%, var(--theme-color) 100%); border: 1px solid var(--c64-light-blue);"
    )
    content = content.replace(
        "    .scene-banner p { color: #aabb99; margin: 0; font-size: 14px; }",
        "    .scene-banner p { color: #aaccee; margin: 0; font-size: 14px; }"
    )
    # Fix part-diagram border
    content = content.replace(
        "    .part-diagram { background: var(--c64-dark); color: var(--theme-light);",
        "    .part-diagram { background: var(--c64-dark); color: var(--c64-green);"
    )
    write('stufe_12_demo_entwicklung_workflow.html', content)

# ── 7. Old-format files: Update #0033aa → #1a3f80, #00ff88 → #00cc66 ──

OLD_FORMAT = [
    'index.html',
    'stufe_00_fundament.html',
    'stufe_01_6510_assembler.html',
    'stufe_02_adressierung_speicher.html',
    'stufe_03_bildschirm_zeichen.html',
    'stufe_04_sprites_animation.html',
    'stufe_05_bitmap_grafik.html',
    'stufe_06_sid_sound.html',
    'stufe_07_interrupts_timing.html',
]

def fix_old_format():
    for f in OLD_FORMAT:
        content = read(f)
        original = content
        content = content.replace('#0033aa', '#1a3f80')
        content = content.replace('#00ff88', '#00cc66')
        # Also update rgba variants
        content = content.replace('rgba(0, 51, 170,', 'rgba(26, 63, 128,')
        content = content.replace('rgba(0, 51, 170)', 'rgba(26, 63, 128)')
        if content != original:
            write(f, content)
        else:
            print(f"  — {f} (no changes)")

if __name__ == '__main__':
    print("Applying redesign...")
    print("\n[1] Converting stufe_13 to c64-base.css:")
    fix_stufe13()
    print("[2] Converting stufe_14 to c64-base.css:")
    fix_stufe14()
    print("[3] Converting stufe_15 to c64-base.css:")
    fix_stufe15()
    print("[4] Removing gold theme from stufe_10:")
    fix_stufe10()
    print("[5] Removing teal theme from stufe_11:")
    fix_stufe11()
    print("[6] Removing purple theme from stufe_12:")
    fix_stufe12()
    print("[7] Updating old-format files:")
    fix_old_format()
    print("\nDone.")

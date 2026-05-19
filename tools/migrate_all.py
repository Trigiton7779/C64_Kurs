#!/usr/bin/env python3
"""Migrate all HTML files to use dynamic sidebar.js and unified c64-base.css."""

import os, re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ── Sidebar patterns ────────────────────────────────────────────────
# New format: <aside class="sidebar">...</aside>
ASIDE_RE = re.compile(
    r'<aside\s+class=["\']sidebar["\'][^>]*>.*?</aside>',
    re.S
)
# Old format: <nav class="sidebar">...</nav>
# Use lookahead for <main so the outer </nav> is matched (not the inner one)
NAV_SIDEBAR_RE = re.compile(
    r'<nav\s+class=["\']sidebar["\'][^>]*>.*?</nav>\s*(?=<main)',
    re.S
)

SIDEBAR_PLACEHOLDER = '<aside class="sidebar"></aside>\n\n'


def migrate(path):
    with open(path, encoding='utf-8') as f:
        content = f.read()

    original = content
    is_tools = os.sep + 'tools' + os.sep in path or '/tools/' in path
    prefix   = '../' if is_tools else ''

    # 1. Replace sidebar block with empty placeholder
    if ASIDE_RE.search(content):
        content = ASIDE_RE.sub('<aside class="sidebar"></aside>', content, count=1)
    elif NAV_SIDEBAR_RE.search(content):
        content = NAV_SIDEBAR_RE.sub(SIDEBAR_PLACEHOLDER, content, count=1)

    # 2. Add sidebar.js before c64-interactive.js (if not already present)
    sidebar_tag     = f'<script src="{prefix}assets/sidebar.js"></script>'
    interactive_pat = re.compile(
        r'(<script\s+src=["\'])(' + re.escape(prefix) + r'assets/c64-interactive\.js)(["\']>)',
        re.S
    )
    if sidebar_tag not in content and interactive_pat.search(content):
        content = interactive_pat.sub(
            sidebar_tag + r'\n  \1\2\3',
            content,
            count=1
        )

    # 3. For old-format files (no c64-base.css): add it before first <style>
    base_link = f'<link rel="stylesheet" href="{prefix}assets/c64-base.css">'
    has_base  = f'{prefix}assets/c64-base.css' in content
    if not has_base:
        # Insert before the first <style> or before </head>
        if re.search(r'<style\b', content):
            content = re.sub(r'(<style\b)', base_link + '\n' + r'\1', content, count=1)
        else:
            content = content.replace('</head>', base_link + '\n</head>', 1)

    if content != original:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'  migrated  {os.path.relpath(path, ROOT)}')
        return True
    else:
        print(f'  unchanged {os.path.relpath(path, ROOT)}')
        return False


def main():
    changed = 0

    # Root-level HTML files (skip build artefacts / example dirs)
    root_files = sorted(
        os.path.join(ROOT, f)
        for f in os.listdir(ROOT)
        if f.endswith('.html')
    )

    # tools/ HTML files
    tools_dir   = os.path.join(ROOT, 'tools')
    tools_files = sorted(
        os.path.join(tools_dir, f)
        for f in os.listdir(tools_dir)
        if f.endswith('.html')
    )

    for path in root_files + tools_files:
        if migrate(path):
            changed += 1

    print(f'\nDone: {changed} file(s) updated.')


if __name__ == '__main__':
    main()

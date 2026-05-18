#!/usr/bin/env python3
"""
C64 Mastery System — Beispielcode-Extraktor
Extrahiert <pre>-Blöcke aus allen stufe_XX HTML-Dateien
und speichert sie als .asm / .sh Dateien in beispiele/stufe_XX/
"""

import os
import re
import html as html_mod
from pathlib import Path

SRC_DIR = Path(__file__).parent.parent
OUT_DIR = SRC_DIR / "beispiele"

ASM_OPCODES = re.compile(
    r'\b(lda|ldx|ldy|sta|stx|sty|adc|sbc|and|ora|eor|cmp|cpx|cpy|'
    r'inx|iny|inc|dex|dey|dec|asl|lsr|rol|ror|bit|jmp|jsr|rts|rti|'
    r'bcc|bcs|beq|bne|bmi|bpl|bvc|bvs|brk|nop|tax|tay|txa|tya|txs|tsx|'
    r'pha|pla|php|plp|clc|sec|cli|sei|clv|cld|sed|'
    r'lax|sax|dcp|isc|slo|sre|rla|rra|anc|alr|arr|xaa|tas|shy|shx|las|ahx)\b',
    re.IGNORECASE
)

SHELL_MARKERS = re.compile(
    r'(^#!|apt-get|sudo |npm |pip |make |cmake |\$ |\.\/|acme |kick |java )',
    re.MULTILINE
)

ACME_DIRECTIVES = re.compile(
    r'(!byte|!word|!source|!to|!cpu|!zone|!pseudopc|!fill|!text|!pet|!scr)',
    re.IGNORECASE
)


def strip_html(text):
    """Remove all HTML tags and decode entities."""
    text = re.sub(r'<[^>]+>', '', text)
    text = html_mod.unescape(text)
    return text


def slug(text):
    """Convert heading text to a filename-safe slug."""
    text = text.lower()
    text = re.sub(r'[äáà]', 'a', text)
    text = re.sub(r'[öóò]', 'o', text)
    text = re.sub(r'[üúù]', 'u', text)
    text = re.sub(r'ß', 'ss', text)
    text = re.sub(r'[^a-z0-9]+', '_', text)
    text = text.strip('_')
    return text[:50]


def classify(code):
    """Return 'asm', 'sh', or 'txt' based on content."""
    if SHELL_MARKERS.search(code):
        return 'sh'
    asm_hits = len(ASM_OPCODES.findall(code))
    acme_hits = len(ACME_DIRECTIVES.findall(code))
    asm_comments = code.count('; ')
    if asm_hits >= 2 or acme_hits >= 1 or asm_comments >= 2:
        return 'asm'
    # hex addresses like $D018 or LDA/STA in uppercase
    if re.search(r'\$[0-9A-Fa-f]{2,4}', code) and asm_comments >= 1:
        return 'asm'
    return 'txt'


def extract_stufe(html_path, out_dir):
    """Parse one stufe HTML file and write example files."""
    out_dir.mkdir(parents=True, exist_ok=True)
    content = html_path.read_text(encoding='utf-8')

    # Split into sections: grab last h2/h3 heading before each <pre>
    # Strategy: scan linearly, track current heading
    heading_re = re.compile(r'<h[23][^>]*>(.*?)</h[23]>', re.DOTALL)
    pre_re = re.compile(r'<pre[^>]*>(.*?)</pre>', re.DOTALL)

    # Build a list of (pos, type, value)
    events = []
    for m in heading_re.finditer(content):
        events.append((m.start(), 'heading', strip_html(m.group(1)).strip()))
    for m in pre_re.finditer(content):
        events.append((m.start(), 'pre', strip_html(m.group(1))))

    events.sort(key=lambda e: e[0])

    current_heading = 'beispiel'
    heading_counter = {}
    written = []

    for pos, kind, value in events:
        if kind == 'heading':
            current_heading = value
        else:
            code = value.strip()
            if not code or len(code) < 20:
                continue

            ext = classify(code)
            if ext == 'txt':
                continue  # skip pure text/diagram blocks

            base = slug(current_heading) or 'beispiel'
            heading_counter[base] = heading_counter.get(base, 0) + 1
            count = heading_counter[base]
            suffix = '' if count == 1 else f'_{count}'
            filename = f'{base}{suffix}.{ext}'
            filepath = out_dir / filename

            header_lines = []
            if ext == 'asm':
                header_lines = [
                    '; ' + '=' * 60,
                    f'; C64 Mastery — {html_path.stem}',
                    f'; Abschnitt: {current_heading}',
                    '; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)',
                    '; ' + '=' * 60,
                    '',
                ]
            elif ext == 'sh':
                header_lines = [
                    '#!/bin/bash',
                    f'# C64 Mastery — {html_path.stem}',
                    f'# Abschnitt: {current_heading}',
                    '',
                ]

            filepath.write_text('\n'.join(header_lines) + code + '\n',
                                 encoding='utf-8')
            written.append(filename)

    return written


def main():
    stufe_files = sorted(SRC_DIR.glob('stufe_*.html'))
    total = 0
    for html_path in stufe_files:
        stufe_num = re.search(r'stufe_(\d+)', html_path.name).group(1)
        out_dir = OUT_DIR / f'stufe_{stufe_num}'
        written = extract_stufe(html_path, out_dir)
        print(f'stufe_{stufe_num}: {len(written)} Dateien')
        for f in written:
            print(f'  {f}')
        total += len(written)
    print(f'\nGesamt: {total} Beispieldateien in {OUT_DIR}')


if __name__ == '__main__':
    main()

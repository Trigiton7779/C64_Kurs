#!/usr/bin/env python3
"""Build search index for C64 Mastery System static search."""

import os, re, json

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT  = os.path.join(ROOT, 'assets', 'search-index.json')

SKIP_FILES = {'suche.html', 'beispiele'}

def strip_tags(html):
    return re.sub(r'<[^>]+>', ' ', html)

def clean(text):
    text = strip_tags(text)
    text = re.sub(r'&amp;', '&', text)
    text = re.sub(r'&lt;',  '<', text)
    text = re.sub(r'&gt;',  '>', text)
    text = re.sub(r'&nbsp;',' ', text)
    text = re.sub(r'&#[^;]+;', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def get_title(html):
    m = re.search(r'<h1[^>]*>(.*?)</h1>', html, re.S)
    if m:
        return clean(m.group(1))
    m = re.search(r'<title[^>]*>(.*?)</title>', html, re.S)
    if m:
        return clean(m.group(1)).replace('C64 Mastery — ', '')
    return ''

def page_type(fname):
    if fname.startswith('stufe_'):   return 'stufe'
    if fname.startswith('anhang_'):  return 'anhang'
    if fname == 'index.html':        return 'index'
    return 'page'

def stufe_num(fname):
    m = re.match(r'stufe_(\d+)', fname)
    return m.group(1) if m else None

def extract_sections_new(html):
    """Extract sections from new-format files (section[id] elements)."""
    sections = []
    for m in re.finditer(r'<section[^>]*\bid=["\']([^"\']+)["\'][^>]*>(.*?)</section>', html, re.S):
        sid  = m.group(1)
        body = m.group(2)
        # heading
        hm = re.search(r'<h[23][^>]*>(.*?)</h[23]>', body, re.S)
        heading = clean(hm.group(1)) if hm else sid
        # text: first paragraph(s), max 400 chars
        text = ''
        for pm in re.finditer(r'<p[^>]*>(.*?)</p>', body, re.S):
            chunk = clean(pm.group(1))
            if len(chunk) > 20:
                text += chunk + ' '
            if len(text) > 400:
                break
        text = text[:400].strip()
        if heading and heading not in ('', sid):
            sections.append({'id': sid, 'heading': heading, 'text': text})
    return sections

def extract_sections_old(html):
    """Extract sections from old-format files by splitting on h2 tags."""
    sections = []
    parts = re.split(r'(<h2[^>]*>)', html)
    for i in range(1, len(parts), 2):
        h2_open = parts[i]
        rest    = parts[i+1] if i+1 < len(parts) else ''
        hm = re.match(r'<h2[^>]*>(.*?)</h2>', h2_open + rest[:200], re.S)
        heading = clean(hm.group(1)) if hm else ''
        # section id from h2 or nearby anchor
        id_m = re.search(r'\bid=["\']([^"\']+)["\']', h2_open)
        sid = id_m.group(1) if id_m else re.sub(r'\W+', '-', heading.lower())[:30]
        # text from first paragraphs
        text = ''
        for pm in re.finditer(r'<p[^>]*>(.*?)</p>', rest[:2000], re.S):
            chunk = clean(pm.group(1))
            if len(chunk) > 20:
                text += chunk + ' '
            if len(text) > 400:
                break
        text = text[:400].strip()
        if heading:
            sections.append({'id': sid, 'heading': heading, 'text': text})
    return sections

def process_file(fname):
    path = os.path.join(ROOT, fname)
    with open(path, encoding='utf-8') as f:
        html = f.read()

    # Remove script/style blocks
    html_clean = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.S)
    html_clean = re.sub(r'<style[^>]*>.*?</style>',  '', html_clean, flags=re.S)
    html_clean = re.sub(r'<aside[^>]*>.*?</aside>',  '', html_clean, flags=re.S)

    title = get_title(html)
    ptype = page_type(fname)
    snum  = stufe_num(fname)

    # Try new-format first, fall back to old
    sections = extract_sections_new(html_clean)
    if not sections:
        sections = extract_sections_old(html_clean)

    return {
        'url':      fname,
        'title':    title,
        'type':     ptype,
        'stufe':    snum,
        'sections': sections
    }

def main():
    index = []
    html_files = sorted(
        f for f in os.listdir(ROOT)
        if f.endswith('.html') and f not in SKIP_FILES
    )
    for fname in html_files:
        try:
            entry = process_file(fname)
            if entry['sections'] or entry['title']:
                index.append(entry)
                print(f'  {fname}: {len(entry["sections"])} sections')
        except Exception as e:
            print(f'  ERROR {fname}: {e}')

    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(index, f, ensure_ascii=False, separators=(',', ':'))

    total_sections = sum(len(e['sections']) for e in index)
    print(f'\nDone: {len(index)} pages, {total_sections} sections → {OUT}')

if __name__ == '__main__':
    main()

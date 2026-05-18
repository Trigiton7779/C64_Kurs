#!/bin/bash
# C64 Mastery — stufe_14_modern_workflow
# Abschnitt: 4.1 Vollständiger GitHub-Actions-Workflow
# .github/workflows/build.yml
name: Build C64 Project

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  release:
    types: [ created ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install ACME Assembler
        run: |
          sudo apt-get update -q
          sudo apt-get install -y acme

      - name: Install VICE (for c1541)
        run: |
          sudo apt-get install -y vice
          # Setzt erforderliche VICE ROM-Dateien
          mkdir -p ~/.config/vice
          cp /usr/share/vice/C64/*.vpl ~/.config/vice/ 2>/dev/null || true

      - name: Build PAL version
        run: make PAL=1 dist

      - name: Build NTSC version
        run: make NTSC=1 dist

      - name: Upload PAL Artifact
        uses: actions/upload-artifact@v4
        with:
          name: build-pal
          path: build/*_pal.d64
          retention-days: 30

      - name: Upload NTSC Artifact
        uses: actions/upload-artifact@v4
        with:
          name: build-ntsc
          path: build/*_ntsc.d64
          retention-days: 30

  release:
    needs: build
    if: github.event_name == 'release'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build all variants
        run: make dist

      - name: Upload Release Assets
        uses: softprops/action-gh-release@v1
        with:
          files: |
            build/*_pal.d64
            build/*_ntsc.d64
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

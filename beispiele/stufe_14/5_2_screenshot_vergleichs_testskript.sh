#!/bin/bash
# C64 Mastery — stufe_14_modern_workflow
# Abschnitt: 5.2 Screenshot-Vergleichs-Testskript
#!/bin/bash
# test/run_screenshot_test.sh — CI-Screenshot-Regression-Test

PRG="$1"
REFERENCE="test/reference.png"
OUTPUT="test/output.png"
DIFF_THRESHOLD=500  # Max. erlaubte Pixel-Differenz

# VICE headless 5 Sekunden laufen lassen
x64sc -headless -autostart "$PRG" \
      -limitcycles 300000 \
      -screenshot "$OUTPUT" \
      -1 2>/dev/null

# Prüfe ob Screenshot erstellt wurde
if [ ! -f "$OUTPUT" ]; then
    echo "FEHLER: Kein Screenshot erstellt (Programmabsturz?)"
    exit 1
fi

# Screenshot mit Referenz vergleichen (ImageMagick)
DIFF=$(compare -metric AE "$REFERENCE" "$OUTPUT" /dev/null 2>&1)
echo "Pixel-Differenz: $DIFF"

if [ "$DIFF" -gt "$DIFF_THRESHOLD" ]; then
    echo "FEHLER: Screenshot weicht um $DIFF Pixel ab (Grenze: $DIFF_THRESHOLD)"
    compare "$REFERENCE" "$OUTPUT" test/diff.png  # Diff-Bild erzeugen
    exit 1
fi

echo "OK: Screenshot-Test bestanden ($DIFF Pixel Differenz)"
exit 0

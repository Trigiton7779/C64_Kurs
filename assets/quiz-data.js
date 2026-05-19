/* C64 Mastery System — Quiz-Daten (18 Stufen × 5 Fragen) */
var C64_QUIZ = {

  '00': [
    {
      q: 'Welche Taktfrequenz hat der 6510-Prozessor im C64 (PAL-Version)?',
      options: ['A) 1,023 MHz (NTSC)', 'B) 985.248 Hz (~1 MHz)', 'C) 3,58 MHz', 'D) 2,048 MHz'],
      correct: 1,
      explanation: 'Der PAL-C64 läuft mit exakt 985.248 Hz. Diese Frequenz ist an die PAL-Farbträgerfrequenz gekoppelt (4,43 MHz ÷ 4,5 ≈ 0,985 MHz).'
    },
    {
      q: 'Wie viel nutzbares RAM hat der C64 ohne Tricks (ROM eingeblendet)?',
      options: ['A) 64 KB', 'B) 52 KB', 'C) 38 KB', 'D) 48 KB'],
      correct: 2,
      explanation: '38 KB stehen im Standardzustand frei zur Verfügung ($0800–$9FFF). ROM (KERNAL, BASIC, Zeichensatz) und I/O belegen den Rest des 64-KB-Adressraums.'
    },
    {
      q: 'Welcher Chip ist im C64 für die Klangsynthese zuständig?',
      options: ['A) VIC-II (6569)', 'B) CIA1 (6526)', 'C) SID (6581/8580)', 'D) TED (7360)'],
      correct: 2,
      explanation: 'Der SID (Sound Interface Device, 6581 oder 8580) hat 3 Stimmen mit Hüllkurven-Generator, Wellenformen und Filtersektion.'
    },
    {
      q: 'Bei welcher Adresse beginnt das Standard-Bildschirm-RAM des C64?',
      options: ['A) $0200', 'B) $0800', 'C) $0400', 'D) $1000'],
      correct: 2,
      explanation: 'Das Standard-Screen-RAM liegt bei $0400–$07E7 (1000 Bytes für 40×25 Zeichen). Der VIC-II zeigt diesen Bereich als Textzeichen an.'
    },
    {
      q: 'Wofür steht die Abkürzung VICE?',
      options: ['A) Video Interface Computer Emulator', 'B) Versatile Commodore Emulator', 'C) Virtual Interface for C64 Emulation', 'D) Virtualized Intel/Commodore Emulator'],
      correct: 1,
      explanation: 'VICE = Versatile Commodore Emulator. Er emuliert C64, C128, VIC-20, PET, CBM-II und weitere Commodore-Systeme mit hoher Genauigkeit.'
    }
  ],

  '01': [
    {
      q: 'Was bewirkt der Befehl LDA #$42?',
      options: ['A) Lädt den Wert an Adresse $42 in den Akkumulator', 'B) Lädt den direkten Wert 66 ($42) in den Akkumulator', 'C) Speichert den Akkumulator an Adresse $42', 'D) Vergleicht den Akkumulator mit $42'],
      correct: 1,
      explanation: 'Das #-Zeichen kennzeichnet den Immediate-Modus: der Wert $42 (dezimal 66) wird direkt in den Akkumulator geladen, kein Speicherzugriff.'
    },
    {
      q: 'Was ist der Unterschied zwischen JMP und JSR?',
      options: ['A) JMP springt relativ, JSR absolut', 'B) JMP ändert den PC; JSR legt zusätzlich die Rücksprungadresse auf dem Stack ab', 'C) Beide sind identisch außer im Timing', 'D) JSR springt relativ, JMP immer absolut'],
      correct: 1,
      explanation: 'JSR (Jump to SubRoutine) schiebt PC+2 auf den Stack, dann springt er. RTS holt die Adresse zurück. JMP springt einfach ohne Rückkehrmöglichkeit.'
    },
    {
      q: 'Das I-Flag im Status-Register P hat welche Bedeutung?',
      options: ['A) Interrupt-Flag: zeigt an dass ein IRQ aufgetreten ist', 'B) Interrupt-Disable: sperrt maskierbare IRQs wenn gesetzt', 'C) Index-Flag: aktiviert X/Y-Indexierung', 'D) Im-Flag: aktiviert Immediate-Adressierung'],
      correct: 1,
      explanation: 'I = Interrupt Disable. Bei I=1 ignoriert die CPU maskierbare IRQs. SEI setzt das Flag, CLI löscht es. NMIs werden durch I nicht beeinflusst.'
    },
    {
      q: 'Welcher Befehl schreibt den Akkumulator auf den Stack?',
      options: ['A) STX', 'B) TSX', 'C) PHA', 'D) PSH'],
      correct: 2,
      explanation: 'PHA (PusH Accumulator) schreibt den Akkumulator an die aktuelle Stackadresse ($0100+SP) und dekrementiert SP. PLA holt ihn zurück.'
    },
    {
      q: 'Wie viele offizielle (dokumentierte) Opcodes hat der 6510?',
      options: ['A) 256', 'B) 151', 'C) 128', 'D) 195'],
      correct: 1,
      explanation: '151 der 256 möglichen Opcode-Bytes sind offiziell dokumentiert. Die restlichen 105 sind undokumentierte "illegale" Opcodes die trotzdem funktionieren.'
    }
  ],

  '02': [
    {
      q: 'Warum ist Zero-Page-Adressierung schneller als absolute Adressierung?',
      options: ['A) Weil der Speicher dort physisch schneller ist', 'B) Weil der Befehl 1 Byte kürzer ist und 1 Zyklus weniger benötigt', 'C) Weil der Cache dort aktiv ist', 'D) Kein Unterschied — nur ein Kompilierungsmythos'],
      correct: 1,
      explanation: 'Zero-Page-Befehle brauchen nur 1 Byte für die Adresse (statt 2 bei absolut), sind damit 1 Byte kürzer und 1 Takt schneller. Hochwertige ZP-Nutzung ist ein Kerntrick.'
    },
    {
      q: 'An welcher Adresse liegt der Hardware-Stack des 6510?',
      options: ['A) $0000–$00FF (Zero Page)', 'B) $0100–$01FF', 'C) $0200–$02FF', 'D) $0300–$03FF'],
      correct: 1,
      explanation: 'Der Stack liegt fest bei $0100–$01FF (256 Bytes). Der Stack Pointer (SP) zeigt auf den nächsten freien Platz; er wächst nach unten.'
    },
    {
      q: 'Mit welchem Register/Adresse steuert man das Memory-Banking (ROM/RAM) beim C64?',
      options: ['A) $0001 (I/O-Port des 6510)', 'B) $0000 (Daten-Richtungs-Register)', 'C) $DD02 (CIA2)', 'D) $DFFF'],
      correct: 0,
      explanation: '$0001 ist der Daten-Port der integrierten I/O-Einheit des 6510. Bits 0–2 steuern welche ROMs eingeblendet sind ($37=Normal, $35=KERNAL+I/O, $34=nur RAM).'
    },
    {
      q: 'Was ist der Vorteil der (indirekt,X)-Adressierung gegenüber absoluter Adressierung?',
      options: ['A) Sie ist immer schneller', 'B) Sie erlaubt Zeigerarrays in der Zero Page: X wählt den Zeiger aus', 'C) Sie kann jeden Befehl adressieren', 'D) Kein Vorteil — veraltet'],
      correct: 1,
      explanation: 'Bei (zp,X) liest die CPU einen 16-Bit-Zeiger aus ZP[zp+X]. Damit kann man ein Array von Zeigern in der Zero Page haben und per X-Register auswählen.'
    },
    {
      q: 'Wo liegt das Color-RAM des C64?',
      options: ['A) $D400–$D7FF', 'B) $D800–$DBFF', 'C) $DC00–$DFFF', 'D) $C000–$CFFF'],
      correct: 1,
      explanation: 'Das Color-RAM liegt bei $D800–$DBFF. Es ist 4-Bit-Nibble-RAM und speichert die Vordergrundfarbe für jede der 1000 Zeichenpositionen.'
    }
  ],

  '03': [
    {
      q: 'Wie viele Zeichen hat der Standardbildschirm des C64?',
      options: ['A) 25 × 40 = 1000', 'B) 32 × 25 = 800', 'C) 40 × 24 = 960', 'D) 80 × 25 = 2000'],
      correct: 0,
      explanation: '40 Spalten × 25 Zeilen = 1000 Zeichenpositionen. Jede braucht 1 Byte im Screen-RAM ($0400) und 1 Nibble im Color-RAM ($D800).'
    },
    {
      q: 'Welches Bit im $D016-Register schaltet in den Multicolor-Zeichenmodus?',
      options: ['A) Bit 0 (Horizontales Scrolling)', 'B) Bit 3 (38-Spalten-Modus)', 'C) Bit 4 (MCM = Multicolor Mode)', 'D) Bit 7 (ungenutzt)'],
      correct: 2,
      explanation: '$D016 Bit 4 (MCM) aktiviert den Multicolor-Zeichenmodus. Jedes Zeichen hat dann 4 Farben bei halbierter Auflösung (4×8 Pixel pro Zeichen).'
    },
    {
      q: 'Wo liegt der Standard-Zeichensatz im C64 (aus VIC-II-Sicht)?',
      options: ['A) Bei $1000 in Bank 0', 'B) Bei $D000 (ROM, aber VIC-II sieht $1000)', 'C) Bei $0800', 'D) Bei $4000'],
      correct: 1,
      explanation: 'Der Zeichensatz liegt im ROM bei $D000–$DFFF, aber der VIC-II "sieht" ihn bei $1000 in Bank 0 (wegen VIC-Bank-Mapping). Er belegt $1000–$17FF (klein) und $1800–$1FFF (groß).'
    },
    {
      q: 'Was bewirkt das Schreiben eines Werts in $D021?',
      options: ['A) Ändert die Hintergrundfarbe', 'B) Ändert die Rahmenfarbe', 'C) Setzt die Sprite-Basisfarbe', 'D) Wechselt den VIC-II-Modus'],
      correct: 0,
      explanation: '$D021 = Hintergrundfarbe 0 (Background Color 0). Sie ist die Grundfarbe für den Textmodus-Hintergrund. $D020 = Rahmenfarbe.'
    },
    {
      q: 'Wie viele Bytes belegt ein benutzerdefinierter Zeichensatz für alle 256 Zeichen?',
      options: ['A) 256 Bytes', 'B) 1024 Bytes', 'C) 2048 Bytes', 'D) 4096 Bytes'],
      correct: 2,
      explanation: 'Jedes Zeichen ist 8×8 Pixel = 8 Bytes. 256 Zeichen × 8 Bytes = 2048 Bytes (= $0800). Der VIC-II erwartet den Zeichensatz an 2-KB-Grenzen.'
    }
  ],

  '04': [
    {
      q: 'Wie groß ist ein Hardware-Sprite auf dem C64?',
      options: ['A) 16×16 Pixel', 'B) 24×21 Pixel', 'C) 32×32 Pixel', 'D) 8×8 Pixel'],
      correct: 1,
      explanation: 'C64-Sprites sind 24 Pixel breit und 21 Pixel hoch (3 Bytes/Zeile × 21 Zeilen = 63 Bytes pro Sprite-Muster).'
    },
    {
      q: 'Über welches Register aktiviert man einzelne Sprites?',
      options: ['A) $D015 (Sprite Enable)', 'B) $D010 (X-MSB)', 'C) $D01B (Sprite Priorität)', 'D) $D027 (Sprite 0 Farbe)'],
      correct: 0,
      explanation: '$D015 (Sprite Enable): Jedes Bit entspricht einem Sprite (Bit 0 = Sprite 0 … Bit 7 = Sprite 7). Eine 1 aktiviert den entsprechenden Sprite.'
    },
    {
      q: 'In welchem Register steht Bit 8 (MSB) der X-Position aller 8 Sprites?',
      options: ['A) $D000 (Sprite 0 X)', 'B) $D010 (Sprites X MSB)', 'C) $D011', 'D) $D01D (Sprite X-Expand)'],
      correct: 1,
      explanation: '$D010 enthält für jeden Sprite (Bit 0–7) das MSB der X-Position. Damit reicht die X-Koordinate von 0–511 — nötig für Sprites am rechten Bildschirmrand.'
    },
    {
      q: 'Was zeigt $D01F an (nach einem Zugriff lesen)?',
      options: ['A) Welche Sprites aktiviert sind', 'B) Sprite-zu-Sprite-Kollision seit letztem Lesen', 'C) Sprite-zu-Hintergrund-Kollision seit letztem Lesen', 'D) Die Y-Position von Sprite 0'],
      correct: 2,
      explanation: '$D01F registriert Sprite-zu-Hintergrund-Kollisionen (Sprites die auf nicht-transparente Zeichen treffen). $D01E registriert Sprite-zu-Sprite-Kollisionen.'
    },
    {
      q: 'Was bewirkt das Setzen von $D01C Bit N (Sprite N Multicolor)?',
      options: ['A) Der Sprite wird doppelt so breit', 'B) Der Sprite verwendet 4 Farben bei halber horizontaler Auflösung', 'C) Der Sprite flackert mit 50 Hz', 'D) Der Sprite wird unsichtbar'],
      correct: 1,
      explanation: 'Multicolor-Sprites haben 4 Farben: transparent, $D025 (MC0, geteilt), $D026 (MC1, geteilt), $D027+N (individuelle Farbe). Die Breite halbiert sich effektiv auf 12 nutzbare Pixel.'
    }
  ],

  '05': [
    {
      q: 'Welche Auflösung hat der Hires-Bitmap-Modus?',
      options: ['A) 160×200 (Multicolor)', 'B) 320×200', 'C) 256×256', 'D) 640×200'],
      correct: 1,
      explanation: '320×200 Pixel, 2 Farben pro 8×8-Zelle. Bitmap-Daten: 8000 Bytes, Farb-Daten im Screen-RAM: 1000 Bytes.'
    },
    {
      q: 'Welches Register-Bit aktiviert den Bitmap-Modus?',
      options: ['A) $D011 Bit 4 (ECM)', 'B) $D016 Bit 4 (MCM)', 'C) $D011 Bit 5 (BMM)', 'D) $D018 Bit 0'],
      correct: 2,
      explanation: '$D011 Bit 5 = BMM (Bitmap Mode). Zusammen mit dem Setzen der Bitmap-Adresse in $D018 wechselt der VIC-II in den Hires-Modus.'
    },
    {
      q: 'Was ist FLI (Flexible Line Interpretation)?',
      options: ['A) Ein schneller Lade-Algorithmus', 'B) Screen-RAM per Raster-IRQ jede Zeile wechseln für ~128 Farben/Zeile', 'C) Ein Sprite-Multiplexer-Trick', 'D) Eine Komprimierungsmethode'],
      correct: 1,
      explanation: 'FLI wechselt per Raster-IRQ in jeder Zeile das Screen-RAM-Register ($D018). Damit kann jede Zeile 4 statt 2 Farben haben — effektiv viele mehr Farben im Bild.'
    },
    {
      q: 'Im Multicolor-Bitmap-Modus hat jeder 4×8-Block wie viele Farben?',
      options: ['A) 2', 'B) 4', 'C) 8', 'D) 16'],
      correct: 1,
      explanation: '4 Farben pro 4×8-Block: $D021 (Hintergrund, geteilt), Screen-RAM Hi-Nibble, Screen-RAM Lo-Nibble, Color-RAM-Nibble. Auflösung effektiv 160×200 Pixel.'
    },
    {
      q: 'Wie viel Speicher belegt ein vollständiges Hires-Bitmap-Bild (Bitmap + Farben)?',
      options: ['A) 8000 Bytes', 'B) 9000 Bytes', 'C) 16000 Bytes', 'D) 10240 Bytes'],
      correct: 1,
      explanation: '8000 Bytes Bitmap-Daten + 1000 Bytes Farb-Daten im Screen-RAM = 9000 Bytes gesamt. Für Multicolor kommen noch 1000 Bytes Color-RAM hinzu (nicht im RAM).'
    }
  ],

  '06': [
    {
      q: 'Wie viele unabhängige Stimmen hat der SID-Chip?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correct: 2,
      explanation: 'Der SID hat 3 vollständig unabhängige Stimmen, jede mit eigener Frequenz, Pulsbreite, Wellenform, ADSR-Hüllkurve und Lautstärke.'
    },
    {
      q: 'Was passiert wenn das GATE-Bit (Bit 0) im SID Control-Register gesetzt wird?',
      options: ['A) Der Ton wird stummgeschaltet', 'B) Die ADSR-Hüllkurve startet (Attack-Phase beginnt)', 'C) Der Oszillator wird zurückgesetzt', 'D) Ring-Modulation wird aktiviert'],
      correct: 1,
      explanation: 'GATE=1 startet die Hüllkurve: Attack → Decay → Sustain. GATE=0 triggert die Release-Phase. Das Gate-Bit ist das "Note On/Off" des SID.'
    },
    {
      q: 'Was beschreibt das Sustain-Level (S) in der SID-Hüllkurve?',
      options: ['A) Die Zeit bis zum maximalen Pegel', 'B) Die Zeitdauer der Note', 'C) Den Pegel der gehalten wird während GATE=1 nach der Decay-Phase', 'D) Die Abklingzeit nach GATE=0'],
      correct: 2,
      explanation: 'Sustain ist ein 4-Bit-Pegel (0–15), nicht eine Zeit. Der Pegel wird gehalten solange GATE=1. Release (Zeit) beginnt wenn GATE=0 gesetzt wird.'
    },
    {
      q: 'Welches Register setzt die Gesamt-Lautstärke des SID?',
      options: ['A) $D418 Bits 0–3 (Volume)', 'B) $D404 Bits 4–7', 'C) $D416 (Master Volume)', 'D) $D419'],
      correct: 0,
      explanation: '$D418 Bits 0–3 setzen die Master-Lautstärke (0–15). Ohne dieses Register ist kein Ton hörbar — häufige Anfängerfalle! Bits 4–7 steuern den Filter-Modus.'
    },
    {
      q: 'Was ist Ring Modulation beim SID?',
      options: ['A) Ein Echo-Effekt', 'B) Dreieck-Welle von Stimme N wird mit Oszillator der Stimme N-1 amplitudenmoduliert', 'C) Synchronisation zweier Oszillatoren', 'D) Frequenzmodulation'],
      correct: 1,
      explanation: 'Ring Mod (RING-Bit im Control-Register) ersetzt die Dreieck-Wellenform durch das Produkt beider Dreiecke (Stimme 1 moduliert Stimme 3 usw.). Erzeugt metallische Klänge.'
    }
  ],

  '07': [
    {
      q: 'Wie quittiert man einen Raster-IRQ korrekt (bevor RTI)?',
      options: ['A) SEI, dann RTI', 'B) $D019 lesen', 'C) Den ausgelösten Bit-Wert in $D019 schreiben (z.B. LDA #$01: STA $D019)', 'D) $D011 zurückschreiben'],
      correct: 2,
      explanation: '$D019 ist ein "Clear on Write 1"-Register: Man schreibt 1 in das Bit das man löschen will. LDA #$01 / STA $D019 quittiert den Raster-IRQ.'
    },
    {
      q: 'Welcher Latch-Wert ergibt bei CIA1 Timer A exakt 50 Hz (PAL, 985248 Hz Takt)?',
      options: ['A) $EA60 (60000)', 'B) $4CF8 (19704)', 'C) $2710 (10000)', 'D) $9C40 (40000)'],
      correct: 1,
      explanation: '985248 ÷ 50 = 19704,96 ≈ 19704 (abgerundet). Hexadezimal: $4CF8. Dieser Wert in Timer-A-Latch geladen ergibt exakt 50 Interrupts pro Sekunde.'
    },
    {
      q: 'Wofür dient der Double-IRQ-Trick (stabiler Raster-IRQ)?',
      options: ['A) Zwei Raster-IRQs gleichzeitig auslösen', 'B) Den Jitter um ±1 Zyklus zu eliminieren durch Zyklen-Synchronisation', 'C) CIA und VIC-II gleichzeitig als IRQ-Quelle nutzen', 'D) NMI und IRQ gleichzeitig behandeln'],
      correct: 1,
      explanation: 'Jitter entsteht weil die CPU einen Befehl zu Ende führt (1–7 Zyklen Varianz). Der erste IRQ synchronisiert mit einer NOP-NOP-Sequenz auf gerade Zyklenposition; der zweite führt den Effekt aus.'
    },
    {
      q: 'An welcher Adresse liegt der NMI-Vektor im C64-RAM (umgeleitet vom ROM-Vektor)?',
      options: ['A) $FFFA/$FFFB', 'B) $0314/$0315', 'C) $0316/$0317', 'D) $0318/$0319'],
      correct: 3,
      explanation: 'Der NMI-RAM-Vektor liegt bei $0318/$0319. Der ROM-Vektor bei $FFFA/$FFFB zeigt auf KERNAL-Code, der $0318/$0319 ausführt. IRQ-Vektor: $0314/$0315.'
    },
    {
      q: 'CIA1 Timer A im Continuous-Modus: was passiert bei Unterlauf des Zählers?',
      options: ['A) Timer hält an und muss manuell neu gestartet werden', 'B) Der Zähler wird automatisch mit dem Latch-Wert neu geladen und zählt weiter', 'C) Ein NMI wird ausgelöst', 'D) Der Timer wechselt in One-Shot-Modus'],
      correct: 1,
      explanation: 'Im Continuous-Modus (CRA Bit 3 = 0) lädt der Timer beim Unterlauf den Latch-Wert selbst neu und zählt weiter. Ein IRQ wird ausgelöst wenn in $DC0D aktiviert.'
    }
  ],

  '08': [
    {
      q: 'Wie viele Taktzyklen stehen pro PAL-Rasterzeile zur Verfügung?',
      options: ['A) 71', 'B) 63', 'C) 57', 'D) 76'],
      correct: 1,
      explanation: '63 Zyklen pro Rasterzeile (PAL). Davon sind bis zu 40 durch Bad-Line-DMA belegt — effektiv 23 Zyklen in einer Bad Line. Im Display-Bereich ($30–$F7) gilt dies.'
    },
    {
      q: 'Was ist eine "Bad Line" auf dem C64?',
      options: ['A) Eine Rasterzeile mit Fehler', 'B) Eine Rasterzeile in der der VIC-II 40 Zyklen für den Zeichensatz-DMA stiehlt', 'C) Eine Zeile außerhalb des sichtbaren Bereichs', 'D) Eine Zeile mit Sprite-DMA'],
      correct: 1,
      explanation: 'Bad Lines treten auf wenn (Rasterzeile ≥ $30) AND ((Rasterzeile AND $07) == YSCROLL). Der VIC-II stoppt die CPU für 40 Zyklen und liest Zeichennummern per DMA.'
    },
    {
      q: 'Was ist "Unrolling" (Loop Unrolling) in der Optimierung?',
      options: ['A) Schleifen durch direkten Code ersetzen um Branch-Overhead zu sparen', 'B) Eine Schleife rückwärts laufen lassen', 'C) Eine Schleife durch einen Subroutinen-Aufruf ersetzen', 'D) Den Schleifenzähler in den Akkumulator legen'],
      correct: 0,
      explanation: 'Statt einer Schleife mit Branch (3–4 Zyklen pro Iteration) schreibt man den Schleifenkörper N-mal aus. Kostet mehr Speicher, spart Zyklen — wichtig für zeitkritischen Code.'
    },
    {
      q: 'Was ist der Hauptvorteil einer Look-Up-Table (LUT) gegenüber Berechnung?',
      options: ['A) Sie verbraucht keinen Speicher', 'B) Sie ist zur Laufzeit anpassbar', 'C) Sie ersetzt teure Multiplikation/Trigonometrie durch Tabellenabfrage (wenige Zyklen)', 'D) Sie funktioniert nur in der Zero Page'],
      correct: 2,
      explanation: 'Eine LUT ersetzt Berechnungen durch Nachschlagen: SIN/COS, Quadrate, Produkte etc. können in wenigen Zyklen nachgeschlagen werden statt dutzende Zyklen berechnet.'
    },
    {
      q: 'Was ist "Self-Modifying Code" (SMC)?',
      options: ['A) Code der sich selbst kompiliert', 'B) Code der zur Laufzeit seinen eigenen Operanden oder Opcode überschreibt', 'C) Code der in der Zero Page ausgeführt wird', 'D) Selbst-prüfender Code mit Checksummen'],
      correct: 1,
      explanation: 'SMC schreibt direkt auf seinen eigenen Operanden-Byte (z.B. die Adresse in einem LDA abs). Das spart Register-Moves und Vergleiche — klassischer C64-Trick für Hochleistungscode.'
    }
  ],

  '09': [
    {
      q: 'Welches Register steuert den horizontalen Hardware-Scroll?',
      options: ['A) $D011 Bits 0–2', 'B) $D016 Bits 0–2', 'C) $D018 Bits 0–3', 'D) $D020'],
      correct: 1,
      explanation: '$D016 Bits 0–2 (XSCROLL) steuern den horizontalen Feinscroll in 1-Pixel-Schritten (0–7). $D011 Bits 0–2 (YSCROLL) analog für vertikal.'
    },
    {
      q: 'Was ist ein Rasterbalken-Effekt (Rasterbar)?',
      options: ['A) Eine Hardware-Funktion des VIC-II', 'B) Farbwechsel in $D020/$D021 per Raster-IRQ in jeder Zeile für farbige horizontale Balken', 'C) Ein Bitmap-Modus', 'D) Ein Sprite-Effekt mit 8 Sprites nebeneinander'],
      correct: 1,
      explanation: 'Rasterbars entstehen durch schnelles Schreiben von Farben in $D020/$D021 (Rahmen/Hintergrund) per Raster-IRQ. Jede Zeile bekommt eine andere Farbe.'
    },
    {
      q: 'Was ist ein Sprite-Multiplexer?',
      options: ['A) Ein Hardware-Chip der mehr Sprites liefert', 'B) Eine IRQ-Technik die 8 Hardware-Sprites durch Neu-Positionierung für 24+ Sprites nutzt', 'C) Ein Filter für Sprite-Kollisionen', 'D) Mehrere Sprite-Farben gleichzeitig'],
      correct: 1,
      explanation: 'Der Multiplexer nutzt Raster-IRQs: Wenn ein Sprite den Bildschirm verlässt, wird er sofort nach unten umpositioniert. So können 8 Hardware-Sprites dutzende Objekte darstellen.'
    },
    {
      q: 'Was ist FLD (Flexible Line Distance)?',
      options: ['A) Ein Bitmap-Modus mit variablen Zeilenhöhen', 'B) Eine Technik den YSCROLL per IRQ zu ändern um Rasterzeilen zu überspringen oder zu strecken', 'C) Ein Floppy-Ladeprotokoll', 'D) Ein Sprite-Dehnungseffekt'],
      correct: 1,
      explanation: 'FLD (auch "Scrolling-IRQ") ändert den YSCROLL-Wert per IRQ so dass keine Bad Lines im kritischen Bereich auftreten — oder dehnt den Bildschirm durch Zeilen-Einfügen.'
    },
    {
      q: 'Welche PAL-Rasterzeile liegt am Anfang des unteren Rahmens (Bottom Border)?',
      options: ['A) $F8 (248) bei 25-Zeilen-Modus', 'B) $C8 (200)', 'C) $FF (255)', 'D) $E0 (224)'],
      correct: 0,
      explanation: 'Im 25-Zeilen-Modus ($D011 Bit 3 = 1) beginnt der untere Rahmen bei Rasterzeile $F8. Um den Rahmen zu öffnen muss man bei $F8 auf 24-Zeilen schalten (Bit 3 löschen).'
    }
  ],

  '10': [
    {
      q: 'Was ist eine State Machine (Zustandsautomat) im Spielkontext?',
      options: ['A) Eine Hardware-Komponente', 'B) Ein Datenkompressionsformat', 'C) Ein Kontrollsystem das genau einen von mehreren definierten Zuständen hat und Übergänge regelt', 'D) Ein Sortier-Algorithmus'],
      correct: 2,
      explanation: 'Spielzustände wie TITLE/PLAYING/PAUSED/GAMEOVER bilden eine State Machine. Jeder Zustand hat eigenen Update/Draw-Code, Übergänge werden durch Ereignisse getriggert.'
    },
    {
      q: 'Was ist ein Tile-basiertes Level-Design?',
      options: ['A) Ein Level aus vorgerenderten Bildern', 'B) Eine Spielwelt aufgebaut aus einem Raster wiederholter Kacheln (Tiles) mit einer Tilemap', 'C) Sprites die als Hintergrund verwendet werden', 'D) Comprimierte Level-Daten'],
      correct: 1,
      explanation: 'Tile-Maps speichern für jede Position nur einen Tile-Index (1 Byte). Der Renderer sucht die Tile-Grafik aus einer Tileset-Tabelle. Spart Speicher und ermöglicht große Levels.'
    },
    {
      q: 'Wie sortiert ein Sprite-Multiplexer die Sprites für korrekte Darstellung?',
      options: ['A) Nach Sprite-Nummer', 'B) Nach X-Position', 'C) Nach Y-Position (von oben nach unten)', 'D) Gar nicht — Reihenfolge egal'],
      correct: 2,
      explanation: 'Der Multiplexer muss Sprites nach Y-Position sortieren damit die IRQs in richtiger Reihenfolge auftreten. Gängig: Bubble-Sort oder Insertion-Sort (reicht für ≤24 Sprites).'
    },
    {
      q: 'Was ist RLE-Komprimierung (Run-Length Encoding)?',
      options: ['A) Relative Label Encoding für Assembler', 'B) Gleiche aufeinanderfolgende Bytes als Länge+Wert-Paar kodieren', 'C) Ein Disk-Dateisystem', 'D) Eine VIC-II-Funktion'],
      correct: 1,
      explanation: 'RLE: z.B. "00 00 00 00 00" → "05 00" (5× Wert $00). Besonders effektiv für Level-Daten mit großen einheitlichen Flächen. Einfach zu implementieren und zu dekomprimieren.'
    },
    {
      q: 'Was ist ein Game Loop (Spielschleife)?',
      options: ['A) Eine Level-Schleife die alle Levels wiederholt', 'B) Die Hauptschleife: Input lesen → Spielzustand updaten → Grafik rendern — einmal pro Frame', 'C) Eine Fehlerbehandlungsroutine', 'D) Die Musik-Wiedergabeschleife'],
      correct: 1,
      explanation: 'Input → Update → Render, wiederholt pro Frame (50 Hz PAL). Typisch VBlank-synchronisiert: warten auf Rasterzeile $F8+ dann alles bis zum nächsten Frame erledigen.'
    }
  ],

  '11': [
    {
      q: 'Was ist ein GDD (Game Design Document)?',
      options: ['A) Ein Assembler-Quellcode-Format', 'B) Ein Dokument das Spielkonzept, Mechaniken, Assets und Scope definiert bevor Coding beginnt', 'C) Ein Grafikdateiformat', 'D) Ein Debug-Protokoll'],
      correct: 1,
      explanation: 'Das GDD dokumentiert Was (Spielkonzept), Wie (Mechaniken), Womit (Assets, Tools) und Bis Wann (Meilensteine). Verhindert Scope Creep und spart Entwicklungszeit.'
    },
    {
      q: 'Was bedeutet "Must" in der MoSCoW-Priorisierungsmethode?',
      options: ['A) Feature ist möglicherweise nützlich', 'B) Feature ist unverzichtbar — ohne es ist das Spiel nicht spielbar', 'C) Feature sollte implementiert werden wenn Zeit', 'D) Feature wird nicht implementiert'],
      correct: 1,
      explanation: 'MoSCoW: Must (unverzichtbar) → Should (wichtig aber ohne Showstopper) → Could (nett zu haben) → Won\'t (ausdrücklich ausgeschlossen). Hilft bei realistischer Scope-Planung.'
    },
    {
      q: 'Was ist ein "Vertikal Slice" Prototyp?',
      options: ['A) Ein scrollendes Level', 'B) Alle Systeme des Spiels in einem kleinen spielbaren Abschnitt demonstriert', 'C) Ein horizontaler Scroller', 'D) Nur die Grafik ohne Gameplay'],
      correct: 1,
      explanation: 'Ein Vertical Slice enthält alle Layer des Spiels (Input, Physik, KI, Grafik, Sound) aber nur für einen kleinen Teil. Beweist die technische Machbarkeit früh.'
    },
    {
      q: 'Wozu dient Exomizer beim C64-Release?',
      options: ['A) Zum Erzeugen von D64-Images', 'B) Als LZ77-Kompressor um .prg-Dateien zu verkleinern', 'C) Zum Disassemblieren von Binärdateien', 'D) Zum Debuggen in VICE'],
      correct: 1,
      explanation: 'Exomizer komprimiert C64-Binärdateien mit LZ77. Typische Kompressionsraten: 40–60%. Die Datei enthält einen Dekompressor der sich in den Zielbereich entpackt.'
    },
    {
      q: 'In welcher Phase sollte das "Technische Gerüst" (IRQ, Game Loop, Speicherlayout) aufgebaut werden?',
      options: ['A) Als Letztes, nach allen Grafiken', 'B) Als Erstes, vor Grafik und Sound', 'C) Gleichzeitig mit dem ersten Spieler-Sprite', 'D) Nur wenn Zeit bleibt'],
      correct: 1,
      explanation: 'Das Gerüst zuerst: Memory Map, IRQ-Setup, Game-Loop-Skelett. Dann Grafik-Framework, dann Kern-Mechanik, dann Inhalte. Ohne Gerüst müsste man später alles neu strukturieren.'
    }
  ],

  '12': [
    {
      q: 'Was ist eine Demo-"Part-Struktur"?',
      options: ['A) Die Bitmap-Daten einer Demo', 'B) Unabhängige Programmabschnitte die nacheinander geladen und abgespielt werden', 'C) Die Musikdaten', 'D) Ein Debug-Format'],
      correct: 1,
      explanation: 'Jeder Part ist ein eigenständiges Programm: eigener Code, eigene Grafik. Parts werden sequenziell von Disk geladen. Ermöglicht mehr Inhalt als ins RAM passt.'
    },
    {
      q: 'Was ist eine Sync-Tabelle in einer Demo?',
      options: ['A) Eine Frequenztabelle für den SID', 'B) Eine Frame-basierte Event-Liste die Effekte mit der Musik synchronisiert', 'C) Eine Tabelle mit Sprites', 'D) Ein Timing-Protokoll'],
      correct: 1,
      explanation: 'Sync-Tabelle: Zeile = Frame-Nummer, Wert = Aktion (Part wechseln, Farbe ändern, Scroll starten). Wird per Frame-Counter ausgewertet für präzise Musik-Bild-Synchronisation.'
    },
    {
      q: 'Wie viele Rasterzeilen hat ein PAL-Frame insgesamt?',
      options: ['A) 200', 'B) 262', 'C) 312', 'D) 256'],
      correct: 2,
      explanation: 'PAL: 312 Rasterzeilen (davon 284 sichtbar, 28 im vertikalen Rücklauf). NTSC: 263 Rasterzeilen. Diese Differenz ist zentral für PAL/NTSC-Kompatibilität.'
    },
    {
      q: 'Was muss eine PAL/NTSC-Detect-Routine unterscheiden?',
      options: ['A) Prozessortyp', 'B) RAM-Größe', 'C) Anzahl der Rasterzeilen pro Frame (312 vs. 263) und Frame-Rate (50 vs. 60 Hz)', 'D) SID-Version (6581 vs. 8580)'],
      correct: 2,
      explanation: 'PAL: 312 Zeilen, 50 Hz. NTSC: 263 Zeilen, ca. 60 Hz. Raster-IRQ-Positionen und Timer-Werte müssen angepasst werden. Detect: Rasterzeile $FF zählen ob PAL.'
    },
    {
      q: 'Was ist ein Fade-to-Black zwischen zwei Demo-Parts?',
      options: ['A) Den SID stumm schalten', 'B) Alle 16 Farben schrittweise auf Schwarz reduzieren über mehrere Frames', 'C) Das VICE-Fenster minimieren', 'D) Den VIC-II Reset'],
      correct: 1,
      explanation: 'Fade-to-Black: Über z.B. 16 Frames die Helligkeit aller C64-Farben in den Farbregistern ($D020–$D021, Sprites) schrittweise auf Schwarz (0) reduzieren. Dann Part laden.'
    }
  ],

  '13': [
    {
      q: 'Wie viel Erweiterungsspeicher hat eine REU 1750?',
      options: ['A) 128 KB', 'B) 256 KB', 'C) 512 KB', 'D) 1 MB'],
      correct: 2,
      explanation: 'REU 1750 = 512 KB. Weitere Modelle: REU 1700 = 128 KB, REU 1764 = 256 KB. Per DMA-Register können bis zu 16 MB adressiert werden (theoretisch).'
    },
    {
      q: 'Welches Register startet den REU DMA-Transfer (C64-RAM → REU)?',
      options: ['A) $DF00 Bit 7', 'B) $DF01 mit dem Wert $01 (Transfer: C64 to REU)', 'C) $DF06 Bits 0–1', 'D) $DFFF'],
      correct: 1,
      explanation: '$DF01 = REU-Befehlsregister. Wert $01 = C64→REU Transfer. Wert $02 = REU→C64. Wert $03 = Swap. Zusätzlich Bit 7 setzen um sofort auszuführen.'
    },
    {
      q: 'CIA2 $DD00 Bits 0–1 = %11 (beide 1) bedeutet welche VIC-II-Bank?',
      options: ['A) Bank 3 ($C000–$FFFF)', 'B) Bank 2 ($8000–$BFFF)', 'C) Bank 0 ($0000–$3FFF)', 'D) Bank 1 ($4000–$7FFF)'],
      correct: 2,
      explanation: 'CIA2 $DD00 Bits 0–1 sind INVERTIERT: %11=Bank0, %10=Bank1, %01=Bank2, %00=Bank3. Default %11 = Bank 0 ($0000–$3FFF) wo Screen-RAM und Zeichensatz liegen.'
    },
    {
      q: 'Wie viele ROM-Bänke hat eine EasyFlash-Cartridge?',
      options: ['A) 4', 'B) 16', 'C) 32', 'D) 64'],
      correct: 3,
      explanation: 'EasyFlash hat 64 Bänke à 16 KB (8 KB ROML + 8 KB ROMH) = 1 MB Flash-Speicher. Bank-Register: $DE00 (Bank 0–63), $DE02 (LED + GAME/EXROM Bits).'
    },
    {
      q: 'Was ist bei CIA2 $DD01 (Userport, Port B) der Standardzustand der DDR ($DD03)?',
      options: ['A) $FF (alle Pins Ausgang)', 'B) $00 (alle Pins Eingang)', 'C) $0F (Low-Nibble Ausgang)', 'D) $55 (abwechselnd)'],
      correct: 1,
      explanation: '$DD03 = $00 nach Reset: alle Pins sind Eingänge. Für LED-Ausgabe muss man $DD03 = $FF schreiben. Vergisst man dies, passiert beim STA $DD01 nichts sichtbares.'
    }
  ],

  '14': [
    {
      q: 'Welche ACME-Kommandozeilen-Option erzeugt eine Dependency-Datei für Make?',
      options: ['A) --depends', 'B) --depfile', 'C) --makedeps', 'D) -d'],
      correct: 1,
      explanation: 'ACME `--depfile output.d` schreibt alle !source-Abhängigkeiten in eine Makefile-kompatible .d-Datei. Make kann diese mit `-include` einlesen für automatisches Rebuilding.'
    },
    {
      q: 'Was macht der ACME-Parameter `--format cbm`?',
      options: ['A) Erzeugt eine .crt Cartridge-Datei', 'B) Erzeugt ein CBM-kompatibles Format mit 2-Byte Load-Adresse am Anfang', 'C) Komprimiert die Ausgabe', 'D) Aktiviert CBM-BASIC-Syntax'],
      correct: 1,
      explanation: '`--format cbm` (Standard) erzeugt eine .prg-Datei mit den 2 Load-Adress-Bytes voran. Ohne dieses Format fehlt der $0801-Header und LOAD",8,1" lädt an die falsche Adresse.'
    },
    {
      q: 'Welcher VICE-Parameter startet es headless (ohne GUI) für CI/CD?',
      options: ['A) --nogui', 'B) -headless', 'C) --batch', 'D) -silent'],
      correct: 1,
      explanation: 'VICE `-headless` startet ohne X11/GUI. Kombiniert mit `-autostart program.prg` und `-limitcycles N` kann man Programme automatisch ausführen und Screenshots machen.'
    },
    {
      q: 'Was ist eine `tasks.json` in VS Code?',
      options: ['A) Eine TODO-Liste für den Entwickler', 'B) Eine Konfigurationsdatei die Build-Tasks definiert (z.B. ACME aufrufen)', 'C) Eine Datei für automatisches Testen', 'D) Eine Liste von Keyboard-Shortcuts'],
      correct: 1,
      explanation: '`.vscode/tasks.json` definiert Build-Tasks die mit Strg+Shift+B oder als `preLaunchTask` in `launch.json` aufgerufen werden. Ermöglicht ACME-Build direkt aus VS Code.'
    },
    {
      q: 'Was ist GitHub Actions im C64-Kontext?',
      options: ['A) Ein Sprite-Animationsformat', 'B) CI/CD: automatisches Bauen und Testen auf jedem Commit via Cloud-Runner', 'C) Ein GitHub-Plugin für VICE', 'D) Ein Code-Review-Tool'],
      correct: 1,
      explanation: 'GitHub Actions installiert ACME + VICE auf einem Ubuntu-Runner, baut das Projekt, führt Tests aus, und erstellt Releases mit .prg/.d64-Artifacts. Vollständig automatisch.'
    }
  ],

  '15': [
    {
      q: 'Was macht der VICE-Monitor-Befehl `d 1000`?',
      options: ['A) Löscht Speicher ab $1000', 'B) Disassembliert 20 Bytes ab Adresse $1000', 'C) Debuggt den Code ab $1000', 'D) Deaktiviert alle Breakpoints'],
      correct: 1,
      explanation: '`d` (disassemble) zeigt den Speicher als 6510-Assembly-Code an. `d 1000` disassembliert ab $1000. `d 1000 1050` begrenzt auf den Bereich $1000–$1050.'
    },
    {
      q: 'Was ist die Formel für eine Bad Line?',
      options: ['A) Rasterzeile mod 8 == 0', 'B) Rasterzeile ≥ $30 AND (Rasterzeile AND $07) == (YSCROLL AND $07)', 'C) Rasterzeile == $D012', 'D) Rasterzeile < $30'],
      correct: 1,
      explanation: 'Bad Lines: (raster ≥ $30) AND (raster AND %111) == (YSCROLL AND %111). YSCROLL = $D011 Bits 0–2 (Standard = 3). In diesen Zeilen stiehlt VIC-II 40 Zyklen.'
    },
    {
      q: 'Was ist ein bedingter Breakpoint im VICE-Monitor?',
      options: ['A) Ein Breakpoint der nur einmal auslöst', 'B) Ein Breakpoint der nur auslöst wenn eine Bedingung erfüllt ist (z.B. A=$42)', 'C) Ein Breakpoint auf einem bestimmten Opcode', 'D) Ein zeitbasierter Breakpoint'],
      correct: 1,
      explanation: 'VICE: `break 1000 if a==$42` hält nur wenn PC=$1000 UND A=$42. Nützlich für schwer reproduzierbare Bugs die nur unter bestimmten Bedingungen auftreten.'
    },
    {
      q: 'Was kostet ein Page-Cross bei `LDA $1000,X` wenn X=$FF?',
      options: ['A) Nichts — kein Unterschied', 'B) +1 Takt (Strafzyklus)', 'C) +2 Takte', 'D) -1 Takt (Optimierung)'],
      correct: 1,
      explanation: '$1000 + $FF = $10FF → $11xx — die High-Byte der Adresse ändert sich (Page-Cross). Betroffene Befehle (LDA abs,X/Y; LDA (zp),Y etc.) brauchen dann +1 Zyklus für die Adresskorrektur.'
    },
    {
      q: 'Wie viele Zyklen stiehlt Sprite-DMA pro aktivem Sprite pro Rasterzeile (im DMA-Bereich)?',
      options: ['A) 1 Zyklus', 'B) 2 Zyklen', 'C) 3 Zyklen', 'D) 4 Zyklen'],
      correct: 1,
      explanation: '2 Zyklen pro aktivem Sprite pro Zeile im DMA-Fetch-Bereich (3 Zeilen pro Sprite: pDMA-Zeile, 2× sDMA). 8 Sprites = maximal 16 gestohlene Zyklen pro Zeile.'
    }
  ],

  '16': [
    {
      q: 'Joystick Port 2 ($DC00) — Bit 4 = 0 bedeutet was?',
      options: ['A) Joystick nach oben gedrückt', 'B) Fire-Taste gedrückt (aktiv Low)', 'C) Joystick nach rechts', 'D) Kein Joystick angeschlossen'],
      correct: 1,
      explanation: 'Joystick-Signale sind aktiv Low: 0 = gedrückt, 1 = losgelassen. Bit-Mapping Port 2 ($DC00): Bit 0=Up, 1=Down, 2=Left, 3=Right, 4=Fire.'
    },
    {
      q: 'Um Tastaturzeile 0 zu scannen, welcher Wert muss in $DC00 geschrieben werden?',
      options: ['A) $00 (alle Zeilen gleichzeitig)', 'B) $FE (%11111110 — nur Bit 0 = 0)', 'C) $FF (deaktiviert)', 'D) $01'],
      correct: 1,
      explanation: '$DC00 wählt die Tastaturzeile aus: Ein Bit auf 0 setzen aktiviert diese Zeile. $FE = %11111110 aktiviert nur Zeile 0 (Bit 0). Dann $DC01 lesen für Spalten-Bits.'
    },
    {
      q: 'Was ist "Keyboard Ghosting" beim C64?',
      options: ['A) Eine Taste die mehrfach registriert wird (Debounce)', 'B) Bei bestimmten 3-Tasten-Kombinationen erscheint eine vierte Taste als gedrückt', 'C) Die RESTORE-Taste löst einen NMI aus', 'D) Ein Flackern des Bildschirms bei Tastendruck'],
      correct: 1,
      explanation: 'Bestimmte 3-Tasten-Combos bilden ein diagonales Matrix-Kreuz und "simulieren" eine 4. Taste. Spiele die mehrere Tasten gleichzeitig lesen müssen sichere Tastenkombinationen verwenden.'
    },
    {
      q: 'Was verhindert Edge Detection beim Joystick?',
      options: ['A) Prellt (Debounce)', 'B) Dass ein einzelner Knopfdruck als mehrfache Aktion gezählt wird solange der Knopf gehalten ist', 'C) Ghosting in der Tastaturmatrix', 'D) Verzögerung durch CIA-Timer'],
      correct: 1,
      explanation: 'Edge Detection vergleicht den aktuellen mit dem vorherigen Zustand: Aktion nur bei Flanke (war 1, ist jetzt 0). Verhindert dass Halten des Buttons 50 Ereignisse/Sekunde auslöst.'
    },
    {
      q: 'Was ist der Nachteil von GETIN ($FFE4) gegenüber direktem Matrix-Scan für Spiele?',
      options: ['A) GETIN ist zu langsam', 'B) GETIN liefert nur eine Taste gleichzeitig — keine Mehrfachtasten-Erkennung', 'C) GETIN funktioniert nicht auf Port 2', 'D) GETIN nutzt CIA2 statt CIA1'],
      correct: 1,
      explanation: 'GETIN liest eine Taste pro Aufruf und mappt nach PETSCII. Für Spiele die gleichzeitig mehrere Tasten (z.B. Richtung + Sprung) erkennen müssen ist direkter Matrix-Scan erforderlich.'
    }
  ],

  '17': [
    {
      q: 'Wie schnell ist der Standard-KERNAL IEC-Loader ungefähr?',
      options: ['A) 2000–3000 Bytes/Sekunde', 'B) 350–400 Bytes/Sekunde', 'C) 1200 Bytes/Sekunde (wie ein Modem)', 'D) 100 Bytes/Sekunde'],
      correct: 1,
      explanation: 'Der KERNAL-Loader überträgt ca. 350–400 Bytes/Sekunde über den seriellen IEC-Bus. Das ist sehr langsam — Fastloader erreichen 4000–8000 Bytes/Sekunde durch optimiertes Protokoll.'
    },
    {
      q: 'Welche KERNAL-Routine muss VOR OPEN aufgerufen werden um den Dateinamen zu setzen?',
      options: ['A) SETLFS ($FFBA)', 'B) SETNAM ($FFBD)', 'C) CHKIN ($FFC6)', 'D) READST ($FFB7)'],
      correct: 1,
      explanation: 'SETNAM ($FFBD): A=Länge des Namens, XY=Adresse des Namens-Strings. Muss vor OPEN aufgerufen werden. SETLFS setzt Logische/Primär/Sekundär-Adresse.'
    },
    {
      q: 'Über welchen Kanal sendet man DOS-Kommandos an das 1541-Laufwerk?',
      options: ['A) Kanal 1', 'B) Kanal 15 (Kommando-/Fehlerkanal)', 'C) Kanal 8', 'D) Kanal 0'],
      correct: 1,
      explanation: 'Kanal 15 ist der DOS-Kommandokanal. Zum Senden: OPEN 1,8,15 dann CHKOUT 1 und CHROUT für jeden Befehlsbuchstaben. Zum Lesen des Fehlercodes: CHKIN 1, CHRIN.'
    },
    {
      q: 'Was macht das "M-W" Kommando an das 1541-Laufwerk?',
      options: ['A) Move Write — benennt eine Datei um', 'B) Memory Write — schreibt Bytes in den RAM des Floppy-Laufwerks', 'C) Master Write — formatiert die Diskette', 'D) Multi Write — schreibt mehrere Sektoren gleichzeitig'],
      correct: 1,
      explanation: 'M-W (Memory Write) schreibt bis zu 32 Bytes in den 1541-eigenen RAM (6502-Prozessor, $0000–$07FF). Wird genutzt um Drive-Code hochzuladen. M-E (Memory Execute) startet ihn dann.'
    },
    {
      q: 'Auf welcher Track/Sector-Position liegt das BAM (Block Availability Map) einer D64-Diskette?',
      options: ['A) Track 1 Sektor 0', 'B) Track 18 Sektor 0', 'C) Track 18 Sektor 1', 'D) Track 35 Sektor 0'],
      correct: 1,
      explanation: 'BAM liegt auf Track 18 Sektor 0. Track 18 Sektor 1+ enthält das Directory. Die BAM zeigt welche Blöcke auf allen 35 Tracks frei sind — zentral für DOS-Dateiverwaltung.'
    }
  ]

};

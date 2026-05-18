; ============================================================
; C64 Mastery — stufe_11_spielentwicklung_workflow
; Abschnitt: 1.2 Das Game Design Document (GDD) für den C64
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; ================================================================
; GAME DESIGN DOCUMENT — "JUMPMASTER"
; Version: 1.0 | Status: In Entwicklung | Ziel: CSDb-Release
; ================================================================
;
; KONZEPT:
;   Ein 1-Screen-Plattformer. Der Spieler springt durch
;   automatisch generierende Plattformen nach oben.
;   Je höher, desto schneller. Kein Ende — nur ein Score.
;
; GENRE:        Endless Plattformer
; SPIELER:      1 (Joystick Port 2)
; GRAFIK:       Zeichenmodus (40x25), benutzerdefinierter Charset
; SOUND:        1 Melodie (3 Stimmen), 2 Sound-Effekte
; LEVEL:        Endlos, prozedural (kein Disk-Laden nötig)
; SPEICHER:     64 KB, kein Bank-Switching benötigt
;
; SPIELMECHANIK:
;   - Joystick: Links/Rechts bewegen, Feuer = Sprung
;   - Plattformen bewegen sich von oben nach unten
;   - Spieler fällt durch den unteren Rand = Game Over
;   - Score: +10 Punkte pro übersprungene Plattform
;
; TECHNISCHE ZIELE:
;   - 50 Hz stabil (kein Frame-Overrun)
;   - Max. 8 Sprites (Spieler + 7 Plattform-Highlights)
;   - Kein Multiplexer benötigt
;
; MEILENSTEINE:
;   Woche 1: Framework + Spieler-Bewegung
;   Woche 2: Plattform-Logik + Kollision
;   Woche 3: Score + Game Over + Musik
;   Woche 4: Polish, Test, Release
; ================================================================

; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 1.13 (Indirect), Y — Post-Indexed Indirect: Der mächtigste Modus
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; (Indirect),Y: Effektive Adresse = [Inhalt($ZP, $ZP+1)] + Y
; Schritt 1: Base = {$ZP+1} * 256 + {$ZP}  (16-Bit-Zeiger aus Zero Page lesen)
; Schritt 2: Effektive Adresse = Base + Y
; Schritt 3: Daten lesen/schreiben von/nach effektiver Adresse

LDA ($FB),Y         ; 5 Zyklen (6 wenn Page-Crossing)

; === VOLLSTÄNDIGES BEISPIEL: NULL-TERMINIERTER STRING AUSGEBEN ===
; KERNAL CHROUT ($FFD2) gibt Zeichen in A aus.
; Konvention: $FB/$FC = 16-Bit-Zeiger auf String im Speicher
; String endet mit Byte $00 (Null-Terminator)

PrintString:
        ldy #0              ; Y = Index, beginnt bei 0
@loop:
        lda ($fb),y         ; Zeichen bei [Zeiger + Y] laden
        beq @done           ; Wenn Null-Byte → Ausgabe beendet
        jsr $ffd2           ; KERNAL: Zeichen aus A ausgeben
        iny                 ; Nächstes Zeichen (Y++)
        bne @loop           ; Solange Y nicht auf 0 zurückrollt (max 255 Zeichen)
@done:
        rts

; Aufruf der Routine:
Aufruf:
        lda #<MeinText      ; Low-Byte der Textadresse
        sta $fb             ; In ZP-Zeiger Low-Byte
        lda #>MeinText      ; High-Byte der Textadresse
        sta $fc             ; In ZP-Zeiger High-Byte
        jsr PrintString     ; Routine aufrufen
        rts

MeinText:
        !text "HALLO C64 MASTERY!"
        !byte 0              ; Null-Terminator

; Zweiter Aufruf — völlig andere Adresse, dieselbe Routine:
        lda #<AndererText
        sta $fb
        lda #>AndererText
        sta $fc
        jsr PrintString     ; Dieselbe Routine, anderer Zeiger!

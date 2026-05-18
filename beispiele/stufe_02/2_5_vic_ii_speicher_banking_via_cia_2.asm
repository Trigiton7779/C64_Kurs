; ============================================================
; C64 Mastery — stufe_02_adressierung_speicher
; Abschnitt: 2.5 VIC-II Speicher-Banking via CIA 2
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; VIC-Bank 2 auswählen ($8000-$BFFF):
        lda $dd00           ; CIA2 Port A lesen
        and #%11111100     ; Bits 1-0 löschen
        ora #%00000001     ; %01 → Bank 2
        sta $dd00

; VIC-II Zeiger-Register $D018 setzen:
; Screen-RAM in Bank 2 bei $8C00 → Offset = $0C00 → $0C00/1024 = 3 → Bits 7-4 = 0011
; Charset in Bank 2 bei $9000 → Offset = $1000 in der Bank → $1000/2048 = 2 → Bits 3-1 = 010
        lda #%00110100     ; Screen=3 (Bits 7-4=0011), Charset=2 (Bits 3-1=010), Bit0=0
        sta $d018

; Zur Bank 0 zurück (Standard):
        lda $dd00
        and #%11111100
        ora #%00000011     ; %11 → Bank 0 (Standard)
        sta $dd00

; Standard-Wert $D018 für Bank 0, Screen=$0400, Charset=$1000:
; Screen-Offset: $0400/1024 = 1 → Bits 7-4 = 0001
; Charset-Offset: $1000/2048 = 2 → Bits 3-1 = 010 (ROM-Zeichensatz!)
; $D018 = %00010100 = $14 ← Standardwert nach Reset

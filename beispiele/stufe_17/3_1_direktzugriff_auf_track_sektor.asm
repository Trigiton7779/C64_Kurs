; ============================================================
; C64 Mastery — stufe_17_floppy_fastloader
; Abschnitt: 3.1 Direktzugriff auf Track/Sektor
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Sektor direkt lesen via Puffer-Kanal (U1)
; track = Track (1–35), sector = Sektor (0–20 je nach Track)
read_sector:
    ; 1. Pufferkanal öffnen (SA=2)
    lda #2 : ldx #8 : ldy #2
    jsr $FFBA
    lda #0 : ldx #0 : ldy #0
    jsr $FFBD            ; kein Name
    jsr $FFC0            ; OPEN

    ; 2. U1-Kommando: "U1:2 0 18 1" (Kanal, Drive, Track, Sektor)
    lda #u1cmd_end - u1cmd
    ldx #<u1cmd : ldy #>u1cmd
    jsr $FFBD
    ; ... (SETLFS 15/8/15, OPEN, CLOSE wie in send_dos_cmd)

    ; 3. Pufferkanal lesen: 256 Bytes = 1 Sektor
    lda #2
    jsr $FFC6            ; CHKIN — Kanal 2 als Input
    ldx #0
.read256:
    jsr $FFCF            ; CHRIN
    sta sector_buffer,x
    inx
    bne .read256
    jsr $FFCC            ; CLRCHN
    lda #2 : jsr $FFC3   ; CLOSE
    rts

u1cmd: !text "U1:2 0 18 1"    ; Track 18, Sektor 1 (Directory)
u1cmd_end:
sector_buffer: !fill 256, 0

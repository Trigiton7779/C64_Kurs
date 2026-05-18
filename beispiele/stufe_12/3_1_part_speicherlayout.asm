; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 3.1 Part-Speicherlayout
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Speicherlayout für eine kleine 3-Part-Demo (alles im RAM)

SHARED_CODE     = $0900  ; IRQ, Musik, Sync-Tabelle, Part-Wechsel (~2 KB)
MUSIC_DATA      = $1000  ; GoatTracker-Daten (~3 KB)
PART1_CODE      = $2000  ; Sinusscroller + Rasterbar-Effekt (~2 KB)
PART1_DATA      = $2800  ; Charset, Scroller-Text (~3 KB)
PART2_CODE      = $3800  ; Plasma-Effekt (~1.5 KB)
PART2_TABLES    = $4000  ; Sinustabellen für Plasma (2 × 256 Bytes)
PART3_CODE      = $4200  ; DYSP Credits-Scroller (~1.5 KB)
PART3_DATA      = $4800  ; Credits-Text, Sprite-Daten (~2 KB)

; Tabellen der Part-Funktionen (Dispatch-Tabelle)
part_init_table:
        !word init_part1
        !word init_part2
        !word init_part3

part_update_table:
        !word update_part1
        !word update_part2
        !word update_part3

current_part:   !byte 0    ; 0 = Part 1, 1 = Part 2, 2 = Part 3

call_part_update:
        lda current_part
        asl a                  ; × 2 für Word-Offset
        tax
        lda part_update_table,x
        sta ZP_PTR_LO
        lda part_update_table+1,x
        sta ZP_PTR_HI
        jmp (ZP_PTR_LO)        ; Indirekter Aufruf des aktuellen Parts

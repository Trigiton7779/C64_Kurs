; ============================================================
; C64 Mastery — stufe_12_demo_entwicklung_workflow
; Abschnitt: 5.1 Standard-KERNAL-Loader für die Demo
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Demo-Loader: Alle Teile von Diskette laden
; Annahme: Demo startet von Disk, KERNAL aktiv

; Konstanten für KERNAL-Aufrufe
SETLFS          = $FFBA
SETNAM          = $FFBD
LOAD            = $FFD5

load_file:
        ; Parameter: .X = Lade-Adresse Low, .Y = High, .A = Datei-Nummer
        ; Dateiname in filename_ptr/filename_len
        pha                  ; Dateinummer merken

        ; SETLFS: Logische Datei = A, Gerät 8, Sekundäradresse 0
        lda filename_len
        ldx #ldy #>filename
        jsr SETNAM           ; Dateiname setzen

        pla                  ; Dateinummer zurück
        ldx #8               ; Gerät 8 (1541)
        ldy #0               ; Sekundäradresse 0
        jsr SETLFS

        ; LOAD: A=0 (Laden), XY = Zieladresse (wenn Sek.-Adresse=0: ignoriert)
        ; Mit Sek.-Adresse=1: Ladeadresse aus PRG-Header verwenden
        lda #0               ; Modus: Laden (nicht Verifizieren)
        jsr LOAD

        ; Fehlerprüfung: Carry = 1 → Fehler
        bcs load_error
        rts

load_error:
        ; Fehlerbehandlung: Fehlermeldung anzeigen, Demo abbrechen
        brk                  ; Placeholder — im echten Code: Fehlermeldung

filename:       !text "BITWAVE.PART2"
filename_len:   !byte 13

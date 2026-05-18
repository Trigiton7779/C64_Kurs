; ============================================================
; C64 Mastery — stufe_06_sid_sound
; Abschnitt: 7. Einfacher Musik-Player
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; =====================================================
; Einfacher 1-stimmiger Musik-Player
; Format: Note-Index (0=Pause, 1=C3...), Dauer (Frames)
; Aufruf: 50x/Sekunde im Raster-IRQ
; =====================================================

; Player-Variablen (Zero Page)
mus_note_dur  = $70   ; Verbleibende Dauer der aktuellen Note
mus_pos       = $71   ; Position im Melodie-Array (Low-Byte)
mus_pos_hi    = $72   ; Position (High-Byte)

; Player initialisieren
MusicInit:
        lda #Melody
        sta mus_pos_hi
        lda #1
        sta mus_note_dur ; Sofort erste Note laden
        ; Lautstärke setzen
        lda #$0f
        sta $d418
        rts

; Player-Update (einmal pro Frame aufrufen)
MusicUpdate:
        dec mus_note_dur
        bne @playing    ; Noch nicht fertig

        ; Nächste Note laden
        ldy #0
        lda (mus_pos),y ; Note-Index
        bmi @end_of_music   ; $FF = Ende

        beq @play_rest  ; 0 = Pause

        ; Frequenz aus Tabelle laden
        sec
        sbc #1          ; Index 1 = C3 = Tabellen-Offset 0
        tax
        lda NoteTabLo,x
        sta $d400
        lda NoteTabHi,x
        sta $d401

        ; Sawtooth + Gate
        lda #$21        ; SAW + GATE
        sta $d404
        bne @load_dur

@play_rest:
        ; Gate aus für Pause
        lda $d404
        and #$fe
        sta $d404

@load_dur:
        ; Dauer laden (Byte 2 der Note)
        iny
        lda (mus_pos),y
        sta mus_note_dur

        ; Pointer weitersetzen (+2)
        lda mus_pos
        clc
        adc #2
        sta mus_pos
        bcc @playing
        inc mus_pos_hi

@playing:
        rts

@end_of_music:
        ; Lied wiederholen
        lda #Melody
        sta mus_pos_hi
        lda #1
        sta mus_note_dur
        rts

; Melodie-Daten: Note-Index, Dauer (in Frames @ 50 Hz)
; Note 1=C3, 2=C#3, ..., 12=B3, 13=C4, ...
Melody:
        !byte 13,12  ; C4, 12 Frames (Viertel bei ~100 BPM)
        !byte 15,12  ; D4
        !byte 17,12  ; E4
        !byte 13,24  ; C4, halbe Note
        !byte  0,12  ; Pause
        !byte 17,12  ; E4
        !byte 18,12  ; F4
        !byte 20,24  ; G4
        !byte $ff    ; Ende-Marker

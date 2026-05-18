; ============================================================
; C64 Mastery — stufe_08_optimierung
; Abschnitt: 3.2 Duff's Device für 6510
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; Kopiere N Bytes ($FB = Zähler), Quelle $FC/$FD, Ziel $FE/$FF
; Technik: Spring direkt in unrolled Loop basierend auf (N mod 8)

CopyN:
          LDA ByteCount     ; Anzahl Bytes
          BEQ .done         ; 0 Bytes: fertig

          ; Berechne Start-Position im unrolled Loop
          SEC
          SBC #1
          LSR               ; /2
          LSR               ; /4
          LSR               ; /8 → Anzahl voller 8er-Gruppen
          STA GroupCount

          LDA ByteCount
          AND #$07          ; Reste 0-7
          ASL               ; × 2 (Bytes pro LDA+STA Paar = 6, aber vereinfacht)
          TAX
          JMP (JumpTable,X) ; Spring zur richtigen Position

JumpTable:
          !word Copy0, Copy1, Copy2, Copy3
          !word Copy4, Copy5, Copy6, Copy7

Copy7:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy6:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy5:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy4:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy3:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy2:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy1:    LDA (SrcPtr),Y : STA (DstPtr),Y : INY
Copy0:    ; Hier landen wir für Rest=0 (nach vollem 8er-Block)
          ; GroupCount verbleibende volle 8er-Gruppen weiter kopieren...
.done:    RTS

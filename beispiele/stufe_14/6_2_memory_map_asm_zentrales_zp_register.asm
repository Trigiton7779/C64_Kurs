; ============================================================
; C64 Mastery — stufe_14_modern_workflow
; Abschnitt: 6.2 memory_map.asm — Zentrales ZP-Register
; Assembler: ACME (acme --cpu 6510 -f cbm -o out.prg datei.asm)
; ============================================================
; memory_map.asm — Zentrales Zero-Page-Layout
; ALLE ZP-Adressen HIER reservieren — nie im Modul-Code

; ── System (nicht verwenden) ───────────────────────────────
; $00-$01: CPU-I/O-Port (für !source memory_map.asm)
; $02-$0F: Reserviert / von BASIC genutzt

; ── IRQ-System ─────────────────────────────────────────────
ZP_IRQ_COUNTER   = $10   ; Frame-Counter (1 Byte)
ZP_IRQ_FLAGS     = $11   ; IRQ-Event-Flags

; ── Spieler ────────────────────────────────────────────────
ZP_PLR_X         = $12   ; Spieler X-Position (16-Bit: $12/$13)
ZP_PLR_X_HI      = $13
ZP_PLR_Y         = $14
ZP_PLR_VY        = $15   ; Vertikale Geschwindigkeit (signed)
ZP_PLR_STATE     = $16   ; 0=Stehen, 1=Laufen, 2=Springen

; ── Grafik-Routinen ────────────────────────────────────────
ZP_GFX_PTR       = $18   ; Allg. 16-Bit-Zeiger für gfx.asm
ZP_GFX_PTR_HI    = $19

; ── REU-Transfer-Parameter ─────────────────────────────────
ZP_REU_C64_LO    = $20   ; Für reu_transfer Subroutine
ZP_REU_C64_HI    = $21
ZP_REU_ADDR_LO   = $22
ZP_REU_ADDR_MI   = $23
ZP_REU_ADDR_HI   = $24
ZP_REU_LEN_LO    = $25
ZP_REU_LEN_HI    = $26
ZP_REU_CMD       = $27

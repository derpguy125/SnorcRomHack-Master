;---------------------------------------------------------------------------
;Subroutine to make Sonic perform a spindash
;---------------------------------------------------------------------------
;||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_SpinDash: 
		tst.b f_spindash(a0) 
		bne.s loc_1AC8E 
		cmpi.b #id_duck,obAnim(a0) 
		bne.s locret_1AC8C 
		move.b (v_jpadpress2).w,d0 
		andi.b #$70,d0 
		beq.w locret_1AC8C 
		move.b #id_Spindash,obAnim(a0) ; changed from #9 
		move.w #$BE,d0 
		jsr (PlaySound_Special).l 
		addq.l #4,sp 
		move.b #1,f_spindash(a0) 
		move.w #0,$3A(a0) 
		cmpi.b #$C,$28(a0) 
		bcs.s loc_1AC84 
		move.b #2,($FFFFD11C).w

loc_1AC84: 
		bsr.w Sonic_LevelBound 
		bsr.w Sonic_AnglePos

locret_1AC8C: 
		rts

;---------------------------------------------------------------------------
loc_1AC8E: 
		move.b (v_jpadhold2).w,d0 
		btst #1,d0 
		bne.w loc_1AD30 
		move.b #$E,$16(a0) 
		move.b #7,$17(a0) 
		move.b #2,obAnim(a0) 
		addq.w #5,$C(a0) 
		move.b #0,f_spindash(a0) 
		moveq #0,d0 
		move.b $3A(a0),d0 
		add.w d0,d0 
		move.w Dash_Speeds(pc,d0.w),$14(a0) 
		move.w obInertia(a0),d0 
		subi.w #$800,d0 
		add.w d0,d0 
		andi.w #$1F00,d0 
		neg.w d0 
		addi.w #$2000,d0 
		move.w d0,($FFFFEED0).w 
		btst #0,$22(a0) 
		beq.s loc_1ACF4 
		neg.w $14(a0)

loc_1ACF4: 
		bset #2,$22(a0) 
		move.b #0,($FFFFD11C).w 
		move.w #$BC,d0 
		jsr (PlaySound_Special).l 
		bra.s loc_1AD78

;===========================================================================
Dash_Speeds: 
	dc.w $800 ; 0 
	dc.w $880 ; 1 
	dc.w $900 ; 2 
	dc.w $980 ; 3 
	dc.w $A00 ; 4 
	dc.w $A80 ; 5 
	dc.w $B00 ; 6 
	dc.w $B80 ; 7 
	dc.w $C00 ; 8

;===========================================================================
loc_1AD30: ; If still charging the dash... 
		tst.w $3A(a0) 
		beq.s loc_1AD48 
		move.w $3A(a0),d0 
		lsr.w #5,d0 
		sub.w d0,$3A(a0) 
		bcc.s loc_1AD48 
		move.w #0,$3A(a0)

loc_1AD48: 
		move.b (v_jpadpress2).w,d0 
		andi.b #$70,d0 ; 'p' 
		beq.w loc_1AD78 
		move.w #$1F00,$1C(a0) 
		move.w #$BE,d0 ; 'à' 
		jsr (PlaySound_Special).l 
		addi.w #$200,$3A(a0) 
		cmpi.w #$800,$3A(a0) 
		bcs.s loc_1AD78 
		move.w #$800,$3A(a0)

loc_1AD78:
		addq.l #4,sp 
		cmpi.w #$60,($FFFFEED8).w 
		beq.s loc_1AD8C 
		bcc.s loc_1AD88 
		addq.w #4,($FFFFEED8).w

loc_1AD88: 
		subq.w #2,($FFFFEED8).w

loc_1AD8C: 
		bsr.w Sonic_LevelBound 
		bsr.w Sonic_AnglePos 
		move.w #$60,(v_lookshift).w
rts

;End of subroutine Sonic_SpinDash
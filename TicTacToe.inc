include \masm32\include\windows.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

; local macro
szText MACRO Name, Text:VARARG
	LOCAL lbl
	jmp lbl
	Name db Text, 0
	lbl:
ENDM

m2m MACRO M1, M2
	push M2
	pop  M1
ENDM

return MACRO arg
	mov eax, arg
	ret
ENDM

; local prototypes
Frame3D PROTO:DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
PushButton PROTO:DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
BmpButton PROTO:DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
WinMain PROTO:DWORD, :DWORD, :DWORD, :DWORD
WndProc	PROTO:DWORD, :DWORD, :DWORD, :DWORD
DrawO PROTO:DWORD, :DWORD, :DWORD
DrawX PROTO:DWORD, :DWORD, :DWORD
TopXY PROTO:DWORD, :DWORD
Paint_Proc PROTO:DWORD, :DWORD
DrawBoardG PROTO:DWORD
ResetGrid PROTO
CheckWin PROTO
ChangePlayer PROTO

.const

.data
	xwins db "The winner is player X!", 10, 13, "Congratulation :)", 0
	owins db "The winner is player O!", 10, 13, "Congratulation :)", 0
	mainName db "Tic Tac Toe - PB", 0
	drawgame db "It`s Draw!", 0
	Wwd dd 370
	Wht dd 320
	CellSize dd 80
    CommandLine dd 0
    hWnd dd 0
    hInstance dd 0

.data?
	hBitmap dd ?
	x_pen dd ?
	o_pen dd ?
	o_brush dd ?
	playing dd ?
	playercolor db ?
	playerturn db ?
	textaddr dd ?
	displayed dd ?
	Grid db	9 dup(?)
	testwin dd ?
	bot dd ?
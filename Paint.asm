; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*
; ¤     Game Tic-tac-toe - created by PB     ¤
; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*

.386
.model flat, stdcall
option casemap:none

include TicTacToe.inc

.code

Paint_Proc proc hWin:DWORD, hDC:DWORD
    LOCAL btn_hi:DWORD
    LOCAL btn_lo:DWORD
    LOCAL Rct:RECT

    invoke GetSysColor, COLOR_BTNHIGHLIGHT
    mov btn_hi, eax

    invoke GetSysColor,	COLOR_BTNSHADOW
	mov btn_lo, eax	

    ; draw a frame around buttons
    invoke Frame3D,	hDC, btn_lo, btn_hi, 277, 175, 423, 270, 2

    ; draw window frame on the left
    invoke Frame3D,	hDC, btn_lo, btn_hi, 10, 10, 270, 270, 2

    ; draw edges around window workspace
    invoke GetClientRect, hWin, ADDR Rct
    add Rct.left, 0
    add Rct.top, 0
    sub Rct.right, 0
    sub Rct.bottom, 0

    invoke Frame3D,	hDC, btn_lo, btn_hi, Rct.left, Rct.top, Rct.right, Rct.bottom, 2
    add Rct.left, 5
    add Rct.top, 5
    sub Rct.right, 5
    sub Rct.bottom, 5

    invoke Frame3D,	hDC, btn_hi, btn_lo, Rct.left, Rct.top, Rct.right, Rct.bottom, 2

    invoke DrawBoardG, hDC

    ret

Paint_Proc endp

Frame3D proc hDC:DWORD, btn_hi:DWORD, btn_lo:DWORD, tx:DWORD, ty:DWORD, lx:DWORD, ly:DWORD, bdrWid:DWORD
    LOCAL hPen:DWORD
    LOCAL hPen2:DWORD
    LOCAL hpenOld:DWORD

    invoke CreatePen, 0, 1, btn_hi
    mov hPen, eax
  
    invoke SelectObject, hDC, hPen
    mov hpenOld, eax

    push tx
    push ty
    push lx
    push ly
    push bdrWid

    lp1:

		invoke MoveToEx, hDC, tx, ty, NULL
        invoke LineTo, hDC, lx, ty

        invoke MoveToEx, hDC, tx, ty, NULL
        invoke LineTo, hDC, tx, ly

        dec tx
        dec ty
        inc lx
        inc ly

        dec bdrWid
        cmp bdrWid, 0
        je lp1Out
        jmp lp1

    lp1Out:

    invoke CreatePen, 0, 1, btn_lo
    mov hPen2, eax
    invoke SelectObject, hDC, hPen2
    mov hPen, eax
    invoke DeleteObject, hPen

    pop bdrWid
    pop ly
    pop lx
    pop ty
    pop tx

    lp2:

        invoke MoveToEx, hDC, tx, ly, NULL
        invoke LineTo, hDC, lx, ly

        invoke MoveToEx, hDC, lx, ty, NULL
        inc ly
        invoke LineTo, hDC, lx, ly
        dec ly

        dec tx
        dec ty
        inc lx
        inc ly

        dec bdrWid
        cmp bdrWid, 0
        je lp2Out
        jmp lp2

    lp2Out:

    invoke SelectObject, hDC, hpenOld
    invoke DeleteObject, hPen2

    ret

Frame3D endp

DrawBoardG proc hDC:DWORD
	LOCAL hBlueBrush:DWORD
	LOCAL hBluePen:DWORD
	LOCAL htime:DWORD
    LOCAL x1:DWORD
	LOCAL x2:DWORD
	LOCAL y1:DWORD
	LOCAL y2:DWORD

	invoke CreatePen, PS_SOLID, 3, 00FF0000h
	mov	hBluePen, eax

	invoke SelectObject, hDC, hBluePen
	push eax

	mov x1, 20
	mov x2, 20
	mov y1, 20
	mov y2, 260

	mov htime, 4

	lp1:

        invoke MoveToEx, hDC, x1, x2, NULL
        invoke LineTo, hDC, y1, y2

        mov eax, x1
        add eax, 80
        mov x1, eax

        mov eax, y1
        add eax, 80
        mov y1, eax

        dec htime
        cmp htime, 0
        je lp1Out
        jmp lp1

    lp1Out:

	mov x1, 20
	mov x2, 20
	mov y1, 260
	mov y2, 20

    mov htime, 4

	lp2:

        invoke MoveToEx, hDC, x1, x2, NULL
        invoke LineTo, hDC, y1, y2

        mov eax, x2
        add eax, 80
        mov x2, eax

        mov eax, y2
        add eax, 80
        mov y2, eax

        dec htime
        cmp htime, 0
        je lp2Out
        jmp lp2

	lp2Out:

	invoke DeleteObject, hBlueBrush
	invoke DeleteObject, hBluePen

	pop	eax
	invoke SelectObject, hDC, eax
	pop	eax
	invoke SelectObject, hDC, eax
	ret

DrawBoardG endp

end
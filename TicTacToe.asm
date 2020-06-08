; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*
; ¤     Game Tic-tac-toe - created by PB     ¤
; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*

.386
.model flat, stdcall
option casemap:none

include TicTacToe.inc

.code

start:

	invoke ResetGrid
	mov playing, 1
    mov playercolor, 1
	mov bot, 1
	mov playerturn, 1
	szText defaultx, "X"
	mov eax, offset defaultx
	mov textaddr, eax
	mov displayed, 0

    invoke GetModuleHandle, NULL

    mov hInstance, eax
    mov CommandLine, eax

    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc hInst:DWORD, hPrevInst:DWORD, CmdLine:DWORD, CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL Wtx:DWORD
	LOCAL Wty:DWORD

	; fill in the WNDCLASSEX procedure with the required variables
	mov wc.cbSize, sizeof WNDCLASSEX
	mov wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
	mov wc.lpfnWndProc, offset WndProc
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, NULL
	m2m wc.hInstance, hInst ; macro

	invoke CreateSolidBrush, 00FFCECEh

	mov	wc.hbrBackground, eax
	mov wc.lpszMenuName, NULL
	mov wc.lpszClassName, offset szClassName

	invoke LoadIcon, hInst,1000; icon ID
	mov wc.hIcon, eax
	mov wc.hIconSm, eax
	invoke LoadCursor, hInst, 996; cursor ID
	mov wc.hCursor, eax
	invoke RegisterClassEx, ADDR wc

	; window center
	invoke GetSystemMetrics, SM_CXSCREEN
	invoke TopXY, Wwd, eax
	mov Wtx, eax
	invoke GetSystemMetrics, SM_CYSCREEN
	invoke TopXY, Wht,eax
	mov Wty, eax
	szText szClassName, "Szablon_Klasy"
	invoke CreateWindowEx, WS_EX_LEFT, ADDR szClassName, ADDR mainName, WS_OVERLAPPEDWINDOW,
	       				   Wtx, Wty, Wwd, Wht, NULL, NULL, hInst, NULL
	mov hWnd, eax
	invoke ShowWindow, hWnd, SW_SHOWNORMAL
	invoke UpdateWindow, hWnd

	; loop PostQuitMessage
	StartLoop:

		invoke GetMessage, ADDR msg, NULL, 0, 0
		cmp	eax, 0
		je ExitLoop
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
		jmp	StartLoop

	ExitLoop:

		return msg.wParam

WinMain endp

WndProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	LOCAL hGame:DWORD
	LOCAL hDC:DWORD
	LOCAL hMemDC:HDC
	LOCAL rect:RECT
	LOCAL Ps:PAINTSTRUCT
	LOCAL pt:POINT
	
	; reset/exit button control
	.if uMsg == WM_COMMAND

		.if wParam == 500
			invoke ResetGrid
			mov displayed, 0
			mov playing, 1
			invoke ChangePlayer
			invoke GetClientRect, hWnd, addr rect
			invoke InvalidateRect, hWnd, addr rect, TRUE
		.elseif wParam == 501
			invoke PostQuitMessage, NULL
		.elseif wParam == 502
			.if bot == 0
				mov bot, 1
				.if playercolor == 1
					mov playercolor, 2
				.else
					mov playercolor, 1
				.endif
			.else
				mov bot, 0
				.if playercolor == 1
					mov playercolor, 2
				.else
					mov playercolor, 1
				.endif
			.endif
		.endif

	; Left-click control
    .elseif uMsg == WM_LBUTTONDOWN

		; get coordinates
		mov eax, lParam
		and eax, 0ffffh
		mov pt.x, eax
		mov eax, lParam
		shr eax, 16
		mov pt.y, eax
		; separate fields of squares
        .if playerturn == 1
			mov cl, playercolor
            .if pt.x > 20 && pt.x < 260 && pt.y > 20 && pt.y < 260
				.if pt.y < 100
					.if pt.x < 100 && Grid[0] == 0
						mov Grid[0], cl
						mov playerturn, 0
					.elseif pt.x > 100 && pt.x < 180 && Grid[1] == 0
						mov Grid[1], cl
						mov playerturn, 0
					.elseif pt.x > 180 && Grid[2] == 0
						mov Grid[2], cl
						mov playerturn, 0
					.endif
				.elseif	pt.y > 100 && pt.y < 180
					.if pt.x < 100 && Grid[3] == 0
						mov Grid[3], cl
						mov playerturn, 0
					.elseif pt.x > 100 && pt.x < 180 && Grid[4] == 0
						mov Grid[4], cl
						mov playerturn, 0
					.elseif pt.x > 180 && Grid[5] == 0
						mov Grid[5], cl
						mov playerturn, 0
					.endif
				.elseif	pt.y > 180
					.if pt.x < 100 && Grid[6] == 0
						mov Grid[6], cl
						mov playerturn, 0
					.elseif pt.x > 100 && pt.x < 180 && Grid[7] == 0
						mov Grid[7], cl
						mov playerturn, 0
					.elseif pt.x > 180 && Grid[8] == 0
						mov Grid[8], cl
						mov playerturn, 0
					.endif
				.endif
			.endif
		.endif

		invoke GetClientRect, hWnd, addr rect
        invoke InvalidateRect, hWnd, addr rect, FALSE
		invoke CheckWin

		; post-game announcements
		.if al == 1 && displayed == 0
			invoke MessageBox, hWnd, addr xwins, addr mainName, MB_OK
			mov playing, 0
			mov displayed, 1
		.elseif al == 2 && displayed == 0
			invoke MessageBox, hWnd, addr owins, addr mainName, MB_OK
			mov playing, 0
			mov displayed, 1
		.elseif al == 5 && displayed == 0
			invoke MessageBox, hWnd, addr drawgame, addr mainName, MB_OK
			mov playing, 0
			mov displayed, 1
		.endif

		.if playing == 1
			.if playerturn == 0
        		invoke ChangePlayer
            .endif
        .endif

	; application window size control
	.elseif uMsg == WM_GETMINMAXINFO

		mov edx, lParam
        mov eax, Wwd
		add	eax, CellSize
		mov [edx].MINMAXINFO.ptMinTrackSize.x, eax
		mov [edx].MINMAXINFO.ptMaxTrackSize.x, eax
        mov eax, Wht
        mov [edx].MINMAXINFO.ptMinTrackSize.y, eax
		mov [edx].MINMAXINFO.ptMaxTrackSize.y,eax
        xor eax, eax

	; draw control in application window
	.elseif uMsg == WM_PAINT

		invoke BeginPaint, hWin, ADDR Ps
		mov	hDC, eax

		invoke GetClientRect, hWin, ADDR rect

		mov eax, 00FFCECEh
		invoke SetBkColor, hDC, eax
		mov eax, 00FF0000h
		invoke SetTextColor, hDC, eax
		mov rect.left, 303
		mov rect.top, 15
		szText Author, "Created by PB"
		invoke DrawText, hDC, addr Author, -1, addr rect, NULL

		.if playercolor == 2
			mov eax, 000000FFh
			invoke SetTextColor, hDC, eax
			invoke SelectObject, hDC, o_pen
			invoke MoveToEx, hDC, 310, 160, NULL
			invoke LineTo,			hDC,390,160
		.elseif playercolor == 1
			mov eax, 00000000h
			invoke SetTextColor, hDC,eax
			invoke SelectObject, hDC,x_pen
			invoke MoveToEx, hDC, 310, 160, NULL
			invoke LineTo, hDC, 390, 160
		.endif

		mov rect.left, 322
		mov rect.top, 140
		invoke DrawText, hDC,textaddr, -1, addr rect, NULL
		add rect.left, 10
		szText TurnPlayer, "'s turn!"
		invoke DrawText, hDC, addr TurnPlayer, -1, addr rect, NULL

		; draw O or X
		.if Grid[0] == 1
	        invoke DrawX, hDC, 40, 40
	    .elseif Grid[0] == 2
	        invoke DrawO, hDC, 40, 40
	    .endif

	    .if Grid[1] == 1 
	        invoke DrawX, hDC,120,40
	    .elseif Grid[1] == 2
	        invoke DrawO, hDC, 120, 40
	    .endif

	    .if Grid[2] == 1 
	        invoke DrawX, hDC, 200, 40
	    .elseif Grid[2] == 2
	        invoke DrawO, hDC, 200, 40
	    .endif

		;-----

	    .if Grid[3] == 1 
	        invoke DrawX, hDC, 40, 120
	    .elseif Grid[3] == 2
	        invoke DrawO, hDC, 40, 120
	    .endif

	    .if Grid[4] == 1 
	        invoke DrawX, hDC, 120, 120
	    .elseif Grid[4] == 2
	        invoke DrawO, hDC, 120, 120
	    .endif

	    .if Grid[5] == 1 
	        invoke DrawX, hDC, 200, 120
	    .elseif Grid[5] == 2
	        invoke DrawO, hDC, 200, 120
	    .endif

		;-----

	    .if Grid[6] == 1 
	        invoke DrawX, hDC,40,200
	    .elseif Grid[6] == 2
	        invoke DrawO, hDC, 40, 200
	    .endif

	    .if Grid[7] == 1 
	        invoke DrawX, hDC, 120, 200
	    .elseif Grid[7] == 2
	        invoke DrawO, hDC, 120, 200
	    .endif

	    .if Grid[8] == 1 
	        invoke DrawX, hDC, 200, 200
	    .elseif Grid[8] == 2
	        invoke DrawO, hDC, 200, 200
	    .endif

		;-----

		invoke Paint_Proc, hWin, hDC

		invoke CreateCompatibleDC, hDC
		mov hMemDC, eax
		invoke SelectObject, hMemDC, hBitmap
		invoke BitBlt, hDC, 300, 35, 100, 100, hMemDC, 0, 0, SRCCOPY
		invoke DeleteDC, hMemDC
		invoke EndPaint, hWin, ADDR Ps
		return 0

	; control creation of brushes, pens and buttons
	.elseif uMsg == WM_CREATE

        invoke CreatePen, PS_SOLID, 3, 00000000h
        mov x_pen, eax
        invoke CreatePen, PS_SOLID, 3, 000000FFh
        mov o_pen, eax
		invoke CreateSolidBrush, 00FFCECEh
		mov	o_brush, eax

		invoke LoadBitmap, hInstance, 997; logo ID
		mov	hBitmap, eax

		jmp @F
			Butn1 db "Reset", 0
			Butn2 db "Exit", 0
			Butn3 db "Game mode", 0

		@@:
			invoke PushButton, ADDR Butn1, hWin, 300, 180, 100, 25, 500
			invoke PushButton, ADDR Butn2, hWin, 300, 240, 100, 25, 501
			invoke PushButton, ADDR Butn3, hWin, 300, 210, 100, 25, 502

	; window close control
	.elseif uMsg == WM_CLOSE

		szText szDisplayInfo, "Are you sure you want to quit?"
		invoke MessageBox, 0, addr szDisplayInfo, addr mainName, MB_YESNO or MB_ICONINFORMATION
		.if ax == IDYES
			invoke PostQuitMessage, NULL
		.endif

	; destruction control
	.elseif uMsg == WM_DESTROY

		invoke PostQuitMessage, NULL

	.else

		invoke DefWindowProc, hWin, uMsg, wParam, lParam
		ret

	.endif

	xor eax, eax
	ret

WndProc endp

PushButton proc lpText:DWORD, hParent:DWORD, a:DWORD, b:DWORD, wd:DWORD, ht:DWORD, ID:DWORD

	szText btnClass, "BUTTON"
    invoke CreateWindowEx, 0, ADDR btnClass, lpText, WS_CHILD or WS_VISIBLE,
    					   a, b, wd, ht, hParent, ID, hInstance, NULL
    ret

PushButton endp

BmpButton proc hParent:DWORD, a:DWORD, b:DWORD, wd:DWORD, ht:DWORD, ID:DWORD

    szText bmpBtnCl, "BUTTON"
    szText blnk2, 0

    invoke CreateWindowEx, 0, ADDR bmpBtnCl, ADDR blnk2, WS_CHILD or WS_VISIBLE or BS_BITMAP,
    					   a, b, wd, ht, hParent, ID, hInstance, NULL
    ret

BmpButton endp

CheckWin proc

	mov ah, Grid[1]
	mov al, Grid[2]
	mov bh, Grid[3]
	mov bl, Grid[4]
	mov ch, Grid[5]
	mov cl, Grid[6]
	mov dh, Grid[7]
	mov dl, Grid[8]

	.if Grid[0] == 1 || Grid[0] == 2
		.if Grid[0] == ah && Grid[0] == al
			mov al, ah
			ret
		.elseif Grid[0] == bh && Grid[0] == cl
			mov al, bh
			ret
		.elseif Grid[0] == bl && Grid[0] == dl
			mov al, bl
			ret
		.endif
	.endif

	.if dl == 1 || dl == 2
		.if dl == dh && dl == cl
			mov al, dh
			ret
		.elseif dl == ch && dl == al
			mov al, ch
			ret
		.endif
	.endif

	.if bl == 1 || bl == 2
		.if bl == bh && bl == ch
			mov al, bh
			ret
		.elseif bl == ah && bl == dh
			mov al, ah
			ret
		.elseif bl == cl && bl == al
			mov al, cl
			ret
		.endif
	.endif

	.if Grid[0] != 0 && Grid[1] != 0 && Grid[2] != 0 && Grid[3] != 0 && Grid[4] != 0\
					 && Grid[5] != 0 && Grid[6] != 0 && Grid[7] != 0 && Grid[8] != 0
		return 5
	.endif

	return 0

CheckWin endp

DrawO proc hDC:DWORD, xx:DWORD, yy:DWORD

	invoke SelectObject, hDC, o_brush
	invoke SelectObject, hDC, o_pen
	mov eax, xx
	mov ecx, yy
	add eax, 40
	add ecx, 40
	invoke Ellipse, hDC, xx, yy, eax, ecx
	ret

DrawO endp

DrawX proc hDC:DWORD, xx:DWORD, yy:DWORD

	invoke SelectObject, hDC, x_pen
	invoke MoveToEx, hDC, xx, yy, NULL
	mov eax, xx
	mov ecx, yy
	add eax, 40
	add ecx, 40
	invoke LineTo, hDC, eax, ecx
	mov eax, yy
	add eax, 40
	invoke MoveToEx, hDC, xx, eax, NULL
	mov eax, xx
	add eax, 40
	invoke LineTo, hDC, eax, yy
	ret

DrawX endp

ChangePlayer proc

	.if playing == 1
		.if bot == 0
			szText xtrn, "X"
			szText otrn, "O"
			.if playercolor == 1
				mov playercolor, 2
				mov eax, offset otrn
				mov textaddr, eax
			.else
				mov playercolor, 1
				mov eax, offset xtrn
				mov textaddr, eax
			.endif
			mov playerturn, 1

		; loop for the game with BOT
		.elseif bot == 1
			getanother:
				invoke GetTickCount
				and eax, 15
				cmp eax, 8
				ja getanother
			.if Grid[eax] == 0
				.if playercolor == 1
					mov Grid[eax], 2
					mov eax, offset xtrn
					mov textaddr, eax
					mov playercolor, 1
				.else
					mov Grid[eax], 1
					mov eax, offset otrn
					mov textaddr, eax
					mov playercolor, 2
				.endif
			.else
				jmp getanother
			.endif
			mov playerturn, 1
		.endif
	.endif
	ret

ChangePlayer endp

ResetGrid proc

	mov Grid[0], 0
	mov Grid[1], 0
	mov Grid[2], 0
	mov Grid[3], 0
	mov Grid[4], 0
	mov Grid[5], 0
	mov Grid[6], 0
	mov Grid[7], 0
	mov Grid[8], 0
	ret

ResetGrid endp

end start
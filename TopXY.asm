; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*
; ¤     Game Tic-tac-toe - created by PB     ¤
; ¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*¤*

.386
.model flat, stdcall
option casemap:none

.code

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    mov eax, sDim
    ret

TopXY endp

end
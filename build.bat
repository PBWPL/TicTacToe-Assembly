@echo off

: set environmental variables
set BIN=\MASM32\BIN\
set INCLUDE=\MASM32\INCLUDE\
set LIB=\MASM32\LIB\

: generate resources (BMP, CUR, ICO)
%BIN%rc.exe /v rsrc.rc

: create a response file from modules
echo TicTacToe.asm > TicTacToe.rsp
echo Paint.asm >> TicTacToe.rsp
echo TopXY.asm >> TicTacToe.rsp

: mount source file
%BIN%ml.exe /c /coff @TicTacToe.rsp

: create a link response file
echo TicTacToe.obj > link.rsp
echo Paint.obj >> link.rsp
echo TopXY.obj >> link.rsp

: combine object modules and set the path to library
%BIN%Link.exe /SUBSYSTEM:WINDOWS /LIBPATH:%LIB% @link.rsp rsrc.res

del *.rsp *.obj rsrc.RES
dir

pause
###############################################################################
# Makefile for project 
###############################################################################

## General options
PROJECT = 
MCU = AT89C52
COMPILER = "Keil for 8051"
TARGET = Release
SHELL = C:\Windows\system32\cmd.exe

## Tools general options
CCFLAGS=ROM(SMALL)

## Processing Tools
CC=C51.exe
LD=BL51.exe
ASM=A51.exe
#  D:/Epan/Study/微处理器原理与应用/单片机实验/硬件实验1IO开关量输入实验/AT89C52_2/Release/Release.hex: TOOL=LD
#  Post: "..\..\..\..\..\..\..\Keil4\C51\BIN\OH51.exe" ".\Release.OMF"
#     D:/Epan/Study/微处理器原理与应用/单片机实验/硬件实验1IO开关量输入实验/AT89C52_2/Release/main.OBJ: TOOL=CC
#        D:/Epan/Study/微处理器原理与应用/单片机实验/硬件实验1IO开关量输入实验/AT89C52_2/main.c

# Build tree:
all:	Release

Release:	Release.hex
	cp "Release.hex" "D:/Epan/Study/微处理器原理与应用/单片机实验/硬件实验1IO开关量输入实验/AT89C52_2.hex"

Release.hex:	main.OBJ 
	"..\..\..\..\..\..\..\Program Files (x86)\Labcenter Electronics\Proteus 8 Professional\Tools\MAKE\RunTool.exe" --good-exits=0,1 --executable=$(LD) "main.OBJ" TO ".\Release.OMF" $(LDFLAGS) 
	"..\..\..\..\..\..\..\Keil4\C51\BIN\OH51.exe" ".\Release.OMF"

main.OBJ:	../main.c 
	"..\..\..\..\..\..\..\Program Files (x86)\Labcenter Electronics\Proteus 8 Professional\Tools\MAKE\RunTool.exe" --good-exits=0,1 --executable=$(CC) "..\main.c" $(CCFLAGS)  OBJECT("main.OBJ")

# tidy - delete all temporary files which are not involved in the target generation
tidy:
	rm -rf Release.M51
	rm -rf ./main.lst
	rm -rf ./main.I

# cleanup - delete all generated files
clean:	tidy
	rm -rf Release.hex
	rm -rf main.OBJ

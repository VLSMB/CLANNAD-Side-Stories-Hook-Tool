    .386
    .model flat,stdcall
    option casemap:none
include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include shell32.inc
includelib shell32.lib

    .data?
hInstance dd ?
OpenFileBuffer db 260 dup(?)  ; 用作文件临时缓冲区
FileResInfo dd ?
FilePointer dd ?
FileSize dd ?
hFile dd ?
WriteSize dd ?
ShotCutBuffer db 300 dup (?)
ShotCutSize dd ?
    .data
CurrentDir db 256 dup(0)
DesktopDir db 260 dup (0)
    .const
MessageTitle db "【超巨星汉化组】CLANNAD被光守望着的坡道 汉化版",0
MessageQuestion db "是否要安装汉化补丁？",0
MessageShotCut db "是否要创建桌面快捷方式？",0
MessageWarn db "请仔细阅读上方内容，并勾选“我已同意”！",0
MessageError db "游戏本体不完整！请将汉化补丁运行在游戏本体所在文件夹！",0
MessageNoAccess db "释放文件失败！请试试“以管理员身份运行”。",0
MessageDone db "汉化补丁安装完成！请双击“RealliveCHS”运行，或者双击桌面上的快捷方式运行。",0AH,0DH,"原版游戏依然能正常打开。",0
; 用x64dbg生成的
Declaration DD 0AFBBBABAh, 0A1B6B9B2h, 0C3D3B9CAh, 0A8B7BDB7h, 0A0DBAA3h, 0BABABEB1h, 0B9B2AFBBh, 0CACAA1B6h, 0DAD3C3D3h, 61657453h, 0B5E6B06Dh, 43B6A1C4h, 4E4E414Ch, 53204441h, 20656469h, 726F7453h, 0A1736569h, 0BDACA3B7h, 0B2BEB1ABh, 0B3A1B6B9h
DD 0B7F2D0CCh, 0DC3D6C5h, 0D3DAD40Ah, 0B8B7CFCEh, 0C2BFC4F9h, 0A3C2CFBCh, 0D0CBD4ACh, 0BFB4BCD0h, 0B1A3A1C9h, 0BACEB4BEh, 0CEAFBBBAh, 0BBBEB1C4h, 0D3DAD3F9h, 0B0AFBBA2h, 0B1C4CEE6h, 0BFACA3BEh, 0B4DCC4C9h, 0B2DAD4E6h, 0DD6B7BFh, 0C8EBD30Ah
DD 0B0C4CED5h, 0C3C4B5E6h, 0B2F6CAE8h, 0CDE0CFBBh, 0BBACA3ACh, 0C1EBC7B9h, 0A1E2BDC2h, 0D0A0DA3h, 0B1D8CC0Ah, 0D0F9C3F0h, 0DBAA3BBh, 0C1AACE0Ah, 0C9F5BCCBh, 0D2ADB7D9h, 0BBA2D3EBh, 0CBE6B0AFh, 0C0F8B4F9h, 0B7C4B5B4h, 0C7EBD2ADh, 0CCCACEBBh
DD 0B1ACA3E2h, 0BACEB4BEh, 0B2AFBBBAh, 0CFD6B7BFh, 0B2DABDB8h, 0C1BCBFCEh, 79654BCBh, 0C4B54346h, 4C430A0Dh, 414E4E41h, 0CBA1D044h, 0BBBABAB5h, 0B1C4CEAFh, 0B5ACA3BEh, 0CEF2D2ABh, 0B4EAC4AAh, 0D4C3BEFAh, 0CEACA3B6h, 0BADCC4B4h, 0D7ADD4CDh
DD 0C8DFD5F7h, 0C1C3B5A1h, 0A3B5CFAAh, 0D7BEB1ACh, 0B7AECAE9h, 0B80A0DD6h, 0B8BBD0D0h, 0C7BBCEF7h, 0C3B2B1B0h, 0D0C4B5C7h, 0B8E0BFC1h, 0A1F6B3B6h, 680A0DA3h, 73707474h, 772F2F3Ah, 6B2E7777h, 63667965h, 74656E2Eh, 7362622Fh, 6F68732Fh
DD 706F7477h, 312D6369h, 30353336h, 7073612Eh, 0B10A0D78h, 0BACEB4BEh, 0B2AFBBBAh, 0BBD6B7BFh, 0D3C9B2B9h, 42CBC1C3h, 5055BED5h, 797AF7D6h, 2D2D2D64h, 0ADB7C4B5h, 0D3CAEBD2h, 0BAA3B5C6h, 74680A0Dh, 3A737074h, 70732F2Fh, 2E656361h
DD 696C6962h, 696C6962h, 6D6F632Eh, 3939342Fh, 34323231h, 0A0D3834h, 0BABA0A0Dh, 0E9D7AFBBh, 0F7C3F9C9h, 0A0DBAA3h, 0B9B2BEB1h, 0C9D3A1B6h, 0DEBEACB3h, 0BABAC7D0h, 0E9D7AFBBh, 0BCB2A2B7h, 0F6BDACA3h, 0C3D3A9B9h, 0A7D1DAD3h, 0BBBDB0CFh
DD 0A3A1F7C1h, 0BABABEB1h, 0E9D7AFBBh, 0F6BEE1BCh, 0D4B6B4B7h, 0CEBACEC8h, 0A0DE9D7h, 0A2A1AFD6h, 0CEBACEC8h, 0CBC8F6B8h, 0CEC8D4D2h, 0FBC3CEBAh, 0ABBDE5D2h, 0BABABEB1h, 0B9B2AFBBh, 0C3D3A1B6h, 0CEC8DAD3h, 0CCC9CEBAh, 0C3D3B5D2h, 0ACA3BECDh
DD 0B9D6FBBDh, 0CEBACEC8h, 0D4D2CBC8h, 0A0DCEC8h, 0CED0CEBAh, 0ABB4BDCAh, 0B2B0A5B2h, 0FDB9B0D7h, 0BABABEB1h, 0B9B2AFBBh, 0C4B5A1B6h, 0FBD5EACDh, 0B7CFCED3h, 0B4D4CAD7h, 0BEB1A3A1h, 0AFBBBABAh, 0BBB2E9D7h, 0A3B5D0B3h, 0CEBACEC8h, 0A8B7C7B7h
DD 0A0DCCC9h, 0BEB1C3D3h, 0AFBBBABAh, 0A1B6B9B2h, 0E2CCCACEh, 0F8B4F8B6h, 0C4B5B4C0h, 0B3B7E9C2h, 0BEB1A3A1h, 0AFBBBABAh, 0E1CCE9D7h, 0E6CDABB3h, 0C7C3D2BCh, 0BAB9C8CFh, 0FDD5F2C2h, 0CED3E6B0h, 0ACA3B7CFh, 0A0DD9D4h, 0C3D3B9CAh, 0BABABEB1h
DD 0B9B2AFBBh, 0A3A1A1B6h, 0A0D0A0Dh, 0AFBBBABAh, 0FBC3E9D7h, 0BAA3A5B5h, 0CCB30A0Dh, 0BAA3F2D0h, 4D534C56h, 0B70A0D42h, 0A3EBD2ADh, 0C9B9B6BAh, 0D7C5CDB3h, 323420D3h, 534C5620h, 0C020424Dh, 36B2C0B2h, 35373736h, 0D4B82035h, 0C7D6E9C6h
DD 7A20FAB4h, 2D2D6479h, 0D00A0D2Dh, 0A3BCCDDEh, 0BEC5BCBAh, 0B3C7D0B2h, 0CFA8A3BEh, 0B0CEC4ABh, 0C1DBB9E8h, 0A3B4BDE5h, 0D5CB20A9h, 0EAC2C5C6h, 0C2B0F6C0h, 0E2B20A0Dh, 0BAA3D4CAh, 4D534C56h, 0B9B62042h, 0C5CDB3C9h, 0A0DD3D7h, 0AABF0A0Dh
DD 0F9C9B4D4h, 0BAA3F7C3h, 0BEB10A0Dh, 0BABACEB4h, 0CCB3AFBBh, 0F9CBF2D0h, 0BDB5C3D3h, 0B4D4C4B5h, 0ACA3EBC2h, 0A9B9C9BFh, 0BBCEF7B8h, 0AFBBBABAh, 0C3BAAEB0h, 0A7D1DFD5h, 0BBBDB0CFh, 0ACA3F7C1h, 0B4CEABB5h, 0BEB1ADBEh, 0EDD0E9D7h, 0C9BF0A0Dh
DD 0BBB2ACA3h, 0DED0C9BFh, 0B4D4C4B8h, 0A5C8EBC2h, 0EBD2E0B1h, 0CFD1BBA3h, 0FBBDF7C0h, 0CEC8B9D6h, 0CBC8CEBAh, 0BEB1ABBDh, 0AFBBBABAh, 0A1B6B9B2h, 0EBC2B4D4h, 0C4B8DED0h, 0F1B6AACEh, 0CCB3E2D2h, 0F2D00A0Dh, 0B0BCD4D2h, 0CEBACEC8h, 0B5D2CCC9h
DD 0BECDC3D3h, 0A0DA3A1h, 70747468h, 2F2F3A73h, 68746967h, 632E6275h, 562F6D6Fh, 424D534Ch, 414C432Fh, 44414E4Eh, 6469532Dh, 74532D65h, 6569726Fh, 6F482D73h, 542D6B6Fh
DB "ool",0
ShotCutText db "[InternetShortcut]",0AH,0DH
            db "URL=%sRealliveCHS.exe",0AH,0DH
            db "IconFile=%sgame.ico",0AH,0DH
            db "IconIndex=0 ",0AH,0DH,0
ShotCutName db "%s\CLANNAD被光守望着的坡道中文版.url",0
NULLstring db 0
; 资源文件
PictureID dd 2000
PictureNum db 106
ProgramID dd 3000
ProgramNum db 2
; 根据游戏特征文件判断目录是否正确
FileExistNum db 2
FileExist01 db "Seen.txt",0
FileExist02 db "Gameexe.ini",0
FileExistPointer dd offset FileExist01,offset FileExist02
DirExist db "G00",0

Program01 db "CJXHook.dll",0
Program02 db "RealliveCHS.exe",0
ProgramPointer dd offset Program01,offset Program02

PICTURE01 db "g00\CHM_01.gch",0
PICTURE02 db "g00\CHM_02.gch",0
PICTURE03 db "g00\CHM_03.gch",0
PICTURE04 db "g00\CHM_04.gch",0
PICTURE05 db "g00\CHM_05.gch",0
PICTURE06 db "g00\Cmenu_01.gch",0
PICTURE07 db "g00\Cmenu_02.gch",0
PICTURE08 db "g00\Cmenu_03.gch",0
PICTURE09 db "g00\Cmenu_04.gch",0
PICTURE10 db "g00\Cmenu_05.gch",0
PICTURE11 db "g00\Cmenu_06.gch",0
PICTURE12 db "g00\Cmenu_07.gch",0
PICTURE13 db "g00\Cmenu_08.gch",0
PICTURE14 db "g00\Cmenu_09.gch",0
PICTURE15 db "g00\Cmenu_10.gch",0
PICTURE16 db "g00\Cmenu_11.gch",0
PICTURE17 db "g00\Cmenu_12.gch",0
PICTURE18 db "g00\Cmenu_13.gch",0
PICTURE19 db "g00\Cmenu_14.gch",0
PICTURE20 db "g00\Cmenu_15.gch",0
PICTURE21 db "g00\Cmenu_16.gch",0
PICTURE22 db "g00\Ctitle_01.gch",0
PICTURE23 db "g00\Ctitle_02.gch",0
PICTURE24 db "g00\Ctitle_03.gch",0
PICTURE25 db "g00\Ctitle_04.gch",0
PICTURE26 db "g00\Ctitle_05.gch",0
PICTURE27 db "g00\Ctitle_06.gch",0
PICTURE28 db "g00\Ctitle_07.gch",0
PICTURE29 db "g00\Ctitle_08.gch",0
PICTURE30 db "g00\Ctitle_09.gch",0
PICTURE31 db "g00\Ctitle_10.gch",0
PICTURE32 db "g00\Ctitle_11.gch",0
PICTURE33 db "g00\Ctitle_12.gch",0
PICTURE34 db "g00\Ctitle_13.gch",0
PICTURE35 db "g00\Ctitle_14.gch",0
PICTURE36 db "g00\Ctitle_15.gch",0
PICTURE37 db "g00\Ctitle_16.gch",0
PICTURE38 db "g00\MENU_01.gch",0
PICTURE39 db "g00\MENU_02.gch",0
PICTURE40 db "g00\MENU_03.gch",0
PICTURE41 db "g00\MENU_04.gch",0
PICTURE42 db "g00\MENU_05.gch",0
PICTURE43 db "g00\MENU_06.gch",0
PICTURE44 db "g00\MENU_07.gch",0
PICTURE45 db "g00\MENU_08.gch",0
PICTURE46 db "g00\MENU_09.gch",0
PICTURE47 db "g00\MENU_10.gch",0
PICTURE48 db "g00\MENU_11.gch",0
PICTURE49 db "g00\MENU_12.gch",0
PICTURE50 db "g00\MENU_13.gch",0
PICTURE51 db "g00\MENU_14.gch",0
PICTURE52 db "g00\MENU_15.gch",0
PICTURE53 db "g00\MENU_16.gch",0
PICTURE54 db "g00\STT_WAR00.gch",0
PICTURE55 db "g00\_SYS_base.gch",0
PICTURE56 db "g00\_SYS_BTN01.gch",0
PICTURE57 db "g00\_SYS_BTN02.gch",0
PICTURE58 db "g00\_SYS_BTN03.gch",0
PICTURE59 db "g00\_sys_ch_base.gch",0
PICTURE60 db "g00\_SYS_EXIT.gch",0
PICTURE61 db "g00\_sys_font.gch",0
PICTURE62 db "g00\_sys_init.gch",0
PICTURE63 db "g00\_sys_r_01.gch",0
PICTURE64 db "g00\_sys_r_02.gch",0
PICTURE65 db "g00\_sys_r_03.gch",0
PICTURE66 db "g00\_sys_r_04.gch",0
PICTURE67 db "g00\_sys_r_05.gch",0
PICTURE68 db "g00\CPM_00.gch",0
PICTURE69 db "g00\CPM_01.gch",0
PICTURE70 db "g00\CPM_02.gch",0
PICTURE71 db "g00\CPM_03.gch",0
PICTURE72 db "g00\CPM_04.gch",0
PICTURE73 db "g00\CPM_05.gch",0
PICTURE74 db "g00\CPM_06.gch",0
PICTURE75 db "g00\CPM_07.gch",0
PICTURE76 db "g00\CPM_08.gch",0
PICTURE77 db "g00\CPM_09.gch",0
PICTURE78 db "g00\CPM_10.gch",0
PICTURE79 db "g00\CPM_11.gch",0
PICTURE80 db "g00\CPM_12.gch",0
PICTURE81 db "g00\CPM_13.gch",0
PICTURE82 db "g00\CPM_14.gch",0
PICTURE83 db "g00\CPM_15.gch",0
PICTURE84 db "g00\CPM_16.gch",0
PICTURE85 db "g00\CREDIT_01.gch",0
PICTURE86 db "g00\CREDIT_02.gch",0
PICTURE87 db "g00\CREDIT_03.gch",0
PICTURE88 db "g00\CREDIT_04.gch",0
PICTURE89 db "g00\CREDIT_05.gch",0
PICTURE90 db "g00\CREDIT_06.gch",0
PICTURE91 db "g00\CREDIT_07.gch",0
PICTURE92 db "g00\CREDIT_08.gch",0
PICTURE93 db "g00\CREDIT_09.gch",0
PICTURE94 db "g00\CREDIT_10.gch",0
PICTURE95 db "g00\CREDIT_11.gch",0
PICTURE96 db "g00\CREDIT_12.gch",0
PICTURE97 db "g00\CREDIT_13.gch",0
PICTURE98 db "g00\CREDIT_14.gch",0
PICTURE99 db "g00\CREDIT_15.gch",0
PICTURE100 db "g00\CREDIT_16.gch",0
PICTURE101 db "g00\_sys_ch_y.gch",0
PICTURE102 db "g00\_sys_ch_n.gch",0
PICTURE103 db "g00\taremaku1.gch",0
PICTURE104 db "g00\taremaku2.gch",0
PICTURE105 db "g00\taremaku3.gch",0
PICTURE106 db "g00\taremaku4.gch",0
PicturePointer dd offset PICTURE01,offset PICTURE02,offset PICTURE03,offset PICTURE04,offset PICTURE05,offset PICTURE06,offset PICTURE07,offset PICTURE08,offset PICTURE09,offset PICTURE10
    dd offset PICTURE11,offset PICTURE12,offset PICTURE13,offset PICTURE14,offset PICTURE15,offset PICTURE16,offset PICTURE17,offset PICTURE18,offset PICTURE19,offset PICTURE20
    dd offset PICTURE21,offset PICTURE22,offset PICTURE23,offset PICTURE24,offset PICTURE25,offset PICTURE26,offset PICTURE27,offset PICTURE28,offset PICTURE29,offset PICTURE30
    dd offset PICTURE31,offset PICTURE32,offset PICTURE33,offset PICTURE34,offset PICTURE35,offset PICTURE36,offset PICTURE37,offset PICTURE38,offset PICTURE39,offset PICTURE40
    dd offset PICTURE41,offset PICTURE42,offset PICTURE43,offset PICTURE44,offset PICTURE45,offset PICTURE46,offset PICTURE47,offset PICTURE48,offset PICTURE49,offset PICTURE50
    dd offset PICTURE51,offset PICTURE52,offset PICTURE53,offset PICTURE54,offset PICTURE55,offset PICTURE56,offset PICTURE57,offset PICTURE58,offset PICTURE59,offset PICTURE60
    dd offset PICTURE61,offset PICTURE62,offset PICTURE63,offset PICTURE64,offset PICTURE65,offset PICTURE66,offset PICTURE67
    dd offset PICTURE68,offset PICTURE69,offset PICTURE70,offset PICTURE71,offset PICTURE72,offset PICTURE73,offset PICTURE74,offset PICTURE75,offset PICTURE76,offset PICTURE77,offset PICTURE78,offset PICTURE79,offset PICTURE80,offset PICTURE81,offset PICTURE82,offset PICTURE83,offset PICTURE84
    dd offset PICTURE85,offset PICTURE86,offset PICTURE87,offset PICTURE88,offset PICTURE89,offset PICTURE90,offset PICTURE91,offset PICTURE92,offset PICTURE93,offset PICTURE94,offset PICTURE95,offset PICTURE96,offset PICTURE97,offset PICTURE98,offset PICTURE99,offset PICTURE100
    dd offset PICTURE101,offset PICTURE102,offset PICTURE103,offset PICTURE104,offset PICTURE105,offset PICTURE106
IDD_DIALOG EQU 101
IDC_EDIT EQU 1003
IDC_BUTTONINSTALL EQU 1001
IDC_CHECKBOX EQU 1004
IDC_BUTTONCANCEL EQU 1002
IDC_ICONMAIN EQU 102

    .code
CallBackFunction proc uses ebx edi esi hWnd,wMsg,wParam,lParam
    mov eax,wMsg
    .if eax == WM_CLOSE
        invoke EndDialog,hWnd,NULL
    .elseif eax == WM_INITDIALOG
        invoke LoadIcon,hInstance,IDC_ICONMAIN
        invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
        invoke SetDlgItemText,hWnd,IDC_EDIT,offset Declaration
        invoke SendDlgItemMessage,hWnd,IDC_EDIT,EM_SETREADONLY,TRUE,NULL
    .elseif eax == WM_COMMAND
        mov eax,wParam
        .if ax == IDC_BUTTONCANCEL
            invoke EndDialog,hWnd,NULL
        .elseif ax == IDC_BUTTONINSTALL
            push hWnd
            call InstallPatch
        .endif
    .else
        mov eax,FALSE
        ret
    .endif
    mov eax,TRUE
    ret
CallBackFunction endp

CreateDesktopCut proc
    push dword ptr [offset NULLstring]
    push dword ptr [offset CurrentDir]
    push offset OpenFileBuffer
    call wsprintf
    add esp,12
    push dword ptr [offset OpenFileBuffer]
    push dword ptr [offset OpenFileBuffer]
    push dword ptr [offset ShotCutText]
    push offset ShotCutBuffer
    call wsprintf
    add esp,16
    mov ebx,offset ShotCutBuffer
    mov esi,-1
CDCs:
    inc esi
    mov al,[ebx+esi]
    cmp al,0
    jne CDCs
    mov eax,esi
    mov ShotCutSize,eax
    ; SHGetSpecialFolderPathA(NULL, (LPSTR)buffer, 0, false)
    invoke SHGetSpecialFolderPathA,NULL,offset DesktopDir,0,FALSE
    push dword ptr [offset DesktopDir]
    push dword ptr [offset ShotCutName]
    push offset OpenFileBuffer
    call wsprintf
    add esp,12
    invoke CreateFileA,offset OpenFileBuffer,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
    mov hFile,eax
    .if eax == -1
        ret
    .endif
    invoke WriteFile,hFile,offset ShotCutBuffer,ShotCutSize,offset WriteSize,NULL
    invoke FlushFileBuffers,hFile
    invoke CloseHandle,hFile
    ret
CreateDesktopCut endp

IsCorrectDir proc
    ; 判断汉化补丁是否运行在正确的位置上
    mov ebx,offset FileExistPointer
    mov cl,FileExistNum
    movzx ecx,cl
    mov esi,0
s1: pushad
    push dword ptr [ebx+esi]
    push dword ptr [offset CurrentDir]
    push offset OpenFileBuffer
    call wsprintf
    add esp,12
    invoke CreateFileA,offset OpenFileBuffer,GENERIC_READ,0,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
    .if eax == INVALID_HANDLE_VALUE
        popad
        mov eax,FALSE
        ret
    .endif
    popad
    add esi,4
    loop s1
    invoke CreateDirectory,offset DirExist,NULL
    .if eax != 0
        invoke RemoveDirectoryA,offset DirExist
        mov eax,FALSE
        ret
    .else
        mov eax,TRUE
        ret
    .endif
IsCorrectDir endp

ReleasePatch proc ID,Num,Pointer
    ; 释放资源文件
    ; eax为资源ID的头，esi为第几个资源，[ebx+edi]为文件名字符串的指针
    mov ecx,Num
    mov ebx,Pointer
    mov esi,1
    mov edi,0
s2: pushad
    push dword ptr [ebx+edi]
    push dword ptr [offset CurrentDir]
    push offset OpenFileBuffer
    call wsprintf
    add esp,12
    ; invoke MessageBoxA,0,offset OpenFileBuffer,offset OpenFileBuffer,0
    mov eax,ID
    add eax,esi
    invoke FindResource,hInstance,eax,RT_RCDATA
    .if eax == NULL
        popad
        mov eax,FALSE
        ret
    .endif
    mov FileResInfo,eax
    invoke LoadResource,hInstance,eax
    invoke LockResource,eax
    mov FilePointer,eax
    invoke SizeofResource,hInstance,FileResInfo
    mov FileSize,eax
    invoke CreateFileA,offset OpenFileBuffer,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
    .if eax == INVALID_HANDLE_VALUE
        popad
        mov eax,FALSE
        ret
    .endif
    mov hFile,eax
    invoke WriteFile,hFile,FilePointer,FileSize,offset WriteSize,NULL
    mov esi,WriteSize
    mov edi,FileSize
    .if eax == NULL || esi < edi
        invoke CloseHandle,hFile
        popad
        mov eax,FALSE
        ret
    .endif
    invoke FlushFileBuffers,hFile
    invoke CloseHandle,hFile
    popad
    add edi,4
    inc esi
    dec ecx
    cmp ecx,0
    ja j2
    mov eax,TRUE
    ret
j2: jmp near ptr s2
ReleasePatch endp

InstallPatch proc hWnd
    ; “确定”按钮单击后的回调函数
    invoke IsDlgButtonChecked,hWnd,IDC_CHECKBOX
    .if eax != BST_CHECKED
        invoke MessageBoxA,hWnd,offset MessageWarn,offset MessageTitle,MB_ICONWARNING
        ret
    .endif
    invoke MessageBoxA,hWnd,offset MessageQuestion,offset MessageTitle,MB_YESNO or MB_ICONQUESTION
    .if eax != IDYES
        ret
    .endif
    call IsCorrectDir
    .if eax != TRUE
        invoke MessageBoxA,hWnd,offset MessageError,offset MessageTitle,MB_ICONERROR
        ret
    .endif
    push offset ProgramPointer
    mov al,ProgramNum
    movzx eax,al
    push eax
    push ProgramID
    call ReleasePatch
    .if eax != TRUE
        invoke MessageBoxA,hWnd,offset MessageNoAccess,offset MessageTitle,MB_ICONERROR
        ret
    .endif
    push offset PicturePointer
    mov al,PictureNum
    movzx eax,al
    push eax
    push PictureID
    call ReleasePatch
    .if eax != TRUE
        invoke MessageBoxA,hWnd,offset MessageNoAccess,offset MessageTitle,MB_ICONERROR
        ret
    .endif
    invoke MessageBoxA,hWnd,offset MessageShotCut,offset MessageTitle,MB_YESNO or MB_ICONQUESTION
    .if eax == IDYES
        call CreateDesktopCut
    .endif
    invoke MessageBoxA,hWnd,offset MessageDone,offset MessageTitle,MB_ICONINFORMATION
    ret
InstallPatch endp

start:
    invoke GetModuleHandle,0
    mov hInstance,eax
    invoke GetCurrentDirectory,256,offset CurrentDir
    mov ebx,offset CurrentDir
    .while byte ptr [ebx] != 0
        inc ebx
    .endw
    mov byte ptr [ebx],'\'
    mov word ptr [ebx+1],'s%'
    invoke DialogBoxParam,hInstance,IDD_DIALOG,NULL,offset CallBackFunction,NULL
    invoke ExitProcess,NULL
end start
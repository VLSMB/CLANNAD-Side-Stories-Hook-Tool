	.386
	.model flat,stdcall
	option casemap:none
include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include gdi32.inc
includelib gdi32.lib

	.data?
dwHandle dd ?	; ��DLL���
dwAppInstance dd ? 	; ��Ϸ����ַ
gdiOrgAddr dd ?
gdiRetAddr dd ?
CFOrgAddr dd ?
CFRetAddr dd ?
SFFOrgAddr dd ?
SFFRetAddr dd ?
SWTOrgAddr dd ?
SWTRetAddr dd ?
CWEXOrgAddr dd ?
CWEXRetAddr dd ?
MBOrgAddr dd ?
MBRetAddr dd ?
EFFOrgAddr dd ?
EFFRetAddr dd ?
BufferOrgAddr dd ?
BufferRetAddr dd ?
; SeenHook struct
IsSeen db ?
SPindex db ?
IsFirst db ?
; SeenHook ends
ResourcePointer dd ?
CreateFileAAddr dd ?
hWindow dd ?
IsMainWindow db ?

	.const
Font db "����",0
gdiName db "gdi32.dll",0
CreateFontName db "CreateFontA",0
EnumFontFamiliesExName db "EnumFontFamiliesExA",0 ; 23
kernelName db "kernelbase.dll",0
kernelNameXP db "kernel32.dll",0
CreateFileName db "CreateFileA",0
SetFilePointerName db "SetFilePointer",0
user32Name db "user32.dll",0
SetWindowTextName db "SetWindowTextA",0
UpdateWindowName db "UpdateWindow",0
MessageBoxName db "MessageBoxA",0
BufferRVA dd 0D19B0H
WindowText db "CLANNAD���������ŵ��µ� ������V1.5 �����Ǻ�����",0
MessageQuit db "��ȷ��Ҫ�˳���Ϸ��",0
FontText db "��������",0
Win7CFRVA1 dd 0C49C7H
Win7CFRVA2 dd 0C47DFH
Episode01Name db "CLANNAD���������ŵ��µ� Episode01 �ó������� �ź��",0
Episode02Name db "CLANNAD���������ŵ��µ� Episode02 ���ӵ��ռ� ��������",0
Episode03Name db "CLANNAD���������ŵ��µ� Episode03 ���������� ������",0
Episode04Name db "CLANNAD���������ŵ��µ� Episode04 �������ٵ�˲�� �����",0
Episode05Name db "CLANNAD���������ŵ��µ� Episode05 �Ǹ�ʱ����� �����Ǵ�",0
Episode06Name db "CLANNAD���������ŵ��µ� Episode06 �ҵĸ�� ��ԭѿ��",0
Episode07Name db "CLANNAD���������ŵ��µ� Episode07 ��ʽ������ζ�� ĵ��",0
Episode08Name db "CLANNAD���������ŵ��µ� Episode08 �ر��ҹ�� �ź�����",0
Episode09Name db "CLANNAD���������ŵ��µ� Episode09 ����ȹ һ֮������",0
Episode10Name db "CLANNAD���������ŵ��µ� Episode10 ��������� �����м���",0
Episode11Name db "CLANNAD���������ŵ��µ� Episode11 ����ǰ����Ե ��ʤƽ",0
Episode12Name db "CLANNAD���������ŵ��µ� Episode12 ���˵Ļ��� ��������֦",0
Episode13Name db "CLANNAD���������ŵ��µ� Episode13 ��ʦ�Ļ��� �Ҵ忡��",0
Episode14Name db "CLANNAD���������ŵ��µ� Episode14 �ź����ʦ�ٽ�� ������Ҳ",0
Episode15Name db "CLANNAD���������ŵ��µ� Episode15 ��������� ������Ҳ",0
Episode16Name db "CLANNAD���������ŵ��µ� Episode16 �����˼�� ����ϫ",0
Episode17Name db "CLANNAD���������ŵ��µ� ��Ϸ����",0
TranslatorName db "�����Ǻ�����",0
MessageDebugger db "��⵽�е����������ڱ������У�",0AH,0DH,0AH,0DH
				db "������������ʾ����������������ѧϰ�о�����ֹ�κ��������޸ı����������ڷǷ�ӯ����;�ϡ�����ַǷ��о�����ɵĺ���������鲻��е���",0
MessageMemoryNoRead db "���������������ش��󣺴�����ڴ治��д��",0AH,0DH,"������������������뵽�������Ǻ�����ɡ�������",0
MessageNoAppHandle db "���������������ش����޷���ȡ���̾����",0AH,0DH,"������������������뵽�������Ǻ�����ɡ�������",0
MessageNoApiAddr db "���������������ش��󣺻�ȡAPI��ַʧ�ܡ����ܵ�ǰ�汾��Windows��API�����˽ϴ�䶯���볢�ԡ��Լ���ģʽ���С���",0AH,0DH,"������������������뵽�������Ǻ�����ɡ�������",0
MessageResError db "���������������ش��󣺺�����Դ��ȡʧ�ܡ�",0AH,0DH,"������������������뵽�������Ǻ�����ɡ�������",0

	.data
fileName db "C:\Users\VLSMB\Desktop\CLSS\HookText\Episode%02d.bin",0
fileBuffer db 58 dup (0)
hFile dd 0
FileByte dd 0
temp dd 0
; ��ȡ�ı�ʱ�ã�CreateFileҪ�����·�����û���ȡ����Ŀ¼���鷳�ģ����Ծ���ôд�ˣ��ɰ��������޸�

; DEBUGΪ1ʱ�����ÿһ�½ڵ�startʱ��ȡ�ı���ָ��Ŀ¼��DEBUGΪ0ʱ������Դ�ļ��ж�Ӧ�Ķ����������滻����������
DEBUG EQU FALSE
; HookSetFilePointer [esp+8]
Episode01 EQU 13880H
Episode02 EQU 17154H
Episode03 EQU 1AB7AH
Episode04 EQU 1F39AH
Episode05 EQU 24145H
Episode06 EQU 280ECH
Episode07 EQU 2C420H
Episode08 EQU 301A8H
Episode09 EQU 349F4H
Episode10 EQU 38A3BH
Episode11 EQU 3C8EAH
Episode12 EQU 4135AH
Episode13 EQU 45449H
Episode14 EQU 48F8DH
Episode15 EQU 4DFAFH
Episode16 EQU 52E63H
MENUTEXT EQU 58992H

	.code
DllEntry proc _hInstance,_dwReason,_dwReserved
	mov eax,_dwReason
	.if eax == DLL_PROCESS_ATTACH
		call IsDebuggerPresent
		.if eax != 0
			invoke MessageBoxA,NULL,offset MessageDebugger,offset TranslatorName,MB_ICONWARNING
			invoke ExitProcess,0
		.endif
		mov eax,_hInstance
		mov dwHandle,eax
		mov eax,0
		mov IsSeen,al
		mov SPindex,al
		mov IsFirst,al
		inc al
		mov IsMainWindow,al
		invoke GetModuleHandle,NULL
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoAppHandle,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
			ret
		.endif
		mov dwAppInstance,eax

		; InlineHook MessageBoxA
		push dword ptr [offset MessageBoxName]
		push dword ptr [offset user32Name]
		call GetApiAddr
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
		.endif
		mov MBOrgAddr,eax
		add eax,5
		mov MBRetAddr,eax
		mov eax,MBOrgAddr
		push eax
		mov eax,offset HookMessageBox
		push eax
		call WriteHookCode
		; InlineHook EnumFontFamiliesExA
		push dword ptr [offset EnumFontFamiliesExName]
		push dword ptr [offset gdiName]
		call GetApiAddr
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
		.endif
		mov EFFOrgAddr,eax
		add eax,5
		mov EFFRetAddr,eax
		mov eax,EFFOrgAddr
		push eax
		mov eax,offset HookEnumFontFamiliesEx
		push eax
		call WriteHookCode
		; InlineHook CreateFontA
		push dword ptr [offset CreateFontName]
		push dword ptr [offset gdiName]
		call GetApiAddr
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
		.endif
		mov gdiOrgAddr,eax
		add eax,5
		mov gdiRetAddr,eax
		mov eax,gdiOrgAddr
		push eax
		mov eax,offset HookFont
		push eax
		call WriteHookCode
		; InlineHook CreateFileA
		push dword ptr [offset CreateFileName]
		push dword ptr [offset kernelName]
		call GetApiAddr
		.if eax == 0
			; WINXPϵͳ�иú���λ��kernel32.dll�У����Է���ֵ��Ϊ0
			push dword ptr [offset CreateFileName]
			push dword ptr [offset kernelNameXP]
			call GetApiAddr
			.if eax == 0
				invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
				invoke ExitProcess,0
			.endif
		.else
			pushad
			push eax
			; ��Win7ϵͳǿ�е���kernelbase�е�CreateFileA
			mov eax,dwAppInstance
			add eax,Win7CFRVA1
			push eax
			invoke VirtualProtect,eax,6,PAGE_EXECUTE_READWRITE,offset temp
			.if eax == 0
				invoke MessageBoxA,NULL,offset MessageMemoryNoRead,offset TranslatorName,MB_ICONERROR
				invoke ExitProcess,0
			.endif
			pop ebx
			mov byte ptr [ebx],0FFH
			mov byte ptr [ebx+1],015H
			pop eax
			mov CreateFileAAddr,eax
			mov eax,offset CreateFileAAddr
			mov dword ptr [ebx+2],eax

			mov eax,dwAppInstance
			add eax,Win7CFRVA2
			push eax
			invoke VirtualProtect,eax,6,PAGE_EXECUTE_READWRITE,offset temp
			.if eax == 0
				invoke MessageBoxA,NULL,offset MessageMemoryNoRead,offset TranslatorName,MB_ICONERROR
				invoke ExitProcess,0
			.endif
			pop ebx
			mov byte ptr [ebx],0FFH
			mov byte ptr [ebx+1],015H
			mov eax,offset CreateFileAAddr
			mov dword ptr [ebx+2],eax
			popad
		.endif
		mov CFOrgAddr,eax
		add eax,5
		mov CFRetAddr,eax
		mov eax,CFOrgAddr
		push eax
		mov eax,offset HookCreateFile
		push eax
		call WriteHookCode
		; InlineHook SetFilePointer
		push dword ptr [offset SetFilePointerName]
		push dword ptr [offset kernelName]
		call GetApiAddr
		.if eax == 0
			; XPϵͳ�иú���λ��kernel32.dll�У����Է���ֵ��Ϊ0
			push dword ptr [offset SetFilePointerName]
			push dword ptr [offset kernelNameXP]
			call GetApiAddr
			.if eax == 0
				invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
				invoke ExitProcess,0
			.endif
		.endif
		mov SFFOrgAddr,eax
		add eax,5
		mov SFFRetAddr,eax
		mov eax,SFFOrgAddr
		push eax
		mov eax,offset HookSetFilePointer
		push eax
		call WriteHookCode
		; InlineHook UpdateWindow
		push dword ptr [offset UpdateWindowName]
		push dword ptr [offset user32Name]
		call GetApiAddr
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
		.endif
		mov CWEXOrgAddr,eax
		add eax,5
		mov CWEXRetAddr,eax
		mov eax,CWEXOrgAddr
		push eax
		mov eax,offset HookUpdateWindow
		push eax
		call WriteHookCode
		; InlineHook SetWindowText
		push dword ptr [offset SetWindowTextName]
		push dword ptr [offset user32Name]
		call GetApiAddr
		.if eax == 0
			invoke MessageBoxA,NULL,offset MessageNoApiAddr,offset TranslatorName,MB_ICONERROR
			invoke ExitProcess,0
		.endif
		mov SWTOrgAddr,eax
		add eax,5
		mov SWTRetAddr,eax
		mov eax,SWTOrgAddr
		push eax
		mov eax,offset HookSetWindowText
		push eax
		call WriteHookCode
		; InlineHook SEEN Buffer
		mov eax,dwAppInstance
		add eax,BufferRVA
		mov BufferOrgAddr,eax
		add eax,7
		mov BufferRetAddr,eax
		mov eax,BufferOrgAddr
		push eax
		mov eax,DEBUG
		.if eax == TRUE
			mov eax,offset GetBufferText
		.else
			mov eax,offset HookBufferText
		.endif
		push eax
		call WriteHookCode

	.endif
	mov eax,TRUE
	ret
DllEntry endp

GetApiAddr proc dllName,FunctionName
	local LoadDll:DWORD
	; ����������Ϊ�ַ���������ֵΪAPI��ַ
	invoke LoadLibraryA,dllName
	.if eax == 0
		ret
	.endif
	mov LoadDll,eax
	invoke GetProcAddress,LoadDll,FunctionName
	.if eax == 0
		ret
	.endif
	push eax
	invoke FreeLibrary,LoadDll
	pop eax
	ret
GetApiAddr endp

PictureCHS proc
	; ��һ����*.g00��Ϊ*.gch��edxΪ�ַ���ָ��β�����Ż��㷨
	.if dword ptr [edx-4] == '00g.'
		.if dword ptr [edx-13] == 'ERAT' && byte ptr [edx-5] != '0'
			jmp ChangeSuffix
		.elseif dword ptr [edx-13] == 'TITC'
			jmp ChangeSuffix
		.elseif dword ptr [edx-11] == 'UNEM'
			.if word ptr [edx-6] == '00'
				jmp PCHSRet
			.else
				jmp ChangeSuffix
			.endif
		.elseif dword ptr [edx-13] == 'DERC'
			jmp ChangeSuffix
		.elseif dword ptr [edx-10] == '_MHC'
			jmp ChangeSuffix
		.elseif dword ptr [edx-10] == '_MPC'
			.if	word ptr [edx-6] == '99'
				jmp PCHSRet
			.else
				jmp ChangeSuffix
			.endif
		.elseif dword ptr [edx-8] == 'ESAB'
			jmp ChangeSuffix
		.elseif dword ptr [edx-8] == '00RA'
			jmp ChangeSuffix
		.elseif dword ptr [edx-13] == 'SYS_'
			.if	dword ptr [edx-8] == '00CS' || dword ptr [edx-8] == 'U_LS'
				jmp PCHSRet
			.else
				jmp ChangeSuffix
			.endif
		.elseif dword ptr [edx-9] == '0NTB'
			jmp ChangeSuffix
		.elseif dword ptr [edx-8] == 'TIXE'
			jmp ChangeSuffix
		.else
			jmp PCHSRet
		.endif
	.else
		jmp PCHSRet
	.endif
ChangeSuffix:
	mov byte ptr [edx-1],'h'
	mov byte ptr [edx-2],'c'
PCHSRet:
	ret
PictureCHS endp

HookEnumFontFamiliesEx proc
	push ebx
	mov ebx,[esp+12]
	mov byte ptr [ebx+23],86H
	pop ebx
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp EFFRetAddr
HookEnumFontFamiliesEx endp

HookMessageBox proc
	; ������ԭ�������Ѿ��滻Ϊ"ȷ��"������ʾ��Ϣ��gameexe.ini��ֻ��Hook�ĵ���
	push ebx
	mov ebx,[esp+10H]
	mov eax,[ebx]
	pop ebx
	cmp eax,0CFC8B7C8H
	jne MBret
	mov eax,offset MessageQuit
	mov [esp+8],eax
MBret:
	xor eax,eax
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp MBRetAddr
HookMessageBox endp

HookUpdateWindow proc
	mov al,IsMainWindow
	movzx eax,al
	.if eax != 0
		mov eax,[esp+4]
		mov hWindow,eax
		xor eax,eax
		mov IsMainWindow,al
	.endif
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp CWEXRetAddr
HookUpdateWindow endp

HookSetWindowText proc
	mov eax,[esp+4]
	.if eax == hWindow
		mov al,IsSeen
		movzx eax,al
		.if eax == 0
			mov eax,offset WindowText
			mov [esp+8],eax
		.endif
	.else
	push ebx
	mov ebx,[esp+0CH]
	cmp dword ptr [ebx],48837483H
	jne HSWTret
	cmp dword ptr [ebx+4],67839383H
	jne HSWTret
	cmp dword ptr [ebx+8],0E892DD90H
	jne HSWTret
	mov eax,offset FontText
	mov [esp+0CH],eax
HSWTret:
	pop ebx
	.endif
	xor eax,eax
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp SWTRetAddr
HookSetWindowText endp

HookCreateFile proc
	mov edx,[esp+4]
HCFcmp0:
	cmp byte ptr [edx],0
	je HCFcmp1
	inc edx
	jmp HCFcmp0
HCFcmp1:
	cmp dword ptr [edx-4],'TXT.'
	jne HCFno
	cmp dword ptr [edx-8],'NEES'
	jne HCFno
	xor edx,edx
	mov dl,1
	mov IsSeen,dl
	jmp HCFyes
HCFno:
	call PictureCHS	
	xor edx,edx
	mov dl,0
	mov IsSeen,dl
HCFyes:
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp CFRetAddr
HookCreateFile endp

HookSetFilePointer proc
	xor eax,eax
	mov al,IsSeen
	cmp al,0
	je HSPret
	mov eax,[esp+8]
	cmp eax,Episode01
	je HSP01
	cmp eax,Episode02
	je HSP02
	cmp eax,Episode03
	je HSP03
	cmp eax,Episode04
	je HSP04
	cmp eax,Episode05
	je HSP05
	cmp eax,Episode06
	je HSP06
	cmp eax,Episode07
	je HSP07
	cmp eax,Episode08
	je HSP08
	cmp eax,Episode09
	je HSP09
	cmp eax,Episode10
	je HSP10
	cmp eax,Episode11
	je HSP11
	cmp eax,Episode12
	je HSP12
	cmp eax,Episode13
	je HSP13
	cmp eax,Episode14
	je HSP14
	cmp eax,Episode15
	je HSP15
	cmp eax,Episode16
	je HSP16
	cmp eax,MENUTEXT
	je HSPMenu
	mov al,0
	mov SPindex,al
	jmp HSPret
HSP01:
	mov al,1
	mov SPindex,al
	jmp HSPret
HSP02:
	mov al,2
	mov SPindex,al
	jmp HSPret
HSP03:
	mov al,3
	mov SPindex,al
	jmp HSPret
HSP04:
	mov al,4
	mov SPindex,al
	jmp HSPret
HSP05:
	mov al,5
	mov SPindex,al
	jmp HSPret
HSP06:
	mov al,6
	mov SPindex,al
	jmp HSPret
HSP07:
	mov al,7
	mov SPindex,al
	jmp HSPret
HSP08:
	mov al,8
	mov SPindex,al
	jmp HSPret
HSP09:
	mov al,9
	mov SPindex,al
	jmp HSPret
HSP10:
	mov al,10
	mov SPindex,al
	jmp HSPret
HSP11:
	mov al,11
	mov SPindex,al
	jmp HSPret
HSP12:
	mov al,12
	mov SPindex,al
	jmp HSPret
HSP13:
	mov al,13
	mov SPindex,al
	jmp HSPret
HSP14:
	mov al,14
	mov SPindex,al
	jmp HSPret
HSP15:
	mov al,15
	mov SPindex,al
	jmp HSPret
HSP16:
	mov al,16
	mov SPindex,al
	jmp HSPret
HSPMenu:
	mov al,17
	mov SPindex,al
HSPret:
	xor eax,eax
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp SFFRetAddr
HookSetFilePointer endp

HookFont proc
	; ��Reallive RVA 0xC5E87 ����CreateFontA����Ĳ���
	mov dword ptr ss:[esp+24H],86H
	; mov dword ptr ss:[esp+38H],offset Font
	mov edi,edi
	push ebp
	mov ebp,esp
	jmp gdiRetAddr
HookFont endp

WriteHookCode proc uses ebx esi edi ecx,tarAddr,orgAddr
	local oldProtect:DWORD
	local RVAaddr:DWORD
	local buffer[5]:BYTE
	invoke VirtualProtect,orgAddr,5,PAGE_EXECUTE_READWRITE,addr oldProtect
	.if eax == 0
		invoke MessageBoxA,NULL,offset MessageMemoryNoRead,offset TranslatorName,MB_ICONERROR
		invoke ExitProcess,0
	.endif
	mov eax,tarAddr
	mov ebx,orgAddr
	sub eax,ebx
	sub eax,5
	lea esi,buffer
	mov byte ptr [esi],0E9H
	mov byte ptr [esi+1],al
	mov byte ptr [esi+2],ah
	shr eax,16
	mov byte ptr [esi+3],al
	mov byte ptr [esi+4],ah
	mov edi,orgAddr
	mov ecx,5
	mov ebx,0
l:	mov al,byte ptr [esi+ebx]
	mov byte ptr [edi+ebx],al
	inc ebx
	loop l
	mov eax,1
	ret
WriteHookCode endp

GetBufferText proc
	je def1	; �˴�Hook�ƻ���ԭ�е�������ת������Ҫ������
	pushad
	pushfd
	xor eax,eax
	mov al,IsSeen
	cmp al,0
	je BTno
	mov al,SPindex
	cmp al,0
	je BTno
	mov al,IsFirst
	cmp al,0
	je FirstSeen	; Seen�½ڶ�ȡ�ڶ���ʱ�����ı�
	push esi
	mov eax,ecx
	add eax,ecx
	add eax,ecx
	add eax,ecx
	mov FileByte,eax
	;invoke wsprintf,offset fileBuffer,offset fileName,SPindex
	push 0
	mov al,SPindex
	movzx ax,al
	push ax
	push offset fileName
	push offset fileBuffer
	call wsprintf
	add esp,14
	invoke CreateFileA,offset fileBuffer,GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
	mov hFile,eax
	pop esi
	invoke WriteFile,hFile,esi,FileByte,offset temp,0
	invoke FlushFileBuffers,hFile
	invoke CloseHandle,hFile
	mov al,0
	mov IsFirst,al
	mov IsSeen,al
	mov SPindex,al
	jmp BTno
FirstSeen:
	mov al,1
	mov IsFirst,al
	xor eax,eax
BTno:
	popfd
	popad
	rep movsd
def1:
	and ebx,3
	jmp BufferRetAddr
GetBufferText endp

HookBufferText proc
	je def2	; �˴�Hook�ƻ���ԭ�е�������ת������Ҫ������
	pushad
	pushfd
	xor eax,eax
	mov al,IsSeen
	cmp al,0
	je BTno2
	mov al,SPindex
	cmp al,0
	je BTno2
	mov al,IsFirst
	cmp al,0
	je FirstSeen2	; Seen�½ڶ�ȡ�ڶ���ʱ�����ı�
	
	mov al,SPindex
	movzx eax,al
	call SetEpisodeText
	.if eax <= 17	; ��17��Ϊ�����е�ʾ���ı�
		push eax
		call GetResourcePointer
		mov ResourcePointer,eax
	.endif
	mov al,0
	mov IsFirst,al
	mov IsSeen,al
	mov SPindex,al
	jmp BTno3
FirstSeen2:
	mov al,1
	mov IsFirst,al
	xor eax,eax
BTno2:
	popfd
	popad
	rep movsd
	and ebx,3
	jmp BufferRetAddr
BTno3:
	popfd
	popad
	mov esi,ResourcePointer
	rep movsd
def2:
	and ebx,3
	jmp BufferRetAddr
HookBufferText endp

GetResourcePointer proc ,EpisodeIndex
	mov eax,1000
	add eax,EpisodeIndex
	invoke FindResource,dwHandle,eax,RT_RCDATA
	.if eax == 0
		invoke MessageBoxA,NULL,offset MessageResError,offset TranslatorName,MB_ICONERROR
		invoke ExitProcess,0
		ret
	.endif
	invoke LoadResource,dwHandle,eax
	.if eax == 0
		invoke MessageBoxA,NULL,offset MessageResError,offset TranslatorName,MB_ICONERROR
		invoke ExitProcess,0
		ret
	.endif
	invoke LockResource,eax
	ret
GetResourcePointer endp

SetEpisodeText proc uses eax ebx
	; ָ���½��滻���⣬����eax
	mov ebx,hWindow
	.if ebx == 0
		ret
	.endif
	.if eax == 1
		invoke SetWindowTextA,hWindow,offset Episode01Name
	.elseif eax == 2
		invoke SetWindowTextA,hWindow,offset Episode02Name
	.elseif eax == 3
		invoke SetWindowTextA,hWindow,offset Episode03Name
	.elseif eax == 4
		invoke SetWindowTextA,hWindow,offset Episode04Name
	.elseif eax == 5
		invoke SetWindowTextA,hWindow,offset Episode05Name
	.elseif eax == 6
		invoke SetWindowTextA,hWindow,offset Episode06Name
	.elseif eax == 7
		invoke SetWindowTextA,hWindow,offset Episode07Name
	.elseif eax == 8
		invoke SetWindowTextA,hWindow,offset Episode08Name
	.elseif eax == 9
		invoke SetWindowTextA,hWindow,offset Episode09Name
	.elseif eax == 10
		invoke SetWindowTextA,hWindow,offset Episode10Name
	.elseif eax == 11
		invoke SetWindowTextA,hWindow,offset Episode11Name
	.elseif eax == 12
		invoke SetWindowTextA,hWindow,offset Episode12Name
	.elseif eax == 13
		invoke SetWindowTextA,hWindow,offset Episode13Name
	.elseif eax == 14
		invoke SetWindowTextA,hWindow,offset Episode14Name
	.elseif eax == 15
		invoke SetWindowTextA,hWindow,offset Episode15Name
	.elseif eax == 16
		invoke SetWindowTextA,hWindow,offset Episode16Name
	.elseif eax == 17
		invoke SetWindowTextA,hWindow,offset Episode17Name
	.else
		invoke SetWindowTextA,hWindow,offset WindowText
	.endif
	ret
SetEpisodeText endp

VLSMB proc
	ret
DB 16h, 0BAh, 0BAh, 0BBh, 0AFh, 0D7h, 0E9h, 0C3h, 0FBh, 0B5h, 0A5h, 0A3h, 0BAh, 0Dh, 0Ah, 0B3h
DB 0CCh, 0D0h, 0F2h, 0A3h, 0BAh, 56h, 4Ch, 53h, 4Dh, 42h, 0Dh, 0Ah, 0B7h, 0ADh, 0D2h, 0EBh
DB 0A3h, 0BAh, 0B6h, 0B9h, 0C9h, 0B3h, 0CDh, 0C5h, 0D7h, 0D3h, 20h, 34h, 32h, 20h, 56h, 4Ch
DB 53h, 4Dh, 42h, 20h, 0C0h, 0B2h, 0C0h, 0B2h, 36h, 36h, 37h, 37h, 35h, 35h, 20h, 0B8h
DB 0D4h, 0C6h, 0E9h, 0D6h, 0C7h, 0B4h, 0FAh, 20h, 7Ah, 79h, 64h, 2Dh, 2Dh, 2Dh, 0Dh, 0Ah
DB 0D0h, 0DEh, 0CDh, 0BCh, 0A3h, 0BAh, 0BCh, 0C5h, 0BEh, 0B2h, 0D0h, 0C7h, 0B3h, 0BEh, 0A3h, 0A8h
DB 0CFh, 0ABh, 0C4h, 0CEh, 0B0h, 0E8h, 0B9h, 0DBh, 0C1h, 0E5h, 0BDh, 0B4h, 0A3h, 0A9h, 20h, 0CBh
DB 0D5h, 0C6h, 0C5h, 0C2h, 0EAh, 0C0h, 0F6h, 0B0h, 0C2h, 0Dh, 0Ah, 0B2h, 0E2h, 0CAh, 0D4h, 0A3h
DB 0BAh, 56h, 4Ch, 53h, 4Dh, 42h, 20h, 0B6h, 0B9h, 0C9h, 0B3h, 0CDh, 0C5h, 0D7h, 0D3h,0
VLSMB endp

end DllEntry
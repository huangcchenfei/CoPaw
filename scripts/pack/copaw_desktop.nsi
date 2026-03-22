; TimoBot NSIS installer. Run makensis from repo root after
; building dist/win-unpacked (see scripts/pack/build_win.ps1).
; Usage: makensis /DCOPAW_VERSION=1.2.3 /DOUTPUT_EXE=dist\TimoBot-Setup-1.2.3.exe scripts\pack\copaw_desktop.nsi

!include "MUI2.nsh"
!define MUI_ABORTWARNING
; Use custom icon from unpacked env (copied by build_win.ps1)
!define MUI_ICON "${UNPACKED}\icon.ico"
!define MUI_UNICON "${UNPACKED}\icon.ico"

!ifndef COPAW_VERSION
  !define COPAW_VERSION "0.0.0"
!endif
!ifndef OUTPUT_EXE
  !define OUTPUT_EXE "dist\TimoBot-Setup-${COPAW_VERSION}.exe"
!endif

Name "TimoBot"
OutFile "${OUTPUT_EXE}"
InstallDir "$LOCALAPPDATA\TimoBot"
InstallDirRegKey HKCU "Software\TimoBot" "InstallPath"
RequestExecutionLevel user

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

; Pass /DUNPACKED=full_path from build_win.ps1 so path works when cwd != repo root
!ifndef UNPACKED
  !define UNPACKED "dist\win-unpacked"
!endif

Section "TimoBot" SEC01
  SetOutPath "$INSTDIR"
  File /r "${UNPACKED}\*.*"
  WriteRegStr HKCU "Software\TimoBot" "InstallPath" "$INSTDIR"
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Main shortcut - uses VBS to hide console window
  CreateShortcut "$SMPROGRAMS\TimoBot.lnk" "$INSTDIR\TimoBot.vbs" "" "$INSTDIR\icon.ico" 0
  CreateShortcut "$DESKTOP\TimoBot.lnk" "$INSTDIR\TimoBot.vbs" "" "$INSTDIR\icon.ico" 0
  
  ; Debug shortcut - shows console window for troubleshooting
  CreateShortcut "$SMPROGRAMS\TimoBot (Debug).lnk" "$INSTDIR\TimoBot (Debug).bat" "" "$INSTDIR\icon.ico" 0
SectionEnd

Section "Uninstall"
  Delete "$SMPROGRAMS\TimoBot.lnk"
  Delete "$SMPROGRAMS\TimoBot (Debug).lnk"
  Delete "$DESKTOP\TimoBot.lnk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "Software\TimoBot"
SectionEnd

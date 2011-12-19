Option Explicit

Dim oWsh, oExec, oEnv, sTmp, oTmp, sTL, sGS, sVal, sDat, dDat, oFS
Dim sP, sPr, bFirstConfig, bAdobe, sAdobe, i, j, s

On Error Resume Next

Set oWsh = Wscript.CreateObject("WScript.Shell")
Set oFS = CreateObject("Scripting.FileSystemObject")
Set oEnv = oWsh.Environment("PROCESS")

'''''''''''''''''''''''''''''''''''
' WMI hocuspocus for deleting registry keys recursively, from
' http://www.tek-tips.com/viewthread.cfm?qid=674375&page=8

const hkcr=&h80000000
const hkcu=&h80000001
const hklm=&h80000002

Dim oReg

Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}//" _
  & "./root/default:StdRegProv")

Function DeleteRegEntry( sHive, sEnumPath )

  Dim lRC, sKeyName, sNames

  ' Attempt to delete key.  If it fails, start the subkey
  ' enumeration process.
  On Error Goto 0
  lRC = oReg.DeleteKey(sHive, sEnumPath)
  ' The deletion failed, start deleting subkeys.
  If (lRC <> 0) Then

    ' Subkey Enumerator
    On Error Resume Next

    lRC = oReg.EnumKey( sHive, sEnumPath, sNames )

    For Each sKeyName In sNames
       If Err.Number <> 0 Then Exit For
       lRC = DeleteRegEntry( sHive, sEnumPath & "\" & sKeyName )
    Next
    ' On Error Goto 0

    ' At this point we should have looped through all subkeys, trying
    ' to delete the registry key again.
    lRC = oReg.DeleteKey( sHive, sEnumPath )
  End If
End Function
'''''''''''''''''''''''''''''''''''

' the installer calls this script with a parameter;
' the menu shortcut for later reconfiguration calls it without
Set oTmp = Wscript.Arguments
bFirstConfig =  (oTmp.count >= 1)

sTL = ""
s = Left (wscript.version, 3)
s = replace (s, ".", "")
i = CInt(s)
If i < 56 Then
  sTL = _
   oFS.GetFolder(oFS.GetFile(Wscript.ScriptFullName).ParentFolder).ParentFolder
Else
  sTmp = ""
  ' ask kpathsea
  Set oExec = oWsh.Exec("kpsewhich -var-value=SELFAUTOPARENT")
  sTmp = oExec.StdOut.ReadAll
  Err.clear()
  If sTmp <> "" then
    sTmp = replace(sTmp, vbCr, "")
    sTmp = replace(sTmp, vbLf, "")
    sTL = replace(sTmp, "/", "\")
  End If
End If
If sTL = "" Then
  MsgBox "TeX Live not found; aborting...", vbOKOnly+vbCritical, "Error"
  quit
End If
sTL = oFS.GetFolder(sTL).ShortPath
'wscript.echo "Root: " & sTL

If Not bFirstConfig then
  i = MsgBox("Please make sure that TeXnicCenter is not running!", _
             vbOKCancel+vbExclamation, "Check for TeXnicCenter")
  If i = vbCancel Then
    wscript.quit(1)
  End If
End If

Const sPro = "HKCU\software\toolscenter\texniccenter\profiles\"

' remove old settings recursively

Err.clear
DeleteRegEntry hkcu, "software\toolscenter\texniccenter\profiles"
Err.clear

' [pdf]latex
For Each sPr in Array( _
    "LaTeX => DVI\", "LaTeX => PDF\", "LaTeX => PS\", "LaTeX => PS => PDF\")
  sP = sPro & sPr
  oWsh.RegWrite sP & "RunLatex", 1, "REG_DWORD"
  If sPr = "LaTeX => PDF\" Then
    oWsh.RegWrite sP & "LatexPath", sTL & "\bin\win32\pdflatex.exe"
  Else
    oWsh.RegWrite sP & "LatexPath", sTL & "\bin\win32\latex.exe"
  End If
  oWsh.RegWrite sP & "LatexArgs", "-synctex=-1 -interaction=nonstopmode ""%Wm"""
  oWsh.RegWrite sP & "LatexStopOnError", 0, "REG_DWORD"
  oWsh.RegWrite sP & "RunBibTex", 1, "REG_DWORD"
  oWsh.RegWrite sP & "BibTexPath", sTL & "\bin\win32\bibtex.exe"
  oWsh.RegWrite sP & "BibTexArgs", """%bm"""
  oWsh.RegWrite sP & "RunMakeIndex", 1, "REG_DWORD"
  oWsh.RegWrite sP & "MakeIndexPath", sTL & "\bin\win32\makeindex.exe"
  oWsh.RegWrite sP & "MakeIndexArgs", """%bm"""
  oWsh.RegWrite sP & "CloseViewBeforeCompilation", 0, "REG_DWORD"
Next

' postprocessing: dvips
For Each sPr in Array("LaTeX => PS\", "LaTeX => PS => PDF\")
  sP = sPro & sPr & "PostProcessors\"
oWsh.RegWrite sP & "PostProcessor0", _
    "DviPs" & vbLf & _
    sTL & "\bin\win32\dvips.exe" & vbLf & """%Bm.dvi""" & vbLf & vbLf
Next

' postprocessing: ps2pdf
sGS = replace(sTL, "\", "/") & "/tlpkg/tlgs/"
oWsh.RegWrite sPro & "LaTeX => PS => PDF\PostProcessors\PostProcessor1", _
    "gswin32c" & vbLf & _
    sTL & "\tlpkg\tlgs\bin\gswin32c.exe" & vbLf & _
    "-I""" & sGS & "lib;" & sGS & "fonts;" & sGS & "Resource""" & _
    " -sPAPERSIZE#a4 -dPDFSETTINGS#/prepress -dCOMPATIBILITYLEVEL#1.3" & _
    " -dNOPAUSE -dBATCH -q -dSAFER -sDEVICE#pdfwrite" & _
    " -sOutputFile#""%Bm.pdf"" ""%Bm.ps""" & vbLf & vbLf

' viewing: dvi
sPr = "LaTeX => DVI\"
oWsh.RegWrite sPro & sPr & "ViewerPath", _
    "wscript """ & sTL & "\tlrug\dviout.vbs"""

For Each s in Array("ViewCurrentCmd\", "ViewProjectCmd\")
  sP = sPro & sPr & s
  oWsh.RegWrite sP & "ProcessCmd", _
    "wscript """ & sTL & "\tlrug\dviout.vbs""" & vbLf & """%bm.dvi"""
  oWsh.RegWrite sP & "DDECmd", vbLf & "System" & vbLf & vbLf
Next

' viewing: ps
sPr = "LaTeX => PS\"
oWsh.RegWrite sPro & sPr & "ViewerPath", "wscript """ & sTL & "\tlrug\psv.vbs"""
For Each s in Array("ViewCurrentCmd\", "ViewProjectCmd\")
  sP = sPro & sPr & s
  oWsh.RegWrite sP & "ProcessCmd", _
      "wscript """ & sTL & "\tlrug\psv.vbs""" & vbLf & """%bm.ps"""
  oWsh.RegWrite sP & "DDECmd", vbLf & "System" & vbLf & vbLf
Next

' viewing: pdf
' when reconfiguring, check for Adobe Reader;
' if found, ask whether to use it
If bFirstConfig Then
  bAdobe = False
Else
  Err.clear
  bAdobe = True
  sTmp = oWsh.RegRead("HKCR\AcroExch.Document\Shell\Open\Command\")
  If Err.number>0 Then
    bAdobe = False
    Err.clear
  Else
    'wscript.echo "open command:" & vbnewline & stmp & vbnewline
    If InStr(sTmp, """") = 1 Then
      sTmp = Mid(sTmp, 2)
    End If
    i = InStr(sTmp, ".exe")
    If i=0 Then
      bAdobe = False
    Else
      sAdobe = Mid(sTmp, 1, InStr(sTmp, ".exe")+3)
      'wscript.echo "reader:" & sAdobe
      Err.clear
      oTmp = oFS.GetFile(sAdobe)
      If Err.number>0 Then
        bAdobe = False
        Err.clear
        'wscript.echo sadobe & " not a file"
      End If
    End If
  End If
End If
If bAdobe Then
  i = MsgBox( "Use Adobe Reader/Acrobat instead of SumatraPDF?", _
    vbYesNo+vbQuestion, "PDF viewer")
  If i = vbNo Then
    bAdobe = False
  End If
End If
'If badobe Then
'  wscript.echo "reader: " & sadobe
'Else
'  wscript.echo "no reader"
'End If

For Each sPr in Array("LaTeX => PDF\", "LaTeX => PS => PDF\")
  If bAdobe Then
    oWsh.RegWrite sPro & sPr & "ViewerPath", sAdobe
    oWsh.RegWrite sPro & sPr & "CloseViewBeforeCompilation", 1, "REG_DWORD"
    For Each s in Array("ViewCurrentCmd\", "ViewProjectCmd\")
      sP = sPro & sPr & s
      oWsh.RegWrite sP & "ActiveType", 1, "REG_DWORD"
      oWsh.RegWrite sP & "ProcessCmd", vbLf
      oWsh.RegWrite sP & "DDECmd", "acroview" & vbLf & "control" & vbLf & _
          "[DocOpen(""%bm.pdf"")][FileOpen(""%bm.pdf"")]" & _
          vbLf & sAdobe
          '          "[MenuitemExecute(""GoBack"")]" &
    Next
    sP = sPro & sPr & "ViewCloseCmd\"
    oWsh.RegWrite sP & "ActiveType", 1, "REG_DWORD"
    oWsh.RegWrite sP & "ProcessCmd", vbLf
    oWsh.RegWrite sP & "DDECmd", _
        "acroview" & vbLf & "control" & vbLf & _
        "[DocClose(""%bm.pdf"")]" & vbLf
  Else
    oWsh.RegWrite sPro & sPr & "ViewerPath", sTL & "\sumatrapdf\SumatraPDF.exe"
    oWsh.RegWrite sPro & sPr & "CloseViewBeforeCompilation", 0, "REG_DWORD"
    For Each s in Array("ViewCurrentCmd\", "ViewProjectCmd\")
      sP = sPro & sPr & s
      oWsh.RegWrite sP & "ActiveType", 1, "REG_DWORD"
      oWsh.RegWrite sP & "DDECmd", "SUMATRA" & vbLf & "control" & vbLf & _
          "[ForwardSearch(""%bm.pdf"",""%nc"",%l,0)]" & vbLf & _
          sTL & "\sumatrapdf\SumatraPDF.exe"
      'oWsh.RegWrite sP & "ProcessCmd", _
      '    sTL & "\SumatraPDF\SumatraPDF.exe" & vbLf & """%bm.pdf"""
      oWsh.RegWrite sP & "ProcessCmd", vbLf
    Next
    oWsh.RegWrite sPro & sPr
  End If
Next

If Not bFirstConfig Then
  If bAdobe then
    MsgBox "TeXnicCenter now configured for TeX Live 2008 and Adobe Reader", _
           0, "TeXnicCenter Configuration"
  Else
    MsgBox "TeXnicCenter now configured for TeX Live 2008 and SumatraPDF", _
           0, "TeXnicCenter Configuration"
  End If
End If

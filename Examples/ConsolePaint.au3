
#include "../Console.au3"

If $__gfIsCUI Then
	MsgBox(0, "Running from SciTE?", "This program has to be run outside of SciTE.")
	Exit
EndIf

Global $aColors[][2] = [ _
	["black", 0], _
	["blue", $BACKGROUND_BLUE], _
	["green", $BACKGROUND_GREEN], _
	["red", $BACKGROUND_RED] ]

Global $BgColor = "black"
Global $FgColor = "red"

Global $CanvasWidth = 128
Global $CanvasHeight = 64
Global $MouseX = -1
Global $MouseY = -1
Global $KeysPressed = ""

_Console_Alloc()

_Console_SetTitle("Console Paint")
_Console_SetIcon(@SystemDir & "\mspaint.exe")
_Console_Clear()
_Console_SetScreenBufferSize(-1, $CanvasWidth, $CanvasHeight)
WinMove(_Console_GetWindow(), "", 100, 100, 10000, 10000)

_Console_FillOutputCharacter(-1, "_", $CanvasWidth, 0, $CanvasHeight - 3)

While 1
	$tData = _Console_ReadInputRecord()

	_conmain(DllStructGetPtr($tData))
WEnd

_Console_Free()
Exit

Func _CanvasClear()
	_Console_Clear()
	_Console_FillOutputCharacter(-1, "_", $CanvasWidth, 0, $CanvasHeight - 3)
EndFunc

Func _mouseevent($tInputRecord)
	If DllStructGetData($tInputRecord, "MousePositionY") > $CanvasHeight - 3 Then
		_StatusBarMouseEvent($tInputRecord)
	Else
		_CanvasMouseEvent($tInputRecord)
	EndIf
EndFunc

Func _CanvasMouseEvent($tInputRecord)
	Switch DllStructGetData($tInputRecord, "EventFlags")
		Case 0, $MOUSE_MOVED
			Local $x = DllStructGetData($tInputRecord, "MousePositionX")
			Local $y = DllStructGetData($tInputRecord, "MousePositionY")
			If $x <> $MouseX Or $y <> $MouseY Then
				_Console_SetCursorPosition(-1, $x, $y)
				_Console_WriteOutputCharacter(-1, StringFormat("%3.3s,%3.3s", $x, $y), $CanvasWidth - 8, $CanvasHeight - 1)
				$MouseX = $x
				$MouseY = $y
			EndIf

			If DllStructGetData($tInputRecord, "ButtonState") = $FROM_LEFT_1ST_BUTTON_PRESSED Then
				_Console_FillSquare( _
						DllStructGetData($tInputRecord, "MousePositionX"), _
						DllStructGetData($tInputRecord, "MousePositionY"), _
						"fg")
			ElseIf DllStructGetData($tInputRecord, "ButtonState") = $RIGHTMOST_BUTTON_PRESSED Then
				_Console_FillSquare( _
						DllStructGetData($tInputRecord, "MousePositionX"), _
						DllStructGetData($tInputRecord, "MousePositionY"), _
						"bg")
			EndIf
		Case $DOUBLE_CLICK
		Case $MOUSE_HWHEELED
		Case $MOUSE_WHEELED
	EndSwitch
EndFunc

Func _StatusBarMouseEvent($tInputRecord)
	Switch DllStructGetData($tInputRecord, "EventFlags")
		Case 0
			If DllStructGetData($tInputRecord, "ButtonState") = $FROM_LEFT_1ST_BUTTON_PRESSED Then

			EndIf
		Case $MOUSE_MOVED
		Case $DOUBLE_CLICK
		Case $MOUSE_HWHEELED
		Case $MOUSE_WHEELED
	EndSwitch
EndFunc


Func _keyevent($tInputRecord)
	Local $sHotkey = _KeyEventToHotkey($tInputRecord)
	If $sHotkey = "" Then
		_Console_WriteOutputCharacter(-1, " ", 8, 0, $CanvasHeight - 2)
		Return
	EndIf

	Switch $sHotkey
		Case "^s"
			;_Save()
		Case "^n"
			_CanvasClear()
	EndSwitch
EndFunc

Func _KeyEventToStateStr($tInputRecord)
	Local $iState = DllStructGetData($tInputRecord, "ControlKeyState"), $sRet = ""

	If BitAND($iState, $SHIFT_PRESSED) Then $sRet = "+"
	If BitAND($iState, BitOR($RIGHT_ALT_PRESSED, $LEFT_ALT_PRESSED)) Then $sRet = "!" & $sRet
	If BitAND($iState, BitOR($RIGHT_CTRL_PRESSED, $LEFT_CTRL_PRESSED)) Then $sRet = "^" & $sRet

	Return $sRet
EndFunc

Func _KeyEventToHotkey($tInputRecord)
	Local $sKey = StringStripWS(DllStructGetData($tInputRecord, "Char"), 8)

	If $sKey = "" Then Return ""

	$sKey = StringLower(Chr(DllStructGetData($tInputRecord, "VirtualKeyCode")))

	Return _KeyEventToStateStr($tInputRecord) & $sKey
EndFunc

Func _conmain($pInputRecord)
	Local $tInputRecord

	$tInputRecord = DllStructCreate($tagINPUT_RECORD, $pInputRecord)

	Switch DllStructGetData($tInputRecord, "EventType")
		Case $KEY_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_KEY, $pInputRecord)

			_Console_WriteOutputCharacter(-1, _
					StringFormat("%8.8s", _KeyEventToStateStr($tInputRecord)), 0, $CanvasHeight - 2)

			_keyevent($tInputRecord)
		Case $MOUSE_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_MOUSE, $pInputRecord)

			_mouseevent($tInputRecord)
	EndSwitch
EndFunc

Func _Console_FillSquare($x, $y, $col)
	Local $aAttr[] = [_Color($col)]
	_Console_WriteOutputAttribute(-1, $aAttr, $x, $y)
EndFunc

Func _Console_Clear()
	Local $aSize = _Console_GetScreenBufferSize()
	Local $iDefAttr = _Console_GetScreenBufferAttributes()

	_Console_FillOutputAttribute(-1, $iDefAttr, $aSize[0] * $aSize[1], 0, 0)
	_Console_FillOutputCharacter(-1, " ", $aSize[0] * $aSize[1], 0, 0)
	_Console_SetCursorPosition(-1, 0, 0)
EndFunc

Func _Color($sName)
	If $sName = "fg" Then
		$sName = $FgColor
	ElseIf $sName = "bg" Then
		$sName = $BgColor
	EndIf

	For $i = 0 to UBound($aColors) - 1
		If $aColors[$i][0] = $sName Then return $aColors[$i][1]
	Next

	Return SetError(1, 0, 0)
EndFunc

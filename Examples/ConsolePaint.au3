
#include "../Console.au3"

If $__gfIsCUI Then
	MsgBox(0, "Running from SciTE?", "This program has to be run outside of SciTE.")
	Exit
EndIf

_Console_Alloc()

_Console_SetTitle("Console Paint")
_Console_SetIcon(@SystemDir & "\mspaint.exe")
_Console_Clear()
_Console_SetScreenBufferSize(-1, 128, 64)
WinMove(_Console_GetWindow(), "", 100, 100, 10000, 10000)

While 1
	$tData = _Console_ReadInputRecord()

	_process(DllStructGetPtr($tData))
WEnd

_Console_Free()
Exit

Func _process($pInputRecord)
	Local $tInputRecord

	$tInputRecord = DllStructCreate($tagINPUT_RECORD, $pInputRecord)

	Switch DllStructGetData($tInputRecord, "EventType")
		Case $KEY_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_KEY, $pInputRecord)
		Case $MOUSE_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_MOUSE, $pInputRecord)

			Switch DllStructGetData($tInputRecord, "EventFlags")
				Case 0, $MOUSE_MOVED
					_Console_SetCursorPosition(-1, _
								DllStructGetData($tInputRecord, "MousePositionX"), _
								DllStructGetData($tInputRecord, "MousePositionY"))

					If DllStructGetData($tInputRecord, "ButtonState") = $FROM_LEFT_1ST_BUTTON_PRESSED Then
						_Console_FillSquare( _
								DllStructGetData($tInputRecord, "MousePositionX"), _
								DllStructGetData($tInputRecord, "MousePositionY"), _
								Chr(35))
					ElseIf DllStructGetData($tInputRecord, "ButtonState") = $RIGHTMOST_BUTTON_PRESSED Then
						_Console_FillSquare( _
								DllStructGetData($tInputRecord, "MousePositionX"), _
								DllStructGetData($tInputRecord, "MousePositionY"), _
								" ")
					EndIf
				Case $DOUBLE_CLICK
				Case $MOUSE_HWHEELED
				Case $MOUSE_WHEELED
			EndSwitch
	EndSwitch
EndFunc

Func _Console_FillSquare($x, $y, $char)
	_Console_WriteOutputCharacter(-1, $char, $x, $y)
EndFunc

Func _Console_Clear()
	Local $aSize = _Console_GetScreenBufferSize()

	_Console_FillOutputCharacter(" ", $aSize[0] * $aSize[1], 0, 0)
	_Console_SetCursorPosition(-1, 0, 0)
EndFunc


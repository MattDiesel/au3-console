#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include "..\Console.au3"

_Example()
Exit

Func _Example()
	_Console_Alloc()
	_Console_SetMode(-1, $ENABLE_WINDOW_INPUT)

	While 1
		$tData = _Console_ReadInputRecord()

		_Console_PrintEventRecord(DllStructGetPtr($tData))
	WEnd

	_Console_Pause()
	_Console_Free()
EndFunc   ;==>_Example

Func _Console_PrintEventRecord($pInputRecord)
	Local $tInputRecord

	$tInputRecord = DllStructCreate($tagINPUT_RECORD, $pInputRecord)

	Switch DllStructGetData($tInputRecord, "EventType")
		Case $KEY_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_KEY, $pInputRecord)

			If DllStructGetData($tInputRecord, "KeyDown") Then
				_Console_WriteLine("Key Pressed: " & _
						DllStructGetData($tInputRecord, "Char") & " (" & _
						DllStructGetData($tInputRecord, "VirtualKeyCode") & ")")
			Else
				_Console_WriteLine("Key Released: " & DllStructGetData($tInputRecord, "Char") & " (" & _
						DllStructGetData($tInputRecord, "VirtualKeyCode") & ")")
			EndIf
		Case $MOUSE_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_MOUSE, $pInputRecord)

			Switch DllStructGetData($tInputRecord, "EventFlags")
				Case 0
					If DllStructGetData($tInputRecord, "ButtonState") = $FROM_LEFT_1ST_BUTTON_PRESSED Then
						_Console_WriteLine("Left button press")
					ElseIf DllStructGetData($tInputRecord, "ButtonState") = $RIGHTMOST_BUTTON_PRESSED Then
						_Console_WriteLine("Right button press")
					Else
						_Console_WriteLine("Button Press")
					EndIf
				Case $DOUBLE_CLICK
					_Console_WriteLine("Double Click")
				Case $MOUSE_HWHEELED
					_Console_WriteLine("Horizontal mouse wheel")
				Case $MOUSE_WHEELED
					_Console_WriteLine("Vertical mouse wheel")
				Case $MOUSE_MOVED
					;_Console_WriteLine("Mouse moved")
				Case Else
					_Console_WriteLine("Unknown mouse event")
			EndSwitch
		Case $WINDOW_BUFFER_SIZE_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_SIZE, $pInputRecord)

			_Console_WriteLine("Window Buffer Size Event (now " & _
					DllStructGetData($tInputRecord, "SizeX") & "x" & _
					DllStructGetData($tInputRecord, "SizeY"))
		Case $MENU_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_MENU, $pInputRecord)

			_Console_WriteLine("./log.txt", "Menu Event id: " & $tInputRecord.CommandId)
		Case $FOCUS_EVENT
			$tInputRecord = DllStructCreate($tagINPUT_RECORD_FOCUS, $pInputRecord)

			If DllStructGetData($tInputRecord, "SetFocus") Then
				_Console_WriteLine("Focused")
			Else
				_Console_WriteLine("Lost focus")
			EndIf
		Case Else
			ConsoleWrite("Unknown event type. Raw struct data:" & BinaryToString($tInputRecord) & @LF)
	EndSwitch
EndFunc   ;==>_Console_PrintEventRecord

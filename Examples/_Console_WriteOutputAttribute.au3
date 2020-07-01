#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Console.au3'

_Example()
Exit

Func _Example()
	_Console_Alloc()

	; main script starts here
	Local $attr[11]
	For $i = 0 To 10 Step 2
		; combine all for white... lame
		$attr[$i] = BitOR($BACKGROUND_RED, $FOREGROUND_RED, $FOREGROUND_GREEN, $FOREGROUND_BLUE, $BACKGROUND_INTENSITY, $FOREGROUND_INTENSITY)
	Next
	For $i = 1 To 9 Step 2
		$attr[$i] = BitOR($BACKGROUND_RED, $BACKGROUND_GREEN, $BACKGROUND_BLUE, $FOREGROUND_RED, $BACKGROUND_INTENSITY, $FOREGROUND_INTENSITY)
	Next

	_Console_SetCursorPosition(-1, 10, 3)
	;_Console_Write("hello world")
	Local $r = _Console_WriteOutputAttribute(-1, $attr, 10, 3)
	_Console_WriteLine(@CRLF & "return: " & $r & " : " & @extended)
	_Console_Pause()
	_Console_Free()
EndFunc   ;==>_Example

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Console.au3'

_Example()
Exit

Func _Example()
	Local $iPid = Run("cmd.exe")
	ProcessWait($iPid)

	_Console_Attach($iPid)

	Local $aSize = _Console_GetScreenBufferSize()

	Local $sHeader = _Console_ReadOutputCharacter(-1, $aSize[0], 0, 0)

	MsgBox(0, "Test", $sHeader)

	_Console_Free()
	ProcessClose($iPid)

EndFunc   ;==>_Example

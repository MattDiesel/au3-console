#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Console.au3'

_Example()
Exit

Func _Example()
	_Console_Alloc()
	_Console_Write("Hello world" & @CRLF)
	_Console_Pause()
	_Console_Free()
EndFunc   ;==>_Example

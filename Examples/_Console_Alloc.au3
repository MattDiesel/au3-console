#include '..\Console.au3'
_Example()

Func _Example()
	_Console_Alloc()
	_Console_Write("Please enter your name: ")

	Local $s = _Console_Read()
	_Console_Write("Hello " & $s & "!" & @LF)

	_Console_Pause()
	_Console_Free()
EndFunc   ;==>_Example

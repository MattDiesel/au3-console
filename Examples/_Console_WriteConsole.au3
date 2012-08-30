
#include '..\Console.au3'

_Console_Alloc()

Local $hConsole = _Console_GetStdHandle($STD_OUTPUT_HANDLE)

_Console_WriteConsole($hConsole, "Hello world" & @CRLF)

_Console_Pause()
_Console_Free()
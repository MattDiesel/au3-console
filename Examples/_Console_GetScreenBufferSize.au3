
#include <Console.au3>

$iPid = Run("cmd.exe")
ProcessWait($iPid)

_Console_Attach($iPid)

$aSize = _Console_GetScreenBufferSize()

$sHeader = _Console_ReadOutputCharacter(-1, $aSize[0], 0, 0)

MsgBox(0, "Test", $sHeader)

_Console_Free()
ProcessClose($iPid)
Exit

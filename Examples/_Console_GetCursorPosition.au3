#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include <String.au3>
#include '..\Console.au3'

_Example()
Exit

Func _Example()
	_Console_Alloc()

	_Console_Write("Loading file: ")

	Local $aiSize = _Console_GetScreenBufferSize()
	If @error Then Exit 1

	Local $aiPos = _Console_GetCursorPosition()

	Local $a = _Console_ProgressCreate(-1, $aiPos[0], $aiPos[1], $aiSize[0] - $aiPos[0])

	_Console_SetCursorVisible(-1, False)
	For $i = 1 To 100
		_Console_ProgressSet($a, $i)

		Sleep(50)
	Next

	_Console_SetCursorPosition(-1, 0, $aiPos[1] + 1)
	_Console_SetCursorVisible(-1, True)

	_Console_Pause()
	_Console_Free()


EndFunc   ;==>_Example

Func _Console_ProgressCreate($hConsole, $x, $y, $w, $sStartChr = "[", $sEndChr = "]", $sEmptyChr = " ", $sFullChr = "=", $fShowPercent = True, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsole = -1 Then $hConsole = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aRet[10] = [$hConsole, $hDll, $x, $y, $w, $sStartChr, $sEndChr, $sEmptyChr, $sFullChr, $fShowPercent]
	_Console_ProgressSet($aRet, 0)

	Return $aRet
EndFunc   ;==>_Console_ProgressCreate

Func _Console_ProgressSet($aProg, $iPercent)
	Local $iWidth, $sPer, $iPerStart

	$iWidth = Floor(($aProg[4] - StringLen($aProg[5]) - StringLen($aProg[6])) * $iPercent / 100)
	$sPer = Round($iPercent, 1) & "%"
	$iPerStart = Ceiling(($aProg[4] - StringLen($sPer)) / 2)

	Local $s = $aProg[5] & _StringRepeat($aProg[8], $iWidth) & _StringRepeat($aProg[7], $aProg[4] - $iWidth - StringLen($aProg[5]) - StringLen($aProg[6])) & $aProg[6]

	If $aProg[9] Then $s = StringLeft($s, $iPerStart) & $sPer & StringTrimLeft($s, $iPerStart + StringLen($sPer))

	_Console_WriteOutputCharacter($aProg[0], $s, $aProg[2], $aProg[3], Default, $aProg[1])

	Return True
EndFunc   ;==>_Console_ProgressSet

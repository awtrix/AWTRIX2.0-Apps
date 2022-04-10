B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private Duration As Long
	Private Scrolling As Boolean
	Private NextTime As Long
	Private Nb As Int
	Private CurrentWidget As Int
	Private NextWidget As Int
	Private Offset As Int
End Sub

Public Sub Initialize(aDuration As Long, aNb As Int)
	Duration = aDuration * 1000 / aNb
	Scrolling = True
	NextTime = DateTime.Now + Duration
	Nb = aNb
	CurrentWidget = 0
	NextWidget = computeNext
	Offset = 0
End Sub

Public Sub getOffset(Widget As Int) As Int
	If Widget = CurrentWidget Then
		Return Offset
	Else If Widget = computeNext Then
		Return Offset - 8
	Else
		' 8 = No need to display
		Return 8 
	End If
	
End Sub

Private Sub computeNext As Int
	Return IIf(CurrentWidget = Nb - 1, 0, CurrentWidget + 1)
End Sub

Public Sub update
	If Scrolling Then
		If Offset<8 Then
			Offset=Offset+1
		Else
			Scrolling = False
			Offset=0
			CurrentWidget = NextWidget
			NextWidget = computeNext
		End If
	Else If DateTime.Now > NextTime Then
		Scrolling = True
		NextTime = NextTime + Duration
	End If
End Sub
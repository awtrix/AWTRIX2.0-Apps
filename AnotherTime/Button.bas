B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private pressedTime As Long
	Private tapping As Boolean
	Private duration As Int
	Private taps As Int
	Private tapDuration As Int
	Private maxTaps As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(aDuration As Int, aMaxTaps As Int, aTapDuration As Int)
	maxTaps = aMaxTaps
	tapDuration = aTapDuration
	duration = aDuration
	reset
End Sub

Private Sub reset
	pressedTime = 0
	tapping = False
	taps = 0
End Sub

' Has to be called every Tick
Public Sub update
	
	If taps = 0 Then
		Return
	End If
	
	Dim now As Long = DateTime.Now
	
	If tapping And now < pressedTime + tapDuration Then 
		' Not updated because still tapping
		Return
	Else If tapping Then
		' Tapping finished
		pressedTime = now
		tapping = False
	Else If now > pressedTime + duration Then
		reset
	End If
End Sub

Public Sub push
	Dim now As Long = DateTime.Now
	If taps > 0 Then 
		If now < pressedTime + tapDuration Then
			pressedTime = now
			taps = taps + 1
			If taps > maxTaps Then
				' If too much taps, stick to maxTaps
				taps = maxTaps
			End If
		Else
			' Tapping finished
			tapping = False
		End If
	Else If now > pressedTime + duration Then
		' First tap
		taps = 1
		tapping = True
		pressedTime = now
	End If

	' Update now, don't wait for next tick to don't interfere with tapDuration	
	update
End Sub

Public Sub getPressed As Boolean
	Return Not(tapping) And taps = 1
End Sub

Public Sub getDoublePressed As Boolean
	Return Not(tapping) And taps = 2
End Sub
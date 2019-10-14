B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim blinkIndex() As Int = Array As Int( 1, 2, 3, 4, 3, 2, 1 )
	Dim blinkCountdown As Int = 30
	Dim gazeCountdown As Int  =  30
	Dim gazeFrames As Int    =  5

	Dim eyeX As Int = 9
	Dim eyeY As Int  = 3
	Dim newX As Int  = 9
	Dim newY As Int  = 3
	Dim dX As Int    = 6
	Dim dY As Int    = 0
	Dim PET_MOOD As Int = 0
	
	Dim n0() As Short = Array As Short(0, 0, 65535, 65535, 65535, 65535, 0, 0, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 65535, 65535, 65535, 65535, 0, 0)
	Dim n1() As Short = Array As Short(0, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 65535, 65535, 65535, 65535, 0, 0)
	Dim n2() As Short = Array As Short(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 65535, 65535, 65535, 0, 0, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	Dim n3() As Short = Array As Short(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 65535, 65535, 65535, 0, 0, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 0, 65535, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	Dim n4() As Short = Array As Short(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 0, 0, 0, 0, 0, 0, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	Dim eye As List 
End Sub


' ignore
Public Sub Initialize() As String
	
	eye.Initialize
	
	eye.AddAll(Array(n0,n1,n2,n3,n4))
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="LookingEyes"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Just some looking eyes:)"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=709
		
	'Tickinterval in ms (should be 65 by default)
	App.Tick=90
	
	App.MakeSettings
	Return "AWTRIX20"
	
End Sub
	
' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_genFrame
	If blinkCountdown < blinkIndex.Length-1 Then
		App.drawBMP(6,0,eye.get(blinkIndex(blinkCountdown)),8,8)
		App.drawBMP(18,0,eye.get(blinkIndex(blinkCountdown)),8,8)
	Else
		App.drawBMP(6,0,eye.get(0),8,8)
		App.drawBMP(18,0,eye.get(0),8,8)
	End If
	
	blinkCountdown=blinkCountdown-1
	If blinkCountdown = 0 Then
		blinkCountdown = Rnd(5, 110)
	End If
	
	If (gazeCountdown < gazeFrames) Or (gazeCountdown = gazeFrames) Then
		gazeCountdown=gazeCountdown-1
		App.drawRect(newX - (dX * gazeCountdown / gazeFrames)+6,	newY - (dY * gazeCountdown / gazeFrames),2,2,Array As Int(0,0,0))
		App.drawRect(newX - (dX * gazeCountdown / gazeFrames)+18,	newY - (dY * gazeCountdown / gazeFrames),2,2,Array As Int(0,0,0))
		If gazeCountdown = 0 Then
			eyeX = newX
			eyeY = newY
			Do Until(((dX * dX + dY * dY) > 3) Or ((dX * dX + dY * dY) = 3))
				If (PET_MOOD = 0) Then
					newX = Rnd(0,6)
					newY = Rnd(0,6)
					dX   = newX-4
					dY   = newY-4
				End If

				If (PET_MOOD = 1) Then
					newX = Rnd(0,7)
					newY = Rnd(0,7)
					dX   = newX - 3
					dY   = newY - 3
				End If

				If (PET_MOOD = 2) Then
					newX = Rnd(1,7)
					newY = Rnd(1,4)
					dX   = newX - 3
					dY   = newY - 3
				End If

				If (PET_MOOD = 3) Then
					newX = Rnd(0,7)
					newY = Rnd(3,7)
					dX   = newX - 3
					dY   = newY - 3
				End If
			Loop
			dX            = newX - eyeX
			dY            = newY - eyeY
			gazeFrames    = Rnd(3, 5)
			gazeCountdown = Rnd(gazeFrames, 30)
		End If
	Else
		gazeCountdown=gazeCountdown-1
		App.drawRect(eyeX+6,eyeY,2,2,Array As Int(0,0,0))
		App.drawRect(eyeX+18,eyeY,2,2,Array As Int(0,0,0))
	End If
End Sub

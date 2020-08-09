B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.31
@EndOfDesignText@
Sub Class_Globals
	Dim x As Int
	Dim y As Int
	Dim color() As Int
	Dim breakable,destroyed As Boolean
	Dim hits As Int
	Dim colors() As Object = Array As Object(Array As Int(153, 25, 25),Array As Int(178, 25, 25),Array As Int(255,0,0),Array As Int(255,0,0))
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	color=colors(0)
End Sub

Public Sub hit
	If breakable And Not(destroyed) Then
		hits=hits+1
		color=colors(hits)
		If hits=3 Then
			destroyed=True
		End If
	End If
End Sub

Public Sub reset
	hits=0
	destroyed=False
End Sub

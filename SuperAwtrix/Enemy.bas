B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.31
@EndOfDesignText@
Sub Class_Globals
	Private moveTimer As Timer
	Dim xPos As Int
	Dim yPos As Int
	Dim savexPos As Int
	Dim saveyPos As Int
	Dim color()As Int
	Dim direction As Boolean
	Dim blocklist As List
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(x As Int,y As Int,dir As Boolean,speed As Int,blocks As List)
	Select speed
		Case 1
			moveTimer.Initialize("move",300)
		Case 2
			moveTimer.Initialize("move",200)
		Case 3
			moveTimer.Initialize("move",100)
		Case Else
			moveTimer.Initialize("move",300)
	End Select
	savexPos=x
	saveyPos=y
	blocklist=blocks
	xPos=x
	yPos=y
	color= Array As Int(255,0,0)
	direction=dir
End Sub

Public Sub setBlocks(blocks As List)
	blocklist=blocks
End Sub

Public Sub reset
	xPos=savexPos
	yPos=saveyPos
	moveTimer.Enabled=True
End Sub

Public Sub stop
	moveTimer.Enabled=False
End Sub

'move enemy with every timer tick
Private Sub move_tick
	Select direction
		Case False 'move right
			If Not(isCollideX(xPos+1,yPos)) Then
				If isCollideY(xPos,yPos+1) Then 'only move if touching the ground
					xPos=xPos+1
				End If
			Else
				direction=Not(direction) 'Change direction
			End If
		Case True 'move left
			If Not(isCollideX(xPos-1,yPos)) Then
				If isCollideY(xPos,yPos+1) Then 'only move if touching the ground
					xPos=xPos-1
				End If
			Else
				direction=Not(direction) 'Change direction
			End If
	End Select
	
	If Not(isCollideY(xPos,yPos+1)) Then
		yPos=yPos+1 'Gravity
	End If
	
End Sub

Private Sub isCollideX(x As Int, y As Int) As Boolean
	For i=0 To blocklist.Size-1
		Dim b As Block=blocklist.Get(i)
		If b.y=y And x = b.x Then
		
			Return True
		End If
	Next
	Return False
End Sub

Private Sub isCollideY(x As Int, y As Int) As Boolean
	For i=0 To blocklist.Size-1
		Dim b As Block=blocklist.Get(i)
		If x = b.x And b.y=y Then
			Return True
		End If
	Next
	Return False
End Sub
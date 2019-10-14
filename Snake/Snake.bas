B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim MAX_SNAKE_LENGTH  As Byte = 15
	Dim direction As Byte
	Dim snakeX(MAX_SNAKE_LENGTH) As Byte                       ' X-coordinates of snake
	Dim snakeY(MAX_SNAKE_LENGTH) As Byte                      'Y-coordinates of snake
	Dim snakeLength  As Byte= 1                              ' nr of parts of snake
	Dim  fruitX, fruitY As Int
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Snake"
	
	'Version of the App
	App.version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Play the classic mobile Snake game on your AWTRIX"
		
	App.Author="Blueforcer"
	
	App.CoverIcon=681
	
	App.howToPLay="The game is pretty self-explanatory. Your objective, as the snake, is to eat the square and continue growing."
	
	App.Tags=Array As String("Beta","Games","Interactive")
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=250
	
	App.isGame=True
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True

	App.Hidden=True
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_controllerButton(button As Int, pressed As Boolean)
	
	Select button
		Case 12
			direction=0
		Case 15
			direction=1
		Case 13
			direction=2
		Case 14
			direction=3
	End Select
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	snakeX(0) = 4
	snakeY(0) = 7
	direction=0
	For i=1 To MAX_SNAKE_LENGTH-1
		snakeX(i) = -1
		snakeY(i) = -1
	Next
	makeFruit
End Sub


'With this sub you build your frame.
Sub App_genFrame
	nextstep
	For i=0 To snakeLength-1
		App.drawPixel(snakeX(i), snakeY(i),Array As Int(0,255,0))
	Next
	If inPlayField(fruitX, fruitY) Then
		App.drawPixel(fruitX, fruitY, Array As Int(255,0,0))
	End If
End Sub

Sub userLose
	snakeLength = 1
End Sub

Sub userWin
	snakeLength = 1
End Sub

Sub inPlayField(x As Int,y As Int) As Boolean
	Return (x>=0) And (x<32) And (y>=0) And (y<8)
End Sub

Sub isPartOfSnake(x As Int,y As Int) As Boolean
	For i=0 To snakeLength-2
		If ((x = snakeX(i)) And (y = snakeY(i))) Then
			Return True
		End If
	Next
	Return False
End Sub

Sub snakeCheck
	For i=1 To snakeLength-1
		If (snakeX(0) = snakeX(i)) And (snakeY(0) = snakeY(i)) Then
			userLose
			Return
		End If
	Next
    
	If (snakeLength = MAX_SNAKE_LENGTH) Then userWin
End Sub

Sub makeFruit
	Dim x, y As Int
	x = Rnd(1, 31)
	y = Rnd(1, 7)
	
	Do While(isPartOfSnake(x, y))
		x = Rnd(1, 31)
		y = Rnd(1, 7)
	Loop
		
	fruitX = x
	fruitY = y
End Sub

Sub nextstep
	For i = snakeLength To 1 Step -1
		If((direction = 1) And (snakeX(0)-snakeLength = 32)) Then
			snakeX(0) = -1
		else if((direction = 3) And (snakeX(0) + snakeLength = 0)) Then
			snakeX(0) = 32
		Else
			snakeX(i) = snakeX(i-1)
		End If
		If((direction = 0) And (snakeY(0)+snakeLength = 1))Then
			snakeY(0) = 8
		else if((direction = 2) And (snakeY(0)-snakeLength = 7))Then
			snakeY(0) = -1
		Else
			snakeY(i) = snakeY(i-1)
		End If
	Next
	  
	Select(direction)
		Case 0
			snakeY(0) = snakeY(0)-1
		Case 1
			snakeX(0) = snakeX(0)+1
		Case 2
			snakeY(0) = snakeY(0)+1
		Case 3
			snakeX(0)=snakeX(0)-1
	End Select
  
	If((snakeX(0) = fruitX) And (snakeY(0) = fruitY)) Then
		snakeLength=snakeLength+1
		If(snakeLength < MAX_SNAKE_LENGTH) Then
			makeFruit
		Else
			fruitX = -1
			fruitY = -1
		End If
	End If
	snakeCheck
End Sub
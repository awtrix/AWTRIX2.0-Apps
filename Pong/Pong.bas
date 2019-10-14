B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim paddleX As Int = 1
	Dim paddleY As Int =7
	Dim ballDirectionX As Int =1
	Dim ballDirectionY As Int =1
	Dim points,score,ballX, ballY, oldBallX, oldBallY,oldPaddleX, oldPaddleY As Int
	Dim prevMillis As Long
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
	App.Name="Pong"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Play the classic Pong game on your AWTRIX"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=680
	
	App.Tags=Array As String("Beta","Games","Interactive")
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
	
	App.isGame=True
	
	App.Hidden=True
	
	App.ShouldShow=False
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_externalCommand(cmd As Object)
	App.ShouldShow=True
	paddleX=cmd
End Sub

Sub App_AppExited
	App.ShouldShow=False
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	paddleX=1
	points=0
	oldBallX=0
	oldBallY=0
	ballDirectionY=1
	ballDirectionX=1
	ballX = Rnd(3,19)
	ballY = 1
End Sub

'With this sub you build your frame.
Sub App_genFrame
	If paddleX=255 Then
		App.finish
		App.ShouldShow=False
	End If
	
	App.drawRect(paddleX, paddleY, 4, 1,Array As Int(0,0,255))
	oldPaddleX = paddleX
	oldPaddleY = paddleY
	
	If (DateTime.Now - prevMillis >= 150) Then
		prevMillis=DateTime.Now
	
		If (ballX > 30) Then
			ballDirectionX = ballDirectionX-1
		End If
	
		If  ballX < 1 Then
			ballDirectionX = ballDirectionX+1
		End If

		If ballY > 8 Then
			ballDirectionY = ballDirectionY-1
		End If
	
		If ballY < 1 Then
			ballDirectionY = ballDirectionY+1
		End If
	
		If (inPaddle(ballX, ballY, paddleX, paddleY, 4, 1)) Then
			App.drawRect(paddleX, paddleY, 4, 1,Array As Int(255,0,255))
			If(ballX = paddleX And ballY = paddleY) Then
				ballDirectionX = ballDirectionX-1
				ballDirectionY = ballDirectionY-1
   
			else if(ballX = paddleX + 3 And ballY = paddleY) Then
				ballDirectionX = ballDirectionX
				ballDirectionY = ballDirectionY-1
    
			else if(ballX = paddleX + 1 And ballY = paddleY) Then
				ballDirectionX = ballDirectionX-1
				ballDirectionY = ballDirectionY-1
     
			else if(ballX = paddleX + 2 And ballY = paddleY) Then
				ballDirectionX = ballDirectionX
				ballDirectionY = ballDirectionY-1
			End If
		End If
	
		ballX =ballX + ballDirectionX
		ballY = ballY +  ballDirectionY
	
		oldBallX = ballX
		oldBallY = ballY
	End If
	
	App.drawPixel(ballX, ballY,Array As Int(150,150,0))
	
	If(ballY > 8) Then
		points=0
		oldBallX=0
		oldBallY=0
		ballDirectionY=1
		ballDirectionX=1
		ballX = Rnd(3,19)
		ballY = 1
	End If
End Sub

Sub inPaddle(x As Int,y As Int,rectX As Int,rectY As Int,rectWidth As Int,rectHeight As Int) As Boolean
	Dim result As Boolean=False
	If ((x >= rectX And x <= (rectX + rectWidth)) And(y+1 >= rectY And y <= (rectY + rectHeight))) Then
		result = True
		points=points+1
	End If
	Return result
End Sub

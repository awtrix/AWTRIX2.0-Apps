B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	'Declare your variables here
	Dim MAX_LEVEL As Byte = 100
	Dim SEQUENCE(MAX_LEVEL) As Byte
	Dim USER_SEQUENCE(MAX_LEVEL) As Byte
	Dim LEVEL As Byte =0
	Dim steps As Int = 0
	Dim GameState As Int
	Dim input As Int
	Dim blank As Boolean
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
	App.Name="SimonSays"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Play the classic Simon Says game on your AWTRIX"
		
	App.Author="Blueforcer"
	
	App.CoverIcon=689
	
	App.Tags=Array As String("Beta","Games","Interactive")
	
	'How many downloadhandlers should be generated
	App.Downloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int()
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=650
	
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
	input=cmd
	
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	reset
End Sub

Sub App_AppExited
	App.ShouldShow=False
End Sub

Sub genSequenz
	For  i = 0 To MAX_LEVEL-1
		SEQUENCE(i) = Rnd(1,5)
	Next
End Sub

'With this sub you build your frame.
Sub App_genFrame
	App.fill(Array As Int(0,0,0))
	If input=5 Then App.finish
	Select GameState
		Case 0
			showSequence
		Case 1
			showGO
		Case 2
			CheckInput
		Case 3
			showFail
		Case 4
			showGreat
		Case 5
			showReady
	End Select
End Sub

Sub CheckInput
	
	If GameState=2 And Not(input=0) Then
		Select input
			Case 1
				Show1
			Case 2
				Show2
			Case 3
				Show3
			Case 4
				Show4
		End Select

		USER_SEQUENCE(steps)=input
		input=0
		
		If steps=LEVEL Then 'win
			steps=0
			GameState=4
			LEVEL=LEVEL+1
			Return
		End If
	
		If Not(SEQUENCE(steps)=USER_SEQUENCE(steps)) Then 'loose
			reset
			GameState=3
			
			Return
		End If
		steps=steps+1
	End If
End Sub


Sub showSequence
	If blank=False Then
		blank=True
			If steps<=LEVEL Then
		Select SEQUENCE(steps)
			Case 1
				Show1
			Case 2
				Show2
			Case 3
				Show3
			Case 4
				Show4
		End Select
		steps=steps+1
	
	Else
		steps=0
		GameState=1
	End If
	Else
		blank=False
	End If
End Sub

Sub Show1
	App.drawRect(0,0,8,8,Array As Int(0,255,0))
End Sub

Sub Show2
	App.drawRect(8,0,8,8,Array As Int(255,0,0))
End Sub

Sub Show3
	App.drawRect(16,0,8,8,Array As Int(255,255,0))
End Sub

Sub Show4
	App.drawRect(24,0,8,8,Array As Int(0,0,255))
End Sub

Sub showGreat
	App.genText("GREAT!",False,1,Array As Int(0,255,0),False)
	GameState=5
End Sub

Sub showFail
	App.genText("FAIL!",False,1,Array As Int(255,0,0),False)
	reset
End Sub

Sub showGO
	App.genText("GO!",False,1,Array As Int(0,255,255),False)
	GameState=2
End Sub

Sub showReady
	If blank=False Then
	blank=True
	App.genText("Ready?",False,1,Array As Int(0,255,255),False)
	GameState=0
	Else
		blank=False
	End If
End Sub

Sub reset
	steps=0
	LEVEL=0
	GameState=5
	genSequenz
End Sub
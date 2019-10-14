B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim dice1 As Int
	Dim dice2 As Int
	Dim dice3 As Int
	Dim iconOffset As Int = 780
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "Dice"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Roll the dice...
	"$
	
	'The developer if this App
	App.author = "Matthias Wahl"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 783
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("NumberDice":"1")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>This App show dice each loop.<br/>
	<b>NumberDice: You decide the number of dice (1/2/3).<br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Dice", "Random")
	
	'How many downloadhandlers should be generated
	App.downloads = 0
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(785,784,783,782,781,780)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = False
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	dice1 = Rnd(1, 7)
	dice2 = Rnd(1, 7)
	dice3 = Rnd(1, 7)
End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'this sub is called right before AWTRIX will display your App.
'if you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'if you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'if you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	Select App.get("NumberDice")
		Case "1"
			App.drawBMP(12,0,App.getIcon(779+dice1),8,8)
		Case "2"
			App.drawBMP(5,0,App.getIcon(779+dice1),8,8)
			App.drawBMP(19,0,App.getIcon(779+dice2),8,8)
		Case "3"
			App.drawBMP(2,0,App.getIcon(779+dice1),8,8)
			App.drawBMP(12,0,App.getIcon(779+dice2),8,8)
			App.drawBMP(22,0,App.getIcon(779+dice3),8,8)
	End Select
	
End Sub
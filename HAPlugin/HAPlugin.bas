B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim state As String
	state = "Hallo"
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
	App.name = "HA-Screen"
	Log(App.name&": Intialize")
	'Version of the App
	App.version = "0.1"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	This is just a test
	"$
	
	'The developer if this App
	App.author = "LuBeDa"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 46
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("Topic":"/awtrix/screen")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	First Test<BR>
	<b>Token:</b>longlived Token from HomeAssistant<br/>
	<b>URL:</b>The URL of your Home Assistant<br/>
	<b>Sensor:</b>The entityname of your sensor<br/>
	<b>Icon:</b>The ID of an Icon<br/>
	"$
	
	App.Settings=CreateMap("URL":"","Token":"","Sensor":"sun.sun","Icon":423)
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Template", "Awesome")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(46)
	
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
	
End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'this sub is called right before AWTRIX will display your App.
'if you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	App.Icons = Array As Int(App.get("Icon"))
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
			App.Download(App.Get("URL") & "/api/states/" & App.get("Sensor"))
			App.setHeader(CreateMap("Authorization":"Bearer " & App.get("Token")))
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
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					state = root.Get("state")
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(state ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(App.Get("Icon")),8,8)
End Sub
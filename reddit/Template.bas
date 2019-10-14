B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim first_name As String
	
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
	App.name = "Template"
	
	'Version of the App
	App.version = "2.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	This is just a template
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 6
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("CustomText":"Hello World")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>CustomText:</b>Text wich will be shown<br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Template", "Awesome")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(6)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = False
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False
	
	App.InitializeOAuth("https://www.reddit.com/api/v1/authorize","https://www.reddit.com/api/v1/access_token","6cwWWPIyo4NJtQ","0kLtLu5zCDpn1zvFOFPhVrmnxcY","mysubreddits")

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
			App.Download("https://www.reddit.com/api/v1/me/karma")
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
					Log(Resp.ResponseString)
'					Dim parser As JSONParser
'					parser.Initialize(Resp.ResponseString)
'					Dim root As Map = parser.NextObject
'					Dim data As Map = root.Get("data")
'					first_name = data.Get("first_name")
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(App.get("CustomText") & " " & first_name ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(6),8,8)
End Sub
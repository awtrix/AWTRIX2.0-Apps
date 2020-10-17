B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	Dim id As Int
	'Declare your variables here
	Dim t As Timer 
	Dim timestring As String = "00:00"
	Dim startAt As Long
	Dim sendCommand As Boolean
	Dim su As StringUtils
	Dim key As String
	Dim bc As ByteConverter
	Dim icon As Int = 1197
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
	t.Initialize("timer",1000)
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "Toggl"
	
	'Version of the App
	App.version = "1.2"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Starts or stops a Toggl task.<br>
	Powered by Toggl.com
	"$
	
	App.setupDescription= $"
	<ul>
  <li><b>APIkey</b>: You can find it under "My profile" in your Toggl account.</li>
  <li><b>Description</b>: Description of your task.</li>
  <li>To start or stop your task just press the middle button while the app is displayed.</li>
</ul>
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1197
	
	App.settings=CreateMap("APIkey":"","Description":"AWTRIX Event")
	
	'How many downloadhandlers should be generated
	App.downloads = 0
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1197,1196)
	
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
	
	Dim k As String = App.get("APIkey")
	If k.Length>0 Then
		key= su.EncodeBase64(bc.StringToBytes(App.get("APIkey") & ":api_token","utf-8"))
	End If
	
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
	key= su.EncodeBase64(bc.StringToBytes(App.get("APIkey") & ":api_token","utf-8"))
	Log(key)
End Sub

'if you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'if you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			If t.Enabled Then
				App.PostString("https://www.toggl.com/api/v8/time_entries/start",$"{"time_entry":{"description":"${App.get("Description")}","created_with":"AWTRIX"}}"$)
				App.SetContentType("application/json")
				App.Header=CreateMap("Authorization":$"Basic ${key}"$)
			Else
				App.PutString($"https://www.toggl.com/api/v8/time_entries/${id}/stop"$,"")
				App.SetContentType("application/json")
				App.Header=CreateMap("Authorization":$"Basic ${key}"$)
			End If
	End Select
	App.downloads = 0
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
					Dim data As Map = root.Get("data")
					id = data.Get("id")
			End Select
		Else
			App.shouldShow=False
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

Sub timer_tick
	Dim p As Period = DateUtils.PeriodBetween(startAt,DateTime.Now)
	If p.Hours=0 Then
		timestring=(NumberFormat(p.Minutes,2,2)&":"&NumberFormat(p.Seconds,2,2))
	Else
		timestring=NumberFormat(p.Hours,2,2)&":"&NumberFormat(p.Minutes,2,2)&":"&NumberFormat(p.Seconds,2,2)
	End If
End Sub

Sub App_buttonPush
	If t.Enabled Then
		t.Enabled=False
		timestring="00:00"
		icon=1197
	Else
		t.Enabled=True
		startAt=DateTime.Now
		icon=1196
	End If
	App.downloads = 1
	sendCommand =True
End Sub

'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	App.genText(timestring,True,1,Null,False)
	
	App.drawBMP(0,0,App.getIcon(icon),8,8)
	If sendCommand Then
		App.customCommand(CreateMap("type":"update"))
		sendCommand=False
	End If
End Sub
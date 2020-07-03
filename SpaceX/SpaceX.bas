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
	Dim launch_date_unix As Long
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
	App.name = "SpaceX"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Displays the countdown of the upcoming SpaceX launch.
	"$
	
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1177
	
		
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("rocket", "spacex", "countdown")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1177)
	
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
			App.Download("https://api.spacexdata.com/v3/launches/next")
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
					If root.ContainsKey("launch_date_unix") Then
						launch_date_unix = root.Get("launch_date_unix")*1000
						App.shouldShow=True
					Else
						App.shouldShow=False
					End If
			End Select
		Else
			App.shouldShow=False
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	Dim p As Period = DateUtils.PeriodBetween(DateTime.Now,launch_date_unix)
	
	If p.Days=0 And p.Hours=0 Then
		App.genText(NumberFormat(p.Minutes,2,0)&":"&NumberFormat(p.Seconds,2,0),True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1177),8,8)
		Return
	End If
	
	If p.Days=0 And p.Hours>0 Then
		App.genText(NumberFormat(p.Hours,2,0)&"H - "&NumberFormat(p.Minutes,2,0)&"M",True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1177),8,8)
		Return
	End If
	

	App.genText(NumberFormat(p.Days,2,0)&"D - "&NumberFormat(p.Hours,2,0)&"H",True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(1177),8,8)

	
End Sub
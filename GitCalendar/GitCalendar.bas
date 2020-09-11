B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim frame(256) As Short = Array As Short(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	
	Dim colors As List = Array(Array As Int(37,78,119), Array As Int(82,123,160), Array As Int(127,168,201), Array As Int(172,213,242), Array As Int(237,237,237))
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
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.Name = "GitCalendar"
	
	'Version of the App
	App.Version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description = $"
	Show your GitLab or GitHub activities in pixel style.
	"$
	
	'The developer if this App
	App.Author = "dreambt"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.CoverIcon = 514
	
	'needed Settings for this App wich can be configurate from user via webinterface. Dont use spaces here!
	App.Settings = CreateMap("host":"http://gitlab.yourhost.com", "account":"dreambt", "session":"xxx", "dateFormat":"yyyy-MM-dd")
		
	'Setup Instructions. You can use HTML to format it
	App.SetupDescription = $"
	<b>Notice:</b>You need provide your gitlab_session or github private token.<br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.Tags = Array As String("GitCalendar", "Gitlab", "Github", "dreambt")
	
	'How many downloadhandlers should be generated
	App.Downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.Icons = Array As Int(514)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick = 120
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock = False
	
	'This tolds AWTRIX that this App is an Game.
	App.IsGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.ForceDownload = False

	'ignore
	App.MakeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started

End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'This sub is called right before AWTRIX will display your App.
'If you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'If you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'If you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'This sub is called when the user presses the middle touchbutton while the app is running
Sub App_buttonPush
	
End Sub

'It possible to create your own setupscreen in HTML.
'This is a very dirty workaround, but its works:)
'Every input must contains an ID with the corresponding settingskey in lowercase
Sub App_CustomSetupScreen As String
	Return ""
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			'Log("API header: " & App.get("session"))
			'Log("API request: " & App.get("host")&"/users/"&App.get("account")&"/calendar.json")
			App.Download(App.get("host")&"/users/"&App.get("account")&"/calendar.json")
			App.SetHeader(CreateMap("Cookie":"_gitlab_session="&App.get("session")))
	End Select
End Sub

'Draw every single pixel into a complete 32x8 BMP to avoid sending massiv amount of drawing commands to the controller.
Sub drawPixel(x As Int, y As Int, color() As Int)
	If x>-1 And x<32 And y>-1 And y<8 Then
		'Calculate RGB585 from RGB888
		Dim NewBlue As Int = Bit.And(Bit.ShiftRight(color(2), 3), 0x1f)
		Dim NewGreen As Int  = Bit.ShiftLeft(Bit.And(Bit.ShiftRight(color(1), 2), 0x3f), 5)
		Dim NewRed As Int  = Bit.ShiftLeft(Bit.And(Bit.ShiftRight(color(0), 3), 0x1f), 11)
		frame(x + 32 * y) =  Bit.Or(Bit.Or(NewRed, NewGreen), NewBlue)
	End If
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	'Log("API response: " & Resp)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim minc As Short = 0
					Dim maxc As Short = 9999999
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					For Each k As String In root.Keys
						Dim v As Short = root.Get(k)
						If v>maxc Then
							maxc=v
						End If
						If v<minc Then
							minc=v
						End If
					Next
					Log("Max: " & maxc & ", Min: " & minc)

					Dim savedFormat As String= DateTime.DateFormat
					DateTime.DateFormat = App.get("dateFormat")
					Dim currentDate As Long = DateTime.Now
					Dim dayOfWeek As Short = DateTime.GetDayOfWeek(currentDate)
					currentDate = currentDate / 1000 / 86400
					
					For Each k As String In root.Keys
						Dim targetDate As Long = DateTime.DateParse(k) / 1000 / 86400
						Dim diff As Short = currentDate - targetDate
						Dim offset As Short = diff + 6 - dayOfWeek
						If offset >= 0 And offset < 256 Then
							Dim v As Short = root.Get(k)
							Dim x As Int = 32 - offset/7
							Dim y As Int = 7 - offset Mod 7
							Dim idx As Short = (v + 10) / 10
							If idx >= 5 Then
								idx = 4
							End If
							Log("k: " & k & ", x: " & x & ", y: " & y & ", diff: " & diff & ", v: " & v & ", idx: " & idx)
							drawPixel(x, y, colors.Get(idx))
						End If
					Next

					DateTime.DateFormat=savedFormat
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & Resp.ResponseString)
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.drawBMP(0,0,frame,32,8)
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim text As String
	Dim name As String
	Dim trophies As String
	Dim warStars As String
	Dim versusTrophies As String
	Dim framelist As List
	Dim error As Boolean
	Dim textcolor(3) As Int
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
	App.name = "ClashOfClans"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Clash of Clans ingame stats
	"$
	
	'The developer if this App
	App.author = "Elfish"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1544
	
	'needed Settings for this App wich can be configurate from user via webinterface. Dont use spaces here!
	App.settings = CreateMap("ShowName":True, "ShowTrophies":True, "ShowVersusTrophies":True, "ShowWarStars":True, "PlayerTag":"", "ApiKey":"", "TextColor":"255,255,255")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>ShowName:</b>  Show player name<br/>
	<b>ShowTrophies:</b>  Show trophies (main vilage)<br/>
	<b>ShowVersusTrophies:</b>  Show trophies (builder's village)<br/>
	<b>ShowWarStars:</b>  Show war stars<br/>
	<b>PlayerTag:</b>  The ingame player tag (#ABCDE...)<br/>
	<b>ApiKey:</b>  Your Clash of Clans stats developer api key<br/>
	<b>TextColor:</b>  Text color (R,G,B)<br /><br/>
	This app uses an api proxy to make the api work for dynamic IPs.<br/>
	For more information visit <a target="_blank" rel="noopener noreferrer" href="https://docs.royaleapi.com/#/proxy">https://docs.royaleapi.com/#/proxy</a> to see how to set this up.
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("coc", "Clash of Clans", "Clash", "ClashOfClans")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1544, 1546, 1547, 1548)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
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
	framelist.Initialize
	
	Dim color As String = App.get("TextColor")
	textcolor = Array As Int(80, 80, 80)
	
	If ValidateColorString(color) = True Then
		Dim c() As String = Regex.Split(",", color)
		textcolor(0)=c(0)
		textcolor(1)=c(1)
		textcolor(2)=c(2)
	End If
	
	If error = False Then
		If App.get("ShowName") Then
			Dim frame1 As FrameObject
			frame1.Initialize
			frame1.text = name
			frame1.TextLength = App.calcTextLength(frame1.text)
			frame1.color = textcolor
			frame1.Icon = 1544
			framelist.Add(frame1)
		End If
		If App.get("ShowTrophies") Then
			Dim frame2 As FrameObject
			frame2.Initialize
			frame2.text = trophies
			frame2.TextLength = App.calcTextLength(frame2.text)
			frame2.color = textcolor
			frame2.Icon = 1546
			framelist.Add(frame2)
		End If
		If App.get("ShowVersusTrophies") Then
			Dim frame3 As FrameObject
			frame3.Initialize
			frame3.text = versusTrophies
			frame3.TextLength = App.calcTextLength(frame3.text)
			frame3.color = textcolor
			frame3.Icon = 1548
			framelist.Add(frame3)
		End If
		If App.get("ShowWarStars") Then
			Dim frame4 As FrameObject
			frame4.Initialize
			frame4.text = warStars
			frame4.TextLength = App.calcTextLength(frame4.text)
			frame4.color = textcolor
			frame4.Icon = 1547
			framelist.Add(frame4)
		End If
	Else
		Dim frame As FrameObject
		frame.Initialize
		frame.text = "Error"
		frame.TextLength = App.calcTextLength(frame.text)
		frame.color = Array As Int(255, 255, 255)
		frame.Icon = 1544
		framelist.Add(frame)
	End If
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
			'Clash of Clans API
			'https://docs.royaleapi.com/#/proxy
			'https://api.clashofclans.com
			'https://cocproxy.royaleapi.dev
			App.Header = CreateMap("authorization":"Bearer " & App.get("ApiKey"))
			Dim playerTag As String = App.get("PlayerTag")
			App.Download("https://cocproxy.royaleapi.dev/v1/players/" & playerTag.Replace("#", "%23"))
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			error = False
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					name = root.Get("name")
					trophies = root.Get("trophies")
					warStars = root.Get("warStars")
					versusTrophies = root.Get("versusTrophies")
			End Select
		Else
			error = True
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.FallingText(framelist, True)
End Sub

Sub ValidateColorString(colorstring As String) As Boolean
	Dim c() As String = Regex.Split(",", colorstring)
	If c.Length = 3 Then
		If IsNumber(c(0)) And IsNumber(c(1)) And IsNumber(c(2)) Then
			If c(0) >= 0 And c(0) <= 255 And c(1) >= 0 And c(1) <= 255 And c(2) >= 0 And c(2) <= 255 Then
				Return True
			Else
				Return False				
			End If
		Else
			Return False
		End If
	Else
		Return False
	End If
End Sub


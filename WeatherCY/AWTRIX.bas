B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
'This Class takes control of the Interface to AWTRIX, the Icon Renderer
'and some useful functions to make the development more easier.
'Usually you dont need to modify this Class!

#Event: Started
#Event: controllerButton(button as int,dir as boolean)
#Event: controllerAxis(axis as int, dir as float)
#Event: Exited
#Event: iconRequest
#Event: settingsChanged
#Event: startDownload(jobNr As Int) As String
#Event: evalJobResponse(Resp As JobResponse)


private Sub Class_Globals
	Private Appduration As Int
	Private mscrollposition As Int
	Private show As Boolean = True
	Private forceDown As Boolean
	Private LockApp As Boolean = False
	Private Icon As List
	Private appName As String
	Private AppVersion As String
	Private TickInterval As Int
	Private NeedDownloads As Int = 0
	Private UpdateInterval As Int = 0
	Private AppDescription As String
	Private AppAuthor As String
	Private SetupInfos As String
	Private MatrixInfo As Map
	Private appSettings As Map = CreateMap()
	Private ServerVersion As String
	Private DisplayTime As Int
	Private MatrixWidth As Int = 32
	Private MatrixHeight As Int = 8
	Private DownloadHeader As Map
	Private pluginversion As Int = 1
	Private Tag As List = Array As String()
	Private playdescription As String
	Private Cover As Int
	Private Game As Boolean
	Private startTimestamp As Long
	Private icoMap As Map
	Private RenderedIcons As Map
	Private animCounter As Map
	Private iconList As List'ignore
	Private timermap As Map
	Private set As Map 'ignore
	
	Private Target As Object
	Private commandList As List
	Private colorCounter As Int
	Private startTime As String ="0"
	Private endtime As String = "0"
	Private CharMap As Map
	Private TextBuffer As String
	Private TextLength As Int
	Private UppercaseLetters As Boolean
	Private SystemColor() As Int
	Private event As String
	Private Enabled As Boolean = True
	Private noIcon() As Short = Array As Short(0, 0, 0, 63488, 63488, 0, 0, 0, 0, 0, 63488, 0, 0, 63488, 0, 0, 0, 0, 0, 0, 0, 63488, 0, 0, 0, 0, 0, 0, 63488, 0, 0, 0, 0, 0, 0, 63488, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63488, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	Private isRunning As Boolean
	Private Menu As Map
	Private MenuList As List
	Private bc As B4XSerializator
	Private noIconMessage As Boolean
	Private verboseLog As Boolean
	Private finishApp As Boolean
	Type JobResponse (jobNr As Int,Success As Boolean,ResponseString As String,Stream As InputStream)
	Private httpMap As Map
	Private OAuthToken As String
	Private OAuth As Boolean
	Private oauthmap As Map
	Private mContentType As String

	Private poll As Map = CreateMap("enable":False,"sub":"")
	Private mHidden As Boolean
End Sub

'Initializes the Helperclass.
Public Sub Initialize(class As Object, Eventname As String)

	oauthmap.Initialize
	Tag.Initialize
	httpMap.Initialize
	DownloadHeader.Initialize
	event=Eventname
	iconList.Initialize
	Icon.Initialize
	commandList.Initialize
	RenderedIcons.Initialize
	icoMap.Initialize
	animCounter.Initialize
	timermap.Initialize
	set.Initialize
	Menu.Initialize
	MatrixInfo.Initialize
	MenuList.Initialize
	Target=class
End Sub

'Checks if the app should shown
Private Sub timesComparative  As Boolean
	Try
		If startTime = endtime Then Return True
		Dim startT() As String=Regex.Split(":",startTime)
		Dim EndT() As String=Regex.Split(":",endtime)
		Dim hour As Int=DateTime.GetHour(DateTime.Now)
		Dim minute As Int=DateTime.GetMinute(DateTime.Now)
		Dim second As Int=DateTime.GetSecond(DateTime.Now)
		Dim now, start, stop As Int
		now = ((hour * 3600) + (minute * 60) + second)
		start = (startT(0) * 3600) + (startT(1) * 60)
		stop = ( EndT(0)* 3600) + (EndT(1) * 60)
		If (start < stop) Then
			Return (now >= start And now <= stop )
		Else
			Return (now >= start Or now <= stop)
		End If
	Catch
		Log("Got Error from " & appName)
		Log("Error in TimesComparative:")
		Log(LastException)
		Return True
	End Try
End Sub

#Region IconRenderer
Private Sub startIconRenderer
	isRunning=True
	FirstTick
	For Each k As Timer In timermap.Keys
		k.Enabled=True
		Sleep(1)
	Next
End Sub

Private Sub stopIconRenderer
	isRunning=False
	For Each k As Timer In timermap.Keys
		k.Enabled=False
		Sleep(1)
	Next
End Sub

Private Sub FirstTick
	For Each IconID As Int In icoMap.Keys
		Try
			If icoMap.ContainsKey(IconID) Then
				Dim ico As List=icoMap.get(IconID)
				Dim parse As JSONParser
				If animCounter.Get(IconID)>ico.Size-1 Then animCounter.put(IconID,0)
				parse.Initialize(ico.Get(animCounter.Get(IconID)))
				Dim bmproot As List = parse.NextArray
				Dim bmp(bmproot.Size) As Short
				For i=0 To bmproot.Size-1
					bmp(i)=bmproot.Get(i)
				Next
				RenderedIcons.Put(IconID,bmp)
				animCounter.put(IconID,animCounter.Get(IconID)+1)
			Else
				Log("IconID" & IconID  & "doesnt exists")
			End If
		Catch
			Log("Got Error from " & appName)
			Log("Error in IconPreloader:")
			Log("IconID:" & IconID)
			Log(LastException)
		End Try
	Next
End Sub

Private Sub Timer_Tick
	Try
		Dim iconid As Int=timermap.Get(Sender)
		If icoMap.ContainsKey(iconid) Then
			Dim ico As List= icoMap.get(iconid)
			Dim parse As JSONParser
			If animCounter.Get(iconid)>ico.Size-1 Then animCounter.put(iconid,0)
			parse.Initialize(ico.Get(animCounter.Get(iconid)))
			Dim bmproot As List = parse.NextArray
			Dim bpm(bmproot.Size) As Short
			For i=0 To bmproot.Size-1
				bpm(i)=bmproot.Get(i)
			Next
			RenderedIcons.Put(iconid,bpm)
			animCounter.put(iconid,animCounter.Get(iconid)+1)
		Else
			Logger("IconID" & iconid  & "doesnt exists")
		End If
	Catch
		Log("Got Error from " & appName)
		Log("Error in IconRenderer:")
		Log(LastException)
		stopIconRenderer
	End Try
End Sub

Private Sub addToIconRenderer(iconMap As Map)
	Try
		If iconMap.Size=0 Then Return
		Dim runMarker As Boolean
		If isRunning Then
			stopIconRenderer
			runMarker=True
		End If
		timermap.Clear
		icoMap.Clear
		animCounter.Clear
		RenderedIcons.Clear
		For Each ico As Int In iconMap.Keys
			Dim ico1 As Map = iconMap.get(ico)
			If ico1.ContainsKey("tick") Then
				icoMap.Put(ico,ico1.Get("data"))
				animCounter.Put(ico,0)
				Dim timer As Timer
				timer.Initialize("Timer",ico1.Get("tick"))
				Dim icoExists As Boolean=False
				For Each timerico As Int In timermap.Values
					If timerico=ico Then icoExists=True
				Next
				If Not(icoExists) Then timermap.Put(timer,ico)
			Else
				RenderedIcons.Put(ico,ico1.Get("data"))
			End If
		Next
		If runMarker Then
			startIconRenderer
		End If
	Catch
		Log("Got Error from " & appName)
		Log("Error in IconAdder:")
		Log(LastException)
	End Try
End Sub

'returns the rendered Icon
Public Sub getIcon(ID As Int) As Short()
	If RenderedIcons.ContainsKey(ID) Then
		Return RenderedIcons.Get(ID)
	Else
		If noIconMessage = False Then
			Logger("Icon " & ID & " not found")
			noIconMessage=True
		End If
	
		Return noIcon
	End If
End Sub
#End Region

'This is the interface between AWTRIX and the App
Public Sub interface(function As String, Params As Map) As Object
	Select Case function
		Case "start"
			mscrollposition=MatrixWidth
			If SubExists(Target,event&"_Started") Then
				CallSub(Target,event&"_Started")
			End If
			Try
				Appduration = Params.Get("AppDuration")
				If DisplayTime>0 Then
					Appduration=DisplayTime
				End If
				verboseLog =Params.Get("verboseLog")
				ServerVersion =	Params.Get("ServerVersion")
				MatrixWidth = Params.Get("MatrixWidth")
				MatrixHeight = Params.Get("MatrixHeight")
				UppercaseLetters = Params.Get("UppercaseLetters")
				CharMap = Params.Get("CharMap")
				SystemColor = Params.Get("SystemColor")
				MatrixInfo=Params.Get("MatrixInfo")
				set.Put("interval",TickInterval)
				set.Put("needDownload",NeedDownloads)
				set.Put("DisplayTime", DisplayTime)
				set.Put("forceDownload", forceDown)
			Catch
				Log("Got Error from " & appName)
				Log("Error in start procedure")
				Log(LastException)
			End Try
			startTimestamp=DateTime.now
			noIconMessage=False
			If show Then
				set.Put("show",timesComparative)
			Else
				set.Put("show",show)
			End If
			
			set.Put("isGame",Game)
			set.Put("hold",LockApp)
			set.Put("iconList",Icon)
			Return set
		Case "downloadCount"
			Return NeedDownloads
		Case "startDownload"
			httpMap.Initialize
			DownloadHeader.Initialize
			mContentType=""
			If SubExists(Target,event&"_startDownload") Then
				CallSub2(Target,event&"_startDownload",Params.Get("jobNr"))
			End If
			If DownloadHeader.Size>0 Then
				httpMap.Put("Header",DownloadHeader)
			End If
			If mContentType.Length>0 Then
				httpMap.Put("ContentType",mContentType)
			End If
			Return httpMap
		Case "httpResponse"
			Dim res As JobResponse
			res.Initialize
			res.jobNr=Params.Get("jobNr")
			res.Success=Params.Get("success")
			res.ResponseString=Params.Get("response")
			res.Stream=Params.Get("InputStream")
			If SubExists(Target,event&"_evalJobResponse") Then
				CallSub2(Target,event&"_evalJobResponse",res)
			End If
			Return True
		Case "running"
			startIconRenderer
		Case "tick"
			commandList.Clear
			If finishApp Then
				finishApp=False
				commandList.Add(CreateMap("type":"finish"))
			Else
				If SubExists(Target,event&"_genFrame") Then
					CallSub(Target,event&"_genFrame")'ignore
				End If
			End If
		
			Return commandList
		Case "infos"
			Dim infos As Map
			infos.Initialize
			Dim isconfigured As Boolean = True
			If File.Exists(File.Combine(File.DirApp,"Apps"),appName&".ax") Then
				Dim m As Map = bc.ConvertBytesToObject(File.ReadBytes(File.Combine(File.DirApp,"Apps"),appName&".ax"))
				For Each v As Object In m.Values
					If v="null" Or v="" Then
						isconfigured=False
					End If
				Next
				If OAuth And OAuthToken.Length=0 Then isconfigured=False
			End If
			infos.Put("isconfigured",isconfigured)
			infos.Put("AppVersion",AppVersion)
			infos.Put("tags",Tag)
			infos.Put("poll",poll)
			infos.Put("oauth",OAuth)
			infos.Put("oauthmap",oauthmap)
			infos.Put("isGame",Game)
			infos.Put("CoverIcon",Cover)
			infos.Put("pluginversion",pluginversion)
			infos.Put("author",AppAuthor)
			infos.Put("howToPLay",playdescription)
			infos.Put("description",AppDescription)
			infos.Put("setupInfos",SetupInfos)
			infos.Put("hidden",mHidden)
			Return infos
		Case "setSettings"
			makeSettings
			Return True
		Case "getUpdateInterval"
			Return UpdateInterval
		Case "setEnabled"
			saveSingleSetting("Enabled",Params.Get("Enabled"))
			makeSettings
		Case "getEnable"
			Return Enabled
		Case "stop"
			If Game Then
				finishApp=False
				show=False
			End If
			stopIconRenderer
			If SubExists(Target,event&"_Exited") Then
				CallSub(Target,event&"_Exited")
			End If
		Case "getIcon"
			If SubExists(Target,event&"_iconRequest") Then
				CallSub(Target,event&"_iconRequest")
			End If
			Return CreateMap("iconList":Icon)
		Case "iconList"
			addToIconRenderer(Params)
		Case "externalCommand"
			externalCommand(Params)
		Case "controller"
			Control(Params)
		Case "getMenu"
			Menu.Initialize
			Menu.Put("Version","1.6")
			Menu.Put("Theme","Light Theme")
			Menu.Put("Items",MenuList)
			Return Menu
		Case "setToken"
			OAuthToken=Params.Get("token")
		Case "isReady"
			If SubExists(Target,event&"_isReady") Then
				Return CallSub(Target,event&"_isReady")
			Else
				Return True
			End If
			
		Case "shouldShow"
			Return show
		Case "poll"
			Dim s As String=Params.Get("sub")
			If SubExists(Target,event & "_" & s) Then
				CallSub(Target,event & "_" & s)
			End If
	End Select
	Return True
End Sub

'This function calculates the ammount of pixels wich a text needs
Public Sub calcTextLength(text As String) As Int
	If UppercaseLetters Then text = text.ToUpperCase
	If TextBuffer<>text Then
		Dim Length As Int
		For i=0 To text.Length-1
			If CharMap.ContainsKey(Asc(text.CharAt(i))) Then
				Length=Length+(CharMap.Get(Asc(text.CharAt(i))))
			Else
				Length=Length+4
			End If
		Next
		TextBuffer=text
		TextLength=Length
		Return Length
	End If
	Return TextLength
End Sub

'This Helper automaticly display a text in a default app style
'If the text is longer than the Matrixwitdh it will scroll the text
'otherwise it will center the text. Call drawText to handle it manually.
'
'Text - the text to be displayed
'IconOffset - wether you need an offset if you place an icon on the left side.
'yPostition
'Color - custom text color. Pass Null to use the Global textcolor (recommended).
'
'<code>App.genText("Hello World",True,Array as int(255,0,0),false)</code>
Public Sub genText(Text As String,IconOffset As Boolean,yPostition As Int,Color() As Int,callFinish As Boolean)
	If Text.Length=0 Then
		finish
		Return
	End If
	calcTextLength(Text)
	Dim offset As Int
	If IconOffset Then offset = 24 Else offset = 32
	If TextLength>offset Then
		drawText(Text,mscrollposition,yPostition,Color)
		mscrollposition=mscrollposition-1
		If mscrollposition< 0-TextLength  Then
			If LockApp And callFinish Then
				finish
				Return
			Else
				mscrollposition=MatrixWidth
			End If
		End If
	Else
		Dim x As Int
		If TextLength<offset+1 Then
			If IconOffset Then
				x=((MatrixWidth/2)-TextLength/2)+4
			Else
				x=(MatrixWidth/2)-TextLength/2
			End If
		End If
		drawText(Text,x,yPostition,Color)
	End If
End Sub

Sub progressBar(percent As Int, x As Int, y As Int,maxLength As Int, barColor()As Int,backColor()As Int)
	Dim progress As Int = Min(percent,100)/(100/Min(maxLength,32))
	If Not(backColor = Null) Then
		drawLine(x,y,maxLength,y,backColor)
	End If
	If progress>0 Then
		drawLine(x,y,progress,y,barColor)
	End If
End Sub

'This functions build and savee the settings. You dont need to call this manually
Public Sub makeSettings
	If Game Then show=False
	If File.Exists(File.Combine(File.DirApp,"Apps"),appName&".ax") Then
		Dim data() As Byte = File.ReadBytes(File.Combine(File.DirApp,"Apps"),appName&".ax")
		Dim m As Map = bc.ConvertBytesToObject(data)
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then
				m.Put(k,appSettings.Get(k))
			Else
				appSettings.Put(k,m.Get(k))
			End If
		Next
		For Counter = m.Size -1 To 0 Step -1
			Dim SettingsKey As String = m.GetKeyAt(Counter)
			If Not(SettingsKey="UpdateInterval" Or SettingsKey="StartTime" Or SettingsKey="EndTime" Or SettingsKey="DisplayTime" Or SettingsKey="Enabled")   Then
				If Not(appSettings.ContainsKey(SettingsKey)) Then m.Remove(SettingsKey)
			End If
		Next
		Try
			Enabled=m.Get("Enabled")
			startTime=m.Get("StartTime")
			endtime=m.Get("EndTime")
			UpdateInterval=m.Get("UpdateInterval")
			DisplayTime=m.Get("DisplayTime")
			File.WriteBytes(File.Combine(File.DirApp,"Apps"),appName&".ax",bc.ConvertObjectToBytes(m))
			If SubExists(Target,event&"_settingsChanged") Then
				CallSub(Target,event&"_settingsChanged")'ignore
			End If
		Catch
			Log("Got Error from " & appName)
			Log("Error while saving settings")
			Log(LastException)
		End Try
	Else
		Dim m As Map
		m.Initialize
		m.Put("UpdateInterval",UpdateInterval)
		m.Put("StartTime","00:00")
		m.Put("EndTime","00:00")
		m.Put("DisplayTime","0")
		m.Put("Enabled",True)
		For Each k As String In appSettings.Keys
			m.Put(k,appSettings.Get(k))
		Next
		File.WriteBytes(File.Combine(File.DirApp,"Apps"),appName&".ax",bc.ConvertObjectToBytes(m))
	End If
End Sub

'Returns the value of a Settingskey
public Sub get(SettingsKey As String) As Object
	If appSettings.ContainsKey(SettingsKey) Then
		Return appSettings.Get(SettingsKey)
	Else
		Log(SettingsKey & " not found")
		Return ""
	End If
End Sub

Public Sub  saveSingleSetting(key As String, value As Object)
	If File.Exists(File.Combine(File.DirApp,"Apps"),appName&".ax") Then
		Dim data() As Byte = File.ReadBytes(File.Combine(File.DirApp,"Apps"),appName&".ax")
		Dim m As Map = bc.ConvertBytesToObject(data)
		m.Put(key,value)
		File.WriteBytes(File.Combine(File.DirApp,"Apps"),appName&".ax",bc.ConvertObjectToBytes(m))
	End If
End Sub


'Draws a Bitmap
Public Sub drawBMP(x As Int,y As Int,bmp() As Short,width As Int, height As Int)
	commandList.Add(CreateMap("type":"bmp","x":x,"y":y,"bmp":bmp,"width":width,"height":height))
End Sub

'Draws a Text
Public Sub drawText(text As String,x As Int, y As Int,Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"text","text":text,"x":x,"y":y))
	Else
		commandList.Add(CreateMap("type":"text","text":text,"x":x,"y":y,"color":Color))
	End If
End Sub

'Draws a Circle
Public Sub drawCircle(X As Int, Y As Int, Radius As Int, Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"circle","x":x,"y":y,"r":Radius,"color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"circle","x":x,"y":y,"r":Radius,"color":Color))
	End If
End Sub

'Draws a filled Circle
Public Sub fillCircle(X As Int, Y As Int, Radius As Int, Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"fillCircle","x":x,"y":y,"r":Radius,"color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"fillCircle","x":x,"y":y,"r":Radius,"color":Color))
	End If
End Sub

'Draws a single Pixel
Public Sub drawPixel(X As Int,Y As Int,Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"pixel","x":x,"y":y,"color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"pixel","x":x,"y":y,"color":Color))
	End If
End Sub

'Draws a Rectangle
Public Sub drawRect(X As Int,Y As Int,Width  As Int,Height As Int,Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"rect","x":x,"y":y,"w":Width,"h":Height,"color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"rect","x":x,"y":y,"w":Width,"h":Height,"color":Color))
	End If
End Sub

'Draws a Line
Public Sub drawLine(X0 As Int,Y0 As Int,X1  As Int,Y1 As Int,Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"line","x0":X0,"y0":Y0,"x1":X1,"y1":Y1,"color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"line","x0":X0,"y0":Y0,"x1":X1,"y1":Y1,"color":Color))
	End If
End Sub

'Sends a custom or undocumented command
Public Sub customCommand(cmd As Map)
	commandList.Add(cmd)
End Sub

'Fills the screen with a color
Public Sub fill(Color() As Int)
	If Color=Null Then
		commandList.Add(CreateMap("type":"fill","color":SystemColor))
	Else
		commandList.Add(CreateMap("type":"fill","color":Color))
	End If
End Sub

'Plays a soundfile via DFplayer
Public Sub playSound(soundfile As Int)
	commandList.Add(CreateMap("type":"sound","file":soundfile))
End Sub

'Exits the app and force AWTRIX to switch to the next App
'only needed if you have set LockApp to true
Public Sub finish
	finishApp=True
End Sub

'Returns a rainbowcolor wich is fading each tick
Public Sub rainbow As Int()
	colorCounter=colorCounter+1
	If colorCounter>255 Then colorCounter=0
	Return(wheel(colorCounter))
End Sub

Private Sub wheel(Wheelpos As Int) As Int() 'ignore
	If(Wheelpos < 85) Then
		Return Array As Int(Wheelpos * 3, 255 - Wheelpos * 3, 0)
	else if(Wheelpos < 170) Then
		Wheelpos =Wheelpos- 85
		Return  Array As Int(255 - Wheelpos * 3, 0, Wheelpos * 3)
	Else
		Wheelpos =Wheelpos- 170
		Return  Array As Int(0, Wheelpos * 3, 255 - Wheelpos * 3)
	End If
End Sub

Public Sub Logger(msg As String)
	If verboseLog Then
		DateTime.DateFormat=DateTime.DeviceDefaultTimeFormat
		Log(DateTime.Date(DateTime.Now) &"      " & appName & ":" & CRLF &  msg)
	End If
End Sub

Private Sub Control(controller As Map)
	If controller.ContainsKey("GameStart") And Game Then
		Dim state As Boolean = controller.Get("GameStart")
		If state Then
			show=True
		Else
			finishApp=True
			show=False
		End If
		Return
	End If
	
	If controller.ContainsKey("button") Then
		Dim buttonNR As Int = controller.Get("button")
		Dim buttonDIR As Boolean = controller.Get("dir")
		If SubExists(Target,event&"_controllerButton") Then
			CallSub3(Target,event&"_controllerButton",buttonNR,buttonDIR)
		End If
		If verboseLog Then
			If buttonDIR Then Logger($"Button ${buttonNR} down"$) Else Logger($"Button ${buttonNR} up"$)
		End If
		Return
	End If
	
	If controller.ContainsKey("axis") Then
		Dim AxisNR As Int = controller.Get("axis")
		Dim val As Float = controller.Get("dir")
		If SubExists(Target,event&"_controllerAxis") Then
			CallSub3(Target,event&"_controllerAxis",AxisNR,val)
		End If
		Return
	End If
End Sub

Private Sub externalCommand(cmd As Map)
	If SubExists(Target,event&"_externalCommand") Then
		CallSub2(Target,event&"_externalCommand",cmd)
	End If
End Sub

Public Sub throwError(message As String)
	Logger(message)
End Sub

'Returns the timestamp when the app was started.
Sub getstartedAt As Long
	Return startTimestamp
End Sub

'Gets or sets the app tags
Sub gettags As List
	Return Tag
End Sub

Sub settags(Tags As List)
	Tag=Tags
End Sub

'Returns the runtime of the app
Sub getduration As Int
	Return Appduration
End Sub

'If set to true, awtrix will skip this app
Sub setshouldShow(shouldShow As Boolean)
	show=shouldShow
End Sub

'If set to true, AWTRIX will download new data before each start.
Sub setforceDownload(forceDownload As Boolean)
	forceDown=forceDownload
End Sub

'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
Sub setlock(lock As Boolean)
	LockApp=lock
End Sub

'IconIDs from AWTRIXER. You can add multiple if you need more
Sub seticons(icons As List)
	Icon=icons
End Sub

'Sets or gets the appname
Sub getname As String
	Return appName
End Sub

Sub setname(name As String)
	appName=name
End Sub

'Sets or gets the app description
Sub getdescription As String
	Return AppDescription
End Sub

Sub setdescription(description As String)
	AppDescription=description
End Sub

'The developer if this App
Sub getauthor As String
	Return AppAuthor
End Sub

Sub setauthor(author As String)
	AppAuthor=author
End Sub

'Sets or gets the appversion
Sub getversion As String
	Return AppVersion
End Sub

Sub setversion(version As String)
	AppVersion=version
End Sub

'Sets or gets the tickinterval
Sub gettick As String
	Return TickInterval
End Sub

Sub settick(tick As String)
	TickInterval=tick
End Sub

'How many downloadhandlers should be generated
Sub setdownloads(downloads As Int)
	NeedDownloads=downloads
End Sub

'Setup Instructions. You can use HTML to format it
Sub setsetupDescription(setupDescription As String)
	SetupInfos=setupDescription
End Sub

'gets all informations from the matrix as a map
Sub getmatrix As Map
	Return MatrixInfo
End Sub

'needed Settings for this App (wich can be configurate from user via webinterface)
Sub setsettings(settings As Map)
	appSettings=settings
End Sub

'returns the version of the serever
Sub getserver As String
	Return ServerVersion
End Sub

'returns the size of the Matrix as an array (height,width)
Sub getmatrixSize As Int()
	Dim size() As Int = Array As Int(MatrixHeight,MatrixWidth)
	Return size
End Sub

'if this is a game you can set your play instructions here
Sub sethowToPlay(howToPlay As String)
	playdescription=howToPlay
End Sub

'Icon (ID) to be displayed in the Appstore and MyApps
Sub setcoverIcon(coverIcon As Int)
	Cover=coverIcon
End Sub

'set this to true if this is a game.
Sub setisGame(isGame As Boolean)
	Game=isGame
End Sub

public Sub InitializeOAuth (AuthorizeURL As String, TokenURL As String, ClientId As String, ClientSecret As String, Scope As String)
	OAuth=True
	oauthmap=CreateMap("AuthorizeURL":AuthorizeURL,"TokenURL":TokenURL,"ClientId":ClientId,"ClientSecret":ClientSecret,"Scope":Scope)
End Sub

Sub getToken As String
	Return OAuthToken
End Sub

Sub getScrollposition As Int
	Return mscrollposition
End Sub

'Sends a POST request with the given data as the post data.
Public Sub PostString(Link As String, Text As String)
	httpMap=CreateMap("type":"PostString","Link":Link,"Text":Text)
End Sub

'Sends a POST request with the given string as the post data
Public Sub PostBytes(Link As String, Data() As Byte)
	httpMap=CreateMap("type":"PostBytes","Link":Link,"Data":Data)
End Sub

'Sends a PUT request with the given data as the post data.
Public Sub PutString(Link As String, Text As String)
	httpMap=CreateMap("type":"PutString","Link":Link,"Text":Text)
End Sub

'Sends a PUT request with the given string as the post data
Public Sub PutBytes(Link As String, Data() As Byte)
	httpMap=CreateMap("type":"PutBytes","Link":Link,"Data":Data)
End Sub

'Sends a PATCH request with the given string as the request payload.
Public Sub PatchString(Link As String, Text As String)
	httpMap=CreateMap("type":"PatchString","Link":Link,"Text":Text)
End Sub

'Sends a PATCH request with the given data as the request payload.
Public Sub PatchBytes(Link As String, Data() As Byte)
	httpMap=CreateMap("type":"PatchBytes","Link":Link,"Data":Data)
End Sub

'Sends a HEAD request.
Public Sub Head(Link As String)
	httpMap=CreateMap("type":"Head","Link":Link)
End Sub

'Sends a multipart POST request.
'NameValues - A map with the keys and values. Pass Null if not needed.
'Files - List of MultipartFileData items. Pass Null if not needed.
Public Sub PostMultipart(Link As String, NameValues As Map, Files As Object)
	httpMap=CreateMap("type":"PostMultipart","Link":Link,"NameValues":NameValues,"Files":Files)
End Sub

'Sends a POST request with the given file as the post data.
'This method doesn't work with assets files.
Public Sub PostFile(Link As String, Dir As String, FileName As String)
	httpMap=CreateMap("type":"PostFile","Link":Link,"Dir":Dir,"FileName":FileName)
End Sub

'Submits a HTTP GET request.
'Consider using Download2 if the parameters should be escaped.
Public Sub Download(Link As String)
	httpMap=CreateMap("type":"Download","Link":Link)
End Sub

'Submits a HTTP GET request.
'Encodes illegal parameter characters.
'<code>Example:
'job.Download2("http://www.example.com", _
'	Array As String("key1", "value1", "key2", "value2"))</code>
Public Sub Download2(Link As String, Parameters() As String)
	httpMap=CreateMap("type":"Download2","Link":Link,"Parameters":Parameters)
End Sub

'Sets the header for the request as an map
'(Headername,Headervalue)
Public Sub setHeader(header As Map)
	DownloadHeader=header
End Sub

'Sets the Mime header of the request.
'This method should only be used with requests that have a payload.
Public Sub SetContentType(ContentType As String)
	mContentType=ContentType
End Sub

'enables pollingmode
'pass the subname wich should be called every 5s. e.g for App_mySub :
'<code>app.pollig("mySub"):</code>
'if you pass a empty String ("") AWTRIX will start the download
Public Sub polling(enable As Boolean,subname As String)
	poll=CreateMap("enable":enable,"sub":subname)
End Sub


'hide this app from apploop
Sub setHidden(hide As Boolean)
	mHidden=hide
End Sub

#Region Colors

#End Region





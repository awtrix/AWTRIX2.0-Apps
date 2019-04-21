B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Private icoMap As Map
	Private RenderedIcons As Map
	Private animCounter As Map
	Private iconList As List'ignore
	Private timermap As Map
	Private Set As Map 'ignore
	Private Target As Object
	Private scrollposition As Int 'ignore
	Private commandList As List
	Private colorCounter As Int
	Public Appduration As Int
	Public ShouldShow As Boolean = True
	Public LockApp As Boolean=False
	Public Icons As List
	Public AppName As String
	Public AppVersion As String
	Public TickInterval As Int
	Public NeedDownloads As Int
	Public UpdateInterval As Int
	Public AppDescription As String
	Public SetupInfos As String
	Public appSettings As Map
	Public ServerVersion As String
	Public Displaytime As Int
	Type JobResponse (jobNr As Int,Success As Boolean,ResponseString As String)
	Dim starttime As String ="0"
	Dim endtime As String = "0"
End Sub

'Initializes the Helperclass.
Public Sub Initialize(class As Object)
	iconList.Initialize
	commandList.Initialize
	RenderedIcons.Initialize
	icoMap.Initialize
	animCounter.Initialize
	timermap.Initialize
	Set.Initialize
	Target=class
End Sub

'Checks if the app should shown
Private Sub timesComparative  As Boolean
	Try
		If starttime = "0" Or endtime = "0" Then Return True
		Dim startT() As String=Regex.Split(":",starttime)
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
		Log(LastException)
		Return True
	End Try
End Sub

#Region IconRenderer
Private Sub startIconRenderer
	FirstTick
	For Each k As Timer In timermap.Keys
		k.Enabled=True
	Next
End Sub

Private Sub stopIconRenderer
	For Each k As Timer In timermap.Keys
		k.Enabled=False
	Next
End Sub

Private Sub FirstTick
	For Each IconID As Int In icoMap.Keys
		Dim ico As List=icoMap.get(IconID)
		Try
			Dim parse As JSONParser
			If animCounter.Get(IconID)>ico.Size-1 Then animCounter.put(IconID,0)
			parse.Initialize(ico.Get(animCounter.Get(IconID)))
			Dim bmproot As List = parse.NextArray
			Dim bmp(bmproot.Size) As Int
			For bm=0 To bmproot.Size-1
				bmp(bm)=bmproot.Get(bm)
			Next
			RenderedIcons.Put(IconID,bmp)
			animCounter.put(IconID,animCounter.Get(IconID)+1)
		Catch
			Log(LastException)
		End Try
	Next
End Sub

Private Sub Timer_Tick
	Dim iconid As Int=timermap.Get(Sender)
	Dim ico As List=icoMap.get(iconid)
	Try
		Dim parse As JSONParser
		If animCounter.Get(iconid)>ico.Size-1 Then animCounter.put(iconid,0)
		parse.Initialize(ico.Get(animCounter.Get(iconid)))
		Dim bmproot As List = parse.NextArray
		Dim bpm(bmproot.Size) As Int
		For bm=0 To bmproot.Size-1
			bpm(bm)=bmproot.Get(bm)
		Next
		RenderedIcons.Put(iconid,bpm)
		animCounter.put(iconid,animCounter.Get(iconid)+1)
	Catch
		Log(LastException)
	End Try
End Sub

Private Sub addToIconRenderer(iconMap As Map)
	icoMap.Clear
	RenderedIcons.Clear
	For Each ico As Int In iconMap.Keys
		Dim ico1 As Map = iconMap.get(ico)
		If ico1.ContainsKey("tick") Then
			icoMap.Put(ico,ico1.Get("data"))
			animCounter.Put(ico,0)
			Dim timer As Timer
			timer.Initialize("Timer",ico1.Get("tick"))
			timermap.Put(timer,ico)
		Else
			RenderedIcons.Put(ico,ico1.Get("data"))
		End If
	Next
End Sub

'returns the rendered Icon
Sub getIcon(IconID As Int) As Int()
	Return RenderedIcons.Get(IconID)
End Sub
#End Region

Sub AppControl(Tag As String, Params As Map) As Object
	Select Case Tag
		Case "start"
			'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 
			End If
			If Params.ContainsKey("ServerVersion") Then
				ServerVersion =	 Params.Get("ServerVersion")
				CallSub(Target,"checkVersion")
				Else
				Log("Please Update to the latest Server to use this App!")
			End If

			scrollposition=32
			Set.Put("interval",TickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
			Set.Put("needDownload",NeedDownloads)
			Set.Put("Displaytime", Displaytime)
			
			If ShouldShow Then
				Set.Put("show",timesComparative)
			Else
				Set.Put("show",ShouldShow)
			End If		
			Set.Put("hold",LockApp)
			Set.Put("iconList",Icons)
			Return Set
		Case "downloadCount"
			Return NeedDownloads
		Case "startDownload"
			Return CallSub2(Target,"startDownload",Params.Get("jobNr"))
		Case "httpResponse"
			Dim res As JobResponse
			res.jobNr=Params.Get("jobNr")
			res.Success=Params.Get("success")
			res.ResponseString=Params.Get("response")
			CallSub2(Target,"evalJobResponse",res)
			Return True
		Case "running"
			startIconRenderer
		Case "tick"
			commandList.Clear
			CallSub(Target,"genFrame")
			Return commandList
		Case "infos"
			Dim infos As Map
			infos.Initialize
			Dim data() As Byte
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".png") Then
				Dim in As InputStream
				in = File.OpenInput(File.Combine(File.DirApp,"plugins"),AppName&".png")
				Dim out As OutputStream
				out.InitializeToBytesArray(1000)
				File.Copy2(in, out)
				data = out.ToBytesArray
				out.Close
			End If
			infos.Put("pic",data)
			Dim isconfigured As Boolean=True
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
				Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
				For Each v As Object In m.Values
					If v="null" Then
						isconfigured=False
					End If
				Next
			End If
			infos.Put("isconfigured",isconfigured)
			infos.Put("AppVersion",AppVersion)
			infos.Put("description",AppDescription)
			infos.Put("setupInfos",SetupInfos)
			Return infos
		Case "setSettings"
			MakeSettings
			Return True
		Case "getUpdateInterval"
			Return UpdateInterval
		Case "stop"
			stopIconRenderer
		Case "iconList"
			addToIconRenderer(Params)
		Case "externalCommand"
			
	End Select
	Return True
End Sub

'This Helper automaticly display a text in a default app style
'If the text is longer that 5 characters it will scroll the text
'else it will center the text.
'Call drawText to handle it manually.
Sub genText(Text As String)'ignore
	If Text.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":Text,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(Text.Length*3.5)  Then
			If LockApp Then
				Dim command As Map=CreateMap("type":"finish")
				commandList.Add(command)
				Return
			Else
				scrollposition=32
			End If
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":Text,"x":9,"y":1,"font":"auto")
	End If
	commandList.Add(command)
End Sub

Sub MakeSettings
	If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then
				m.Put(k,appSettings.Get(k))
			Else
				appSettings.Put(k,m.Get(k))
			End If
		Next
		For Counter = m.Size -1 To 0 Step -1
			Dim SettingsKey As String = m.GetKeyAt(Counter)
			If Not(SettingsKey="updateInterval" Or SettingsKey="StartTime" Or SettingsKey="EndTime" Or SettingsKey="Displaytime")   Then
				If Not(appSettings.ContainsKey(SettingsKey)) Then m.Remove(SettingsKey)
			End If
		Next
		starttime=m.Get("StartTime")
		endtime=m.Get("EndTime")
		UpdateInterval=m.Get("updateInterval")
		Displaytime=m.Get("Displaytime")
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
	Else
		Dim m As Map
		m.Initialize
		m.Put("updateInterval",UpdateInterval)
		m.Put("StartTime","0")
		m.Put("EndTime","0")
		m.Put("Displaytime","0")
		For Each k As String In appSettings.Keys
			m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
	End If
End Sub

'Returns the value from a Settingskey
Sub get(SettingsKey As String) As Object 'ignore
	If appSettings.ContainsKey(SettingsKey) Then
		Return appSettings.Get(SettingsKey)
	Else
		Return ""
	End If
End Sub

'Draws a Bitmap
Sub drawBMP(x As Int,y As Int,IconID As Int,width As Int, height As Int)'ignore
	commandList.Add(CreateMap("type":"bmp","x":x,"y":y,"bmp":getIcon(IconID),"width":width,"height":height))
End Sub

'Draws a Text
Sub drawText(text As String,x As Int, y As Int,Color() As Int)'ignore
	If Color=Null Then
		commandList.Add(CreateMap("type":"text","text":text,"x":x,"y":y))
	Else
		commandList.Add(CreateMap("type":"text","text":text,"x":x,"y":y,"color":Color))
	End If
End Sub

'Draws a Circle
Sub drawCircle(X As Int, Y As Int, Radius As Int, Color() As Int)'ignore	
	commandList.Add(CreateMap("type":"circle","x":x,"y":y,"r":Radius,"color":Color))
End Sub

'Draws a filled Circle
Sub fillCircle(X As Int, Y As Int, Radius As Int, Color() As Int)'ignore
	commandList.Add(CreateMap("type":"fillCircle","x":x,"y":y,"r":Radius,"color":Color))
End Sub

'Draws a single Pixel
Sub drawPixel(X As Int,Y As Int,Color() As Int)'ignore
	commandList.Add(CreateMap("type":"pixel","x":x,"y":y,"color":Color))
End Sub

'Draws a Rectangle
Sub drawRect(X As Int,Y As Int,Width  As Int,Height As Int,Color() As Int)'ignore
	commandList.Add(CreateMap("type":"rect","x":x,"y":y,"w":Width,"h":Height,"color":Color))
End Sub

'Draws a Line
Sub drawLine(X0 As Int,Y0 As Int,X1  As Int,Y1 As Int,Color() As Int)'ignore
	commandList.Add(CreateMap("type":"line","x0":X0,"y0":Y0,"x1":X1,"y1":Y1,"color":Color))
End Sub

'Fills the screen with a color
Sub fill(Color() As Int)'ignore
	commandList.Add(CreateMap("type":"fill","color":Color))
End Sub

'Exits the app and force AWTRIX to switch to the next App
'only needed if you have set LockApp to true
Sub finish'ignore
	commandList.Add(CreateMap("type":"finish"))
End Sub

'Returns a rainbowcolor wich is fading each tick
Sub Rainbow As Int()
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


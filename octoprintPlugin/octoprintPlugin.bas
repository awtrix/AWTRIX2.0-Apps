B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore
	
	Dim icon() As Int = Array As Int(0x180, 0x180, 0x8590, 0x4c09, 0x4c09, 0x4c09, 0x180, 0x180, 0x180, 0x8590, 0xffff, 0x4c09, 0x64cc, 0xffff, 0x8590, 0x180, 0x180, 0x180, 0x8590, 0x64cc, 0x64cc, 0x8590, 0x180, 0x180, 0x64cc, 0x8590, 0x180, 0x64cc, 0x64cc, 0x180, 0x8590, 0x8590, 0x180, 0x180, 0x8590, 0xcff9, 0xcff9, 0x8590, 0x180, 0x180, 0x8590, 0x8590, 0x64cc, 0xcff9, 0xcff9, 0x64cc, 0x8590, 0x8590, 0x180, 0x180, 0x8590, 0x8590, 0x8590, 0x8590, 0x180, 0x180, 0x8590, 0x8590, 0x180, 0x180, 0x180, 0x180, 0x8590, 0x8590)
	Private AppVersion As String="1.1"
	Private AppName As String = "octoprint" 'plugin name (must be unique)
	Private tickInterval As Int= 60 'tick rate in ms (FPS)
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int=60
	Dim lockApp As Boolean=False
	
	Private description As String= $"
	Shows the percentage of progress and remaining time of OctoPrint printing.<br />
	<small>Created by Dennis Hinzpeter</small>"$
	
	Private setupInfos As String= $"
	
	"$
	
	Private appSettings As Map = CreateMap("ip":Null,"apiKey":Null) 'needed Settings for this Plugin

	'necessary variable declaration
	Private ip As String
	Private apiKey As String
	Private completion As String
	Private printTimeLeft As String ="0"
	
	Dim startedAt As Long
	Dim isOnline As Boolean
 
End Sub

' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	setSettings
	Return "MyKey"
End Sub

' ignore
public Sub GetNiceName() As String
	Return AppName
End Sub


' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Select Case Tag
		Case "start" 													'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If
			startedAt=DateTime.Now
			scrollposition=32
			MainSettings.Put("show",isOnline)

			Return MainSettings
		Case "downloadCount"
			Return needDownloads
		Case "startDownload"
			Return startDownload(Params.Get("jobNr"))
		Case "httpResponse"
			Return evalJobResponse(Params.Get("jobNr"),Params.Get("success"),Params.Get("response"),Params.Get("InputStream"))
		Case "tick"
			commandList.Clear											'Wird in der eingestellten Tickrate aufgerufen
			Return genFrame
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
			infos.Put("description",description)
			infos.Put("setupInfos",setupInfos)
			Return infos
		Case "setSettings"
			Return setSettings
		Case "getUpdateInterval"
			Return updateInterval
	End Select
	Return True
End Sub

'Get settings from the settings file
'You only need to set your variables
Sub setSettings As Boolean
	If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
		updateInterval=m.Get("updateInterval")
		'You need just change the following lines to get the values into your variables
		ip=m.Get("ip")
		apiKey=m.Get("apiKey")
	Else
		Dim m As Map
		m.Initialize
		m.Put("updateInterval",updateInterval)
		For Each k As String In appSettings.Keys
			m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
	End If
	Return True
	
End Sub

'Start of download for new data
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL="http://"&ip&"/api/job?apikey="&apiKey
	End Select
	Return URL
End Sub

'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then
		isOnline = False
		Log("OctoPrint is offline")
		Return False
	End If
	Select nr
		Case 1
			Try
				isOnline = True
				Dim parser As JSONParser
				parser.Initialize(response)
				Dim root As Map = parser.NextObject
				Dim ticker As Map = root.Get("progress")
				completion  = ticker.Get("completion")
				printTimeLeft  = ticker.Get("printTimeLeft")
				Return True
			Catch
				
				Return False
		
			End Try
	End Select
	Return False
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub genFrame As List
	If isOnline Then
		If printTimeLeft == "null" Then
			commandList.Add(CreateMap("type":"text","text":"wait..","x":9,"y":1,"font":"auto"))
		Else
			Dim seconds As Int = printTimeLeft * DateTime.TicksPerSecond 'convert seconds to ticks!
			Dim hour As String=NumberFormat( Floor(seconds/DateTime.TicksPerHour Mod 24),2,0)
			Dim minute As String=NumberFormat( Floor(seconds/DateTime.TicksPerMinute Mod 60),2,0)
			Dim day As String=NumberFormat( Floor(seconds/DateTime.TicksPerDay),2,0)
	
			If startedAt < DateTime.Now - Appduration / 2 Then
				commandList.Add(genText(Round2(completion,0)&"%"))
			Else
				If day > 0 Then
					commandList.Add(genText(day&":"&hour))
					
					commandList.Add(CreateMap("type":"line","x0":10,"y0":7,"x1":14,"y1":7,"color":Array As Int(124,252,000)))
				
				Else
					commandList.Add(genText(hour&":"&minute))
					commandList.Add(CreateMap("type":"line","x0":10,"y0":7,"x1":14,"y1":7,"color":Array As Int(124,252,000)))
				
				End If
			End If
		End If
	Else
		commandList.Add(CreateMap("type":"text","text":"zZz","x":9,"y":1,"font":"auto"))
	End If
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	
	Return commandList
End Sub

'Function for automatic scrolling of the text (optional)
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If lockApp Then
			Dim command As Map=CreateMap("type":"finish")
			Return command
		Else
			scrollposition=32
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
	
	Return command
End Sub
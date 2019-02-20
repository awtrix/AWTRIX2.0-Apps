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
	
	Private AppName As String = "pm" 'plugin name (must be unique)
	Private AppVersion As String="1.1"
	Private tickInterval As Int= 60 'tick rate in ms (FPS)
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
 	Private lockApp As Boolean=False
	
	
	Private description As String= $"
	Shows the atmospheric particulate matter (PM2.5)<br />
	<small>Created by AWTRIX</small>
	"$ 
	
		
	Private setupInfos As String= $"
	<b>Location:</b>  Get you location from https://openaq.org/#/map e.g. "DEHE041".
	"$
	
	Private appSettings As Map = CreateMap("Location":Null) 'needed Settings for this Plugin

	Dim loaction As String
	Dim scrollposition As Int
	Dim pm As String ="0"
	Dim icon() As Int = Array As Int(0x0, 0x9cd3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x9cd3, 0x0, 0x0, 0x0, 0xe73c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a69, 0x0, 0xf800, 0xf800, 0xf800, 0x0, 0x0, 0xf800, 0xf800, 0xf800, 0x0, 0x0, 0xe269, 0x0, 0x0, 0xe269, 0x0, 0x0, 0xfc10, 0xfc10, 0xfc10, 0x0, 0x0, 0xfc10, 0xfc10, 0xfc10, 0xfd96, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xfd96, 0xfe79, 0xfe79, 0xfe79, 0x0, 0x8410, 0xfe79, 0xfe79, 0xfe79)
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
			scrollposition=32
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


'Called with every update from Awtrix,
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL=("https://api.openaq.org/v1/latest?location="&loaction&"&parameter=pm25")
	End Select
	Return URL
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
		loaction=m.Get("Location")
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


Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
				Dim parser As JSONParser
				parser.Initialize(response)
					Dim root As Map = parser.NextObject
					Dim results As List = root.Get("results")
					For Each colresults As Map In results
			
						Dim measurements As List = colresults.Get("measurements")
						For Each colmeasurements As Map In measurements

							pm = colmeasurements.Get("value")
						Next
					Next
				Return True
			Catch
				Log("Error in: "& AppName & CRLF & LastException)
					Log("API response: " & CRLF & LastException)
			End Try
	
	End Select
	Return False
End Sub

Sub genFrame As List
	commandList.Add(genText(pm))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

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
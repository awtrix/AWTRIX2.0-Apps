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

	Private AppName As String = "MinecraftServer" 'plugin name (must be unique)
	Private AppVersion As String="1.0"
	Private tickInterval As Int= 65 'tick rate in ms
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean =False


	Private description As String= $"
	Shows the player count of a Minecraft Server<br/> 
	Only appears if the server is online<br/>
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>Host:</b> The Hostname or IP-Adress of the Minecraft server. <br/>
	"$
	
	Private appSettings As Map = CreateMap("Host":"hub.mcs.gg") 'needed Settings for this Plugin
	Dim isOnline As Boolean
	Dim playersNow As Int
	Dim Host As String = "hub.mcs.gg"
	Dim Icon() As Int = Array As Int(30121, 30121, 25863, 25863, 32234, 27976, 27911, 21605, 36363, 42702, 25093, 30185, 30153, 38444, 22980, 29350, 29351, 25125, 31399, 25093, 29351, 31399, 35921, 37737, 44010, 31431, 37737, 39785, 46058, 46059, 29318, 31399, 39785, 39785, 29351, 37737, 33512, 37737, 31399, 25093, 37705, 31399, 46091, 37705, 31431, 46091, 37737, 39785, 29351, 23045, 37704, 27501, 39785, 29351, 39785, 46058, 37705, 31399, 31399, 39785, 44010, 37705, 31399, 37737)
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
public Sub Run(Tag As String, Params As Map) As Object 'ignore
	Select Case Tag
		Case "start" 													'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If
			MainSettings.Put("show",isOnline)
			scrollposition=32
			If lockApp Then MainSettings.Put("hold",True)
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
		Host=m.Get("Host")
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

Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL=("https://mcapi.us/server/status?ip="&Host)
	End Select
	Return URL
End Sub

Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
				isOnline=True
				Dim parser As JSONParser
				parser.Initialize(response)
				Dim root As Map = parser.NextObject
				Dim status As String = root.Get("status")
				If status="error" Then
					isOnline=False
					If root.ContainsKey("error") Then
						Log(root.Get("error"))
					End If
				Else
					Dim players As Map = root.Get("players")
					playersNow = players.Get("now")
				End If
			
				Return True
			Catch
				Log("Error in: "& AppName & CRLF & LastException)
				Log("API response: " & CRLF & response)
				Return False
			End Try
	End Select
	Return False
End Sub

Sub genFrame As List
	commandList.Add(genText(playersNow))
	
	If scrollposition>9 Then
		commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":Icon,"width":8,"height":8))
	Else
		If scrollposition>-8 Then
				commandList.Add(CreateMap("type":"bmp","x":scrollposition-9,"y":0,"bmp":Icon,"width":8,"height":8))
		End If
	
	End If
	
	Return commandList
End Sub

Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*3.5)  Then
			If lockApp Then
				Dim command As Map=CreateMap("type":"finish")
				Return command
			Else
				scrollposition=32
			End If
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
	
	Return command
End Sub
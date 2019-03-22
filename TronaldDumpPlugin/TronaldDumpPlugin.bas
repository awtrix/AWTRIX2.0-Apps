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

	Private AppName As String = "TronaldDump" 'plugin name (must be unique)
	Private AppVersion As String="1.0"
	Private tickInterval As Int= 65 'tick rate in ms
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean =True


	Private description As String= $"
	Shows the dumbest things Donald Trump has ever said <br/> 
	Powered by tronalddump.io<br />
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	
	"$
	
	Private appSettings As Map = CreateMap() 'needed Settings for this Plugin
	
	Dim QUOT As String

	Dim icon() As Int = Array As Int(6338, 6338, 2178, 47913, 8354, 4258, 6338, 6338, 6338, 6338, 33, 41672, 60362, 12547, 6338, 6338, 6338, 2178, 49961, 54121, 31629, 2210, 4258, 6338, 6338, 33, 21227, 25453, 47945, 58314, 8354, 4258, 2178, 47913, 54121, 52041, 52041, 52041, 60362, 12547, 65, 43719, 52041, 54089, 31596, 27501, 27566, 4259, 27436, 27533, 27501, 25453, 47977, 52041, 52041, 56234, 43719, 52073, 52073, 52041, 49993, 49993, 49993, 52073)
End Sub

' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	MainSettings.Put("forceDownload",True)
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
			URL=("https://api.tronalddump.io/random/quote")
	End Select
	Return URL
End Sub

Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
				Dim parser As JSONParser
				parser.Initialize(response)
				Dim root As Map = parser.NextObject
				QUOT = root.Get("value")
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
	commandList.Add(genText(QUOT))
	
	If scrollposition>9 Then
		commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Else
		If scrollposition>-8 Then
				commandList.Add(CreateMap("type":"bmp","x":scrollposition-9,"y":0,"bmp":icon,"width":8,"height":8))
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
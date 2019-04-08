B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore

	Dim icon() As Int = Array As Int(4, 36, 36, 4, 4, 4, 4, 4, 4624, 2413, 71, 2, 4, 4, 4, 4, 21691, 19708, 28222, 15483, 137, 4, 4, 4, 15089, 13010, 10996, 15385, 26110, 6804, 37, 37, 14957, 6538, 6539, 10799, 8817, 17497, 17562, 6, 6407, 2148, 6440, 6505, 6539, 8718, 8981, 15385, 34, 34, 34, 2181, 2214, 4392, 6540, 13142, 33, 34, 34, 2147, 67, 100, 4359, 12910)
	Dim shouldShow As Boolean = True 'ignore
	
	Private AppName As String = "peopleInSpace" 'change plugin name (must be unique)
	Private AppVersion As String="1.0" 'version of the App
	Private tickInterval As Int= 65 'Tickinterval in ms (should be 65 by default)
	Private needDownloads As Int = 1 'How many downloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean=False 'If set to true AWTRIX will wait for the " finish" command before switch wo the next app.
	Private iconID As Int = 144 'default Icon from AWTRIXER.
	
	Private description As String= $"
	Shows how many people are in space right now.<br />
	<small>Created by huseyint</small>
	"$
	
	Private setupInfos As String= $"
	"$
	
	Private appSettings As Map = CreateMap() 'needed Settings for this Plugin, parse Null if this setting should entered bny the user in the Apps Setup
	
	Dim people As String = "0"
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
			MainSettings.Put("show",shouldShow)
			MainSettings.Put("hold",lockApp)
			MainSettings.Put("icon",iconID)
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

'ignore
Sub setSettings As Boolean
	Log("setSettings")
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
			Log(SettingsKey)
			If Not(SettingsKey="updateInterval") Then
				If Not(appSettings.ContainsKey(SettingsKey)) Then m.Remove(SettingsKey)
			End If
		Next
		updateInterval=m.Get("updateInterval")
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
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

'Called with every updatecall from Awtrix, here you can download your desired data
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL=("http://www.howmanypeopleareinspacerightnow.com/space.json")
	End Select
	Return URL
End Sub

'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
				Dim parser As JSONParser
				parser.Initialize(response)
				Dim root As Map = parser.NextObject
				people = root.Get("number")
				Return True
			Catch
				Log("Error in: "& AppName & CRLF & LastException)
				Log("API response: " & CRLF & response)
			End Try
	End Select
	Return False
End Sub


'Generate your Frame. This Sub is called with every Tick
Sub genFrame As List
	commandList.Add(genText(people))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

'Helper to generate a scrolling Text
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*4)  Then
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

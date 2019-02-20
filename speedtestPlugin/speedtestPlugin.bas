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
	Private AppName As String = "speedtest" 'plugin name (must be unique)
	Private AppVersion As String="1.1"
	Private tickInterval As Int= 80 'tick rate in ms
	Private needDownloads As Int = 0 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval

	Private description As String= $"
	Messures the time between the Frames<br />
<small>Created by AWTRIX</small> 
	"$
	
	Private setupInfos As String= $"

	"$
	
	Private appSettings As Map = CreateMap() 'needed Settings for this Plugin



'	Dim Followers As String
'	Dim accountname As String
'	Dim icon() As Int = Array As Int(0x0, 0x39bf, 0x61bf, 0x91ff, 0x91ff, 0xc1be, 0xc1be, 0x0, 0x89de, 0x89de, 0xffff, 0xffff, 0xffff, 0xffff, 0xf9ff, 0xf9b8, 0xd21f, 0xffff, 0xf9b8, 0xf9b8, 0xf9b8, 0xffff, 0xffff, 0xf9b8, 0xf21f, 0xffff, 0xf9b8, 0xffff, 0xffff, 0xf9b8, 0xffff, 0xf9b8, 0xe9ed, 0xffff, 0xe9ed, 0xffff, 0xffff, 0xf9b8, 0xffff, 0xf9b8, 0xfc06, 0xffff, 0xfc06, 0xfc06, 0xfc06, 0xe9ed, 0xffff, 0xf9b8, 0xfd85, 0xfeec, 0xffff, 0xffff, 0xffff, 0xffff, 0xe9ed, 0xf9b8, 0x0, 0xffb5, 0xffb5, 0xfe8e, 0xfdc7, 0xf426, 0xfaa6, 0x0)
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
		
	End Select
	Return URL
End Sub

Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	Return True
End Sub

Sub genFrame As List
	
	commandList.Add(CreateMap("type":"speedtest","random":DateTime.Now))
	Return commandList
End Sub

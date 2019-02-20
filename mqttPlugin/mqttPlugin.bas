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
	
	Dim icon() As Int = Array As Int(0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xe73c, 0xe73c, 0xe73c, 0x0, 0x0, 0x0, 0x0, 0xe73c, 0xe73c, 0xe73c, 0xe73c, 0xe73c, 0x0, 0xffff, 0xffff, 0xffff, 0xe73c, 0xe73c, 0xe73c, 0xe73c, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xe73c, 0xe73c, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff)
	Private PluginName As String = "mqtt" 'plugin name (must be unique)
	Private tickInterval As Int= 60 'tick rate in ms (FPS)
	Private needDownloads As Int = 0 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private mqttTopic As String = "app"
	
	
	Private description As String= $"
	Display data via MQTT.<br />
	<small>Created by AWTRIX</small>
	"$
		
	Private settingsIds() As String = Array As String() 'needed Settings for this Plugin

	'necessary variable declaration
	Dim topicValue As String
	
	End Sub

' ignore
Public Sub Initialize() As String
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	MainSettings.Put("mqttTopic",mqttTopic)
	setSettings
	Return "MyKey"
End Sub

' ignore
public Sub GetNiceName() As String
	Return PluginName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object 'ignore
	Select Case Tag
		Case "start" 													'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If
			scrollposition=32
			Return MainSettings
		Case "download"
			CallerObject = Params.Get("Handler")
			startDownload(Params.Get("jobNr"))
		Case "httpResponse"
			evalJobResponse(Params.Get("jobNr"),Params.Get("response"))
		Case "tick"
			commandList.Initialize											'Wird in der eingestellten Tickrate aufgerufen
			Return genFrame
		Case "infos"
			Dim infos(3) As Object
			Dim data() As Byte
			If File.Exists(File.Combine(File.DirApp,"plugins"),PluginName&".png") Then
				Dim in As InputStream
				in = File.OpenInput(File.Combine(File.DirApp,"plugins"),PluginName&".png")
				Dim out As OutputStream
				out.InitializeToBytesArray(1000)
				File.Copy2(in, out) '<---- This does the actual copying
				data = out.ToBytesArray
			End If
			infos(0)=data
			infos(1)=description
		
			Dim isconfigured As Boolean=True
			If File.Exists(File.Combine(File.DirApp,"plugins"),PluginName&".ax") Then
				Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),PluginName&".ax")
				For Each v As Object In m.Values
					If v="null" Then
						isconfigured=False
					End If
				Next
			End If
			
			infos(2)=isconfigured
			Return infos
		Case "setSettings"
			setSettings
		Case "mqtt"
			If Params.ContainsKey("topicValue") Then
				topicValue = Params.Get("topicValue") 
			End If
		Case "getUpdateInterval"
			Return updateInterval
		End Select
End Sub


'Get settings from the settings file
Sub setSettings
	If File.Exists(File.Combine(File.DirApp,"plugins"),PluginName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),PluginName&".ax")
		updateInterval=m.Get("updateInterval")
		'You need just change the following lines to get the values into your variables
		
	Else
		Dim m As Map
		m.Initialize
		m.Put("updateInterval",updateInterval)
		For i=0 To settingsIds.Length-1
			m.Put(settingsIds(i),Null)
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),PluginName&".ax",m)
	End If
	
End Sub

'Start download for new data
Sub startDownload(nr As Int)
	Select nr
		Case "1" 'Download data with Downloadhandler "1"
			
	End Select
End Sub

'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,job As HttpJob)
	If Not(job.JobName=PluginName) Then Return
	Select nr
		Case "1" 'get data from Downloadhandler "1"
			If job.Success Then
				
				End If			
	End Select
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub genFrame As List
	commandList.Add(genText(topicValue))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

'Function for automatic scrolling of the text (optional)
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*6)  Then
			scrollposition=32
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
    
	Return command
End Sub

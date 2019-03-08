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
	Dim iconTimer As Timer'ignore
	Dim iconList As List'ignore
	Dim animCount As Int'ignore
	Dim isAnimated As Boolean'ignore
	Dim icon() As Int'ignore
	Private shouldShow As Boolean'ignore
	
	Private AppName As String = "template" 'change plugin name (must be unique)
	Private AppVersion As String="1.0" 'version of the App
	Private tickInterval As Int= 65 'Tickinterval in ms (should be 65 by default)
	Private needDownloads As Int = 0 'How many downloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean=False 'If set to true AWTRIX will wait for the " finish" command before switch wo the next app.
	Private iconID As Int = 141 'default Icon from AWTRIXER.

	
	Private description As String= $"
	This is a template for a native AWTRIX app<br />
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>Text:</b>  Enter a text wich should be displayed.
	"$
	
	Private appSettings As Map = CreateMap("Text":Null) 'needed Settings for this Plugin, parse Null if this setting should entered bny the user in the Apps Setup
	

	'Create the needed variables
	Dim Text As String
End Sub

' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	iconTimer.Initialize("iconTimer",1000)
	iconList.Initialize
	setSettings
	Return "MyKey"
End Sub

' ignore
public Sub GetNiceName() As String
	Return AppName
End Sub

' ignore
Sub IconTimer_Tick
	Try
		Dim parse As JSONParser
		If animCount>iconList.Size-1 Then animCount=0
		parse.Initialize(iconList.Get(animCount))
		Dim bmproot As List = parse.NextArray
		Dim bpm(bmproot.Size) As Int
		For bm=0 To bmproot.Size-1
			bpm(bm)=bmproot.Get(bm)
		Next
		icon=bpm
	Catch
		Log(LastException)
	End Try
	animCount=animCount+1
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Select Case Tag
		Case "start" 													'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If
			scrollposition=32
			animCount=0
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
		Case "running"
			If isAnimated Then
				iconTimer.Enabled=True
				IconTimer_Tick
			End If
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
		Case "stop"
			iconTimer.Enabled=False
		Case "icon"
			If Not(Params.ContainsKey("noIcon")) Then
				If Params.ContainsKey("tick") Then
					iconList=Params.Get("data")
					iconTimer.Interval=Params.Get("tick")
					isAnimated=True
				Else
					icon=Params.Get("data")
					isAnimated=False
				End If
			End If
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
		Text=m.Get("Text")
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
			URL=("https://http://example.com/")
	End Select
	Return URL
End Sub

'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	Return True
End Sub


'Generate your Frame. This Sub is called with every Tick
Sub genFrame As List
		commandList.Add(genText(Text))			'Fügt einen Befehl der Liste hinzu
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
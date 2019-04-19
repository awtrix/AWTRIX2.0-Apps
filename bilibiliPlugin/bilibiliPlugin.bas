B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=1.0
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore
	
	Private AppName As String = "Bilibili" 'change plugin name (must be unique)
	Private AppVersion As String="1.0" 'version of the App
	Private tickInterval As Int= 65 'Tickinterval in ms (should be 65 by default)
	Private needDownloads As Int = 1 'How many downloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean=False 'If set to true AWTRIX will wait for the " finish" command before switch wo the next app.
    Private iconID As Int = 9
	
	Private description As String= $"
	This is a app for a Bilibili Upper to show fans count.<br />
	<small>Created by Albert</small>
	"$
	
	Private setupInfos As String= $"
	<b>MID:</b>
    <ul>
		<li>Go to https://space.bilibili.com/</li>
		<li>Find the 'MID' at 'https://space.bilibili.com/XXX'.</li>
		<li>Copy and enter your MID</li><br/><br/>
	</ul>
	"$
	
	Private appSettings As Map = CreateMap("MID":Null) 'needed Settings for this Plugin, parse Null if this setting should entered bny the user in the Apps Setup
	
	'Define your variables here
	Dim mid As String
    Dim subs As String ="0"

	Dim Icon() As Int = Array as Int(0, 26303, 0, 0, 0, 0, 26303, 0, 0, 0, 26303, 0, 0, 26303, 0, 0, 0, 26303, 26303, 26303, 26303, 26303, 26303, 0, 26303, 0, 0, 0, 0, 0, 0, 26303, 26303, 0, 26303, 0, 0, 26303, 0, 26303, 26303, 0, 0, 0, 0, 0, 0, 26303, 26303, 0, 0, 0, 0, 0, 0, 26303, 0, 26303, 26303, 26303, 26303, 26303, 26303, 0)
	
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
		mid=m.Get("MID")
		
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
            URL=("https://api.bilibili.com/x/relation/stat?vmid="&mid&"&jsonp=jsonp")
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
                Dim bdata As Map = root.Get("data")
                subs = bdata.Get("follower")
				Return True
			Catch
				Log("Error in: "&AppName & CRLF & LastException)
				Log("API response: " & CRLF & response)
			End Try
	End Select
	Return False
End Sub


'Generate your Frame. This Sub is called with every Tick
Sub genFrame As List
	commandList.Add(genText(subs))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":Icon,"width":8,"height":8))
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

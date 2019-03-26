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
	Dim iconTimer As Timer'ignore
	Dim iconList As List'ignore
	Dim animCount As Int'ignore
	Dim isAnimated As Boolean'ignore
	
	Private AppName As String = "mixer" 'change plugin name (unique)
	Private AppVersion As String="1.3"
	Private tickInterval As Int= 65
	Private needDownloads As Int = 1
	Private updateInterval As Int = 60 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean=False
	Private iconID As Int = 488

	Private description As String= $"
	Shows your mixer subscriber count or your live viewers while youre streaming<br />
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>Profile:</b>  Your mixer profile name.
	"$
	
	Private appSettings As Map = CreateMap("Profile":Null) 'needed Settings for this Plugin
	
	Dim icon() As Int = Array As Int(0x0, 0x49af, 0x49af, 0x49af, 0x49af, 0x49af, 0x49af, 0x49af, 0x49af, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0x49af, 0x49af, 0xffff, 0xffff, 0x49af, 0xffff, 0x49af, 0xffff, 0x49af, 0x49af, 0xffff, 0xffff, 0x49af, 0xffff, 0x49af, 0xffff, 0x49af, 0x49af, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0x49af, 0x49af, 0x49af, 0x49af, 0xffff, 0xffff, 0x49af, 0x49af, 0x49af, 0x0, 0x0, 0x49af, 0xffff, 0x49af, 0x0, 0x0, 0x0, 0x0, 0x0, 0x49af, 0x49af, 0x0, 0x0, 0x0, 0x0)
'	Dim liveIcon() As Int= Array As Int(0, 33593, 33593, 33593, 33593, 33593, 63488, 63488, 33593, 65535, 65535, 65535, 65535, 65535, 63488, 63488, 33593, 65535, 65535, 33593, 65535, 33593, 65535, 33593, 33593, 65535, 65535, 33593, 65535, 33593, 65535, 33593, 33593, 65535, 65535, 65535, 65535, 65535, 65535, 33593, 33593, 33593, 33593, 65535, 65535, 33593, 33593, 33593, 0, 0, 33593, 65535, 33593, 0, 0, 0, 0, 0, 33593, 33593, 0, 0, 0, 0)
	Dim Profile As String
	Dim followers As String = "0"
	Dim viewers As String = "0"
	Dim isStreaming As Boolean
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
		Profile=m.Get("Profile")
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

'Called with every update from Awtrix,
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL="https://mixer.com/api/v1/channels/"&Profile
	End Select
	Return URL
End Sub


Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			isStreaming=False
			
			Try
				Dim parser As JSONParser
				parser.Initialize(response)
				Dim root As Map = parser.NextObject
				followers = root.Get("numFollowers")		
				If  root.Get("online") Then
					isStreaming=True
					iconID=489
					viewers = root.Get("viewersCurrent")
				Else
					iconID=488
				End If
				
				Return True
			Catch
				Log("Error in: "& AppName & CRLF & LastException)
				Log("API response: " & CRLF & LastException)
			End Try
	End Select
	Return False
End Sub

Sub genFrame As List
	If isStreaming Then
		commandList.Add(genText(viewers))			'Fügt einen Befehl der Liste hinzu
		commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Else
		commandList.Add(genText(followers))			'Fügt einen Befehl der Liste hinzu
		commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	End If

	Return commandList
End Sub

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
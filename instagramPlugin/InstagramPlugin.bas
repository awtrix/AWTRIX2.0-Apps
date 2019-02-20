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
	
	Dim lockapp As Boolean=False
	Dim icon() As Int = Array As Int(0x0, 0x39bf, 0x61bf, 0x91ff, 0x91ff, 0xc1be, 0xc1be, 0x0, 0x89de, 0x89de, 0xffff, 0xffff, 0xffff, 0xffff, 0xf9ff, 0xf9b8, 0xd21f, 0xffff, 0xf9b8, 0xf9b8, 0xf9b8, 0xffff, 0xffff, 0xf9b8, 0xf21f, 0xffff, 0xf9b8, 0xffff, 0xffff, 0xf9b8, 0xffff, 0xf9b8, 0xe9ed, 0xffff, 0xe9ed, 0xffff, 0xffff, 0xf9b8, 0xffff, 0xf9b8, 0xfc06, 0xffff, 0xfc06, 0xfc06, 0xfc06, 0xe9ed, 0xffff, 0xf9b8, 0xfd85, 0xfeec, 0xffff, 0xffff, 0xffff, 0xffff, 0xe9ed, 0xf9b8, 0x0, 0xffb5, 0xffb5, 0xfe8e, 0xfdc7, 0xf426, 0xfaa6, 0x0)

	Private AppName As String = "instagram" 'plugin name (must be unique)
	Private AppVersion As String="1.1"
	Private tickInterval As Int= 65 'tick rate in ms
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval (configurable)

	Private description As String= $"
	Shows your Instagram followers<br />
	<small>Created by AWTRIX</small> 
	"$
	
	Private setupInfos As String= $"
	<b>Profilename:</b>  As the name implies, your instagram profile name.
	"$
	
	Private appSettings As Map = CreateMap("Profilename":Null) 'needed Settings for this Plugin

	'declare needed variables
	Dim Followers As String
	Dim Profilename As String
End Sub

#Region ignore
' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
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

#End Region


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
		Profilename=m.Get("Profilename")
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

'Called with every update from Awtrix.
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL=("https://www.instagram.com/"&Profilename&"/")
	End Select
	Return URL
End Sub

'response from Awtrixs donwloadhandler
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
				Dim Reader As TextReader
				Reader.Initialize(InputStream)
				Dim line As String
				line = Reader.ReadLine
				Do While line <> Null
					If line.Contains("Followers") Then
						Followers=line.SubString2(line.IndexOf("""")+1,line.IndexOf("Followers")-1)
						Exit
					End If
					line = Reader.ReadLine
				Loop
				Reader.Close
				InputStream.Close
				Return True
			Catch
				Log("Error in: "&AppName & CRLF & LastException)
				Log("API response: "& CRLF & Reader.ReadAll)
				Return False
			End Try
	End Select
	Return False
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub genFrame As List
	commandList.Add(genText(Followers))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

'helperfunction wich automatic displays the text big,tiny or scrolling.
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*4)  Then
			If lockapp Then
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

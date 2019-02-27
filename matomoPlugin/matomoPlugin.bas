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
	
	Dim icon() As Int = Array As Int(0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1993, 0x1993, 0x0, 0x0, 0xfd8c, 0xfd8c, 0x0, 0x3276, 0x1993, 0x1993, 0x0, 0x0, 0xfd8c, 0xfd8c, 0x8590, 0x3276, 0x3276, 0x0, 0x1993, 0x1993, 0x0, 0x8590, 0x8590, 0x3276, 0x0, 0x0, 0x1993, 0x1993, 0x0, 0x0, 0x8590, 0xcfff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8590, 0xcfff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8590, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	Private AppVersion As String="1.1"
	Private AppName As String = "matomo" 'plugin name (must be unique)
	Private tickInterval As Int= 64 'tick rate in ms
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Dim lockApp As Boolean=False
	
	Private description As String= $"	
	Shows you the visitors of the transferred Matomo instance who were online during the given time period.<br />
	<small>Created by Dennis Hinzpeter</small>"$
	
	Private setupInfos As String= $"
	
	"$
	
	Private appSettings As Map = CreateMap("apiKey":Null,"siteID":Null,"baseURL":Null,"timeSpan":Null) 'needed Settings for this Plugin


	'necessary variable declaration
	Private apiKey As String
	Private siteID As String
	Private baseURL As String
	Private timeSpan As String
	Dim result As String = "0"
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
		apiKey=m.Get("apiKey")
		siteID=m.Get("siteID")
		baseURL=m.Get("baseURL")
		timeSpan=m.Get("timeSpan")
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
			URL=(baseURL&"/index.php?module=API&method=Live.getCounters&idSite="&siteID&"&lastMinutes="&timeSpan&"&format=JSON&token_auth="&apiKey)
	End Select
	Return URL
End Sub


'response from Awtrixs donwloadhandler
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
					Dim parser As JSONParser
				parser.Initialize(response.replace("[","").replace("]",""))
					Dim root As Map = parser.NextObject
					result = root.Get("visits")
				Return True
				Catch
				Log("Error in: "&AppName & CRLF & LastException)
				Log("API response: " & CRLF & response)
				End Try
		
	End Select
	Return False
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub genFrame As List
	commandList.Add(genText(result))
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
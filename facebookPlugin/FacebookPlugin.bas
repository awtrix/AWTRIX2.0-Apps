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
	Dim icon() As Int = Array As Int(0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0xffff, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3)
	Private AppVersion As String="1.4"
	Private AppName As String = "Facebook" 'plugin name (must be unique)
	Private tickInterval As Int= 60 'tick rate in ms (FPS)
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	
	Private description As String= $"
	Shows the likes of your Facebook page.<br/>
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>PageID:</b><br/>Get your facebook PageID from https://findmyfbid.com/<br/><br/>
	<b>AccessToken:</b><br/><br/>
	<iframe width="560" height="315" src="https://www.youtube.com/embed/rjyfDRjUCMw?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>  <br/><br/>
	Links:<br/>
	Facebook Developer<br/>
	https://developers.facebook.com/<br/>
<br/>
	Graph API Explorer<br/>
	https://developers.facebook.com/tools/explorer/<br/>
<br/>
	Token Converter<br/>
	https://www.displaysocialmedia.com/app-dev/get_page_token.php<br/>					
	"$
	Private appSettings As Map = CreateMap("AccessToken":Null,"PageID":Null) 'needed Settings for this Plugin


	'necessary variable declaration
	Dim AccessToken As String
	Dim PageID As String
	Dim likes As String ="="
	
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
		m.Remove("AppSecret")
		m.Remove("AppID")
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
		updateInterval=m.Get("updateInterval")
		'You need just change the following lines to get the values into your variables
		AccessToken=m.Get("AccessToken")
		PageID=m.Get("PageID")
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
			URL=("https://graph.facebook.com/v3.2/?ids="&PageID&"&fields=fan_count&access_token="&AccessToken)
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
				Dim api As Map = root.Get(PageID)
				likes = api.Get("fan_count")
				
					Return True
				Catch
					Log("Error in: "& AppName & CRLF & LastException)
				Log("API response: "& CRLF & response)
				End Try
	End Select
	Return False
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub genFrame As List
	commandList.Add(genText(likes))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

'Function for automatic scrolling of the text (optional)
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*4)  Then
			scrollposition=32
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
    
	Return command
End Sub

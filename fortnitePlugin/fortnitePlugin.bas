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
	
	Private AppName As String = "fortnite" 'change plugin name (unique)
	Private AppVersion As String="1.0"
	Private tickInterval As Int= 65
	Private needDownloads As Int = 1
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	Private lockApp As Boolean=True
	Dim icon() As Int = Array As Int(12678, 12678, 65535, 65535, 65535, 65535, 12678, 12678, 30774, 30774, 65535, 65535, 65535, 65535, 30774, 30774, 30774, 30774, 65535, 65535, 30774, 30774, 30774, 30774, 30774, 30774, 65535, 65535, 65535, 30774, 30774, 30774, 30774, 30774, 65535, 65535, 65535, 30774, 30774, 30774, 30774, 30774, 65535, 65535, 30774, 30774, 30774, 30774, 30774, 30774, 65535, 65535, 30774, 30774, 30774, 30774, 12678, 12678, 65535, 65535, 12678, 12678, 12678, 12678)

	Private description As String= $"
	Shows your Kills, Wins, Wins% and K/D <br/>
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>APIkey:</b>  https://fortnitetracker.com/site-api<br/>
	<b>Profile:</b>  Your fortnite nickname<br/>
	<b>Platform:</b>  pc, xbl or psn<br/>
	<b>Stats:</b>  solo, duo or squad<br/>
	<b>Season:</b>  whether the season stats are displayed (true/false)<br/>
	"$
	
	Private appSettings As Map = CreateMap("Platform":"pc","Profile":Null,"APIkey":Null,"Stats":"solo", "Season":False) 'needed Settings for this Plugin
			
	Dim win As String
	Dim winProz As String
	Dim kdRatio As String
	Dim kill As String
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
			If lockApp Then MainSettings.Put("hold",True)
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


'Called with every update from Awtrix,
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			URL=("https://api.fortnitetracker.com/v1/profile/"&appSettings.Get("Platform")&"/"&appSettings.Get("Profile") & CRLF & "TRN-Api-Key: "& appSettings.Get("APIkey"))
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
'				Dim lifeTimeStats As List = root.Get("lifeTimeStats")
'				For Each collifeTimeStats As Map In lifeTimeStats
'					Dim value As String = collifeTimeStats.Get("value")
'					Dim key As String = collifeTimeStats.Get("key")
'				Next
'				Dim platformNameLong As String = root.Get("platformNameLong")
				Dim FortniteStats As Map = root.Get("stats")
		
				If Not(appSettings.Get("Season")) Then
					Select appSettings.Get("Stats")
						Case "solo"
							Dim Solo As Map = FortniteStats.Get("p2")
							Dim SoloWins As Map = Solo.Get("top1")
							win = SoloWins.Get("value")
							Dim kills As Map = Solo.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = Solo.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = Solo.Get("kd")
							kdRatio = kd.Get("value")
						Case "duo"
							Dim Duo As Map = FortniteStats.Get("p10")
							Dim DuoWins As Map = Duo.Get("top1")
							win = DuoWins.Get("value")
							Dim kills As Map = Duo.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = Duo.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = Duo.Get("kd")
							kdRatio = kd.Get("value")
						Case "squad"
							Dim Squad As Map = FortniteStats.Get("p9")
							Dim SquadWins As Map = Squad .Get("top1")
							win = SquadWins.Get("value")
							Dim kills As Map = Squad.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = Squad.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = Squad.Get("kd")
							kdRatio = kd.Get("value")
					End Select
				Else
					Select appSettings.Get("Stats")
						Case "solo"
							Dim SeasonSolo As Map = FortniteStats.Get("curr_p2")
							Dim SeasonSoloWins As Map = SeasonSolo .Get("top1")
							win = SeasonSoloWins.Get("value")
							Dim kills As Map = SeasonSolo.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = SeasonSolo.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = SeasonSolo.Get("kd")
							kdRatio = kd.Get("value")
						Case "duo"
							Dim SeasonDuo As Map = FortniteStats.Get("curr_p10")
							Dim SeasonDuoWins As Map = SeasonDuo .Get("top1")
							win = SeasonDuoWins.Get("value")
							Dim kills As Map = SeasonDuo.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = SeasonDuo.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = SeasonDuo.Get("kd")
							kdRatio = kd.Get("value")
						Case "squad"
							Dim SeasonSquad As Map = FortniteStats.Get("curr_p9")
							Dim toSeasonSquadWins As Map = SeasonSquad .Get("top1")
							win = toSeasonSquadWins.Get("value")
							Dim kills As Map = SeasonSquad.Get("kills")
							kill = kills.Get("value")
							Dim winRatio As Map = SeasonSquad.Get("winRatio")
							winProz = winRatio.Get("value")
							Dim kd As Map = SeasonSquad.Get("kd")
							kdRatio = kd.Get("value")
					End Select
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

	commandList.Add(genText(kill&" Kills        " & win & " Wins        "  & winProz & " %        " & kdRatio & " k/d"))			'Fügt einen Befehl der Liste hinzu
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))

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
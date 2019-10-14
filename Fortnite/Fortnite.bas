B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim win As String
	Dim winProz As String
	Dim kdRatio As String
	Dim kill As String
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Fortnite"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows your Kills, Wins, Wins% and K/D"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=199
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>APIkey:</b>  https://fortnitetracker.com/site-api<br/>
	<b>Profile:</b>  Your fortnite nickname<br/>
	<b>Platform:</b>  pc, xbl or psn<br/>
	<b>Stats:</b>  solo, duo or squad<br/>
	<b>Season:</b>  whether the season stats are displayed (true/false)<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(199)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Platform":"pc","Profile":"","APIkey":"","Stats":"solo", "Season":False)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://api.fortnitetracker.com/v1/profile/"&App.Get("Platform")&"/"&App.Get("Profile"))
			App.Header = CreateMap("TRN-Api-Key":App.Get("APIkey"))
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1				
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim FortniteStats As Map = root.Get("stats")
					If Not(App.Get("Season")) Then
						Select App.Get("Stats")
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
						Select App.Get("Stats")
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
		End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(kill&" Kills        " & win & " Wins        "  & winProz & " %        " & kdRatio & " k/d",True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(199),8,8)
End Sub
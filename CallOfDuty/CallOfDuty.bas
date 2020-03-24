B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim delimiter As String = " - "
	
	' CoD API values
	Dim level As Double
	Dim wins As Double
	Dim kdRatio As Double
	Dim username As String
	Dim recordLongestWinStreak As Double
	Dim recordXpInAMatch As Double
	Dim accuracy As Double
	Dim bestTotalXp As Double
	Dim losses As Double
	Dim totalGamesPlayed As Double
	Dim score As Double
	Dim winLossRatio As Double
	Dim totalShots As Double
	Dim bestScoreXp As Double
	Dim gamesPlayed As Double
	Dim bestSquardKills As Double
	Dim bestSguardWave As Double
	Dim bestConfirmed As Double
	Dim deaths As Double
	Dim bestSquardCrates As Double
	Dim bestAssists As Double
	Dim bestFieldgoals As Double
	Dim bestScore As Double
	Dim recordDeathsInAMatch As Double
	Dim scorePerGame As Double
	Dim bestSPM As Double
	Dim bestKillChains As Double
	Dim recordKillsInAMatch As Double
	Dim suicides As Double
	Dim wlRatio As Double
	Dim currentWinStreak As Double
	Dim bestMatchBonusXp As Double
	Dim bestMatchXp As Double
	Dim bestSguardWeaponLevel As Double
	Dim bestKD As Double
	Dim kills As Double
	Dim bestKillsAsInfected As Double
	Dim bestReturns As Double
	Dim bestStabs As Double
	Dim bestKillsAsSurvivor As Double
	Dim timePlayedTotal As Double
	Dim bestDestructions As Double
	Dim headshots As Double
	Dim bestRescues As Double
	Dim assists As Double
	Dim ties As Double
	Dim recordKillStreak As Double
	Dim bestPlants As Double
	Dim misses As Double
	Dim bestDamage As Double
	Dim bestSetbacks As Double
	Dim bestTouchdowns As Double
	Dim scorePerMinute As Double
	Dim bestDeaths As Double
	Dim bestMedalXp As Double
	Dim bestDefends As Double
	Dim bestSquardRevives As Double
	Dim bestKills As Double
	Dim bestDefuses As Double
	Dim bestCaptures As Double
	Dim hits As Double
	Dim bestMiscXp As Double
	Dim bestKillStreak As Double
	Dim bestDenied As Double
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "CallOfDuty"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Displays up to 62 status values of your Call of Duty player
	"$
	
	'The developer if this App
	App.author = "elpatron"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1110
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("Username":"", "Version":"v1", "Game":"mw", "Platform":"battle", "Values":"level,wins,kdRatio")

	'Setup Instructions. You can use HTML to format it
	' https://gist.github.com/elpatron68/a613950da1eb342f3caef96433875632#file-cod-sats-txt
	App.setupDescription = $"
	<b>Username:</b> Your CoD user name, url encoded (e.g. "iShot%2321899", use <a href="https://www.urlencoder.org/" target="_blank">this page</a> to decode your name)<br/>
	<b>Version:</b> The version of the API you're trying to use (options: 'v1' (for mw), 'v2' (for wwii and bo4))<br/>
	<b>Game:</b> The game you want to pull the information for (options: 'mw', 'wwii', 'bo4')<br/>
	<b>Platform:</b> The platform of choice. Either 'battle' (for Battle.net), 'steam' (for Steam), 'xbl' (for Xbox) or 'psn' (for PlayStation). Further: 'battleuno', 'uno', 'me', 'mention'</br>
	<b>Values:</b> Comma separated list of values to be displayed. See <a href="https://gist.github.com/elpatron68/a613950da1eb342f3caef96433875632#file-cod-sats-txt" target="_blank">this Gist</a> for a list of possilbe values.</br>
	<i>Important: Do not add blanks or anything else but values and commas to the <b>Values</b> field! Also: Values are case sensitive, so just copy-paste them from the Gist!</i><br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Gaming", "Callofduty", "CoD")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1110)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'this sub is called right before AWTRIX will display your App.
'if you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'if you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'if you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			Dim url As String = "https://my.callofduty.com/api/papi-client/stats/cod/" & App.get("Version") & "/title/" & App.get("Game") & "/platform/" & App.get("Platform") & "/gamer/" & App.get("Username") & "/profile/type/mp"
			Log("CoD url: " & url)
			App.Download(url)
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	' CoD API: https://documenter.getpostman.com/view/7896975/SW7aXSo5?version=latest
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim data As Map = root.Get("data")
					level = data.Get("level")
					Dim lifetime As Map = data.Get("lifetime")
					Dim all As Map = lifetime.Get("all")
					Dim properties As Map = all.Get("properties")
					username = data.Get("username")
					recordLongestWinStreak = properties.Get("recordLongestWinStreak")
					recordXpInAMatch = properties.Get("recordXpInAMatch")
					accuracy = properties.Get("accuracy")
					bestTotalXp = properties.Get("bestTotalXp")
					losses = properties.Get("losses")
					totalGamesPlayed = properties.Get("totalGamesPlayed")
					score = properties.Get("score")
					winLossRatio = properties.Get("winLossRatio")
					totalShots = properties.Get("totalShots")
					bestScoreXp = properties.Get("bestScoreXp")
					gamesPlayed = properties.Get("gamesPlayed")
					bestSquardKills = properties.Get("bestSquardKills")
					bestSguardWave = properties.Get("bestSguardWave")
					bestConfirmed = properties.Get("bestConfirmed")
					deaths = properties.Get("deaths")
					wins = properties.Get("wins")
					bestSquardCrates = properties.Get("bestSquardCrates")
					kdRatio = properties.Get("kdRatio")
					kdRatio = Round2(kdRatio, 2)
					bestAssists = properties.Get("bestAssists")
					bestFieldgoals = properties.Get("bestFieldgoals")
					bestScore = properties.Get("bestScore")
					recordDeathsInAMatch = properties.Get("recordDeathsInAMatch")
					scorePerGame = properties.Get("scorePerGame")
					bestSPM = properties.Get("bestSPM")
					bestKillChains = properties.Get("bestKillChains")
					recordKillsInAMatch = properties.Get("recordKillsInAMatch")
					suicides = properties.Get("suicides")
					wlRatio = properties.Get("wlRatio")
					currentWinStreak = properties.Get("currentWinStreak")
					bestMatchBonusXp = properties.Get("bestMatchBonusXp")
					bestMatchXp = properties.Get("bestMatchXp")
					bestSguardWeaponLevel = properties.Get("bestSguardWeaponLevel")
					bestKD = properties.Get("bestKD")
					kills = properties.Get("kills")
					bestKillsAsInfected = properties.Get("bestKillsAsInfected")
					bestReturns = properties.Get("bestReturns")
					bestStabs = properties.Get("bestStabs")
					bestKillsAsSurvivor = properties.Get("bestKillsAsSurvivor")
					timePlayedTotal = properties.Get("timePlayedTotal")
					bestDestructions = properties.Get("bestDestructions")
					headshots = properties.Get("headshots")
					bestRescues = properties.Get("bestRescues")
					assists = properties.Get("assists")
					ties = properties.Get("ties")
					recordKillStreak = properties.Get("recordKillStreak")
					bestPlants = properties.Get("bestPlants")
					misses = properties.Get("misses")
					bestDamage = properties.Get("bestDamage")
					bestSetbacks = properties.Get("bestSetbacks")
					bestTouchdowns = properties.Get("bestTouchdowns")
					scorePerMinute = properties.Get("scorePerMinute")
					bestDeaths = properties.Get("bestDeaths")
					bestMedalXp = properties.Get("bestMedalXp")
					bestDefends = properties.Get("bestDefends")
					bestSquardRevives = properties.Get("bestSquardRevives")
					bestKills = properties.Get("bestKills")
					bestDefuses = properties.Get("bestDefuses")
					bestCaptures = properties.Get("bestCaptures")
					hits = properties.Get("hits")
					bestMiscXp = properties.Get("bestMiscXp")
					bestKillStreak = properties.Get("bestKillStreak")
					bestDenied = properties.Get("bestDenied")
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub


'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	Dim text As String
	' Add a comma to the beginning and the and to safely parse values
	Dim v As String = "," & App.get("Values") & ","
	
	' Check if API returned CoD user name
	If username = "" Then 
		text = text & "No data for user " & App.get("Username" & "!")
		Log(DateTime.Now & " No valid data received, check user name (encoding!) or other settings as game and platform.")
	Else
		' Build text
		text = text & "CoD stats for " & username & ": "
		If v.contains(",level,") Then
			text = text & "Level: " & level & delimiter
		End If
		If v.contains(",wins,") Then
			text = text & "Wins: " & wins & delimiter
		End If
		If v.contains(",kdRatio,") Then
			text = text & "KDR: " & Round2(kdRatio,2) & delimiter
		End If
		If v.contains(",recordLongestWinStreak,") Then
			text = text & "Record longest win streak: " & recordLongestWinStreak & delimiter
		End If
		If v.contains(",recordXpInAMatch,") Then
			text = text & "Record XP in a Match: " & recordXpInAMatch & delimiter
		End If
		If v.contains(",accuracy,") Then
			text = text & "Accuracy: " & Round2(accuracy,2) & delimiter
		End If
		If v.contains(",bestTotalXp,") Then
			text = text & "Best total XP: " & bestTotalXp & delimiter
		End If
		If v.contains(",losses,") Then
			text = text & "Losses: " & losses & delimiter
		End If
		If v.contains(",totalGamesPlayed,") Then
			text = text & "Total games played: " & totalGamesPlayed & delimiter
		End If
		If v.contains(",score,") Then
			text = text & "Score: " & score & delimiter
		End If
		If v.contains(",winLossRatio,") Then
			text = text & "Win-Loss-Ratio: " & Round2(winLossRatio,2) & delimiter
		End If
		If v.contains(",totalShots,") Then
			text = text & "Total shots: " & totalShots & delimiter
		End If
		If v.contains(",bestScoreXp,") Then
			text = text & "Best score XP: " & bestScoreXp & delimiter
		End If
		If v.contains(",gamesPlayed,") Then
			text = text & "Games Played: " & gamesPlayed & delimiter
		End If
		If v.contains(",bestSquardKills,") Then
			text = text & "Best Squard Kills: " & bestSquardKills & delimiter
		End If
		If v.contains(",bestSguardWave,") Then
			text = text & "Best Sguard Wave: " & bestSguardWave & delimiter
		End If
		If v.contains(",bestConfirmed,") Then
			text = text & "Best confirmed: " & bestConfirmed & delimiter
		End If
		If v.contains(",deaths,") Then
			text = text & "Deaths: " & deaths & delimiter
		End If
		If v.contains(",bestSquardCrates,") Then
			text = text & "Best squard crates: " & bestSquardCrates & delimiter
		End If
		If v.contains(",bestAssists,") Then
			text = text & "Best assists: " & bestAssists & delimiter
		End If
		If v.contains(",bestFieldgoals,") Then
			text = text & "Best field goals: " & bestFieldgoals & delimiter
		End If
		If v.contains(",bestScore,") Then
			text = text & "Best score: " & bestScore & delimiter
		End If
		If v.contains(",recordDeathsInAMatch,") Then
			text = text & "Record deaths in a match: " & recordDeathsInAMatch & delimiter
		End If
		If v.contains(",scorePerGame,") Then
			text = text & "Score per game: " & Round2(scorePerGame,2) & delimiter
		End If
		If v.contains(",bestSPM,") Then
			text = text & "Best SPM: " & bestSPM & delimiter
		End If
		If v.contains(",bestKillChains,") Then
			text = text & "Best kill chains: " & bestKillChains & delimiter
		End If
		If v.contains(",recordKillsInAMatch,") Then
			text = text & "Record kills in a match: " & recordKillsInAMatch & delimiter
		End If
		If v.contains(",suicides,") Then
			text = text & "Suicides: " & suicides & delimiter
		End If
		If v.contains(",wlRatio,") Then
			text = text & "WL-Ratio: " & Round2(wlRatio,2) & delimiter
		End If
		If v.contains(",currentWinStreak,") Then
			text = text & "Current win streak: " & currentWinStreak & delimiter
		End If
		If v.contains(",bestMatchBonusXp,") Then
			text = text & "Best match bonus XP: " & bestMatchBonusXp & delimiter
		End If
		If v.contains(",bestMatchXp,") Then
			text = text & "Best match XP: " & bestMatchXp & delimiter
		End If
		If v.contains(",bestSguardWeaponLevel,") Then
			text = text & "Best sguard weapon level: " & bestSguardWeaponLevel & delimiter
		End If
		If v.contains(",bestKD,") Then
			text = text & "Best KD: " & Round2(bestKD,2) & delimiter
		End If
		If v.contains(",kills,") Then
			text = text & "Kills: " & kills & delimiter
		End If
		If v.contains(",bestKillsAsInfected,") Then
			text = text & "Best kills as infected: " & bestKillsAsInfected & delimiter
		End If
		If v.contains(",bestReturns,") Then
			text = text & "Best returns: " & bestReturns & delimiter
		End If
		If v.contains(",bestStabs,") Then
			text = text & "Best stabs: " & bestStabs & delimiter
		End If
		If v.contains(",bestKillsAsSurvivor,") Then
			text = text & "Best kills as survivor: " & bestKillsAsSurvivor & delimiter
		End If
		If v.contains(",timePlayedTotal,") Then
			text = text & "Time played total: " & timePlayedTotal & delimiter
		End If
		If v.contains(",bestDestructions,") Then
			text = text & "Best destructions: " & bestDestructions & delimiter
		End If
		If v.contains(",headshots,") Then
			text = text & "Headshots: " & headshots & delimiter
		End If
		If v.contains(",bestRescues,") Then
			text = text & "Best rescues: " & bestRescues & delimiter
		End If
		If v.contains(",assits,") Then
			text = text & "Assists: " & assists & delimiter
		End If
		If v.contains(",ties,") Then
			text = text & "Ties: " & ties & delimiter
		End If
		If v.contains(",recordKillStreak,") Then
			text = text & "Record kill streak: " & recordKillStreak & delimiter
		End If
		If v.contains(",bestPlants,") Then
			text = text & "Best plants: " & bestPlants & delimiter
		End If
		If v.contains(",misses,") Then
			text = text & "Misses: " & misses & delimiter
		End If
		If v.contains(",bestDamage,") Then
			text = text & "Best damage: " & bestDamage & delimiter
		End If
		If v.contains(",bestSetbacks,") Then
			text = text & "Best setbacks: " & bestSetbacks & delimiter
		End If
		If v.contains(",bestTouchdowns,") Then
			text = text & "Best touchdowns: " & bestTouchdowns & delimiter
		End If
		If v.contains(",scorePerMinute,") Then
			text = text & "Score per minute: " & Round2(scorePerMinute,2) & delimiter
		End If
		If v.contains(",bestDeaths,") Then
			text = text & "Best deaths: " & bestDeaths & delimiter
		End If
		If v.contains(",bestMedalXp,") Then
			text = text & "Best medal XP: " & bestMedalXp & delimiter
		End If
		If v.contains(",bestDefends,") Then
			text = text & "Best Defends: " & bestDefends & delimiter
		End If
		If v.contains(",bestSquardRevives,") Then
			text = text & "Best squard revives: " & bestSquardRevives & delimiter
		End If
		If v.contains(",bestKills,") Then
			text = text & "Best kills: " & bestKills & delimiter
		End If
		If v.contains(",bestDefuses,") Then
			text = text & "Best defenses: " & bestDefuses & delimiter
		End If
		If v.contains(",bestCaptures,") Then
			text = text & "Best captures: " & bestCaptures & delimiter
		End If
		If v.contains(",hits,") Then
			text = text & "Hits: " & hits & delimiter
		End If
		If v.contains(",bestMiscXp,") Then
			text = text & "Best misc XP: " & bestMiscXp & delimiter
		End If
		If v.contains(",bestKillStreak,") Then
			text = text & "Best kill streak: " & bestKillStreak & delimiter
		End If
		If v.contains(",bestDenied,") Then
			text = text & "Best denied: " & bestDenied & delimiter
		End If
	End If
	
	' Remove last delimiter
	text = text.SubString2(0, text.Length - delimiter.Length)
	
	' Display text
	App.genText(text, True, 1, Null, True)
	If App.scrollposition > 9 Then
		App.drawBMP(0,0,App.getIcon(1110),8,8)
	Else
		If App.scrollposition > -8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(1110),8,8)
		End If
	End If
End Sub
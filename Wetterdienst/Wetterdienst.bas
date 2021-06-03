B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim sb As StringBuilder
End Sub


'' Config your App
Public Sub Initialize() As String
	sb.Initialize
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Wetterdienst"
	
	'Version of the App
	App.Version="1.1"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Displays weather-warnings of Deutscher Wetterdienst<br/> 
	Only appears if there is at least one warning
	"$
	
	App.Author="Blueforcer"
		
	App.CoverIcon=521
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>CellID:</b> Warncell-ID von https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_warncellids_csv.csv/<br/><br/> 
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(521)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	App.lock=True
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings=CreateMap("CellID":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
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
			App.Download("https://www.dwd.de/DWD/warnungen/warnapp/json/warnings.json")
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
					sb.Initialize
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString.Replace(");","").Replace("warnWetter.loadWarnings(",""))
					Dim root As Map = parser.NextObject
					Dim warnings As Map = root.Get("warnings")
					If warnings.ContainsKey(App.get("CellID")) Then
						App.ShouldShow=True
						Dim weather As List = warnings.Get(App.get("CellID"))
						Dim count As Int = 1
						For Each col As Map In weather
							sb.Append(count & ". " & col.Get("headline") & "  ")
							count=count+1
						Next
					
					Else
						App.ShouldShow=False
					End If
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(sb.ToString,True,1,Null,True)
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(521),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(521),8,8)
		End If
	End If
End Sub

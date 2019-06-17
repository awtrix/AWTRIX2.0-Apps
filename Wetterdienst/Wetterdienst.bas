B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim sb As StringBuilder
	Dim CellID As String = "806435019"
End Sub


'' Config your App
Public Sub Initialize() As String
	sb.Initialize
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.AppName="Wetterdienst"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Displays weather-warnings of Deutscher Wetterdienst<br/> 
	Only appears if there is at least one warning<br/> 
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>CellID:</b> Warncell-ID von https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_warncellids_csv.csv/<br/><br/> 
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(521)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("CellID":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "https://www.dwd.de/DWD/warnungen/warnapp/json/warnings.json"
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
				If warnings.ContainsKey(CellID) Then
					App.ShouldShow=True
					Dim weather As List = warnings.Get(CellID)
					For Each col As Map In weather
						sb.Append(col.Get("headline")).Append("          ")
					Next
					Else
					App.ShouldShow=False
				End If
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(sb.ToString,True,1,Null)
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(521),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(521),8,8)
		End If
	End If
End Sub

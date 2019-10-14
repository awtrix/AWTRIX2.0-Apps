B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim SunTime As String
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Sunrise"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows sunset and sunrise times for a given location.<br />
	Powered by sunrise-sunset.org
	"$
	
	App.Author="0o.y.o0"
	
	App.CoverIcon=493
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Latitude:</b>  Enter the latitude for your location in degree (e.g.  50.1343).<br />
	<b>Longitude:</b>  Enter the longitude for your location in degree (e.g. 8.8398).<br />
	<b>UTC-Offset:</b>  Enter the UTC offset for your location (e.g. 1 or -1).<br />
	<b>12hrFormat:</b>  Switch from 24hr to 12h timeformat (true/false) .<br />
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(493)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Latitude":"50.1343", "Longitude":"8.8398", "UTC-Offset":"2", "12hrFormat":False)
	
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
			App.Download("https://api.sunrise-sunset.org/json?lat="&App.get("Latitude")&"&lng="&App.get("Longitude"))
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
					Dim savedTime As String= DateTime.TimeFormat
					DateTime.TimeFormat = "KK:mm:ss a"
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim results As Map = root.Get("results")
				
					Dim sunr As String = results.Get("sunrise")
					Dim suns As String = results.Get("sunset")
				 
					DateTime.SetTimeZone(App.get("UTC-Offset"))

					Dim utc As Long = App.get("UTC-Offset")

					Dim SunriseLocal As Long = DateTime.TimeParse(sunr) + (utc * DateTime.TicksPerHour)
					Dim SunsetLocal As Long = DateTime.TimeParse(suns) + (utc *DateTime.TicksPerHour)
				
					If App.get("12hrFormat") Then
						DateTime.TimeFormat = "KK:mm a"
					Else
						DateTime.TimeFormat = "HH:mm"
					End If
				
					SunTime = DateTime.Time(SunriseLocal) & "/" & DateTime.Time(SunsetLocal)
					DateTime.TimeFormat=savedTime
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
		DateTime.TimeFormat=savedTime
	End Try
End Sub


'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	App.genText(SunTime,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(493),8,8)
End Sub

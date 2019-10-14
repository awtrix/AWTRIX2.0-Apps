B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim pmValue As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="PM"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows the atmospheric particulate matter (PM2.5)"
		
	App.Author="Blueforcer"
	
	App.CoverIcon=2	
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Location:</b>  Get you location from https://openaq.org/#/map e.g. "DEHE041".
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(2)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Location":"DEHE041")
	
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
			App.Download("https://api.openaq.org/v1/latest?location="&App.get("Location")&"&parameter=pm25")
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
					Dim results As List = root.Get("results")
					For Each colresults As Map In results
						Dim measurements As List = colresults.Get("measurements")
						For Each colmeasurements As Map In measurements
							pmValue = colmeasurements.Get("value")
						Next
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(pmValue,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(2),8,8)
End Sub
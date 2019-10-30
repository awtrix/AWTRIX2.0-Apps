B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim iconId As Int = 923
	Dim AQIValue As String ="0"
	Dim dominentpol As String = "NULL"
	Dim scroll As Int = 1
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="AQI"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows real-time air quality index (AQI) of your city and key pollutant."
		
	App.Author="King Shen"
	
	App.CoverIcon = iconId
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>City:</b> get your location from http://aqicn.org e.g. "shanghai".<br/>
	<b>Token:</b> get yours at http://aqicn.org/data-platform/token/#/<br/><br/>
	<b>Result:</b><br/>
	0-50: Good;<br/>
	51-100: Moderate;<br/>
	101-150: Unhealthy for Sensitive Groups;<br/>
	151-200: Unhealthy;<br/>
	201-300: Very Unhealthy;<br/>
	300+: Hazardous;<br/><br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads = 1
	
	'IconIDs from AWTRIXER.
	App.Icons = Array As Int(iconId)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings = CreateMap("City":"shanghai","Token":"")
	
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

Sub App_iconRequest
	App.Icons = Array As Int(iconId)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://api.waqi.info/feed/"&App.get("City")&"/?token="&App.get("Token"))
	End Select

End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/

Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Dim parser As JSONParser
			parser.Initialize(Resp.ResponseString)
			Dim root As Map = parser.NextObject
			Dim status As String = root.Get("status")
			If status == "ok" Then
				Dim data As Map = root.Get("data")
				AQIValue = data.Get("aqi")
				dominentpol = data.Get("dominentpol")
			Else
				Log("Error in: "& App.Name)
				Log("Service status: NOT OK")
			End If
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	If App.startedAt<DateTime.Now-App.duration*1000/2 Then
		App.genText(AQIValue,True,scroll,getTextColor(AQIValue),True)
		App.drawBMP(0,scroll-1,App.getIcon(iconId),8,8)
		If scroll < 9 Then
			scroll = scroll + 1
		Else
			App.genText(dominentpol,True,scroll-8,getTextColor(AQIValue),False)
			App.drawBMP(0,scroll-9,App.getIcon(iconId),8,8)
		End If
	Else
		App.genText(AQIValue,True,1,getTextColor(AQIValue),False)
		App.drawBMP(0,0,App.getIcon(iconId),8,8)
	End If
End Sub

Sub getTextColor (value As Int) As Int()
	If value >= 0 And value <= 50 Then
		Return Array As Int(0,153,102)
	Else If value >= 51 And value <= 100 Then
		Return Array As Int(255,222,51)
	Else If value >= 101 And value <= 150 Then
		Return Array As Int(255,153,51)
	Else If value >= 151 And value <= 200 Then
		Return Array As Int(204,0,51)
	Else If value >= 201 And value <= 300 Then
		Return Array As Int(102,0,153)
	Else If value > 300 Then
		Return Array As Int(126,0,35)
	Else
		Log("Error from AQIApp:")
		Log("Not a correct AQI value.")
		Return Null
	End If
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'###### nötige Variablen deklarieren ######
	Dim temp As String = 0	
	Dim iconID As Int = 487
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="OpenWeather"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows the current temperature of your location.<br/>
	powered by OpenWeatherMap.org<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>Unit:</b> enter your unit (metric or imperial)<br/>
	<b>LocationID:</b> search for the weather at your location and get the ID from the adressbar (e.g https://openweathermap.org/city/2874230)<br/>
	<b>APIKey:</b> get yours at https://home.openweathermap.org/api_keys<br/><br/>
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array(399)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("APIKey":"","Unit":"metric","LocationID":"2874230")
	
	App.addMenuItem(Array As String("metric","imperial"),"Unit","Short Options","Unit",True)
	App.addMenuItem(Array As String(),"APIKey","Text","APIKey",True)
	App.addMenuItem(Array As String(),"Location ID","Number","LocationID",True)
	
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

Sub App_iconRequest
	App.Icons=Array As Int(iconID)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "http://api.openweathermap.org/data/2.5/weather?id="&App.get("LocationID")&"&appid="&App.get("APIKey")&"&units="&App.get("Unit")
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
					Dim MainMap As Map = root.Get("main")
					Dim t1 As Double = MainMap.Get("temp")
					temp = NumberFormat(t1,1,1) & "°"

					Dim weather As List = root.Get("weather")
					Dim colweather As Map = weather.Get(0)
					iconID=getIconID(colweather.Get("icon"))
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


Sub App_genFrame
	App.genText(temp,True,1,Null)
	App.drawBMP(0,0,App.getIcon(iconID),8,8)
End Sub

Sub getIconID (ico As String)As Int
	Select ico
	'Day
		Case "01d"
			Return 349
		Case "02d"
			Return 312
		Case "03d"
			Return 486
		Case "04d"
			Return 486
		Case "09d"
			Return 346
		Case "10d"
			Return 346
		Case "11d"
			Return 345
		Case "13d"
			Return 344
		Case "50d"
			Return 347
			'Night
		Case "01n"
			Return 348
		Case "02n"
			Return 485
		Case "03n"
			Return 486
		Case "04n"
			Return 486
		Case "09n"
			Return 346
		Case "10n"
			Return 346
		Case "11n"
			Return 345
		Case "13n"
			Return 347
		Case "50n"
			Return 347
		Case Else
			Log("Error from weatherApp:")
			Log("Icon " & ico & " not found!")
			Return 487
	End Select
	
	
End Sub

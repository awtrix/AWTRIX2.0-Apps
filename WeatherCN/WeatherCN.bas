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
	App.Name="WeatherCN"
	
	'Version of the App
	App.Version="0.86"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	What's the weather like in china. 查询天气，在中国可用。<br/>
	powered by Tianqiapi.com
	"$
		
	App.author="Lemon"	
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>写城市名就完事咯嗷。<br/>
	"$
	
	App.coverIcon=473
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array(487)
	
	'Tickinterval in ms (should be 65 by default)
	App.tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("CityName":"广州")
	
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

Sub App_iconRequest
	App.Icons=Array As Int(iconID)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://www.tianqiapi.com/api/?city="&App.get("CityName"))
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
					Dim MainMap As List = root.Get("data")
					Dim t0 As Map = MainMap.Get("0")
					Dim t1 As String = t0.Get("tem")
					temp = t1 & "°C"
					
					Dim colweather As String = t0.Get("wea_img")
					iconID=getIconID(colweather)
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


Sub App_genFrame
	App.genText(temp,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(iconID),8,8)
End Sub

Sub getIconID (ico As String)As Int
	Select ico
	'Day
		Case "qing"
			Return 349 'sunny
		Case "yun"
			Return 486 'cloudy
		Case "lei"
			Return 346 'rainy
		Case "yu"
			Return 346 'rainy
		Case Else
			Log("Error from weatherApp:")
			Log("Icon " & ico & " not found!")
			Return 487
	End Select
	
	
End Sub

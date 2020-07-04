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
	Dim hum As String = 0
	Dim prop As Float = 0
	Dim iconID As Int = 487
	'Declare your variables here
	Dim scroll As Int
    Dim prob As Float = 0
    Dim count As Int = 0
	
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="WeatherCY"
	
	'Version of the App
	App.Version="0.01"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Show the weather at your location, caiyun。<br/>
	powered by www.caiyunapp.com
	"$
		
	App.author="FrankLv"	
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>彩云天气，请使用经纬度定位(所有设置均需填写)：<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· longitude：经度，latitude：纬度，根据自己位置填写；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· probability: 预警的降雨概率设置，超过设置值会显示提示文字和声音；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· playsound: 通过DFplayer播放sd卡中对应的编号文件，默认0为不播放；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· text: 自定义部分，显示内容: RAIN: p% 自定义内容；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· count: 循环显示预警信息及播放预警声次数；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· stime和etime: 预警声播放时间段,格式为xx:xx:xx；<br/>
	<b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp· token: 彩云天气官网上申请的token。<br/>
	<b><br/>
	<b>Contact <a href="https://twitter.com/vaguecupid" target=”_blank">FrankLv</a><br/>
	<b>Fans in <a href="https://bbs.iobroker.cn/" target=”_blank">https://bbs.iobroker.cn/</a><br/>
	"$
	
	App.coverIcon=473
	
	'How many downloadhandlers should be generated
	App.Downloads=2
	
	'IconIDs from AWTRIXER.
	App.Icons=Array(487)
	
	'Tickinterval in ms (should be 65 by default)
	App.tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("longitude":"","latitude":"","probability":"80","playsound":"0","text":"be careful","count":"1","stime":"","etime":"","token":"")
	
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
			App.Download("https://api.caiyunapp.com/v2/"&App.get("token")&"/"&App.get("longitude")&","&App.get("latitude")&"/realtime.json?&unit=metric:v2")
		Case 2
			App.Download("https://api.caiyunapp.com/v2/"&App.get("token")&"/"&App.get("longitude")&","&App.get("latitude")&"/forecast.json?&unit=metric:v2")
			
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
					Dim MainMap As Map = root.Get("result")
					Dim t1 As String = MainMap.Get("temperature")
					temp = t1 & "°"
					Dim t2 As Float = MainMap.Get("humidity")*100
					hum = t2 & "%"
					Dim colweather As String = MainMap.Get("skycon")
					iconID=getIconID(colweather)
				Case 2
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim MainMap As Map = root.Get("result")
					Dim SMap As Map = MainMap.Get("minutely")
					Dim TMap As List = SMap.Get("probability")
					Dim t3 As Int = TMap.Get("0")*100
					prop = t3
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_Started
	scroll = 1
End Sub

Sub App_genFrame
    If prop = 0 And prob > 0 Then
		prob = 0
	End If
	DateTime.TimeFormat = "HH:mm:ss"
	Dim timeString As String= DateTime.Time(DateTime.Now)
	Dim StartTimeTicks As Long
	StartTimeTicks =  DateTime.TimeParse(App.get("stime"))
	Dim EndTimeTicks As Long
	EndTimeTicks =  DateTime.TimeParse(App.get("etime"))
	Dim NowTimeTicks As Long
	NowTimeTicks =  DateTime.TimeParse(timeString)
	If prop>=App.get("probability") Then
		If prob < prop Then
			If scroll = 1 Then
				If App.get("playsound") <> "0" And count <= (App.get("count")-1) And StartTimeTicks <= NowTimeTicks And NowTimeTicks<= EndTimeTicks Then
					App.playSound(App.get("playsound"))
				End If
				scroll = scroll + 1
				count = count + 1
				If count = App.get("count")+1 Then
					prob = prop
					count = 0
				End If
			End If
			App.genText("RAIN:"&prop&"% "&App.get("text"),True,1,Array As Int(255,0,0),False)
			App.drawBMP(0,0,App.getIcon(iconID),8,8)
		Else
			If App.startedAt<DateTime.Now-App.duration*1000/2 Then
				App.genText(temp,True,scroll,Null,False)
				App.drawBMP(0,scroll-1,App.getIcon(iconID),8,8)
				If scroll<9 Then
					scroll=scroll+1
				Else
					App.genText(hum,True,scroll-8,Null,False)
					App.drawBMP(0,scroll-9,App.getIcon(iconID),8,8)
				End If
			Else
				App.genText(temp,True,1,Null,False)
				App.drawBMP(0,0,App.getIcon(iconID),8,8)
			End If
	    End If
	Else
		If App.startedAt<DateTime.Now-App.duration*1000/2 Then
			App.genText(temp,True,scroll,Null,False)
			App.drawBMP(0,scroll-1,App.getIcon(iconID),8,8)
			If scroll<9 Then
				scroll=scroll+1
			Else
				App.genText(hum,True,scroll-8,Null,False)
				App.drawBMP(0,scroll-9,App.getIcon(iconID),8,8)
			End If
		Else
			App.genText(temp,True,1,Null,False)
			App.drawBMP(0,0,App.getIcon(iconID),8,8)
		End If
	End If
End Sub

Sub getIconID (ico As String)As Int
	Select ico
	'Day
		Case "CLEAR_DAY"
			Return 349 'sunny
		Case "CLEAR_NIGHT"
			Return 348 'nsunny
		Case "PARTLY_CLOUDY_DAY"
			Return 312 'pcloudy
		Case "PARTLY_CLOUDY_NIGHT"
			Return 485 'npcloudy
		Case "CLOUDY"
			Return 486 'cloudy
		Case "RAIN"
			Return 346 'rain
		Case "SNOW"
			Return 344 'snow
		Case "WIND"
			Return 313 'wind
		Case "HAZE"
			Return 314 'fog
		Case "FOG"
			Return 314 'fog
		Case Else
			Log("Error from weatherApp:")
			Log("Icon " & ico & " not found!")
			Return 487
	End Select
End Sub

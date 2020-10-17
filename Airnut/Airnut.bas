B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim prop As Float = 0
	Dim prob As Float = 0
	'Declare your variables here
	Dim scroll As Int
	Dim scroll_2 As Int
	Dim scroll_3 As Int
	Dim count As Int = 0
	Dim CO2 As Float = 0
	Dim HUM As Float = 0
	Dim PM25 As Float = 0
	Dim TEMP As Float = 0
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Airnut"
	
	'Version of the App
	App.Version="0.1"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	The environmental monitoring from airnut。<br/>
	powered by mm.airnut.com
	"$
		
	App.author="FrankLv"
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>空气果监测，需要填写三个ID内容（抓包获取）：<br/>
	<b><br/>
	<b>Contact <a href="https://twitter.com/vaguecupid" target=”_blank">FrankLv</a><br/>
	<b>Fans in <a href="https://bbs.iobroker.cn/" target=”_blank">https://bbs.iobroker.cn/</a><br/>
	"$
	
	App.coverIcon=433
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.icons=Array As Int(2,235,693,1027)
	
	'Tickinterval in ms (should be 65 by default)
	App.tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("pushid":"","snsid":"","sessionid":"","co2prob":"1000","co2sound":"0","text":"be careful","count":"1","stime":"","etime":"")
	
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
			App.Download("http://has.moji001.com/HAS/PersonPage?push-id="&App.get("pushid")&"&sns-id="&App.get("snsid")&"&session-id="&App.get("sessionid"))
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
					Dim MainList As List = root.Get("result")
					Dim Arrs As Map = MainList.Get(0)
					Dim Datas As Map =Arrs.Get("datas")
					CO2 = Datas.Get("co2")
					HUM = Datas.Get("humidity")
					PM25 = Datas.Get("pm25")
					TEMP = Datas.Get("temp")
					prop = CO2
					Log("CO2:"&CO2 & "HUM:"&HUM & "PM25:"&PM25 & "TEMP:"&TEMP)
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_Started
	scroll = 1
	scroll_2 = 1
	scroll_3 = 1
End Sub

Sub App_genFrame
	If prop < 500 And prob > 0 Then
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
	If prop>=App.get("co2prob") And prob < prop Then
		If scroll = 1 Then
			If App.get("co2sound") <> "0" And count <= (App.get("count")-1) And StartTimeTicks <= NowTimeTicks And NowTimeTicks<= EndTimeTicks Then
				App.playSound(App.get("co2sound"))
			End If
			scroll = scroll + 1
			count = count + 1
			If count = App.get("count")+1 Then
				prob = prop
				count = 0
			End If
		End If
		App.genText("CO2:"&prop&"PPM, "&App.get("text"),True,1,Array As Int(255,0,0),False)
		App.drawBMP(0,0,App.getIcon(1027),8,8)
	Else
		If App.startedAt<DateTime.Now-App.duration*1000/4 Then
			App.genText(CO2,True,scroll,getCO2Color(CO2),False)
			App.drawBMP(0,scroll-1,App.getIcon(1027),8,8)
			If scroll<9 Then
				scroll=scroll+1
			Else
				App.genText(PM25,True,scroll_2,getPM25Color(PM25),False)
				App.drawBMP(0,scroll_2-1,App.getIcon(2),8,8)
				If App.startedAt<DateTime.Now-App.duration*1000*2/4 Then
					If scroll_2<9 Then
						scroll_2=scroll_2+1
					Else
						App.genText(TEMP&"°",True,scroll_3,getTEMPColor(TEMP),False)
						App.drawBMP(0,scroll_3-1,App.getIcon(235),8,8)
						If App.startedAt<DateTime.Now-App.duration*1000*3/4 Then
							If scroll_3<9 Then
								scroll_3=scroll_3+1
							Else
								App.genText(HUM&"%",True,scroll_3-8,getHUMColor(HUM),False)
								App.drawBMP(0,scroll_3-9,App.getIcon(693),8,8)
							End If
						End If
					End If
				End If
			End If
		Else
			App.genText(CO2,True,scroll,getCO2Color(CO2),False)
			App.drawBMP(0,scroll-1,App.getIcon(1027),8,8)
		End If
	End If

End Sub

Sub getPM25Color (value As Float) As Int()
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
		Log("Error from PM25:")
		Log("Not a correct PM25 value.")
		Return Null
	End If
End Sub

Sub getCO2Color (value As Float) As Int()
	If value >= 0 And value <= 250 Then
		Return Array As Int(0,153,102)
	Else If value >= 250 And value <= 350 Then
		Return Array As Int(255,222,51)
	Else If value >= 351 And value <= 1000 Then
		Return Array As Int(255,153,51)
	Else If value >= 1001 And value <= 2000 Then
		Return Array As Int(204,0,51)
	Else If value >= 2001 And value <= 5000 Then
		Return Array As Int(102,0,153)
	Else If value > 5000 Then
		Return Array As Int(126,0,35)
	Else
		Log("Error from CO2:")
		Log("Not a correct CO2 value.")
		Return Null
	End If
End Sub
		
Sub getTEMPColor (value As Float) As Int()
	If value >= 18 And value <= 25 Then
		Return Array As Int(0,153,102)
	Else If value < 18 Then
		Return Array As Int(204,0,51)
	Else If value >25 Then
		Return Array As Int(126,0,35)
	Else
		Log("Error from TEMP:")
		Log("Not a correct TEMP value.")
		Return Null
	End If
End Sub

Sub getHUMColor (value As Float) As Int()
	If value >= 40 And value <= 70 Then
		Return Array As Int(0,153,102)
	Else If value < 40 Then
		Return Array As Int(204,0,51)
	Else If value > 70 Then
		Return Array As Int(126,0,35)
	Else
		Log("Error from HUM:")
		Log("Not a correct HUM value.")
		Return Null
	End If
		
End Sub

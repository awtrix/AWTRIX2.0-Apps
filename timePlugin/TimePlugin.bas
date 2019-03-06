B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore
	Dim weekday As Int
	
	Private AppName As String = "time" 'change plugin name (unique)
	Private AppVersion As String="1.6"
	Private tickInterval As Int= 60
	Private needDownloads As Int = 0
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	
	Private description As String= $"
	Shows Time, Date and the day of the week.<br />
	<small>Created by AWTRIX</small>
	"$ 
	
	Private setupInfos As String= $"
	<b>showWeekday:</b>  Whether the weekday should be displayed or not (true/false).<br />
	<b>showSeconds:</b>  Whether the seconds should be displayed or not (true/false).<br />
	<b>showDate:</b>  Whether the date should be displayed or not (true/false).<br />
	<b>12hrFormat:</b>  Switch from 24hr to 24h timeformat (true/false).<br />
	<b>dateformat:</b>  Set date format (DD/MM or MM/DD) .<br />
	"$
	
	Private appSettings As Map = CreateMap("showSeconds":False,"showWeekday":True,"showDate":True,"12hrFormat":False,"dateFormat":"MM/DD") 'needed Settings for this Plugin

	Dim startat As Long
	Dim showWeekDay As Boolean =True
	Dim showDate As Boolean =True
	Dim showSeconds As Boolean =False
	Dim hrFormat As Boolean=False
	Dim scroll As Int
	Dim dateFormat As String
End Sub

'Initializes the object. You can NOT add parameters to this method!
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	setSettings
	
	Return "MyKey"
End Sub


' must be available
public Sub GetNiceName() As String
	Return AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Select Case Tag
		Case "start"
			startat=DateTime.Now											'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If
			scrollposition=32
			scroll=1
			weekday=GetWeekNumber(DateTime.Now)
			Return MainSettings
		Case "downloadCount"
			Return needDownloads
		Case "startDownload"
			Return startDownload(Params.Get("jobNr"))
		Case "httpResponse"
'			Return evalJobResponse(Params.Get("jobNr"),Params.Get("success"),Params.Get("response"),Params.Get("InputStream"))
		Case "tick"
			commandList.Clear											'Wird in der eingestellten Tickrate aufgerufen
			Return genFrame
		Case "infos"
			Dim infos As Map
			infos.Initialize
			Dim data() As Byte
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".png") Then
				Dim in As InputStream
				in = File.OpenInput(File.Combine(File.DirApp,"plugins"),AppName&".png")
				Dim out As OutputStream
				out.InitializeToBytesArray(1000)
				File.Copy2(in, out)
				data = out.ToBytesArray
				out.Close
			End If
			infos.Put("pic",data)
			Dim isconfigured As Boolean=True
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
				Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
				For Each v As Object In m.Values
					If v="null" Then
						isconfigured=False
					End If
				Next
			End If
			infos.Put("isconfigured",isconfigured)
			infos.Put("AppVersion",AppVersion)
			infos.Put("description",description)
			infos.Put("setupInfos",setupInfos)
			Return infos
		Case "setSettings"
			Return setSettings
		Case "getUpdateInterval"
			Return updateInterval
	End Select
	Return True
End Sub

Sub setSettings As Boolean
	If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
		updateInterval=m.Get("updateInterval")
		'You need just change the following lines to get the values into your variables
		showWeekDay=m.Get("showWeekday")
		showDate=m.Get("showDate")
		showSeconds=m.Get("showSeconds")
		hrFormat=m.Get("12hrFormat")
		dateFormat=m.Get("dateFormat")
	Else
		Dim m As Map
		m.Initialize
		m.Put("updateInterval",updateInterval)
		For Each k As String In appSettings.Keys
			m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
	End If
	Return True
End Sub

Sub startDownload(nr As Int)
	Select nr
		Case "1"
			
	End Select
End Sub

Sub genFrame As List

	If hrFormat =False Then
		If showSeconds Then
			DateTime.TimeFormat = "HH:mm:ss"
			Dim xpos As Int =2
		Else
			Dim xpos As Int =7
			DateTime.TimeFormat = "HH:mm"

		End If
		
	Else
		DateTime.TimeFormat="KK:mm a"
		Dim xpos As Int =2
	End If
	
	Dim second As Int =DateTime.GetSecond(DateTime.Now)
	Dim timeString As String= DateTime.Time(DateTime.Now)
	
	If showDate Then
		If startat<DateTime.Now-Appduration/2 Then
			renderDate
			If showSeconds Then
				commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":scroll,"font":"tiny"))
			Else
				If second Mod 2 >0 Then
					commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":scroll,"font":"tiny"))
				Else
					commandList.add(CreateMap("type":"text","text":timeString.Replace(":"," "),"x":xpos,"y":scroll,"font":"tiny"))
				End If
			End If
			
					
			If scroll<9 Then
				scroll=scroll+1
			End If
		Else
			If showSeconds Then
				commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":1,"font":"tiny"))
			Else
				If second Mod 2 >0 Then
					commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":1,"font":"tiny"))
				Else
					commandList.add(CreateMap("type":"text","text":timeString.Replace(":"," "),"x":xpos,"y":1,"font":"tiny"))
				End If
			End If
			
		End If
	Else
		If showSeconds Then
			commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":1,"font":"tiny"))
		Else
			If second Mod 2 >0 Then
				commandList.add(CreateMap("type":"text","text":timeString,"x":xpos,"y":1,"font":"tiny"))
			Else
				commandList.add(CreateMap("type":"text","text":timeString.Replace(":"," "),"x":xpos,"y":1,"font":"tiny"))
			End If
		End If
	End If
	
	If showWeekDay Then
		renderWeekDay
	End If
	
	
	Return commandList
End Sub

Sub renderDate
																						'Add Date Format Option
	Dim day As String=NumberFormat( DateTime.GetDayOfMonth(DateTime.Now),2,0)
	Dim month As String=NumberFormat(DateTime.GetMonth(DateTime.Now),2,0)
											'Sets the Date Format
	If dateFormat= "MM/DD" Then
		commandList.add(CreateMap("type":"text","text":month&"."& day&".","x":7,"y":scroll-8,"font":"tiny"))
	Else
		commandList.add(CreateMap("type":"text","text":day&"."& month&".","x":7,"y":scroll-8,"font":"tiny"))
	End If
	

End Sub

Sub renderWeekDay
	commandList.add(CreateMap("type":"line","x0":0,"y0":7,"x1":31,"y1":7,"color":Array As Int(0,0,0)))
	For i=0 To 6
		
		If i=weekday-1  Then
			commandList.add(CreateMap("type":"line","x0":2+i*4,"y0":7,"x1":i*4+4,"y1":7,"color":Array As Int(200,200,200)))
		Else
			commandList.add(CreateMap("type":"line","x0":2+i*4,"y0":7,"x1":i*4+4,"y1":7,"color":Array As Int(80,80,80)))
		End If
	Next
End Sub

Private Sub GetWeekNumber(DateTicks As Long) As Int
	Dim psCurrFmt As String = DateTime.DateFormat
	DateTime.DateFormat = "u"
	Dim piCurrentWeek As Int = DateTime.Date(DateTicks)
	DateTime.DateFormat = psCurrFmt
	Return piCurrentWeek
End Sub

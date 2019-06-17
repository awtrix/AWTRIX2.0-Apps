B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim weekday As Int
	Dim startat As Long
	Dim scroll As Int
End Sub

'Initializes the object. You can NOT add parameters to this method!
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="Time"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows Time, Date and the day of the week.<br />
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>ShowWeekday:</b>  Whether the weekday should be displayed or not (true/false).<br />
	<b>ShowSeconds:</b>  Whether the seconds should be displayed or not (true/false).<br />
	<b>ShowDate:</b>  Whether the date should be displayed or not (true/false).<br />
	<b>12hrFormat:</b>  Switch from 24hr to 24h timeformat (true/false).<br />
	<b>DateFormat:</b>  Set date format (DD/MM or MM/DD) .<br />
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
		
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings= CreateMap("ShowSeconds":False,"ShowWeekday":True,"ShowDate":True,"12hrFormat":False,"DateFormat":"DD/MM") 'needed Settings for this Plugin
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub


' must be available
public Sub GetNiceName() As String
	Return App.AppName
End Sub


' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

Sub App_Started
	startat=DateTime.Now
	scroll=1
	weekday=GetWeekNumber(DateTime.Now)
End Sub


Sub App_genFrame
	If App.get("12hrFormat") Then
		DateTime.TimeFormat="KK:mm a"
		Dim xpos As Int =2
	Else
		If  App.get("ShowSeconds") Then
			DateTime.TimeFormat = "HH:mm:ss"
			Dim xpos As Int =2
		Else
			Dim xpos As Int =7
			DateTime.TimeFormat = "HH:mm"
		End If
		
	End If
	
	Dim second As Int =DateTime.GetSecond(DateTime.Now)
	Dim timeString As String= DateTime.Time(DateTime.Now)
	
	If  App.get("ShowDate") Then
		If startat<DateTime.Now-App.Appduration*1000/2 Then
			Dim day As String=NumberFormat( DateTime.GetDayOfMonth(DateTime.Now),2,0)
			Dim month As String=NumberFormat(DateTime.GetMonth(DateTime.Now),2,0)
			'Sets the Date Format
			If App.get("DateFormat")= "MM/DD" Then
				App.drawText(month&"."& day&".",7,scroll-8,Null)
			Else
				App.drawText(day&"."& month&".",7,scroll-8,Null)
			End If
			If  App.get("ShowSeconds") Then
				App.drawText(timeString,xpos,scroll,Null)
			Else
				If second Mod 2 >0 Then
					App.drawText(timeString,xpos,scroll,Null)
				Else
					App.drawText(timeString.Replace(":"," "),xpos,scroll,Null)
				End If
			End If
					
			If scroll<9 Then
				scroll=scroll+1
			End If
		Else
			If App.get("ShowSeconds") Then
				App.drawText(timeString,xpos,1,Null)
			Else
				If second Mod 2 >0 Then
					App.drawText(timeString,xpos,1,Null)
				Else
					App.drawText(timeString.Replace(":"," "),xpos,1,Null)
				End If
			End If
			
		End If
	Else
		If App.get("ShowSeconds") Then
			App.drawText(timeString,xpos,1,Null)
		Else
			If second Mod 2 >0 Then
				App.drawText(timeString,xpos,1,Null)
			Else
				App.drawText(timeString.Replace(":"," "),xpos,1,Null)
			End If
		End If
	End If
	
	If App.get("ShowWeekday") Then
		App.drawLine(0,7,31,7,Array As Int(0,0,0))
		For i=0 To 6
			If i=weekday-1  Then
				App.drawLine(2+i*4,7,i*4+4,7,Array As Int(200,200,200))
			Else
				App.drawLine(2+i*4,7,i*4+4,7,Array As Int(80,80,80))
			End If
		Next
	End If
End Sub

Private Sub GetWeekNumber(DateTicks As Long) As Int
	Dim psCurrFmt As String = DateTime.DateFormat
	DateTime.DateFormat = "u"
	Dim piCurrentWeek As Int = DateTime.Date(DateTicks)
	DateTime.DateFormat = psCurrFmt
	Return piCurrentWeek
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim weekday As Int
	Dim scroll As Int
	Dim WeekdaysColor() As Int
	Dim CurrentDayColor() As Int
End Sub

'Initializes the object. You can NOT add parameters to this method!
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Time"
	
	'Version of the App
	App.Version="1.3"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows Time, Date and the day of the week."
	
	App.Author = "Blueforcer"
	
	App.CoverIcon = 13
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>ShowWeekday:</b>  Whether the weekday should be displayed or not (true/false).<br />
	<b>ShowSeconds:</b>  Whether the seconds should be displayed or not (true/false).<br />
	<b>ShowDate:</b>  Whether the date should be displayed or not (true/false).<br />
	<b>12hrFormat:</b>  Switch from 24hr to 24h timeformat (true/false).<br />
	<b>DisableBlinking:</b>  Disable the colon blinking (true/false).<br />
	<b>DateFormat:</b>  Set date format (DD/MM or MM/DD) .<br />
	<b>StartsSunday:</b>  Week begins on sunday .<br />
	<b>CurrentDayColor:</b> Color of the current day highlight (R,G,B) .<br />
	<b>WeekdaysColor:</b>  Color of the other days highlight (R,G,B) .<br />
	"$
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings= CreateMap("ShowSeconds":False,"ShowWeekday":True,"ShowDate":True,"12hrFormat":False,"DisableBlinking":False,"StartsSunday":False,"DateFormat":"DD/MM","WeekdaysColor":"80,80,80","CurrentDayColor":"255,255,255") 'needed Settings for this Plugin
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub


' must be available
public Sub GetNiceName() As String
	Return App.Name
End Sub


' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_Started
	scroll=1
	weekday=GetWeekNumber(DateTime.Now)
	If App.get("StartsSunday") Then
		weekday=weekday+1
	End If
	
	Dim weekcolor As String = App.get("WeekdaysColor")
	WeekdaysColor = Array As Int(80,80,80)
	
	If weekcolor.Contains(",") Then
		Dim c() As String = Regex.Split(",",weekcolor)
		
		If c.Length=3 Then
			WeekdaysColor(0)=c(0)
			WeekdaysColor(1)=c(1)
			WeekdaysColor(2)=c(2)
		End If
	End If
	
	Dim currentday As String = App.get("CurrentDayColor")
	CurrentDayColor = Array As Int(255,255,255)
	If currentday.Contains(",") Then
		Dim c1() As String = Regex.Split(",",currentday)
		
		If c1.Length=3 Then
			CurrentDayColor(0)=c1(0)
			CurrentDayColor(1)=c1(1)
			CurrentDayColor(2)=c1(2)
		End If
	
	End If
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
		If App.startedAt<DateTime.Now-App.duration*1000/2 Then
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
				If second Mod 2 >0 Or App.get("DisableBlinking") Then
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
				If second Mod 2 >0 Or App.get("DisableBlinking") Then
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
			If second Mod 2 >0 Or App.get("DisableBlinking") Then
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
				App.drawLine(3+i*4,7,i*4+5,7,CurrentDayColor)
			Else
				App.drawLine(3+i*4,7,i*4+5,7,WeekdaysColor)
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
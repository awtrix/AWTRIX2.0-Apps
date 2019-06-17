B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim weekday As String
	Dim week As Int
	Dim scroll As Int
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.AppName="DayOfTheWeek"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows the Day of the Week and the Week of the Year<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>ShowWeekOfYear:</b>Wether it should show the Week of the Year (true/false)<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int()
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("ShowWeekOfYear":True)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	scroll=1
	weekday= DateUtils.GetDayOfWeekName(DateTime.Now)
	Dim offset As Int = DateTime.GetDayOfWeek(DateUtils.SetDate( _
    DateTime.GetYear(DateTime.Now), 1, 1)) - 1
	week= Floor((DateTime.GetDayOfYear(DateTime.Now) -1 + offset) / 7) + 1
End Sub

'With this sub you build your frame.
Sub App_genFrame
If App.get("ShowWeekOfYear") Then
	If App.StartedAt<DateTime.Now-App.Appduration*1000/2 Then
		App.genText(week,False,scroll-8,Null)
		App.genText(weekday,False,scroll,Null)
		If scroll<9 Then
			scroll=scroll+1
		End If
		Else
		App.genText(weekday,False,1,Null)
	End If
	Else
		App.genText(weekday,False,1,Null)
End If
End Sub

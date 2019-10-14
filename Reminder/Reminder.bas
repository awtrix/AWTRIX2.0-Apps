B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim Days As String
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Reminder"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows the remaining days from now to a reminder"$
	
	App.Author="King.Shen"
	
	App.CoverIcon = 806
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>DayOfMonth:</b>  Target date (Format: dd).<br />
	<small>Note: Please make sure the date of month existing in this/next month.</small><br />
	<b>ShowText:</b>  Content of reminder.<br />
	<b>IconID:</b>  Choose your desired IconID from AWTRIXER.<br />
	<b>Identifier:</b>  Enter your desired translation for "days,day" Example: Tage,Tag.<br />
	"$
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons = Array As Int(806)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick = 65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings = CreateMap("DayOfMonth":"01", "ShowText":"Things to do", "Identifier":"Days,Day", "IconID":806)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

Sub App_Started
	Days=ExecuteReminder
End Sub


' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons = Array As Int(App.Get("IconID"))
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genText(Days,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(App.Get("IconID")),8,8)
End Sub

Sub ExecuteReminder As String
	Dim AmountOfDays As String
	Dim Diff As Int
	Dim PerDiff As Period
	Dim DateNow As Long
	Dim TargetDate = 0 As Long
	
	DateTime.DateFormat = "dd.MM.yyyy"
	Dim TargetDayOfMonth = App.Get("DayOfMonth") As Int

	'----------------separate identifiers ------------------------
	Dim separatedIdentifier() As String
	separatedIdentifier = Regex.split(",",App.Get("Identifier"))
	
	'----------------date now------------------------
	Dim CurYear, CurMonth, CurDayOfMonth, DaysInCurMonth, DaysInNextMonth As Int
	CurYear = DateTime.GetYear(DateTime.Now)
	CurMonth = DateTime.GetMonth(DateTime.Now)
	CurDayOfMonth = DateTime.GetDayOfMonth(DateTime.Now)
	DateNow = DateUtils.SetDate(CurYear, CurMonth, CurDayOfMonth)
	DaysInCurMonth = DateUtils.NumberOfDaysInMonth(CurMonth, CurYear)
	
	'----------------fix target date------------------------
	'If target date is greater than current date, count in this month
	If TargetDayOfMonth >= CurDayOfMonth Then
		If TargetDayOfMonth <= DaysInCurMonth Then
			TargetDate = DateUtils.SetDate(CurYear, CurMonth, TargetDayOfMonth)
		End If
		If TargetDate = 0 Then
			Return "Date doesn't exist in this month"
		End If
		'If target date is less than current date, count in next month
	Else
		If CurMonth = 12 Then
			DaysInNextMonth = DateUtils.NumberOfDaysInMonth(1, CurYear + 1)
			If TargetDayOfMonth <= DaysInNextMonth Then
				TargetDate = DateUtils.SetDate(CurYear + 1, 1, TargetDayOfMonth)
			End If
		Else
			DaysInNextMonth = DateUtils.NumberOfDaysInMonth(CurMonth + 1, CurYear)
			If TargetDayOfMonth <= DaysInNextMonth Then
				TargetDate = DateUtils.SetDate(CurYear, CurMonth + 1, TargetDayOfMonth)
			End If
		End If
		
		If TargetDate = 0 Then
			Return "Date doesn't exist in next month"
		End If
	End If
	
	'----------------calculate difference ------------------------
	PerDiff = DateUtils.PeriodBetweenInDays(DateNow, TargetDate)
	Diff = PerDiff.Days
	
	'----------------process result ------------------------
	If Diff > 1 Then
		AmountOfDays = Diff
		AmountOfDays = App.Get("ShowText") & ": " & Diff & " " & separatedIdentifier(0)
	Else If Diff = 1 Then
		AmountOfDays = Diff
		AmountOfDays = App.Get("ShowText") & ": " & Diff & " " & separatedIdentifier(1)
	Else If Diff < 0 Then
		Diff = "0"	'we set the amount of days to zero here too
		AmountOfDays = App.Get("ShowText") & ": " & AmountOfDays & " " & separatedIdentifier(1)
	Else If Diff = 0 Then
		AmountOfDays = App.Get("ShowText") & ": " & "Today"
	End If

	Return AmountOfDays
End Sub
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
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="DayOfTheWeek"
	
	'Version of the App
	App.Version= "1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description = $"Shows the Day of the Week and the Week of the Year"$
	
	App.Author = "Blueforcer"	
		
	App.CoverIcon = 414
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>ShowWeekOfYear:</b>Wether it should show the Week of the Year (true/false)<br/>
	"$
		
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("ShowWeekOfYear":True)
	
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
	If App.StartedAt<DateTime.Now-App.duration*1000/2 Then
		App.genText(week,False,scroll-8,Null,True)
			App.genText(weekday,False,scroll,Null,True)
		If scroll<9 Then
			scroll=scroll+1
		End If
		Else
			App.genText(weekday,False,1,Null,True)
	End If
	Else
		App.genText(weekday,False,1,Null,True)
End If
End Sub

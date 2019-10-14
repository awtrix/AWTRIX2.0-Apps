B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim PerDiff As Period
	Dim iconID As Int
End Sub
' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="DaysGone"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows the past days from a certain date."$
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Date:</b>  Format: dd.mm.yyyy.<br />
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=711
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(711)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("QuitDate":"01.01.2019","IconID":635)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_iconRequest
	App.Icons=Array As Int(App.get("IconID"))
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	iconID=App.get("IconID")
	Try
		DateTime.DateFormat = "dd.MM.yyyy"
		PerDiff= DateUtils.PeriodBetweenInDays(DateTime.Dateparse(App.Get("QuitDate")),DateTime.now)
	Catch
		Log("Error in " &App.Name)
		Log(LastException)
	End Try
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genText(PerDiff.Days,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(iconID),8,8)
End Sub

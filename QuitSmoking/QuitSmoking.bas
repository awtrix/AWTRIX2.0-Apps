B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim PerDiff As Period
End Sub
' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.AppName="QuitSmoking"
	
	'Version of the App
	App.AppVersion="2.0"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows the days how long you don't smoke anymore<br/>
	<small>Created by AWTRIX</small> 
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>Quit Date:</b>  Format: dd.mm.yyyy.<br />
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(581)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("QuitDate":"01.01.2019")
	
	App.MakeSettings
	Return "AWTRIX2"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	Try
		DateTime.DateFormat = "dd.MM.yyyy"
		PerDiff= DateUtils.PeriodBetweenInDays(DateTime.Dateparse(App.Get("QuitDate")),DateTime.now)
	Catch
		Log("Error in " &App.AppName)
		Log(LastException)
	End Try
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genText(PerDiff.Days,True,1,Null)
	App.drawBMP(0,0,App.getIcon(581),8,8)
End Sub

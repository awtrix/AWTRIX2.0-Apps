B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim sun As Calculations
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Sunrise"
	
	'Version of the App
	App.Version="1.3"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows sunset and sunrise times for a given location.
	"$
	
	App.Author="0o.y.o0 & Blueforcer"
	
	App.CoverIcon=493
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Latitude:</b>  Enter the latitude for your location in degree (e.g.  50.1343).<br />
	<b>Longitude:</b>  Enter the longitude for your location in degree (e.g. 8.8398).<br />
	<b>12hrFormat:</b>  Switch from 24hr to 12h timeformat (true/false) .<br />
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(493)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Latitude":"50.1343", "Longitude":"8.8398", "12hrFormat":False)
	
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

Sub App_Started
	sun.Initialize(App.get("Latitude"),App.get("Longitude"),App.get("12hrFormat"))
	sun.doCalculation
End Sub

'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	App.genText(sun.SunTime,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(493),8,8)
End Sub

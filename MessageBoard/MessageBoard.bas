B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="MessageBoard"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Show a fixed text with an icon on your awtrix"$
	
	App.Author="TheHackLife"
	
	App.CoverIcon = 187
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>CustomText:</b>Text wich will be shown<br/>
	<b>IconID:</b>  Icon to show (ID).<br />
	"$
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons = Array As Int(187)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick = 65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings = CreateMap("ShowText":"", "IconID":187)
	
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

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons = Array As Int(App.Get("IconID"))
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genSimpleFrame(App.get("ShowText"),App.Get("IconID"),True,False,Null,False)
End Sub

B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	Dim repeats As Int 
	Dim displayTyp As Int
	Dim birthdayText As String
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "HappyBirthday"
	
	'Version of the App
	App.version = "1.2"
	
	'Description of the App. You can use HTML to format it
	App.description = $"Shows birthday congratulations"$
	
	'The developer if this App
	App.author = "jzech"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1302
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
    <b>Name:</b>  Name of birthday persond<br />
	"$

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Name":"jzech")
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Happy Birthday", "Congratulation")
	
	'How many downloadhandlers should be generated
	App.downloads = 0
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1302)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = False
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	displayTyp = 1
	repeats = 0
	birthdayText = "Happy Birthday " & App.get("Name")
End Sub
	
'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	birthdayText = "Happy Birthday " & App.get("Name")
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	Dim count As Int
	If (displayTyp > 0) Then
		count = App.showMulticolorText(1302, birthdayText,1, App.rainbowList)
	Else 
		count = App.showMulticolorFalling(1302, birthdayText, App.rainbowList, True)
	End If

	If (count = 0) Then repeats = repeats + 1
	If (repeats > 1) Then
		App.resetLocalTickCount
		repeats = 0
		displayTyp = -1 * displayTyp 
	End If
End Sub



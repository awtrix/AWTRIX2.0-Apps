B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim started As Long
	Dim LastDrink As Long
	Dim alreadydrunk As Int
	Dim buttonPushed As Boolean
	Dim reminded As Int
	Dim reset As Boolean
	Dim RemindSoundPlayed As Boolean
	Dim DrinkSoundPlayed As Boolean
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
	started=DateTime.Now
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "DrinkWater"
	
	'Version of the App
	App.version = "1.1"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Reminds you to drink water. <br/>
	(interactive)
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1238
	
	'needed Settings for this App wich can be configurate from user via webinterface. Dont use spaces here!
	App.settings = CreateMap("RemindEvery":60,"GlassVolume":200,"Goal":2600,"RemindSound":120,"DrinkSound":121,"PlaySound":True)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	The app will remind you to drink until you confirm via the middle button. Then you will be reminded again after the set minutes.
	when you have reached your daily goal, the app will disappear for the rest of the day.<br/>
	<br/>
	<b>RemindEvery:</b> After how many minutes do you want to be reminded of drinking?<br/>
	<b>GlassVolume:</b> How many milliliters of water does your glass hold<br/>
	<b>Goal:</b> How many milliliters would you like to drink during the day?<br/>	
	<b>PlaySound:</b> Plays a sound to reminds you acoustically.<br/>	
	<b>RemindSound:</b> Sound file to be played during the reminder.<br/>	
	<b>DrinkSound:</b> Sound file to be played at confirmation.<br/>	
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("water", "drink", "reminder")
	

	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1238)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
	If DateTime.GetHour(DateTime.Now) = 0 And reset =False Then
		alreadydrunk=0
		reset=True
	Else
		reset=False
	End If
	
	Dim everyXMinutes As Int = App.get("RemindEvery") * 60000
	 
'	Dim nextdrink As Int = (DateTime.Now + LastDrink - everyXMinutes)*60000
'	App.setupDescription="Next reminder in " & nextdrink & " minutes"
	If alreadydrunk>= App.get("Goal") Then
		App.shouldShow=False
	Else
		If DateTime.Now - everyXMinutes > LastDrink Then
			App.shouldShow=True
		Else
			App.shouldShow=False
		End If
	End If
	

End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	buttonPushed=False
	RemindSoundPlayed=False
	DrinkSoundPlayed=False
End Sub

'This sub is called right before AWTRIX will display your App.
'If you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'If you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'If you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'This sub is called when the user presses the middle touchbutton while the app is running
Sub App_buttonPush
	
	If  alreadydrunk< App.get("Goal") Then
		alreadydrunk=alreadydrunk+App.get("GlassVolume")
	End If
	
	App.shouldShow=False
	LastDrink=DateTime.Now
	buttonPushed=True
	DrinkSoundPlayed=False
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	
	If App.shouldShow And App.get("PlaySound") And Not(RemindSoundPlayed) Then
		App.playSound(App.get("RemindSound"))
		RemindSoundPlayed=True
	End If
	
	If buttonPushed Then
		
		If App.get("PlaySound") And Not(DrinkSoundPlayed) Then
			App.playSound(App.get("DrinkSound"))
			DrinkSoundPlayed=True
		End If
		
		If alreadydrunk < 1000 Then
			App.genSimpleFrame(alreadydrunk&"ml",1238,False,Null,True)
		Else
			App.genSimpleFrame((alreadydrunk/1000) &"L",1238,False,Null,True)
		End If
		
	Else
		App.genSimpleFrame("Drink!",1238,False,Null,True)
	End If
	
	
End Sub


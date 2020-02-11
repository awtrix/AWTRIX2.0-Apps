B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here	
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
	App.name = "CustomApp"
	
	'Version of the App
	App.version = "1.1"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	 You can use this app to integrate your notifications firmly into the Apploop.  
	"$
	
	'The developer if this App
	App.author = "Blueforcer"
	
	App.setupDescription= $"
	Use the App Sort function to place this app anywhere in your apploop. Each app gets its own ID (starting with 0).
Now send your notifications via any API interface (MQTT: topic /customapp; REST: endpoint /api/v3/customapp)  and add the key "ID" with the app ID. The notification will be saved and displayed continuously so you don't have to actively send the notification. You can overwrite any ID at any time.
	"$

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1060
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Template", "Awesome")
	
	'How many downloadhandlers should be generated
	App.downloads = 0
	
	
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
	
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	

End Sub
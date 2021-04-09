B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	'Declare your variables here
	Dim inzidenz As Double
	Dim deaths As Int
	Dim mortality As Double
	Dim cases As Int
	Dim landkreis As String
	Dim framelist As List

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
	
	framelist.Initialize
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "Corona_Lkr"
	
	'Version of the App
	App.version = "1.7"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Zeigt die aktuelle Inzidenz, Tote und Sterblichkeitsrate aus deinem Landkreis. (Germany only)
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Apspstore and MyApps
	App.coverIcon = 1298
	
	'needed Settings for this App wich can be configurate from user via webinterface. Dont use spaces here!
	App.settings = CreateMap("ObjectID":"","Landkreis":True,"Inzidenz":True,"Tote":True,"Sterblichkeit":True,"Fälle":True,"Einfärben":True)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>ObjectID:  </b>Klicke auf deinen Landkreis in <a href="https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0" target="_blank">dieser Map</a> und kopiere dir die ObjectID die angezeigt wird.<br/>
	<b>Einfärben: Färbt die inzidenz anhand des Wertes Grün, Gelb, Rot</b>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Corona", "Deutschland")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1298)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub


	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
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
	
End Sub

'It possible to create your own setupscreen in HTML.
'This is a very dirty workaround, but its works:)
'Every input must contains an ID with the corresponding settingskey in lowercase 
Sub App_CustomSetupScreen As String
	Return ""
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download($"https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=OBJECTID=${App.get("ObjectID")}&outFields=GEN,death_rate,cases,deaths,cases7_per_100k,&returnGeometry=false&outSR=4326&f=json"$)
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim features As List = root.Get("features")
					Dim colfeatures As Map = features.Get(0)
					Dim attributes As Map = colfeatures.Get("attributes")
					Log(attributes)
					cases= attributes.Get("cases")
					inzidenz = attributes.Get("cases7_per_100k")
					mortality= attributes.Get("death_rate")
					deaths= attributes.Get("deaths")
					landkreis=attributes.Get("GEN")
			End Select
		End If
	Catch
		App.throwError("Error while eval http job" & LastException)
		App.throwError(LastException)
	End Try
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
	
	framelist.Clear
	
	
	If App.get("Landkreis") Then
		Dim frame As FrameObject
		frame.Initialize
		frame.text=landkreis
		frame.TextLength=App.calcTextLength(frame.text)
		frame.Icon=1298
		frame.color=Null
		framelist.Add(frame)
	End If
	
	If App.get("Inzidenz") Then
		Dim frame1 As FrameObject
		frame1.Initialize
		frame1.text="Inzidenz: " & Round2(inzidenz,2)
		frame1.TextLength=App.calcTextLength(frame1.text)
		
		If App.get("Einfärben") Then
			If inzidenz>50 Then
				frame1.color= Array As Int(255,0,0)
			else if inzidenz>35 Then
				frame1.color= Array As Int(255,255,0)
			Else
				frame1.color= Array As Int(0,255,0)
			End If
		Else
			frame1.color= Null
		End If
		
	
		
		If Not(App.get("Landkreis")) Then
			frame1.Icon=1298
		End If
		
		framelist.Add(frame1)
	End If
	
	If App.get("Fälle") Then
		Dim frame2 As FrameObject
		frame2.Initialize
		frame2.text="Fälle: " & cases
		frame2.TextLength=App.calcTextLength(frame2.text)
		frame2.color = Null
		framelist.Add(frame2)
	End If
	
	If App.get("Tote") Then
		Dim frame3 As FrameObject
		frame3.Initialize
		frame3.text="Tote: " & deaths
		frame3.TextLength=App.calcTextLength(frame3.text)
		frame3.color = Null
		framelist.Add(frame3)
	End If
	
	If App.get("Sterblichkeit") Then
		Dim frame4 As FrameObject
		frame4.Initialize
		frame4.text="Sterblichkeit: " & Round2(mortality,2) & "%"
		frame4.TextLength=App.calcTextLength(frame4.text)
		frame4.color=Null
		framelist.Add(frame4)
	End If
	
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.FallingText(framelist,True)
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim ads_blocked_today As Int
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
	App.name = "PiHole"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows the amount of todays blocked Ads
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 759
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("PiHole":"")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>PiHole:</b>IP-Adress of your Pi-Hole<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(759)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65


	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
End Sub
	
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'this sub is called right before AWTRIX will display your App.
'if you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'if you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'if you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)
	
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://"&App.get("PiHole")&"/admin/api.php")
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
'					Dim unique_domains As Int = root.Get("unique_domains")
'					Dim privacy_level As Int = root.Get("privacy_level")
'					Dim reply_NODATA As Int = root.Get("reply_NODATA")
'					Dim reply_NXDOMAIN As Int = root.Get("reply_NXDOMAIN")
					ads_blocked_today = root.Get("ads_blocked_today")
'					Dim dns_queries_all_types As Int = root.Get("dns_queries_all_types")
'					Dim gravity_last_updated As Map = root.Get("gravity_last_updated")
'					Dim file_exists As String = gravity_last_updated.Get("file_exists")
'					Dim absolute As Int = gravity_last_updated.Get("absolute")
'					Dim relative As Map = gravity_last_updated.Get("relative")
'					Dim hours As String = relative.Get("hours")
'					Dim minutes As String = relative.Get("minutes")
'					Dim days As String = relative.Get("days")
'					Dim dns_queries_today As Int = root.Get("dns_queries_today")
'					Dim reply_IP As Int = root.Get("reply_IP")
'					Dim queries_cached As Int = root.Get("queries_cached")
'					Dim reply_CNAME As Int = root.Get("reply_CNAME")
'					Dim domains_being_blocked As Int = root.Get("domains_being_blocked")
'					Dim ads_percentage_today As Double = root.Get("ads_percentage_today")
'					Dim queries_forwarded As Int = root.Get("queries_forwarded")
'					Dim clients_ever_seen As Int = root.Get("clients_ever_seen")
'					Dim unique_clients As Int = root.Get("unique_clients")
'					Dim status As String = root.Get("status")
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	App.genText(ads_blocked_today ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(759),8,8)
End Sub
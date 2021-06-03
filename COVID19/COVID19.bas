B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	Dim confirmed As Int = 0
	Dim active As Int = 0
	Dim recovered As Int = 0
	Dim deaths As Int = 0
	Dim mortality As Double = 0
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
	App.name = "COVID19"
	
	'Version of the App
	App.version = "1.3"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Displays Corona virus cases for your Country<br/>
	Data from the <i>Center for Systems Science and Engineering (CSSE)</i> at Johns Hopkins University in Baltimore, Maryland, USA<br/>
	"$
	
	'The developer if this App
	App.author = "elpatron"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1040
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("Country":"Germany", "Confirmed":True, "Recovered":True, "Active":True, "Deaths":True, "Mortality":True)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>Select country and values to be displayed.</b><br/>
	Find supported countries <a href="https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6" target="_blank">here</a> 
	(enter the name exactly as in the left sided list).<br/>
	Mortality is calculated by: <pre><i>Deaths</i> * 100 / <i>Confirmed</i></pre>
	Read <a href="https://heise.de/-4679338">this article</a> (german) for a deeper look into different methods of 
	calculation of mortality rates. At this early stage of the desease, it´s extremely hard to find reasonable values!<br/>
	<i>Read <a href="https://systems.jhu.edu/research/public-health/ncov/">this blog article</a> for more background information about the source of the values.</i><br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Corona", "Virus", "Health")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(1040)
	
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
	Dim url As String= ""
	' url = "https://services9.arcgis.com/N9p5hsImWXAccRNI/arcgis/rest/services/Z7biAeD8PAkqgmWhxG2A/FeatureServer/2/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc&outSR=102100&resultOffset=0&resultRecordCount=200&cacheHint=true"
	url = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/2/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc&resultOffset=0&resultRecordCount=100&cacheHint=true"
	App.Download(url)
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Dim parser As JSONParser
			parser.Initialize(Resp.ResponseString)
			Dim root As Map = parser.NextObject
			Dim features As List = root.Get("features")
			For Each colfeatures As Map In features
				Dim attributes As Map = colfeatures.Get("attributes")
				Dim Country_Region As String = attributes.Get("Country_Region")
				Log("Country: " & Country_Region)
				If Country_Region = App.get("Country") Then
					recovered = attributes.Get("Recovered")
					active = attributes.Get("Active")
					deaths = attributes.Get("Deaths")
					confirmed = attributes.Get("Confirmed")
					If confirmed > 0 Then
						mortality = Round2(deaths * 100 / confirmed, 2)
					End If
					Exit
				End If
			Next
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	Dim text As String = "Covid-19 rates: "
	If App.get("Confirmed") = True Then
		text = text & "Infections: " & confirmed & " "
	End If
	If App.get("Recovered") = True Then
		text = text & "Recovered: " & recovered & " "
	End If
	If App.get("Active") = True Then
		text = text & "Active: " & active & " "
	End If
	If App.get("Deaths") = True Then
		text = text & "Deaths: " & deaths  & " "
	End If
	If App.get("Mortality") = True Then
		text = text & "Mortality: " & mortality & " %"
	End If
	
	App.genText(text, True, 1, Null, True)
	If App.scrollposition > 9 Then
		App.drawBMP(0,0,App.getIcon(1040),8,8)
	Else
		If App.scrollposition > -8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(1040),8,8)
		End If
	End If
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	Dim total As Int = 0
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
	App.version = "1.1"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Displays Corona virus global cases<br/>
	Data from the <i>Center for Systems Science and Engineering (CSSE)</i> at Johns Hopkins University in Baltimore, Maryland, USA<br/>
	<a href="https://systems.jhu.edu/research/public-health/ncov/">Coronavirus Dashboard</a>
	"$
	
	'The developer if this App
	App.author = "elpatron"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1040
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("Totals":True, "Recovered":True, "Deaths":True, "Mortality":True,"UpdateInterval":3600)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>Select values to be displayed.</b><br/>
	Mortality is calculated by: <pre><i>Deaths</i> * 100 / <i>Infections</i></pre>
	<i>Read <a href="https://systems.jhu.edu/research/public-health/ncov/">this blog article</a> for more background information.</i><br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Corona", "Virus", "Health")
	
	'How many downloadhandlers should be generated
	App.downloads = 3
	
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
	Dim parameter As String = ""
	Select jobNr
		Case 1
			' Confirmed
			parameter = "Confirmed"
		Case 2
			' Recovered
			parameter = "Recovered"
		Case 3
			' Deaths
			parameter = "Deaths"
	End Select
	Dim url As String = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22" & parameter & "%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true"
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
				Dim value As Int = attributes.Get("value")
			Next
			Select Resp.jobNr
				Case 1
					total = value
					Log("COVID19-Total: " & total)
				Case 2
					recovered = value
					Log("COVID19-Recovered: " & recovered)
				Case 3
					deaths = value
					Log("COVID19-Deaths: " & deaths)
					If total > 0 Then
						mortality = Round2(deaths * 100 / total, 2)
					End If
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	Dim text As String = "Covid-19 rates: "
	If App.get("Totals") = True Then
		text = text & "Infections: " & total & " "
	End If
	If App.get("Recovered") = True Then
		text = text & "Recovered: " & recovered & " "
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
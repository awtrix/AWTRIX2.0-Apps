B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	'Declare your variables here
	Dim Stations As Map
	Dim sb As StringBuilder
	Dim displaylist As List
	Dim SettingsMap As Map
	Dim devices As List
	Dim finaldatapoints As Map
	Dim showedNames As List
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
	displaylist.Initialize
	showedNames.Initialize
	finaldatapoints.Initialize
	devices.Initialize
	SettingsMap.Initialize
	Stations.Initialize
	'App name (must be unique, no spaces)
	App.name = "Netatmo"
	
	'Version of the App
	App.version = "1.96"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows the data of all Netatmo Modules.
	"$
	
	App.setupDescription="Login and refresh the Page. After that you can enable or disable your desired datapoints"
	
	'The developer if this App
	App.author = "Blueforcer & Whyet"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 874
	
	App.InitializeOAuth("https://api.netatmo.com/oauth2/authorize","https://api.netatmo.com/oauth2/token","xxxxxx","xxxxxxxx","read_station")
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Netatmo", "Awesome")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(874,235,693,1213,976,1215)

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
	displaylist.Clear
	showedNames.Clear
	For Each k As String In finaldatapoints.Keys
		If App.settings.ContainsKey(k) Then
			If App.settings.Get(k) = True Then
				Dim d() As String = Regex.Split("_",k)
				
				'Ein Wert der Station
				If d.Length=2 Then
					
					Dim stationname As String = d(0)
					
					If showedNames.IndexOf(stationname) = -1 Then
						showedNames.Add(stationname)
						Dim datapoint As String = d(1)
						Dim value As String = finaldatapoints.Get(k)
						Dim frame As FrameObject
						frame.Initialize
						frame.text = stationname
						frame.TextLength = App.calcTextLength(frame.text)
						frame.color=Array As Int(255,255,255)
						frame.Icon = 874
						displaylist.Add(frame)
						Dim datapoint As String = d(1)
						Dim value As String = finaldatapoints.Get(k)
						Dim frame As FrameObject
						frame.Initialize
						frame.text = value & getUnit(datapoint)
						frame.TextLength = App.calcTextLength(frame.text)
						frame.color=Null
						frame.Icon = getIcon(datapoint)
						displaylist.Add(frame)
					Else
						Dim datapoint As String = d(1)
						Dim value As String = finaldatapoints.Get(k)
						Dim frame As FrameObject
						frame.Initialize
						frame.text = value & getUnit(datapoint)
						frame.TextLength = App.calcTextLength(frame.text)
						frame.color=Null
						frame.Icon = getIcon(datapoint)
						displaylist.Add(frame)
					End If
	
				End If
				
				'Ein Wert eines Moduls
				If d.Length=3 Then
					Dim stationname1 As String = d(0)
					Dim modulename1 As String = d(1)
					If showedNames.IndexOf(modulename1) = -1 Then
						showedNames.Add(modulename1)
						Dim datapoint1 As String = d(2)
						Dim value1 As String = finaldatapoints.Get(k)
						Dim frame1 As FrameObject
						frame1.Initialize
						frame1.text = modulename1
						frame1.TextLength = App.calcTextLength(frame1.text)
						frame1.color=Array As Int(255,255,255)
						frame1.Icon = 874
						displaylist.Add(frame1)
						Dim datapoint1 As String = d(2)
						Dim value1 As String = finaldatapoints.Get(k)
						Dim frame1 As FrameObject
						frame1.Initialize
						frame1.text = value1 & getUnit(datapoint1)
						frame1.TextLength = App.calcTextLength(frame1.text)
						frame1.color=Null
						frame1.Icon = getIcon(datapoint1)
						displaylist.Add(frame1)
					Else
						Dim datapoint1 As String = d(2)
						Dim value1 As String = finaldatapoints.Get(k)
						Dim frame1 As FrameObject
						frame1.Initialize
						frame1.text = value1 & getUnit(datapoint1)
						frame1.TextLength = App.calcTextLength(frame1.text)
						frame1.color=Null
						frame1.Icon = getIcon(datapoint1)
						displaylist.Add(frame1)
					End If
					
				End If
			End If
		End If
	Next

	If( displaylist.Size == 0 ) Then
		App.shouldShow=False
	Else
		App.shouldShow=True
	End If
End Sub

Sub getIcon(datapoint As String) As Int
	Select True
		Case datapoint.ToLowerCase.Contains("temperature")
			Return 235
		Case datapoint.ToLowerCase.Contains("humidity")
			Return 693
		Case datapoint.ToLowerCase.Contains("co2")
			Return 1213
		Case datapoint.ToLowerCase.Contains("pressure")
			Return 976
		Case datapoint.ToLowerCase.Contains("noise")
			Return 1215
		Case Else 874
	End Select
End Sub

Sub getUnit(datapoint As String) As String
	Select True
		Case datapoint.ToLowerCase.Contains("temperature")
			Return " °C"
		Case datapoint.ToLowerCase.Contains("humidity")
			Return " %"
		Case datapoint.ToLowerCase.Contains("co2")
			Return " ppm"
		Case datapoint.ToLowerCase.Contains("pressure")
			Return " mb"
		Case datapoint.ToLowerCase.Contains("noise")
			Return " dB"
		Case Else 874
	End Select
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


'End Sub
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
			App.Download("https://api.netatmo.com/api/getstationsdata")
			App.header= CreateMap("Authorization": "Bearer " & App.Token)
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
					If Resp.Success = True Then
						Dim parser As JSONParser
						finaldatapoints.Clear
						parser.Initialize(replaceUmlauts(Resp.ResponseString))
					
						Dim root As Map = parser.NextObject
						Dim body As Map = root.Get("body")
						devices = body.Get("devices")
						For Each coldevices As Map In devices
							
							Dim station_name As String = coldevices.Get("station_name")
							
							If station_name.Contains("(") And  station_name.Contains(")") Then
								station_name=station_name.SubString2(0,station_name.IndexOf("(")-1)
								station_name=station_name.Replace(" ","")
								station_name=station_name.Replace(".","")
							End If
													
							
							Dim stationreachable As Boolean= coldevices.Get("reachable")
							If stationreachable=False Then Continue
							Dim station_datapoints As List = coldevices.Get("data_type")
							
							Dim station_dashboard_data As Map = coldevices.Get("dashboard_data")
							
							For Each dp As String In station_datapoints
								If Not(App.settings.ContainsKey(station_name & "_" & dp)) Then
									App.settings.Put(station_name & "_" & dp,True)
								End If
								finaldatapoints.Put(station_name & "_" & dp,station_dashboard_data.Get(dp))
							Next
							
							Dim modules As List = coldevices.Get("modules")
							For Each colmodules As Map In modules
								Dim module_name As String = colmodules.Get("module_name")
								Dim modulereachable As Boolean= colmodules.Get("reachable")
								If modulereachable=False Then Continue
								Dim module_datapoints As List = colmodules.Get("data_type")
								Dim module_dashboard_data As Map = colmodules.Get("dashboard_data")
								
								For Each moduledatapoint As String In module_datapoints
									If Not(App.settings.ContainsKey(module_name & "_" & moduledatapoint)) Then
										App.settings.Put(station_name & "_" & module_name & "_" & moduledatapoint,True)
									End If
									finaldatapoints.Put(station_name & "_" & module_name & "_" & moduledatapoint,module_dashboard_data.Get(moduledatapoint))
								Next
							Next
						Next
						File.WriteMap(File.DirApp,"netatmoSettings.txt",App.settings)
						App.makeSettings
					End If
			End Select

		Else
			
'		Log("NO SUCSESS: "&Resp.ResponseString)
			
		End If
	Catch
		App.throwError(LastException)
	End Try
	
End Sub

Sub App_CustomSetupScreen As String
	sb.Initialize
	
	sb.Append("<ul>")
	For Each device As Map In devices
		Dim station_name As String = device.Get("station_name")
		If station_name.Contains("(") And  station_name.Contains(")") Then
			station_name=station_name.SubString2(0,station_name.IndexOf("(")-1)
			station_name=station_name.Replace(" ","")
			station_name=station_name.Replace(".","")
		End If
		
		sb.Append($"<li><h5>${station_name}</h5>"$)
		sb.Append("<h6>Datapoints</h6><ul>")
		
		Dim station_datapoints As List = device.Get("data_type")
		
		For Each stationdata As String In station_datapoints
			If App.settings.ContainsKey(station_name & "_"  & stationdata) Then
				sb.Append($"<li><div class="switch">
							<label for="${station_name.ToLowerCase & "_"  & stationdata.ToLowerCase}" style="display: inline-block;width: 100px;">${stationdata}</label>
                            <label><input type="checkbox" id="${station_name.ToLowerCase & "_"  & stationdata.ToLowerCase}" ${boolToChecked(App.Get(station_name & "_"  & stationdata))}>
							<span class="lever switch-col-blue"></span></label>
                    </div></li>"$)
			Else
				sb.Append($"<li>Not reachable</li>"$)
			End If
		Next
		sb.Append("</ul>")
		
		sb.Append("<h6>Modules</h6>")
		sb.Append("<ul>")
		
		Dim modules As List = device.Get("modules")
		
		For Each colmodules As Map In modules
			Dim module_name As String = colmodules.Get("module_name")
			sb.Append($"<li>${module_name}"$)
			sb.Append("<ul>")
'			Dim battery_percent As Int = colmodules.Get("battery_percent")
			Dim datapoints As List = colmodules.Get("data_type")
			For Each data As String In datapoints
				If App.settings.ContainsKey(station_name & "_"  & module_name & "_"  & data) Then
					sb.Append($"<li><div class="switch">
							<label for="${station_name.ToLowerCase & "_"  & module_name.ToLowerCase & "_"  & data.ToLowerCase}" style="display: inline-block;width: 100px;">${data}</label>
                            <label><input type="checkbox" id="${station_name.ToLowerCase & "_"  & module_name.ToLowerCase & "_"  & data.ToLowerCase}" ${boolToChecked(App.Get(station_name & "_"  & module_name & "_"  & data))}>
							<span class="lever switch-col-blue"></span></label>
                    </div></li>"$)
				Else
					sb.Append($"<li>Not reachable</li>"$)
				End If
				
			Next
			sb.Append("</ul></li>")
		Next
		sb.Append("</ul></li>")
	Next
	
	sb.Append("</ul>")
	Return sb.ToString
End Sub

Sub boolToChecked(checked As Boolean) As String
	If checked Then
		Return "checked"
	Else
		Return ""
	End If
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
    
	App.FallingText(displaylist,True)
'	App.drawBMP(0,0,App.getIcon(874),8,8)

End Sub

Sub replaceUmlauts(text As String) As String
	
	Dim t As String = text.Replace("\u00fc","ue").Replace("\u00f6","oe").Replace("\u00e4","ae").Replace("\u00dc","UE").Replace("\u00d6","OE").Replace("\u00c4","AE")
	File.WriteString(File.DirApp,"netatmo.txt",t)
	Return t
End Sub

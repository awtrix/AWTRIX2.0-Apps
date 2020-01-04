B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim OutsideTemp As Double = 0
	Dim access_token As String
	Dim CO2Value As Int = 0 
	Dim ModuleType As String =""
	Dim DisplayText As String 
	
	Dim displaylist As List
	Dim ModuleUpdate As Boolean = False
	Dim SettingsMap As Map
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
	SettingsMap.Initialize
	'App name (must be unique, no spaces)
	App.name = "Netatmo"
	
	'Version of the App
	App.version = "1.4"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	This App shows the temperature of a Netatmo Module
	"$
	
	'The developer if this App
	App.author = "wHyEt2004"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 874
	
	
	SettingsMap.Put("ClientID","")
	SettingsMap.Put("ClientSecret","")
	SettingsMap.Put("DeviceID","")
	SettingsMap.Put("E-Mail","")
	SettingsMap.Put("Password","")
	SettingsMap.Put("Modulename","")
	SettingsMap.Put("AutoGetModules",False)
	App.settings = SettingsMap
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	'App.settings = CreateMap("ClientID":"","ClientSecret":"","DeviceID":"","E-Mail":"","Password":"","Modulename":"","ModuleCount":"","AutoGetModules":False)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>DeviceID:</b>The Mac Adress of the Weather Station<br/>
	<b>ClientID:</b>Create an app at https://dev.netatmo.com/myaccount</br></br>
	<b>ClientSecret:</b>Create an app at https://dev.netatmo.com/myaccount</br></br>
	<b>Modulename:</b>Name of the Module from wich you want to show the Temp</br></br>
	<b>Init the App with AutoGenMoudles. Enable and Save. Leave the Config for Netatmo and comeback. Then you can select all your desired values. After you Save the values will be displayed wenn the next update cycle is past.</br>
	"$
	
	
	
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Netatmo", "Awesome")
	
	'How many downloadhandlers should be generated
	App.downloads = 2
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(874)
	
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
	Log(App.get("AutoGetModules"))
	Dim AutoUpdateEnabled As String = App.get("AutoGetModules")
If(AutoUpdateEnabled == "true") Then
	 Log("Autoupdate True ... Disabling and Starting..")
	 App.saveSingleSetting("AutoGetModules", False)
	 ModuleUpdate = True 
'	    Get_Modules
'	If(App.get("ModuleCount") == "1") Then
		
'		App.settings = CreateMap("ClientID":"","ClientSecret":"","DeviceID":"","E-Mail":"","Password":"","Modulename":"","ModuleCount":"")
'		App.makeSettings
'	End If
'	If(App.get("ModuleCount") == "2") Then
		
'		App.settings = CreateMap("ClientID":"","ClientSecret":"","DeviceID":"","E-Mail":"","Password":"","Modulename":"","ModuleCount":"", "Modulename2":"")
'		App.makeSettings
'	End If
'	If(App.get("ModuleCount") == "3") Then
		
'		App.settings = CreateMap("ClientID":"","ClientSecret":"","DeviceID":"","E-Mail":"","Password":"","Modulename":"","ModuleCount":"", "Modulename2":"", "Modulename3":"")
'		App.makeSettings
'	End If
End If
End Sub


'Sub Get_Modules
'	Dim payload As String
'	payload = "grant_type=password&client_id="&App.get("ClientID")&"&client_secret="&App.get("ClientSecret")&"&username="&App.get("E-Mail")&"&password="&App.get("Password")
'	Log("Get_Modules_Started")
''	App.PostString("https://api.netatmo.com/oauth2/token", payload)
	
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
			Dim payload As String
			payload = "grant_type=password&client_id="&App.get("ClientID")&"&client_secret="&App.get("ClientSecret")&"&username="&App.get("E-Mail")&"&password="&App.get("Password")
			Log("Case 1 Started")
			App.PostString("https://api.netatmo.com/oauth2/token", payload)
		Case 2
			Log("Starting get Outside Temp")
			Dim payload As String
			payload = "access_token="&access_token&"&device_id="&App.get("DeviceID")
'			Log("Case 2: "&payload)
			App.PostString("https://api.netatmo.com/api/getstationsdata", payload)
			
	End Select
End Sub


'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Log(Resp.ResponseString)
			Log("-------------------" & Resp.jobNr)
			Select Resp.jobNr
				Case 1
					
					Log("JobName = " & Resp.jobNr & ", Success = " & Resp.Success)
					If Resp.Success = True Then
						Dim parser As JSONParser
						parser.Initialize(Resp.ResponseString)
						Dim root As Map = parser.NextObject
						Dim access_token As String = root.Get("access_token")
'						Dim refresh_token As String = root.Get("refresh_token")
'						Dim scope As List = root.Get("scope")
'						For Each colscope As String In scope
'						Next
'						Dim expire_in As Int = root.Get("expire_in")
'						Dim expires_in As Int = root.Get("expires_in")
					End If
				Case 2
'					Log("JobName = " & Resp.jobNr & ", Success = " & Resp.Success)
    				displaylist.Clear
					
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
'					Dim time_server As Int = root.Get("time_server")
'					Dim time_exec As Double = root.Get("time_exec")
					
					Dim body As Map = root.Get("body")
					Dim devices As List = body.Get("devices")
					For Each coldevices As Map In devices
'						Dim station_name As String = coldevices.Get("station_name")
						Dim module_name As String = coldevices.Get("module_name")
						Dim Type2 As String = coldevices.Get("type")
                        If ModuleUpdate = True Then 
							SettingsMap.Put(module_name, False)
							If Type2 = "NAMain" Then
								SettingsMap.Put(module_name & "_Temp", False)
								SettingsMap.Put(module_name & "_CO2", False)
							 End If
							If Type2 = "NAModule4" Then
								SettingsMap.Put(module_name & "_Temp", False)
								SettingsMap.Put(module_name & "_CO2", False)
							End If
							If Type2 = "NAModule1" Then
								SettingsMap.Put(module_name & "_Temp", False)							
							End If
                        End If
						

'						Dim reachable As String = coldevices.Get("reachable")
						Dim modules As List = coldevices.Get("modules")
						Dim dashboard_data As Map = coldevices.Get("dashboard_data")
						Try
						If  App.get(module_name & "_Temp")Then
							Dim Temperature As Double = dashboard_data.Get("Temperature")
								Dim frame0 As FrameObject
							OutsideTemp = Temperature
							DisplayText = OutsideTemp & "°"
							frame0.Initialize
							frame0.text = DisplayText
							frame0.TextLength = App.calcTextLength(frame0.text)
							frame0.Icon = 874
							Log("I am here " & frame0)
							displaylist.Add(frame0)

						End If
						Catch
							Log("not found") 
							End Try
						For Each colmodules As Map In modules
'							Dim last_seen As Int = colmodules.Get("last_seen")
'							Dim last_message As Int = colmodules.Get("last_message")
							Dim Type_ As String = colmodules.Get("type")
							ModuleType = Type_
'							Dim reachable As String = colmodules.Get("reachable")
'							Dim last_setup As Int = colmodules.Get("last_setup")
'							Dim rf_status As Int = colmodules.Get("rf_status")
'							Dim battery_vp As Int = colmodules.Get("battery_vp")
'							Dim battery_percent As Int = colmodules.Get("battery_percent")
'							Dim data_type As List = colmodules.Get("data_type")
'							For Each coldata_type As String In data_type			
'							Next
'							Dim id As String = colmodules.Get("_id")
							Dim module_name As String = colmodules.Get("module_name")
							
							If ModuleUpdate = True Then
								SettingsMap.Put(module_name, False)
								If Type_ = "NAMain" Then
									SettingsMap.Put(module_name & "_Temp", False)
									SettingsMap.Put(module_name & "_CO2", False)
								End If
								If Type_ = "NAModule4" Then
									SettingsMap.Put(module_name & "_Temp", False)
									SettingsMap.Put(module_name & "_CO2", False)
								End If
								If Type_ = "NAModule1" Then
									SettingsMap.Put(module_name & "_Temp", False)
								End If
							End If
							
							
							
							module_name=module_name.Replace("\u00c4","Ä").Replace("\u00e4","ä")
							module_name=module_name.Replace("\u00d6","Ö").Replace("\u00f6","ö")
							module_name=module_name.Replace("\u00dc","Ü").Replace("\u00fc","ü")
							module_name=module_name.Replace("\u00df","ß")
							
							
							
							
							
							
							
							Dim dashboard_data As Map = colmodules.Get("dashboard_data")
'							Dim date_min_temp As Int = dashboard_data.Get("date_min_temp")
'							Dim time_utc As Int = dashboard_data.Get("time_utc")
'							Dim date_max_temp As Int = dashboard_data.Get("date_max_temp")
							
'							Dim min_temp As Double = dashboard_data.Get("min_temp")
'							Dim Humidity As Int = dashboard_data.Get("Humidity")
'							Dim temp_trend As String = dashboard_data.Get("temp_trend")
'							Dim max_temp As Double = dashboard_data.Get("max_temp")
'							Dim firmware As Int = colmodules.Get("firmware")
				Try
							If  App.get(module_name & "_Temp") Then
								Dim Temperature As Double = dashboard_data.Get("Temperature")
							    Dim frame1 As FrameObject
								OutsideTemp = Temperature
								DisplayText = OutsideTemp & "°"
								frame1.Initialize
								frame1.text = DisplayText
								frame1.TextLength = App.calcTextLength(frame1.text)
								frame1.Icon = 874
								displaylist.Add(frame1)
								Log("I am here " & frame1)
							End If
			Catch
			Log("not found")
		End Try
		Try
							If ModuleType = "NAModule4" And App.get(module_name & "_CO2") Then
								Dim CO2 As Int = dashboard_data.Get("CO2")
								CO2Value = CO2
								DisplayText =  CO2Value								
								Dim frame2 As FrameObject
								frame2.Initialize
								frame2.text = DisplayText
								frame2.TextLength = App.calcTextLength(frame2.text)
								frame2.Icon = 874
								displaylist.Add(frame2)
								Log("I am here:  " & frame2)
							End If
							Catch
							Log("not found") 
							End Try
						Next
'						Dim date_setup As Int = coldevices.Get("date_setup")
'						Dim last_setup As Int = coldevices.Get("last_setup")
'						Dim last_upgrade As Int = coldevices.Get("last_upgrade")
'						Dim co2_calibrating As String = coldevices.Get("co2_calibrating")
'						Dim wifi_status As Int = coldevices.Get("wifi_status")
'						Dim data_type As List = coldevices.Get("data_type")
'						For Each coldata_type As String In data_type
'						Next
'						Dim id As String = coldevices.Get("_id")
'						Dim module_name As String = coldevices.Get("module_name")
'						Log(module_name)
'						Dim place As Map = coldevices.Get("place")
'						Dim altitude As Int = place.Get("altitude")
'						Dim country As String = place.Get("country")
'						Dim city As String = place.Get("city")
'						Dim timezone As String = place.Get("timezone")
'						Dim location As List = place.Get("location")
'						For Each collocation As Double In location
'						Next
'						Dim dashboard_data As Map = coldevices.Get("dashboard_data")
'						Dim date_min_temp As Int = dashboard_data.Get("date_min_temp")
'						Dim time_utc As Int = dashboard_data.Get("time_utc")
'						Dim Temperature As Double = dashboard_data.Get("Temperature")
'						Dim pressure_trend As String = dashboard_data.Get("pressure_trend")
'						Dim Noise As Int = dashboard_data.Get("Noise")																			
'						Dim temp_trend As String = dashboard_data.Get("temp_trend")
'						Dim Pressure As Double = dashboard_data.Get("Pressure")
'						Dim date_max_temp As Int = dashboard_data.Get("date_max_temp")
'						Dim min_temp As Double = dashboard_data.Get("min_temp")
'						Dim Humidity As Int = dashboard_data.Get("Humidity")
'						Dim AbsolutePressure As Double = dashboard_data.Get("AbsolutePressure")
'						Dim max_temp2 As Int = dashboard_data.Get("max_temp")
'						Dim last_status_store As Int = coldevices.Get("last_status_store")
'						Dim firmware As Int = coldevices.Get("firmware")
					Next
'					Dim user As Map = body.Get("user")
'					Dim mail As String = user.Get("mail")
'					Dim administrative As Map = user.Get("administrative")
'					Dim unit As Int = administrative.Get("unit")
'					Dim reg_locale As String = administrative.Get("reg_locale")
'					Dim windunit As Int = administrative.Get("windunit")
'					Dim feel_like_algo As Int = administrative.Get("feel_like_algo")
'					Dim lang As String = administrative.Get("lang")
'					Dim pressureunit As Int = administrative.Get("pressureunit")
'					Dim status As String = root.Get("status")
					If ModuleUpdate = True Then
					App.settings = SettingsMap
					App.makeSettings
					ModuleUpdate = False
					End If
					Dim frame3 As FrameObject
					frame3.Initialize
					frame3.text = " "
					frame3.TextLength = App.calcTextLength(frame2.text)
					frame3.Icon = 874
					displaylist.Add(frame3)
					
			End Select
			Log("Show List: " & displaylist.Size)
			For Each item In displaylist
				Log("In Netatmo display list: " & item )
			Next
			If( displaylist.Size == 0 ) Then
				App.shouldShow=False
			Else
				App.shouldShow=True
			End If
		Else
			
'		Log("NO SUCSESS: "&Resp.ResponseString)
			
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
    
	App.genText2(displaylist,Null,True,10000,50000)
	'App.drawBMP(0,0,App.getIcon(874),8,8)

End Sub
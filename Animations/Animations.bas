B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	Dim animationlist As List
	Dim nextAnimation As String
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	animationlist.Initialize
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name ="Animations"
	
	'Version of the App
	App.Version ="1.6"
	
	'Description of the App. You can use HTML to format it
	App.Description = "Shows a Animations from the AWTRIX Cloud."
	
	
	App.CoverIcon = 620
	
	App.downloads=1

		
	App.Author = "Blueforcer"
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	Try
		App.shouldShow=True
		If animationlist.Size>0 Then
		
			Dim oneActive As Boolean
			For Each AppName As String In animationlist
				If App.settings.Get(AppName) Then
					oneActive=True
				End If
			Next
		
			If oneActive = True Then
				Dim isEnable As Boolean =False
				nextAnimation="random"
				Do Until isEnable
					Dim nextApp As String = animationlist.Get(Rnd(0,animationlist.Size))
					If isactive(nextApp) Then
						isEnable = True
						nextAnimation=nextApp
					End If
				Loop
			Else
				nextAnimation="random"
			End If
		Else
			nextAnimation="random"
		End If
	Catch
		nextAnimation="random"
	End Try
	
End Sub


Sub isactive(name As String)As Boolean
	
	If App.Settings.ContainsKey(name) Then
		If App.settings.Get(name) = True Then
		
			Return True
		Else
			Return False
		End If
	Else
		Return False
	End If
	
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.PostString("https://awtrix.blueforcer.de/animation", $"{"reqType":"getAnimationList","filter":""}"$)
			App.SetContentType("application/json")
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
					animationlist.Clear
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					For Each name As String In root.Values
						If Not(App.settings.ContainsKey(name)) Then
							App.settings.Put(name,True)
						End If
						animationlist.Add(name)
					Next
					
					For Counter = App.settings.Size-1 To 0 Step -1
						Dim SettingsKey As String =App.settings.GetKeyAt(Counter)
						If Not(SettingsKey="UpdateInterval" Or SettingsKey="StartTime" Or SettingsKey="EndTime" Or SettingsKey="DisplayTime" Or SettingsKey="Enabled")   Then
								If animationlist.IndexOf(SettingsKey)=-1 Then
									App.settings.Remove(SettingsKey)
								End If
						End If
					Next
					
					File.WriteList(File.Combine(File.DirApp,"Apps"),"Animationlist.txt",animationlist)
					App.makeSettings
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


'With this sub you build your frame.
Sub App_genFrame
	
	App.customCommand(CreateMap("type":"animation","ID":nextAnimation))
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim RocketName As String
	Dim TimeString As String
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
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="RocketLaunch"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Show next rocket launch"
		
	App.Author="Blueforcer"
	
	App.CoverIcon=671
	
	'How many downloadhandlers should be generated
	App.downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(671)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
		
	App.MakeSettings
	Return "AWTRIX20"
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://launchlibrary.net/1.4/launch/next/1")
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
					Dim launches As List = root.Get("launches")
					For Each collaunches As Map In launches
						Dim netstamp As Long = collaunches.Get("netstamp")
						
						Dim rocket As Map = collaunches.Get("rocket")
						RocketName = rocket.Get("name")
						Dim p As Period=DateUtils.PeriodBetween(DateTime.Now,netstamp*1000)
						TimeString=p.Days & "D " & p.Hours & "H " & p.Minutes & "M "& p.Seconds& "S"
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'With this sub you build your frame.
Sub App_genFrame
	App.genText(RocketName& "              T-0: " & TimeString,True,1,Null,True)
	
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(671),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(671),8,8)
		End If
	End If
End Sub
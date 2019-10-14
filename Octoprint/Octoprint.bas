B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
		
	Private completion As String
	Private printTimeLeft As String ="0"
	
	Dim isOnline As Boolean
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Octoprint"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows the percentage of progress and remaining time of OctoPrint printing.<br />
	<small>Created by Dennis Hinzpeter</small>
	"$
		
	App.Author="Dennis Hinzpeter"
	
	App.CoverIcon=74
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>IP:</b>IP of your Octoprint instance<br/>
	<b>apiKey:</b>Your Octoprint API Key<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(74)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("IP":"","apiKey":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_Started
	App.ShouldShow=isOnline
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://"&App.get("IP")&"/api/job?apikey="&App.get("apiKey"))
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	If Resp.Success=False Then
		isOnline = False
		Return
	End If
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					isOnline = True
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim ticker As Map = root.Get("progress")
					completion  = ticker.Get("completion")
					printTimeLeft  = ticker.Get("printTimeLeft")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


'Generates the frame to be displayed.
'this function is called every tick
Sub App_genFrame
	If isOnline Then
		If printTimeLeft == "null" Then
			App.genText("wait..",True,1,Null,True)
		Else
			Dim seconds As Int = printTimeLeft * DateTime.TicksPerSecond 'convert seconds to ticks!
			Dim hour As String=NumberFormat( Floor(seconds/DateTime.TicksPerHour Mod 24),2,0)
			Dim minute As String=NumberFormat( Floor(seconds/DateTime.TicksPerMinute Mod 60),2,0)
			Dim day As String=NumberFormat( Floor(seconds/DateTime.TicksPerDay),2,0)
	
			If App.startedAt < DateTime.Now - App.duration / 2 Then
				App.genText(Round2(completion,0)&"%",True,1,Null,True)
			Else
				If day > 0 Then
					App.genText(day&":"&hour,True,1,Null,True)
					App.drawLine(10,7,14,7,Array As Int(124,252,000))
					
				Else
					App.genText(hour&":"&minute,True,1,Null,True)
					App.drawLine(10,7,14,7,Array As Int(124,252,000))
				End If
			End If
		End If
	Else
		App.genText("zZz",True,1,Null,True)
	End If
	App.drawBMP(0,0,App.getIcon(74),8,8)
End Sub
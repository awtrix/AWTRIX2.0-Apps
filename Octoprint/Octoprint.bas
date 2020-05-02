B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim hour As String
	Private completion As String
	Private printTimeLeft As String ="0"
	Dim scroll As Int
	Dim isOnline As Boolean
	Dim minute As String
	Dim day As String
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Octoprint"
	
	'Version of the App
	App.Version="1.3"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows the percentage of progress and remaining time of OctoPrint printing.
	"$
		
	App.Author="Blueforcer"
	
	App.CoverIcon=74
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>IP:</b>IP of your Octoprint instance<br/>
	<b>apiKey:</b>Your Octoprint API Key<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(1014)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	App.forceDownload=True
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
	scroll=1
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
					Dim seconds As Long = printTimeLeft * DateTime.TicksPerSecond 'convert seconds to ticks!
					hour=NumberFormat( Floor(seconds/DateTime.TicksPerHour Mod 24),2,0)
					minute=NumberFormat( Floor(seconds/DateTime.TicksPerMinute Mod 60),2,0)
					day=NumberFormat( Floor(seconds/DateTime.TicksPerDay),2,0)
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
			
	
			If App.startedAt<DateTime.Now-App.duration*1000/2 Then
				If day > 0 Then
					App.genText(day&":"&hour,True,scroll-8,Null,True)
					
				Else
					App.genText(hour&":"&minute,True,scroll-8,Null,True)
					
				End If
				If scroll<9 Then
					scroll=scroll+1
				End If
			Else
				App.genText(Round2(completion,0)&"%",True,scroll,Null,True)
			End If
		End If
	Else
		App.genText("zZz",True,1,Null,True)
	End If
	App.drawBMP(0,0,App.getIcon(1014),8,8)
End Sub
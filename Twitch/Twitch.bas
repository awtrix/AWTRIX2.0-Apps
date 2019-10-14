B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim followers As String = "0"
	Dim viewers As String = "0"
	Dim isStreaming As Boolean
	Dim iconID As Int=141
End Sub
' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Twitch"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows your Twitch subscriber count or your live viewers while youre streaming"
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>ClientID:</b>  To get a client ID, register your application on the Twitch dev portal (https://glass.twitch.tv/console/apps/create).
	<b>Profile:</b>  Your Twitch profile name.
	"$
	
	App.CoverIcon=339
	
	App.Author="Blueforcer"
	
	'How many downloadhandlers should be generated
	App.Downloads=2
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(141)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Profile":"","ClientID":"")
	
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

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons=Array As Int(iconID)
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://api.twitch.tv/kraken/streams/"&App.get("Profile")&"?client_id="&App.get("ClientID"))
		Case 2
			App.Download("https://api.twitch.tv/kraken/channels/"&App.get("Profile")&"?client_id="&App.get("ClientID")&"&callback=null")
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
					isStreaming=False
						Dim parser As JSONParser
						Dim res As String = Resp.ResponseString
						Dim s As String=res.SubString(res.IndexOf("(")+1).Replace(")","")
						parser.Initialize(s)
						Dim root As Map = parser.NextObject
						If root.Get("stream") Is Map Then
							isStreaming=True
							iconID=339
							Dim stream As Map = root.Get("stream")
							viewers = stream.Get("viewers")
						Else
							iconID=141
						End If
				Case 2	
						Dim parser As JSONParser
						Dim res As String = Resp.ResponseString
						Dim s As String=res.SubString(res.IndexOf("(")+1).Replace(")","")
						parser.Initialize(s)
						Dim root As Map = parser.NextObject
						followers= root.Get("followers")	
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	If isStreaming Then
		App.genText(viewers,True,1,Null,True)
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	Else
		App.genText(followers,True,1,Null,True)	
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	End If
End Sub
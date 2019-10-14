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
	Dim iconID As Int
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Mixer"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows your mixer subscriber count or your live viewers while youre streaming"$
		
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Profile:</b>  Your mixer profile name.
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=489
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(489,488)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Profile":"")
	
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

Sub App_iconRequest
	App.Icons=Array As Int(iconID)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://mixer.com/api/v1/channels/"&App.get("Profile"))
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
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					followers = root.Get("numFollowers")
					If  root.Get("online") Then
						isStreaming=True
						iconID=489
						viewers = root.Get("viewersCurrent")
					Else
						iconID=488
					End If
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	If isStreaming Then
		App.genText(viewers,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	Else
		App.genText(followers,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	End If
End Sub
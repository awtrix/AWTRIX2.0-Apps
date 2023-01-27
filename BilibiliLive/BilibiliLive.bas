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
	Dim iconID As Int = 1342
	
	Dim status As Int = -1
End Sub
' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="BilibiliLive"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows your Bilibili subscriber count or your live viewers while youre streaming"
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>roomId:</b>
    <ul>
		<li>Go to https://live.bilibili.com/202449</li>
		<li>Find the 'roomId' at 'https://live.bilibili.com/xxxxxx'</li>
		<li>Copy and enter your roomId</li><br/><br/>
	</ul>
	"$
	
	App.CoverIcon=2040
	
	App.Author="s0urce"
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(1342)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("roomId":"")
	
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
			App.Download("https://api.live.bilibili.com/room/v1/Room/get_info?room_id="&App.Get("roomId"))
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
					Dim data As Map = root.Get("data")
					followers = data.Get("attention")
					viewers = data.Get("online")
					status = data.Get("live_status")
					
					If status = 1 Then
						isStreaming=True
						iconID=2040
					Else
						isStreaming=False
						iconID=1342
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
		App.genText(viewers,True,1,Null,True)
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	Else
		App.genText(followers,True,1,Null,True)
		App.drawBMP(0,0,App.getIcon(iconID),8,8)
	End If
End Sub
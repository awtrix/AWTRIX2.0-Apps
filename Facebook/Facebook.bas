B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	'necessary variable declaration
	Dim likes As String ="="
End Sub


' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="Facebook"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows the likes of your Facebook page.<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>PageID:</b><br/>Get your facebook PageID from https://findmyfbid.com/<br/><br/>
	<b>AccessToken:</b><br/><br/>
	<iframe width="560" height="315" src="https://www.youtube.com/embed/rjyfDRjUCMw?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>  <br/><br/>
	Links:<br/>
	Facebook Developer<br/>
	https://developers.facebook.com/<br/>
	<br/>
	Graph API Explorer<br/>
	https://developers.facebook.com/tools/explorer/<br/>
	<br/>
	Token Converter<br/>
	https://www.displaysocialmedia.com/app-dev/get_page_token.php<br/>					
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(584)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("AccessToken":"","PageID":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "https://graph.facebook.com/v3.2/?ids="&App.Get("PageID")&"&fields=fan_count&access_token="&App.Get("AccessToken")
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
					Try
						Dim parser As JSONParser
						parser.Initialize(Resp.ResponseString)
						Dim root As Map = parser.NextObject
						Dim api As Map = root.Get(App.get("PageID"))
						likes = api.Get("fan_count")
					Catch
						Log("Error in: "& App.AppName & CRLF & LastException)
						Log("API response: "& CRLF & Resp.ResponseString)
					End Try
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub App_genFrame
	App.genText(likes,True,1,Null)
	App.drawBMP(0,0,App.getIcon(584),8,8)
End Sub
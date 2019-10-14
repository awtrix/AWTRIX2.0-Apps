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
	App.Name="Facebook"
	
	'Version of the App
	App.Version="1.1"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows the likes of your Facebook page."$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=584
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>PageID:</b><br/>Get your facebook PageID from https://findmyfbid.com/<br/><br/>				
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(584)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	App.InitializeOAuth("https://www.facebook.com/v4.0/dialog/oauth","https://graph.facebook.com/oauth/access_token","413044212451682","1b83bfa010904e1a18267c5845f59efe","public_profile")
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("PageID":"")
	
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

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("https://graph.facebook.com/v3.2/?ids="&App.Get("PageID")&"&fields=fan_count&access_token="&App.Token)
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
						Log("Error in: "& App.Name & CRLF & LastException)
						Log("API response: "& CRLF & Resp.ResponseString)
					End Try
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
	App.genText(likes,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(584),8,8)
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim playersNow As Int
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="MinecraftServer"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows the player count of a Minecraft Server<br/> 
	Only appears if the server is online
	"$
		
	App.Author="Blueforcer"
	
	App.CoverIcon=172
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Host:</b> The Hostname or IP-Adress of the Minecraft server. <br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(172)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Host":"hub.mcs.gg")
	
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
			App.Download("https://mcapi.us/server/status?ip="&App.get("Host"))
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
					App.ShouldShow=True
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim status As String = root.Get("status")
					If status="error" Then
						App.ShouldShow=False
						If root.ContainsKey("error") Then
							Log(root.Get("error"))
						End If
					Else
						Dim players As Map = root.Get("players")
						playersNow = players.Get("now")
					End If
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(playersNow,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(172),8,8)
End Sub

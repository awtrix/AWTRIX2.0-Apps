B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim followers As String ="0"
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Twitter"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows your Twitter Follower count."
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Profilename:</b>  As the name implies, your twitter profile name.
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=142
	
	'How many downloadhandlers should be generated
	App.downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(142)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("Profilename":"")
	
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
			App.Download("http://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names="& App.get("Profilename"))
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
					Dim root As List = parser.NextArray
					For Each colroot As Map In root
						followers = colroot.Get("followers_count")
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genText(followers,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(142),8,8)
End Sub
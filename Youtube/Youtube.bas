B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim subs As String ="0"
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="Youtube"
	
	'Version of the App
	App.Version="1.1"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows your Youtube subscriber count."
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>APIKey:</b>
	<ul>
		<li>Go to https://console.developers.google.com/apis/library</li>
		<li>Log in with your Google account.</li>
		<li>Next to the logo click on 'Project' and 'Create project'. Name it whatever you want and click on 'Create'.<br/>
		<li>Wait until the project is created, the page will switch to it by itself, it will take a couple of seconds up to a minute. Once it's done it will be selected next to the logo.</li>
		<li>Once it's created and selected, click on 'Credentials' from the menu on the left.</li>
		<li>Click on 'Create Credentials' and choose 'API Key'.</li>
		<li>Copy your API KEY</li><br/><br/>
	</ul>
	<b>ChannelID:</b><br/>Login to YouYube website and select 'My channel'. You will get the ID from the page adress afer /Channel/. e.g. https://www.youtube.com/channel/UCpGLALzRO0uaasWTsm9M99w
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=155
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(155)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("APIKey":"","ChannelID":"")
	
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
			App.Download("https://content.googleapis.com/youtube/v3/channels?part=statistics&id="&App.get("ChannelID")&"&key="&App.get("APIKey"))
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
					Dim items As List = root.Get("items")
					For Each colitems As Map In items
						Dim statistics As Map = colitems.Get("statistics")
						subs = statistics.Get("subscriberCount")
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(subs.Replace(",",""),True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(155),8,8)
End Sub
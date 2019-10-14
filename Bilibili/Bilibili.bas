B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=1.0
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX	
	
	'Define your variables here
    Dim subs As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Bilibili"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="This Is a App For a Bilibili Upper To show fans count."
	
	App.Author="Albert"
	
	App.CoverIcon = 9
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>MID:</b>
    <ul>
		<li>Go to https://space.bilibili.com/</li>
		<li>Find the 'MID' at 'https://space.bilibili.com/XXX'.</li>
		<li>Copy and enter your MID</li><br/><br/>
	</ul>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(9)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("MID":"")
	
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
			App.Download("https://api.bilibili.com/x/relation/stat?vmid="&App.Get("MID")&"&jsonp=jsonp")
	End Select

End Sub

Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim bdata As Map = root.Get("data")
					subs = bdata.Get("follower")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	App.genText(subs,True,1,Array As Int(98,214,255),True)
	App.drawBMP(0,0,App.getIcon(9),8,8)
    App.drawLine(9,7,29,7,Array As Int(98,214,255))
End Sub
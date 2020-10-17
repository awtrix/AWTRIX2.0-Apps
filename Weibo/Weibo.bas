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
	App.Name="Weibo"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows your Weibo fans count"
	
	App.Author="UniqueDing"
	
	App.CoverIcon = 1293
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>MID:</b>
    <ul>
		<li>Go to https://weibo.com/</li>
		<li>Login your weibo</li>
		<li>and url will be https://weibo.com/XXXXXXX</li>
		<li>XXXXXXX is your MID</li><br/><br/>
	</ul>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(1294)
	
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
			App.Download("http://awtrix.uniqueding.cn/weibo/"&App.Get("MID"))
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
					subs = root.Get("fans")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	App.genText(subs,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(1294),8,8)
End Sub
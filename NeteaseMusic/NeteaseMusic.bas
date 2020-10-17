B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim scroll As Int
	Dim fans As String ="0"
	Dim nums As String ="0"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.name="NeteaseMusic"
	
	'Version of the App
	App.version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.description="Shows your netease music fans and total listened music number"
		
	App.author="UniqueDing"
			
	App.coverIcon = 1296
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>MID:</b>
    <ul>
		<li>Go to https://music.163.com/</li>
		<li>Login your Netease Music and go to personal page</li>
		<li>and url will be https://music.163.com/#/user/home?id=XXXXXXX</li>
		<li>XXXXXXX is your MID</li><br/><br/>
	</ul>
	"$
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.icons=Array As Int(1295,1296)
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("MID":"")
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick=65
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	scroll=1
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://awtrix.uniqueding.cn/neteasemusic/"&App.Get("MID"))
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
					fans = root.Get("fans")
					nums = root.Get("music_num")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'With this sub you build your frame.
Sub App_genFrame
	If App.startedAt<DateTime.Now-App.duration*1000/2 Then
		App.genText(nums,True,scroll,Null,False)
		App.drawBMP(0,scroll-1,App.getIcon(1296),8,8)
		If scroll<9 Then
			scroll=scroll+1
		Else
			App.genText(fans,True,scroll-8,Null,False)
			App.drawBMP(0,scroll-9,App.getIcon(1295),8,8)
		End If
	Else
		App.genText(nums,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1296),8,8)
	End If
End Sub
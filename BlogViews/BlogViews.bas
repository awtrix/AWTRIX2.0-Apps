B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim followers As Int = 0
	Dim iconId As Int = 8
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
	App.Name="BlogViews"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows your website unique visitor on <b>busuanzi</b> statistical tools"$
	
	App.Author="JoyLau"
		
	App.CoverIcon=iconId
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Website:</b>  Your Website Address<br/>
	<b>IconID:</b>  Icon id<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(iconId)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))p://
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings=CreateMap("Website":"http://blog.joylau.cn","IconID":iconId)
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://busuanzi.ibruce.info/busuanzi?jsonpCallback=callback")
			App.Header = CreateMap("Referer":App.Get("Website"),"Cookie":"busuanziId=D58737A150864C68B83F962028616CD6")
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
					parser.Initialize(Resp.ResponseString.replace("try{callback(","").replace(");}catch(e){}",""))
					Dim root As Map = parser.NextObject
					followers = root.Get("site_uv")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons=Array As Int(App.Get("IconID"))
End Sub

'With this sub you build your frame.
Sub App_genFrame
	App.genSimpleFrame(followers,App.Get("IconID"),True,False,Null,True)
End Sub
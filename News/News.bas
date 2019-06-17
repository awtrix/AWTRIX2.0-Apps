B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim sb As StringBuilder
End Sub

Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="News"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Provides live top and breaking headlines for your country.<br/> 
	Powered by NewsAPI.org<br />
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>APIkey:</b>  Get your API-Key from https://newsapi.org/<br/><br/> 
	<b>Country:</b>  Countrycode e.g "de" <br/><br/> 
	<b>maxNews:</b>  maximum number of headlines you want do read.<br/><br/> 
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(585)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=True
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("Country":"de","APIkey":"","maxNews":2)
	
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

Public Sub AppStarted
	
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "https://newsapi.org/v2/top-headlines?country="&App.get("Country")&"&pageSize="&App.get("maxNews")&"&apiKey="&App.get("APIkey")
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
					sb.Initialize
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim articles As List = root.Get("articles")
					For Each colarticles As Map In articles
						Dim title As String = colarticles.Get("title")
						sb.Append(title)
						sb.Append("       ")
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(sb.ToString,True,1,Null)
		
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(585),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(585),8,8)
		End If
	End If
End Sub

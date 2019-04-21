B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'###### nötige Variablen deklarieren ######

End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me)
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="Template"
	
	'Version of the App
	App.AppVersion="1.0"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	This is just a template<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>CustomText:</b>Text wich will be shown<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(6)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("CustomText":"Hello World")
	
	App.MakeSettings
	Return "MyKey"
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
Sub startDownload(jobNr As Int) As String
	Select jobNr
		Case 1
			Return "https://reqres.in/api/users/2"
	End Select
	Return ""
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim data As Map = root.Get("data")
					Dim first_name As String = data.Get("first_name")
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub genFrame
	App.GenText(App.get("CustomText"))
	App.drawBMP(0,0,6,8,8)
End Sub
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here	
	Dim TTR As String
	Dim QTTR As String
	
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "myTischtennis"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows your TTR (Table Tennis Ranking)
	"$
	
	'The developer if this App
	App.author = "Matthias Wahl"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 761
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("UserName":"","Password":"","TTR":True,"QTTR":False)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	This App shows your TTR. You need a premium account for myTischtennis.de <br />
	<b>UserName:</b> Write your UserName from myTischtennis.de here.
	<b>Password:</b> Write your Password from myTischtennis.de here.
	<b>TTR:</b> Show your TTR (true/false).
	<b>TTR:</b> Show your QTTR (true/false).
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("myTischtennis", "TTR")
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(761)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.PostMultipart("https://www.mytischtennis.de/community/events",CreateMap("userNameB":App.get("UserName"),"userPassWordB":App.get("Password")),Null)
			App.setHeader(CreateMap("goLogin":"Einloggen","Accept-Encoding":"identity"))
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
					Dim Reader As TextReader
					Reader.Initialize(Resp.Stream)
					Dim line As String
					line = Reader.ReadLine
					Do While line <> Null
						If line.Contains("<span>TTR:</span>") Then
							TTR = line.SubString2(18,line.Length)
						End If
						If line.Contains(">Q-TTR:</span>") Then
							QTTR = line.SubString2(120,line.Length)
						End If
						line = Reader.ReadLine
					Loop
			End Select
		End If
	Catch
		Log("Try Catch rausgeflogen...")
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	If App.get("TTR")=True And App.get("QTTR")=False Then
		App.genText("TTR: " & QTTR ,True,1,Null,False)
	End If
	If App.get("QTTR")=True  And App.get("TTR") = False Then
		App.genText("QTTR: " & TTR ,True,1,Null,False)
	End If
	If App.get("QTTR") = True And App.get("TTR") = True Then
		App.genText("TTR: " & TTR & " - QTTR: " & QTTR,True,1,Null,False)
	End If
	If App.get("QTTR") = False And App.get("TTR") = False Then
		App.genText("Setup again!",True,1,Null,False)
	End If

	App.drawBMP(0,0,App.getIcon(761),8,8)
End Sub
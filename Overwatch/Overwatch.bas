B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	
	Dim support As Int
	Dim tank As Int
	Dim damage As Int
	Dim framelist As List
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Overwatch"
	
	'Version of the App
	App.Version="1.5"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Shows your actual Skillranking"$
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Platform:</b>The game platform (pc, etc)<br/>
	<b>Region:</b>The game region (us, eu, asia)<br/>
	<b>BattleTag:</b>Your battlenet tag<br/>
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=586
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(586,1300,1307,1306)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings= CreateMap("Platform":"pc","Region":"eu","BattleTag":"","showSupport":True,"showTank":True,"showDamage":True)
	
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
			Dim profile As String=App.get("BattleTag")
			App.Download("https://ow-api.com/v1/stats/"&App.get("Platform")&"/"&App.get("Region")&"/"& profile.Replace("#","-")&"/profile")
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
					Dim ratings As List = root.Get("ratings")
					
					For Each colratings As Map In ratings
						Log(colratings)
						Dim role As String = colratings.Get("role")
						support=0
						If role="support" Then
							support=colratings.Get("level")
						End If
						tank=0
						If role="tank" Then
							tank=colratings.Get("level")
						End If
						damage=0
						If role="damage" Then
							support=colratings.Get("level")
						End If
						
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


Sub App_Started
	framelist.Initialize
	framelist.Clear
	
	Dim frame As FrameObject
	frame.Initialize
	frame.text="Overwatch"
	frame.TextLength=App.calcTextLength(frame.text)
	frame.Icon=586
	frame.color=Null
	framelist.Add(frame)
	
	If App.get("showTank") And tank>0 Then
		Dim frame1 As FrameObject
		frame1.Initialize
		frame1.text="Tank: " & tank
		frame1.TextLength=App.calcTextLength(frame.text)
		frame1.Icon=1300
		frame1.color=Null
		framelist.Add(frame1)
	End If
	
	If App.get("showDamage") And damage>0 Then
		Dim frame1 As FrameObject
		frame1.Initialize
		frame1.text="Damage: " & damage
		frame1.TextLength=App.calcTextLength(frame.text)
		frame1.Icon=1307
		frame1.color=Null
		framelist.Add(frame1)
	End If
	
	If App.get("showSupport") And support>0 Then
		Dim frame1 As FrameObject
		frame1.Initialize
		frame1.text="Support: " & support
		frame1.TextLength=App.calcTextLength(frame.text)
		frame1.Icon=1306
		frame1.color=Null
		framelist.Add(frame1)
	End If
	
End Sub

Sub App_genFrame
App.FallingText(framelist,True)
End Sub

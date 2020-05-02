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
	sb.Initialize
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Tankerkoenig"
	
	'Version of the App
	App.Version="1.2"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Zeigt dir die die Spritpreise in Deiner Nähe an.<br/>
	Powered by Tankerkoenig.
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=128
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>APIkey:</b> https://creativecommons.tankerkoenig.de/.<br/><br/>
	<b>Latitude & Longitude:</b> Koordinaten kann man hier bekommen https://www.latlong.net/.<br/><br/>
	<b>Radius:</b> Suchradius in km.<br/><br/>
	<b>Type:</b> Spritsorte ('e5', 'e10', 'diesel' oder 'all')<br/><br/>	
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(128)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings= CreateMap("Latitude":"","Longitude":"","APIKey":"","Radius":3,"Type":"diesel")
	
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
			App.Download("https://creativecommons.tankerkoenig.de/json/list.php?lat="&App.get("Latitude")&"&lng="&App.get("Longitude")&"&rad="&App.get("Radius")&"&sort=dist&type="&App.get("Type")&"&apikey="&App.get("APIKey"))
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
					Dim stations As List = root.Get("stations")
					For Each colstations As Map In stations
						
						sb.Initialize
						Dim parser As JSONParser
						parser.Initialize(Resp.ResponseString)
						Dim root As Map = parser.NextObject
						Dim stations As List = root.Get("stations")
						For Each colstations As Map In stations
							If Not(colstations.ContainsKey("price")) Then
								sb.Append(colstations.Get("brand")).Append(": ")
							End If
							If colstations.ContainsKey("e10") Then
								sb.Append($"e10:${colstations.Get("e10")}€ / "$)
							End If
					
							If colstations.ContainsKey("e5") Then
								sb.Append($"e5:${colstations.Get("e5")}€ / "$)
							End If
						
							If colstations.ContainsKey("diesel") Then
								sb.Append($"diesel:${colstations.Get("diesel")}€ "$)
							End If
						
							If colstations.ContainsKey("price") Then
								sb.Append(colstations.Get("brand")).Append(": ").Append(colstations.Get("price")).Append("€").Append("          ")
							Else
								sb.Append("          ")
							End If
						Next
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(sb.ToString,True,1,Null,True)

	
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(128),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(128),8,8)
		End If
	End If
End Sub
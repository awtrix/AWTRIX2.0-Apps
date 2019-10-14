B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim follower_count As String = "0"
End Sub


' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Pinterest"
	
	'Version of the App
	App.Version="1.0"

	'Description of the App. You can use HTML to format it
	App.Description="Shows your pinterest follower count."
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Username:</b>  As the name implies, your pinterest Username.
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=88
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(88)
	
	'Tickinterval in ms (should be 65 by default)
	App.tick=65

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings=CreateMap("Username":"")
	
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
			App.Download("https://www.pinterest.de/"&App.get("Username"))
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
						If line.Contains("""follower_count"":") Then
							follower_count=line.SubString2(line.IndexOf("follower_count"":")+17,line.IndexOf(", ""domain_url")).Trim
							Exit
						End If
						line = Reader.ReadLine
					Loop
					Reader.Close
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


Sub App_genFrame
	App.genText(follower_count,True,1,Null,True)
	App.drawBMP(0,0,App.getIcon(88),8,8)
End Sub
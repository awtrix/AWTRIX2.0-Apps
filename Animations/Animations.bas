B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	Dim animationlist As List
	Dim nextAnimation As String
	Dim availableAnimations As StringBuilder
	Dim aniCount As Int
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
	App.Name ="Animations"
	
	'Version of the App
	App.Version ="1.3"
	
	'Description of the App. You can use HTML to format it
	App.Description = "Shows a Animations from the AWTRIX Cloud."
	
	App.setupDescription =$"<b>Favorites: </b> choose your favorite animations. You can get the <b>name</b> from each available animation below.<br> You can choose more than one by seperate each name wich a comma.<br>  Enter "random" for random animations"$
	
	App.CoverIcon = 620
	
	App.downloads=1
	
	App.settings= CreateMap("Favorites":"random","Mix":True )
		
	App.Author = "Blueforcer"
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	animationlist.Initialize
	Dim favString As String = App.get("Favorites")
	If favString.Contains(",") Then
		Dim reg() As String = Regex.Split(",",favString)
		For i=0 To reg.Length-1
			animationlist.Add(reg(i))
		Next
		If App.get("Mix") Then
			Dim randomAnimation As Int = Rnd(0,animationlist.Size)
			nextAnimation=animationlist.Get(randomAnimation)
		Else
			If animationlist.Size>0 Then
				aniCount=aniCount+1
				If aniCount>animationlist.Size-1 Then aniCount=0
				nextAnimation=animationlist.Get(aniCount)
			Else
				nextAnimation="random"
			End If
			
		End If
		
	Else
		nextAnimation=App.get("Favorites")
	End If
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.PostString("https://awtrix.blueforcer.de/animation", $"{"reqType":"aniList","filter":""}"$)
			App.SetContentType("application/json")
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
					availableAnimations.Initialize
					availableAnimations.Append($"<b>Favorites: </b><br> Choose your favorite animations. 
					You can get the <b>name</b> from each available animation below. (This list updates itself) <br> 
					You can choose more than one by seperate each name wich a comma.<br> 
					Enter "random" for shwoing all available animations randomly<br><br> 
					<b>Mix:</b><br> If activated, all specified animations are displayed randomly with each appstart. If deactivated it will be displayed in the given order<br><br>
					<i><b>Pro-Tip:</b><br> deactivate it, and copy the app to different places inside the loop, so you can determine exactly when which animation is displayed.<br>
					<b>You can also create new animations with the icon creator! Just resize the sprite to 32x8 and keep going!</b></i>
					<br><br>
					Available animations:<br>
					"$)
					availableAnimations.Append("<ul>")
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					For Each name As String In root.Values
						availableAnimations.Append($"<li>${name}</li>"$)
					Next
					availableAnimations.Append("</ul>")
					App.setupDescription=availableAnimations.ToString
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub


'With this sub you build your frame.
Sub App_genFrame
	App.customCommand(CreateMap("type":"animation","ID":nextAnimation))
End Sub
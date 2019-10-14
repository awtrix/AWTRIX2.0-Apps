B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
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
	App.Version ="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description = "Shows a random Animation from AWTRIX Cloud."
	
	App.CoverIcon = 620
		
	App.Author = "Blueforcer"
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub


'With this sub you build your frame.
Sub App_genFrame
	App.customCommand(CreateMap("type":"animation","ID":-1))
End Sub
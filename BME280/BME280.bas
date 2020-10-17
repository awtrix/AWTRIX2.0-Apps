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
	App.name="BME280"
	
	'Version of the App
	App.version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.description="This App shows the temperature And humidity your connected BME280"
		
	App.author="Blueforcer"
			
	App.coverIcon = 609
	
	App.settings=CreateMap("TempOffset":0,"HumOffset":0,"PresOffset":0)

	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.icons=Array As Int(693,235)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick=65
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	scroll=1
End Sub


'With this sub you build your frame.
Sub App_genFrame
	If App.startedAt<DateTime.Now-App.duration*1000/2 Then
		App.genText(NumberFormat(App.matrix.Get("Temp"),0,1)&"°",True,scroll,Null,False)
		App.drawBMP(0,scroll-1,App.getIcon(235),8,8)
		If scroll<9 Then
			scroll=scroll+1
			Else
			App.genText(NumberFormat(App.matrix.Get("Hum"),0,1)&"%",True,scroll-8,Null,False)
			App.drawBMP(0,scroll-9,App.getIcon(693),8,8)
		End If
	Else
		App.genText(NumberFormat(App.matrix.Get("Temp"),0,1)&"°",True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(235),8,8)
	End If
End Sub
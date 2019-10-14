B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim hr, mn, sc As Int
	Dim sc0, sc1 As Int
	Dim mn0, mn1 As Int
	Dim hr0, hr1 As Int
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
	App.Name="BinaryClock"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows the time in binary format."
	
	App.Author="Blueforcer"
	
	App.CoverIcon = 708
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=1000
		
	App.MakeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
End Sub

'With this sub you build your frame.
Sub App_genFrame
	
	hr = DateTime.GetHour(DateTime.Now)
	mn = DateTime.GetMinute(DateTime.Now)
	sc = DateTime.GetSecond(DateTime.Now)
	sc0 = sc Mod 10
	sc1 = sc/10
	mn0 = mn Mod 10
	mn1 = mn/10
	hr0 = hr Mod 10
	hr1 = hr/10

	Select Case sc0
		Case 0
			App.drawRect(22,6,2,2,Array As Int(0,35,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 1
			App.drawRect(22,6,2,2,Array As Int(0,225,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 2
			App.drawRect(22,6,2,2,Array As Int(0,35,0))
			App.drawRect(22,4,2,2,Array As Int(0,225,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 3
			App.drawRect(22,6,2,2,Array As Int(0,225,0))
			App.drawRect(22,4,2,2,Array As Int(0,225,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 4
			App.drawRect(22,6,2,2,Array As Int(0,35,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,225,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 5
			App.drawRect(22,6,2,2,Array As Int(0,225,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,225,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 6
			App.drawRect(22,6,2,2,Array As Int(0,35,0))
			App.drawRect(22,4,2,2,Array As Int(0,225,0))
			App.drawRect(22,2,2,2,Array As Int(0,225,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 7
			App.drawRect(22,6,2,2,Array As Int(0,225,0))
			App.drawRect(22,4,2,2,Array As Int(0,225,0))
			App.drawRect(22,2,2,2,Array As Int(0,225,0))
			App.drawRect(22,0,2,2,Array As Int(0,35,0))
		Case 8
			App.drawRect(22,6,2,2,Array As Int(0,35,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,225,0))
		Case 9
			App.drawRect(22,6,2,2,Array As Int(0,225,0))
			App.drawRect(22,4,2,2,Array As Int(0,35,0))
			App.drawRect(22,2,2,2,Array As Int(0,35,0))
			App.drawRect(22,0,2,2,Array As Int(0,225,0))
	End Select

	Select Case sc1
		Case 0
			App.drawRect(19,6,2,2,Array As Int(0,35,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 1
			App.drawRect(19,6,2,2,Array As Int(0,255,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 2
			App.drawRect(19,6,2,2,Array As Int(0,35,0))
			App.drawRect(19,4,2,2,Array As Int(0,255,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 3
			App.drawRect(19,6,2,2,Array As Int(0,255,0))
			App.drawRect(19,4,2,2,Array As Int(0,255,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 4
			App.drawRect(19,6,2,2,Array As Int(0,35,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,255,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 5
			App.drawRect(19,6,2,2,Array As Int(0,255,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,255,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 6
			App.drawRect(19,6,2,2,Array As Int(0,35,0))
			App.drawRect(19,4,2,2,Array As Int(0,255,0))
			App.drawRect(19,2,2,2,Array As Int(0,255,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 7
			App.drawRect(19,6,2,2,Array As Int(0,255,0))
			App.drawRect(19,4,2,2,Array As Int(0,255,0))
			App.drawRect(19,2,2,2,Array As Int(0,255,0))
'			App.drawRect(19,0,2,2,Array As Int(0,35,0))
		Case 8
			App.drawRect(19,6,2,2,Array As Int(0,35,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,255,0))
		Case 9
			App.drawRect(19,6,2,2,Array As Int(0,255,0))
			App.drawRect(19,4,2,2,Array As Int(0,35,0))
			App.drawRect(19,2,2,2,Array As Int(0,35,0))
'			App.drawRect(19,0,2,2,Array As Int(0,255,0))
	End Select


	Select Case mn0
		Case 0
			App.drawRect(16,6,2,2,Array As Int(0,0,35))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 1
			App.drawRect(16,6,2,2,Array As Int(0,0,255))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 2
			App.drawRect(16,6,2,2,Array As Int(0,0,35))
			App.drawRect(16,4,2,2,Array As Int(0,0,255))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 3
			App.drawRect(16,6,2,2,Array As Int(0,0,255))
			App.drawRect(16,4,2,2,Array As Int(0,0,255))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 4
			App.drawRect(16,6,2,2,Array As Int(0,0,35))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,255))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 5
			App.drawRect(16,6,2,2,Array As Int(0,0,255))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,255))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 6
			App.drawRect(16,6,2,2,Array As Int(0,0,35))
			App.drawRect(16,4,2,2,Array As Int(0,0,255))
			App.drawRect(16,2,2,2,Array As Int(0,0,255))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 7
			App.drawRect(16,6,2,2,Array As Int(0,0,255))
			App.drawRect(16,4,2,2,Array As Int(0,0,255))
			App.drawRect(16,2,2,2,Array As Int(0,0,255))
			App.drawRect(16,0,2,2,Array As Int(0,0,35))
		Case 8
			App.drawRect(16,6,2,2,Array As Int(0,0,35))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,255))
		Case 9
			App.drawRect(16,6,2,2,Array As Int(0,0,255))
			App.drawRect(16,4,2,2,Array As Int(0,0,35))
			App.drawRect(16,2,2,2,Array As Int(0,0,35))
			App.drawRect(16,0,2,2,Array As Int(0,0,255))
	End Select
	
	Select Case mn1
		Case 0
			App.drawRect(13,6,2,2,Array As Int(0,0,35))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 1
			App.drawRect(13,6,2,2,Array As Int(0,0,255))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 2
			App.drawRect(13,6,2,2,Array As Int(0,0,35))
			App.drawRect(13,4,2,2,Array As Int(0,0,255))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 3
			App.drawRect(13,6,2,2,Array As Int(0,0,255))
			App.drawRect(13,4,2,2,Array As Int(0,0,255))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 4
			App.drawRect(13,6,2,2,Array As Int(0,0,35))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,255))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 5
			App.drawRect(13,6,2,2,Array As Int(0,0,255))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,255))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 6
			App.drawRect(13,6,2,2,Array As Int(0,0,35))
			App.drawRect(13,4,2,2,Array As Int(0,0,255))
			App.drawRect(13,2,2,2,Array As Int(0,0,255))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 7
			App.drawRect(13,6,2,2,Array As Int(0,0,255))
			App.drawRect(13,4,2,2,Array As Int(0,0,255))
			App.drawRect(13,2,2,2,Array As Int(0,0,255))
'			App.drawRect(13,0,2,2,Array As Int(0,0,35))
		Case 8
			App.drawRect(13,6,2,2,Array As Int(0,0,35))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,255))
		Case 9
			App.drawRect(13,6,2,2,Array As Int(0,0,255))
			App.drawRect(13,4,2,2,Array As Int(0,0,35))
			App.drawRect(13,2,2,2,Array As Int(0,0,35))
'			App.drawRect(13,0,2,2,Array As Int(0,0,255))
	End Select

	Select Case hr0
		Case 0
			App.drawRect(10,6,2,2,Array As Int(35,0,0))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 1
			App.drawRect(10,6,2,2,Array As Int(255,0,0))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 2
			App.drawRect(10,6,2,2,Array As Int(35,0,0))
			App.drawRect(10,4,2,2,Array As Int(255,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 3
			App.drawRect(10,6,2,2,Array As Int(255,0,0))
			App.drawRect(10,4,2,2,Array As Int(255,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 4
			App.drawRect(10,6,2,2,Array As Int(35,0,0))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(255,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 5
			App.drawRect(10,6,2,2,Array As Int(255,0,0))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(255,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 6
			App.drawRect(10,6,2,2,Array As Int(35,0,0))
			App.drawRect(10,4,2,2,Array As Int(255,0,0))
			App.drawRect(10,2,2,2,Array As Int(255,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 7
			App.drawRect(10,6,2,2,Array As Int(255,0,0))
			App.drawRect(10,4,2,2,Array As Int(255,0,0))
			App.drawRect(10,2,2,2,Array As Int(255,0,0))
			App.drawRect(10,0,2,2,Array As Int(35,0,0))
		Case 8
			App.drawRect(10,6,2,2,Array As Int(35,0,35))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(255,0,0))
		Case 9
			App.drawRect(10,6,2,2,Array As Int(255,0,0))
			App.drawRect(10,4,2,2,Array As Int(35,0,0))
			App.drawRect(10,2,2,2,Array As Int(35,0,0))
			App.drawRect(10,0,2,2,Array As Int(255,0,0))
	End Select
	
	Select Case hr1
		Case 0
			App.drawRect(7,6,2,2,Array As Int(35,0,0))
			App.drawRect(7,4,2,2,Array As Int(35,0,0))
		Case 1
			App.drawRect(7,6,2,2,Array As Int(255,0,0))
			App.drawRect(7,4,2,2,Array As Int(35,0,0))
		Case 2
			App.drawRect(7,6,2,2,Array As Int(35,0,0))
			App.drawRect(7,4,2,2,Array As Int(255,0,0))
	End Select

End Sub
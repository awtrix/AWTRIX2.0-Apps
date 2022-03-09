B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	Dim FrameList As List
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
	FrameList.Initialize
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.name="EnvSensor"
	
	'Version of the App
	App.version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.description="Displays the Values of a connected BME280, BMP280 or HTU21"
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>Choose wich value you want to show.<br/>
	<b>You can also set an offset for each value.<br/>
	<b>If you have many Controllers, you can show all of them by enter "all" in setting "Controller", or you can enter the name of a specific controller.<br/>
	"$
		
	App.author="Blueforcer"
			
	App.coverIcon = 609
	
	App.settings=CreateMap("Temperature":True,"Humidity":True,"Pressure":True,"TempOffset":0,"HumOffset":0,"PresOffset":0,"Controller":"all")

	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.icons=Array As Int(609,693,1214)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick=65
	
	App.lock=True
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	FrameList.Clear
	
	
	If App.get("Temperature") = False And App.get("Humidity") = False And App.get("Pressure") = False Then
		Dim frame3 As FrameObject
		frame3.Initialize
		frame3.text = "None"
		frame3.TextLength = App.calcTextLength(frame3.text)
		frame3.color=Null
		frame3.Icon = 609
		FrameList.Add(frame3)
		Return
	End If
	
	Dim m As Map
	m.initialize
	
	If App.matrix.ContainsKey("Temp") Then
		m=App.matrix
		genMatrixInfos(m,False)
	Else
		If App.get("Controller") = "all" Then
			For Each IP As String In App.matrix.Keys
				m=App.matrix.Get(IP)
				genMatrixInfos(m,App.matrix.Size>1)
			Next
		Else
			For Each IP As String In App.matrix.Keys
				m=App.matrix.Get(IP)
				If m.ContainsKey("name") Then
					If m.Get("name") = App.get("Controller") Then
						genMatrixInfos(m,False)
					End If
				End If
			Next
		End If
	End If
	
	If FrameList.Size=0 Then
		Log("no data for SensorApp")
		App.shouldShow=False
	Else
		App.shouldShow=True
	End If
	
End Sub


Sub genMatrixInfos(m As Map, withName As Boolean)
	
	If m.ContainsKey("name") And withName Then
		Dim frame0 As FrameObject
		frame0.Initialize
		frame0.text=m.Get("name")
		frame0.TextLength = App.calcTextLength(frame0.text)
		frame0.color=Array As Int(255,255,255)
		frame0.Icon = -1
		FrameList.Add(frame0)
	End If
					
	
	If App.get("Temperature") = True Then
		Dim frame As FrameObject
		frame.Initialize
		
		Dim temp As Double = m.Get("Temp")
		If IsNumber( App.get("TempOffset")) Then
			Dim tOfset As Double = App.get("TempOffset")
			frame.text = NumberFormat(temp + tOfset,1,1)
		Else
			frame.text = NumberFormat(temp,1,1)
		End If
		frame.text=frame.text  & "°"
		frame.TextLength = App.calcTextLength(frame.text)
		frame.color=Null
		frame.Icon = 609
		FrameList.Add(frame)
	End If
	
	If App.get("Humidity") = True Then
		Dim frame1 As FrameObject
		frame1.Initialize
		Dim hum As Double =m.Get("Hum")
		
		If IsNumber( App.get("HumOffset")) Then
			Dim hOfset As Double = App.get("HumOffset")
			frame1.text = NumberFormat(hum+hOfset,0,0)
		Else
			frame1.text = NumberFormat(hum,0,0)
		End If
		frame1.text=frame1.text  & "%"
		frame1.TextLength = App.calcTextLength(frame1.text)
		frame1.color=Null
		frame1.Icon = 693
		FrameList.Add(frame1)
	End If
	
	If App.get("Pressure") = True Then
		Dim frame2 As FrameObject
		frame2.Initialize
		Dim hPa As Double = m.Get("hPa")
		If IsNumber( App.get("PresOffset")) Then
			Dim pOfset As Double = App.get("PresOffset")
			frame2.text = NumberFormat(hPa+ pOfset,0,0)
		Else
			frame2.text = NumberFormat(hPa,0,0)
		End If
		frame2.text=frame2.text
		frame2.TextLength = App.calcTextLength(frame2.text)
		frame2.color=Null
		frame2.Icon = 1214
		FrameList.Add(frame2)
	End If
End Sub

'With this sub you build your frame.
Sub App_genFrame
	App.FallingText(FrameList,True)
End Sub
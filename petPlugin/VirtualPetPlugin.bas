B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore
	
	Private AppName As String = "VirtualPet" 'change plugin name (unique)
	Private AppVersion As String="1.0"
	Private tickInterval As Int= 80
	Private needDownloads As Int = 0
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval

	
	Private description As String= $"
	
	"$
	
	Private setupInfos As String= $"
	
	"$
	
	Private appSettings As Map = CreateMap() 'needed Settings for this Plugin
	
	Dim blinkIndex() As Int = Array As Int( 1, 2, 3, 4, 3, 2, 1 )
	Dim blinkCountdown As Int = 30
	Dim gazeCountdown As Int  =  30
	Dim gazeFrames As Int    =  5

	Dim eyeX As Int = 9
	Dim eyeY As Int  = 3
	Dim newX As Int  = 9
	Dim newY As Int  = 3
	Dim dX As Int    = 6
	Dim dY As Int    = 0
	Dim PET_MOOD As Int = 2
	
	Dim normal() As Int = Array As Int(0, 0, 65535, 65535, 65535, 65535, 0, 0, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 0, 65535, 65535, 65535, 65535, 65535, 65535, 0, 0, 0, 65535, 65535, 65535, 65535, 0, 0)

End Sub

' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval) 										'übergibt AWTRIX die gewünschte tick-rate in ms. bei 0 wird der Tick nur einmalig aufgerufen
	MainSettings.Put("needDownload",needDownloads)
	setSettings
	Return "MyKey"
End Sub

' ignore
public Sub GetNiceName() As String
	Return AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Select Case Tag
		Case "start" 													'wird bei jedem start des Plugins aufgerufen und übergibt seine Settings an Awtrix
			If Params.ContainsKey("AppDuration") Then
				Appduration = Params.Get("AppDuration") 						'Kann zur berechnung von Zeiten verwendet werden 'ignore
			End If

			Return MainSettings
		Case "downloadCount"
			Return needDownloads
		Case "startDownload"
		
		Case "httpResponse"
		
		Case "tick"
			commandList.Clear											'Wird in der eingestellten Tickrate aufgerufen
			Return genFrame
		Case "infos"
			Dim infos As Map
			infos.Initialize
			Dim data() As Byte
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".png") Then
				Dim in As InputStream
				in = File.OpenInput(File.Combine(File.DirApp,"plugins"),AppName&".png")
				Dim out As OutputStream
				out.InitializeToBytesArray(1000)
				File.Copy2(in, out)
				data = out.ToBytesArray
				out.Close
			End If
			infos.Put("pic",data)
			Dim isconfigured As Boolean=True
			If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
				Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
				For Each v As Object In m.Values
					If v="null" Then
						isconfigured=False
					End If
				Next
			End If
			infos.Put("isconfigured",isconfigured)
			infos.Put("AppVersion",AppVersion)
			infos.Put("description",description)
			infos.Put("setupInfos",setupInfos)
			Return infos
		Case "setSettings"
			Return setSettings
		Case "getUpdateInterval"
			Return updateInterval
	End Select
	Return True
End Sub

'Get settings from the settings file
'You only need to set your variables
Sub setSettings As Boolean
	If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
		updateInterval=m.Get("updateInterval")
	Else
		Dim m As Map
		m.Initialize
		m.Put("updateInterval",updateInterval)
		For Each k As String In appSettings.Keys
			m.Put(k,appSettings.Get(k))
		Next
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
	End If
	Return True
End Sub

Sub genFrame As List
	commandList.Add(CreateMap("type":"bmp","x":6,"y":0,"bmp":normal,"width":8,"height":8,"color":Array As Int(0,0,0)))
	commandList.Add(CreateMap("type":"bmp","x":18,"y":0,"bmp":normal,"width":8,"height":8,"color":Array As Int(0,0,0)))
		
	If(blinkCountdown = 0) Then
		blinkCountdown = Rnd(5, 180)
		blinkCountdown=blinkCountdown-1
	Else
		blinkCountdown=blinkCountdown-1
	End If

	If (gazeCountdown < gazeFrames) Or (gazeCountdown = gazeFrames) Then
		gazeCountdown=gazeCountdown-1
		commandList.Add(CreateMap("type":"rect","x":newX - (dX * gazeCountdown / gazeFrames)+6,"y":	newY - (dY * gazeCountdown / gazeFrames),"w":2,"h":2,"color":Array As Int(0,0,0)))
		commandList.Add(CreateMap("type":"rect","x":newX - (dX * gazeCountdown / gazeFrames)+18,"y":newY - (dY * gazeCountdown / gazeFrames),"w":2,"h":2,"color":Array As Int(0,0,0)))
		
		If gazeCountdown = 0 Then
			eyeX = newX
			eyeY = newY
			Do Until(((dX * dX + dY * dY) > 1) Or ((dX * dX + dY * dY) = 1))
				If (PET_MOOD = 0) Then
					newX = Rnd(0,7)
					newY = Rnd(5,7)
					dX   = newX-3
					dY   = newY-3
				End If

				If (PET_MOOD = 1) Then
					newX = Rnd(0,7)
					newY = Rnd(0,7)
					dX   = newX - 3
					dY   = newY - 3
				End If

				If (PET_MOOD = 2) Then
					newX = Rnd(1,7)
					newY = Rnd(1,4)
					dX   = newX - 3
					dY   = newY - 3
				End If

				If (PET_MOOD = 3) Then
					newX = Rnd(0,7)
					newY = Rnd(3,7)
					dX   = newX - 3
					dY   = newY - 3
				End If
			Loop
			dX            = newX - eyeX
			dY            = newY - eyeY
			gazeFrames    = Rnd(3, 5)
			gazeCountdown = Rnd(gazeFrames, 20)

		End If
	Else
		gazeCountdown=gazeCountdown-1
		commandList.Add(CreateMap("type":"rect","x":eyeX+6,"y":eyeY,"w":2,"h":2, "color":Array As Int(0,0,0)))
		commandList.Add(CreateMap("type":"rect","x":eyeX+18,"y": eyeY,"w":2,"h":2,"color": Array As Int(0,0,0)))
	End If
	 
	Return commandList
End Sub

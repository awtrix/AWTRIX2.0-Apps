B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim MainSettings As Map 'ignore
	Private settings As Map 'ignore
	Dim scrollposition As Int 'ignore
	Dim commandList As List 'ignore
	Dim CallerObject As Object 'ignore
	Dim Appduration As Int 'ignore
	Dim iconTimer As Timer'ignore
	Dim iconList As List'ignore
	Dim animCount As Int'ignore
	Dim isAnimated As Boolean'ignore
	
	Dim lockapp As Boolean=False
	Dim Icon() As Int = Array As Int(0, 0, 63488, 63488, 63488, 63488, 0, 0, 0, 63488, 25388, 0, 0, 0, 63488, 0, 63488, 25388, 25388, 0, 0, 63488, 0, 63488, 63488, 25388, 0, 0, 63488, 0, 0, 63488, 63488, 65535, 65535, 63488, 65535, 64908, 64908, 63488, 63488, 0, 63488, 0, 0, 0, 0, 63488, 0, 63488, 0, 0, 0, 0, 63488, 0, 0, 0, 63488, 63488, 63488, 63488, 0, 0)

	Private AppName As String = "QuitSmoking" 'plugin name (must be unique)
	Private AppVersion As String="1.1"
	Private tickInterval As Int= 65 'tick rate in ms
	Private needDownloads As Int = 0 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval (configurable)
	
	Private description As String= $"
	Shows the days how long you don't smoke anymore<br/>
	<small>Created by AWTRIX</small> 
	"$
	
	Private setupInfos As String= $"
	<b>Quit Date:</b>  Format: dd.mm.yyyy.<br />
	"$
	
	Private appSettings As Map = CreateMap("QuitDate":"01.01.2019") 'needed Settings for this Plugin
	Dim PerDiff As Period
End Sub

#Region ignore
' ignore
Public Sub Initialize() As String
	commandList.Initialize
	MainSettings.Initialize
	MainSettings.Put("interval",tickInterval)
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
			DateTime.DateFormat = "dd.MM.yyyy"
			Try
				PerDiff= DateUtils.PeriodBetweenInDays(DateTime.Dateparse(appSettings.Get("QuitDate")),DateTime.now)
			Catch
				Log("Error in " &AppName)
				Log(LastException)
			End Try
			 
			scrollposition=32
			Return MainSettings
		Case "downloadCount"
			Return needDownloads
		Case "startDownload"
			Return startDownload(Params.Get("jobNr"))
		Case "httpResponse"
			Return evalJobResponse(Params.Get("jobNr"),Params.Get("success"),Params.Get("response"),Params.Get("InputStream"))
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
#End Region

'ignore
Sub setSettings As Boolean
	Log("setSettings")
	If File.Exists(File.Combine(File.DirApp,"plugins"),AppName&".ax") Then
		Dim m As Map = File.ReadMap(File.Combine(File.DirApp,"plugins"),AppName&".ax")
	
		For Each k As String In appSettings.Keys
			If Not(m.ContainsKey(k)) Then
				m.Put(k,appSettings.Get(k))
			Else
				appSettings.Put(k,m.Get(k))
			End If
		Next
		For Counter = m.Size -1 To 0 Step -1
			Dim SettingsKey As String = m.GetKeyAt(Counter)
			Log(SettingsKey)
			If Not(SettingsKey="updateInterval") Then
				If Not(appSettings.ContainsKey(SettingsKey)) Then m.Remove(SettingsKey)
			End If
		Next
		updateInterval=m.Get("updateInterval")
		File.WriteMap(File.Combine(File.DirApp,"plugins"),AppName&".ax",m)
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

'Called with every update from Awtrix,
Sub startDownload(nr As Int) As String
	Dim URL As String
	Select nr
		Case 1
			
	End Select
	Return URL
End Sub

'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	Return True
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub genFrame As List
	
	commandList.Add(genText(PerDiff.Days))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":Icon,"width":8,"height":8))
	Return commandList
End Sub

'helperfunction wich automatic displays the text big,tiny or scrolling.
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*4)  Then
			If lockapp Then
				Dim command As Map=CreateMap("type":"finish")
				Return command
			Else
				scrollposition=32
			End If
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
	
	Return command
End Sub
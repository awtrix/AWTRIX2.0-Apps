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
	
	Dim icon() As Int = Array As Int(0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0xffff, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0x3ad3, 0xffff, 0x3ad3, 0x3ad3, 0x3ad3)
	Private AppVersion As String="1.1"
	Private AppName As String = "facebook" 'plugin name (must be unique)
	Private tickInterval As Int= 60 'tick rate in ms (FPS)
	Private needDownloads As Int = 1 'how many dowloadhandlers should be generated
	Private updateInterval As Int = 0 'force update after X seconds. 0 for systeminterval
	
	Private description As String= $"
	Shows the likes of your Facebook page.<br/>
	<small>Created by AWTRIX</small>
	"$
	
	Private setupInfos As String= $"
	<b>PageID:</b>  Get your facebook PageID from https://findmyfbid.com/.<br/><br/>
	<b>AppID & AppSecret:</b> <small>Infos from https://goldplugins.com/documentation/wp-social-pro-documentation/how-to-get-an-app-id-and-secret-key-from-facebook/</small><br/>
	
	<p>In order to get an App ID and Secret Key from Facebook, you&#8217;ll need to register a new application. Don&#8217;t worry &#8211; its very easy, and your application doesn&#8217;t need to do anything. We only need the keys.</p>
<p>There are 4 simple steps to creating a Facebook App, which we&#8217;ve outlined below.</p>
<h3>Step One: Visit The Facebook Developers Page</h3>
<p>To start with, navigate your browser to the <a title="Facebook Developers" href="https://developers.facebook.com/" target="_blank">Facebook Developers page</a>. You&#8217;ll need to login to your Facebook account.</p>
<p>Once logged in, you&#8217;ll see a screen similar to this:</p>
<figure id="attachment_11139" style="width: 1280px" class="wp-caption alignnone"><img class="img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/add-a-new-app.png" alt="Screenshot of developers.facebook.com" width="1280" height="984" srcset="https://goldplugins.com/wp-content/uploads/2013/07/add-a-new-app.png 1280w, https://goldplugins.com/wp-content/uploads/2013/07/add-a-new-app-300x231.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/add-a-new-app-768x590.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/add-a-new-app-1024x787.png 1024w" sizes="(max-width: 1280px) 100vw, 1280px" /><figcaption class="wp-caption-text">Click the &#8220;Add a New App&#8221; link to get started.</figcaption></figure>
<p>To begin, click the green &#8220;Add a New App&#8221; link in the top right menu.</p>
<h3>Step Two: Input Your New App&#8217;s Information</h3>
<p>Once you&#8217;ve clicked &#8220;Add a New App&#8221;, a box will appear asking you for your new App&#8217;s Display Name, Contact E-Mail Address, and Category. Since this App won&#8217;t be published, just pick a name that is easy for you to remember.</p>
<img class="wp-image-11140 img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/create-a-new-app-screen-e1487868371560.png" alt="Screenshot of Add a New App modal." width="1280" height="979" srcset="https://goldplugins.com/wp-content/uploads/2013/07/create-a-new-app-screen-e1487868371560.png 1280w, https://goldplugins.com/wp-content/uploads/2013/07/create-a-new-app-screen-e1487868371560-300x229.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/create-a-new-app-screen-e1487868371560-768x587.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/create-a-new-app-screen-e1487868371560-1024x783.png 1024w" sizes="(max-width: 1280px) 100vw, 1280px" /><figcaption class="wp-caption-text">These are the fields you will see after clicking Add a New App. They are the Display name, Contact E-Mail, and Category.</figcaption></figure>
<p>You will be asked to choose a Category for your App &#8212; choose Apps for Pages.</p>
<img class="img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/new-app-fields-filled-out.png" alt="Screenshot of Add a New App Category drop down." width="1280" height="984" srcset="https://goldplugins.com/wp-content/uploads/2013/07/new-app-fields-filled-out.png 1280w, https://goldplugins.com/wp-content/uploads/2013/07/new-app-fields-filled-out-300x231.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/new-app-fields-filled-out-768x590.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/new-app-fields-filled-out-1024x787.png 1024w" sizes="(max-width: 1280px) 100vw, 1280px" /><figcaption class="wp-caption-text">Once you&#8217;ve filled out the required fields, be sure you&#8217;ve selected Apps for Pages in the category drop down.</figcaption></figure>
<h3>Step Three: Locate and Copy your App ID and Secret Key</h3>
<p>After you&#8217;ve filled out the required fields and clicked Create a New App ID, you&#8217;ll be taken to your new App&#8217;s dashboard. From here, you&#8217;ll need to click on the Settings link to view your App ID and Secret Key.</p>
<img class="img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-settings-link.png" alt="Screenshot of new App's Dashboard." width="1260" height="888" srcset="https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-settings-link.png 1260w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-settings-link-300x211.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-settings-link-768x541.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-settings-link-1024x722.png 1024w" sizes="(max-width: 1260px) 100vw, 1260px" /><figcaption class="wp-caption-text">This is the new App&#8217;s Dashboard. Click the Settings link on the left to proceed to your App ID and Secret Key.</figcaption></figure>
<p>Your Secret Key will be hidden from view until you click the Show button.</p>
<img class="img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-show-app-secret-button.png" alt="Screenshot of new App's Settings" width="1280" height="893" srcset="https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-show-app-secret-button.png 1280w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-show-app-secret-button-300x209.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-show-app-secret-button-768x536.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/app-dashboard-show-app-secret-button-1024x714.png 1024w" sizes="(max-width: 1280px) 100vw, 1280px" /><figcaption class="wp-caption-text">Your Secret Key is hidden from view until you click the Show button.</figcaption></figure>
<p>Once you&#8217;ve done this, we recommend copying both fields to a text file for easy access later.</p>
<img class="img-fluid" src="https://goldplugins.com/wp-content/uploads/2013/07/facebook-developer-app-id-and-secret-key.png" alt="Screenshot of new App's Settings with Secret Key revealed." width="1280" height="894" srcset="https://goldplugins.com/wp-content/uploads/2013/07/facebook-developer-app-id-and-secret-key.png 1280w, https://goldplugins.com/wp-content/uploads/2013/07/facebook-developer-app-id-and-secret-key-300x210.png 300w, https://goldplugins.com/wp-content/uploads/2013/07/facebook-developer-app-id-and-secret-key-768x536.png 768w, https://goldplugins.com/wp-content/uploads/2013/07/facebook-developer-app-id-and-secret-key-1024x715.png 1024w" sizes="(max-width: 1280px) 100vw, 1280px" /><figcaption class="wp-caption-text">After clicking Show, your Secret Key will be visible to copy.</figcaption></figure>
<p>You&#8217;re finished! That&#8217;s all there is to generating an App ID and Secret Key from Facebook. You can ignore the other settings.</p>
	"$
	Private appSettings As Map = CreateMap("AppID":Null,"AppSecret":Null,"PageID":Null) 'needed Settings for this Plugin


	'necessary variable declaration
	Dim AppID As String
	Dim AppSecret As String
	Dim PageID As String
	Dim likes As String ="="
	
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
		'You need just change the following lines to get the values into your variables
		AppID=m.Get("AppID")
		AppSecret=m.Get("AppSecret")
		PageID=m.Get("PageID")
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
			URL=("https://graph.facebook.com/"&PageID&"/?access_token="&AppID&"|"&AppSecret&"&fields=fan_count")
	End Select
	Return URL
End Sub


'Is called when the JobHandler has downloaded the data.
Sub evalJobResponse(nr As Int,success As Boolean,response As String,InputStream As InputStream) As Boolean
	If success=False Then Return False
	Select nr
		Case 1
			Try
					Dim parser As JSONParser
				parser.Initialize(response)
					Dim root As Map = parser.NextObject
					likes = root.Get("fan_count")
					Return True
				Catch
					Log("Error in: "& AppName & CRLF & LastException)
				Log("API response: "& CRLF & response)
				End Try
	End Select
	Return False
End Sub

'Generates the frame to be displayed.
'this function is called every tick
Sub genFrame As List
	commandList.Add(genText(likes))
	commandList.Add(CreateMap("type":"bmp","x":0,"y":0,"bmp":icon,"width":8,"height":8))
	Return commandList
End Sub

'Function for automatic scrolling of the text (optional)
Sub genText(s As String) As Map
	If s.Length>5 Then
		Dim command As Map=CreateMap("type":"text","text":s,"x":scrollposition,"y":1,"font":"auto")
		scrollposition=scrollposition-1
		If scrollposition< 0-(s.Length*4)  Then
			scrollposition=32
		End If
	Else
		Dim command As Map=CreateMap("type":"text","text":s,"x":9,"y":1,"font":"auto")
	End If
    
	Return command
End Sub

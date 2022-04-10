B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim StockList As List
	Dim loadedStocks As List
	Dim FrameList As List
End Sub

' Config your App
Public Sub Initialize() As String
	loadedStocks.Initialize
	StockList.Initialize
	FrameList.Initialize
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="StockTicker"
	
	'Version of the App
	App.Version="1.2"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows the Current stock price for up to 5 companies<br/> 
	Powered by alphavantage.co
	"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=442
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>APIKey: get your key at https://www.alphavantage.co/<br/>
	<b>Symbols: stock symbols, you can use up to 5 stocks (with free API key). Just seperate them with ","<br/>
	<b>ScrollTime: How long each Item schould be shown in seconds","<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(442)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("APIKey":"","Symbols":"MSFT,APC,GOOGL")
	
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
	If jobNr=1 Then
		FrameList.Clear
		loadedStocks.Clear
	End If
	Dim Symbol As String = StockList.Get(jobNr-1)
	App.Download("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="&Symbol&"&apikey=" & App.get("APIKey"))
End Sub

Sub App_settingsChanged
	StockList.Clear
	Dim SymbolsString As String = App.get("Symbols")
	If SymbolsString.Contains(",") Then
		Dim l() As String = Regex.Split(",",SymbolsString)
		For i=0 To l.Length-1
			StockList.Add(l(i))
		Next
	Else
		StockList.Add(SymbolsString)
	End If
	App.Downloads=StockList.Size
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.Success Then
	
			Dim parser As JSONParser
			parser.Initialize(Resp.ResponseString)
			Dim root As Map = parser.NextObject
			If root.ContainsKey("Note") Then
				Return
			End If
			Dim GlobalQUOTE As Map = root.Get("Global Quote")
			loadedStocks.Add(GlobalQUOTE)
		End If
	Catch
		Log("Error in " & App.Name)
		Log(LastException)
	End Try
	
End Sub


Sub App_Started
	
	If StockList.Size=0 Or loadedStocks.Size=0 Then
		App.shouldShow=False
		Log("no stock")
	Else
		
		For Each GlobalQUOTE As Map In loadedStocks
			App.shouldShow=True
			Dim Symbol As String = GlobalQUOTE.Get("01. symbol")
			Dim change As String = GlobalQUOTE.Get("10. change percent")
			Dim Price As String = GlobalQUOTE.Get("05. price")
			Price=NumberFormat2(Price,2,2,0,False)
			Dim frame As FrameObject
			frame.Initialize
			frame.text = Symbol
			frame.TextLength = App.calcTextLength(frame.text)
			frame.color=Null
			frame.Icon=442
			FrameList.Add(frame)
			Dim frame As FrameObject
			frame.Initialize
			frame.text = Price
			frame.TextLength = App.calcTextLength(frame.text)
			Dim col(3) As Int
			If change.Contains("-") Then col=Array As Int (255,0,0) Else col=Array As Int (0,255,0)
			frame.color=col
			frame.Icon=-1
			FrameList.Add(frame)
		Next	
	End If
	
End Sub



Sub App_genFrame
	App.FallingText(FrameList,True)
End Sub

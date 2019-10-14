B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim StockMap As Map
	Dim StockList As List
	Dim scrollsdone As Int =1
	Dim scroll As Int
	Dim waittime As Long
	Dim waittime2 As Long
	Dim scrolled As Boolean
	Dim scrolledfinished As Boolean =True
	Dim scope1 As Map
	Dim Symbol As String
	Dim Price As String
	Dim stocksfinish As Boolean
	Dim col() As Int
End Sub

' Config your App
Public Sub Initialize() As String
	
	StockMap.Initialize
	StockList.Initialize
	scope1.Initialize

	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="StockTicker"
	
	'Version of the App
	App.Version="1.1"
	
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
	App.Settings=CreateMap("ScrollTime":3,"APIKey":"","Symbols":"MSFT,APC,GOOGL")
	
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
	Dim Symbol As String = StockList.Get(jobNr-1)
	App.Download("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="&Symbol&"&apikey=" & App.get("APIKey"))
End Sub

Sub App_settingsChanged
	StockList.Clear
	StockMap.Clear
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
			StockMap.Put(Resp.jobNr,CreateMap("Symbol":"---","Change":"-","Price":"0000"))
			 Return
			 End If
		Dim GlobalQUOTE As Map = root.Get("Global Quote")
		Dim Symbol As String = GlobalQUOTE.Get("01. symbol")
		Dim change As String = GlobalQUOTE.Get("10. change percent")
		Dim Price As String = GlobalQUOTE.Get("05. price")
		StockMap.Put(Resp.jobNr,CreateMap("Symbol":Symbol,"Change":change,"Price":Price))
		Else
			StockMap.Put(Resp.jobNr,CreateMap("Symbol":"---","Change":"-","Price":"0000"))
		End If
	Catch
		Log("Error in " & App.Name)
		Log(LastException)
	End Try
	
End Sub

Sub App_Started
	waittime=App.get("ScrollTime")*1000
	waittime2=App.get("ScrollTime")*1000
	stocksfinish=False
	scrollsdone=1
	scroll=1
	If StockMap.Size=0 Then
		App.shouldShow=False
		Log("no stock")
	Else
		App.shouldShow=True
		scope1 = StockMap.Get(scrollsdone)
		Symbol=scope1.Get("Symbol")
		Price=scope1.Get("Price")
		Price=NumberFormat2(Price,2,2,0,False)
		Dim change As String= scope1.Get("Change")
		If change.Contains("-") Then col=Array As Int (255,0,0) Else col=Array As Int (0,255,0)
	End If

End Sub

Sub scrolling
	scrolledfinished=False
	If Not(scrolled) Then
		If scroll>-8 Then
			scroll=scroll-1
		End If
		If scroll=-7 Then
			scrolledfinished=True
			scrolled=True
			scrollsdone=scrollsdone+1
			Try
				scope1 = StockMap.Get(scrollsdone)
				Symbol=scope1.Get("Symbol")
			Catch
				stocksfinish=True
			End Try
		
		End If
	Else
		If scroll<1 Then
			scroll=scroll+1
		End If
		If scroll=1 Then
			scrolled=False
			scrolledfinished=True
			scope1 = StockMap.Get(scrollsdone)
			Price=scope1.Get("Price")
			Price=NumberFormat2(Price,2,2,0,False)
			Dim change As String= scope1.Get("Change")
			If change.Contains("-") Then col=Array As Int (255,0,0) Else col=Array As Int (0,255,0)
		End If
	End If
End Sub


Sub App_genFrame
	App.genText(Symbol,True,scroll,Null,True)
	App.drawBMP(0,scroll-2,App.getIcon(442),8,8)
	App.genText(Price,False,scroll+8,col,True)
	
	If Waithelper2 And stocksfinish Then
		Log("finish")
		App.finish
		Return
	End If
	
	If Waithelper  Then scrolling
	If Not(scrolledfinished) Then scrolling

End Sub

Sub Waithelper As Boolean
	If App.StartedAt + waittime < DateTime.Now Then
		waittime=waittime+App.get("ScrollTime")*1000
		Return True
	Else
		Return False
	End If
End Sub

Sub Waithelper2 As Boolean
	If App.StartedAt + waittime2 < DateTime.Now Then
		waittime2=waittime2+App.get("ScrollTime")*1000
		Return True
	Else
		Return False
	End If
End Sub


B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Private displaylist As List
	Private pairs As List
	Private iconmapping As Map
	Private icondefault As Int = 1541
	Private textcolor(3) As Int
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag, Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.Name="Crypto"
	
	'Version of the App
	App.Version="1.2"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"
	Shows prices for any cryptocurrency. Set your desired Coins and your currencies<br/>
	Powered by binance.com
	"$
	
	'The developer if this App
	App.Author="Elfish"
	
	'Icon (ID) to be displayed in the Appstore and MyApps
	App.CoverIcon=icondefault
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("CryptoPairs":"BTC/USD,ETH/USD", _
						   "CryptoIcons":"BTC/1538,ETH/1507,doge/1497,DOT/1540,ADA/1539,EUR/520,USD/25", _
						   "TextColor":"255,255,255", _
						   "ShowBaseTarget":True, _
						   "ShowToday":False, _
						   "ShowAsk":False, _
						   "ShowBid":False, _
						   "ShowLastTradeClosed":False, _
						   "ShowVolume":False, _
						   "ShowAveragePrice":True, _
						   "ShowNumerOfTrades":False, _
						   "ShowLow":False, _
						   "ShowHigh": False, _
						   "ShowOpeningPrice":False)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>CryptoPairs:</b>  Conversion pairs in format base1/currency1,base2/currency2 ... e.g. (BTC/USD,ETH/EUR ...).<br/>
	<b>CryptoIcons:</b>  Icons for base values in format base1/icon1,base2/icon2 ... e.g. (BTC/1538,ETH/1507 ...).<br/>
	<b>TextColor:</b>  <br/>
	<b>ShowBaseTarget:</b>  Show description of conversion pairs.<br/><br/>
	<b>ShowToday:</b>  <br/>
	<b>ShowAsk:</b>  <br/>
	<b>ShowBid:</b>  <br/>
	<b>ShowLastTradeClosed:</b>  <br/>
	<b>ShowVolume:</b>  <br/>
	<b>ShowAveragePrice:</b>  <br/>
	<b>ShowNumerOfTrades:</b>  <br/>
	<b>ShowLow:</b>  <br/>
	<b>ShowHigh:</b>  <br/>
	<b>ShowOpeningPrice:</b>  <br/>
	For possible coins and currencies visit <a target="_blank" rel="noopener noreferrer" href="https://api.kraken.com/0/public/AssetPairs">https://api.kraken.com/0/public/AssetPairs</a>.
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Crypto")
	
	'How many downloadhandlers should be generated
	App.Downloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.Icons=Array As Int(icondefault)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=65
		
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False	

	'ignore
	App.makeSettings
		
	'Init downloads	
	ParseSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	Dim pair(3) As String
	displaylist.Initialize
	
	Dim color As String = App.get("TextColor")
	textcolor = Array As Int(80, 80, 80)
	
	If ValidateColorString(color) = True Then
		Dim c() As String = Regex.Split(",", color)
		textcolor(0)=c(0)
		textcolor(1)=c(1)
		textcolor(2)=c(2)
	End If
	
	If pairs.Size <> 0 Then
		For i = 0 To pairs.Size - 1
			pair = pairs.Get(i)
			Dim frame As FrameObject
			frame.Initialize
			frame.text = pair(2)
			frame.TextLength = App.calcTextLength(frame.text)
			frame.color = textcolor
			frame.Icon = iconmapping.GetDefault(pair(0), icondefault)
			displaylist.Add(frame)
		Next
	Else
		Dim frame As FrameObject
		frame.Initialize
		frame.text = "Error"
		frame.TextLength = App.calcTextLength(frame.text)
		frame.color = textcolor
		frame.Icon = icondefault
		displaylist.Add(frame)
	End If
End Sub

'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'This sub is called right before AWTRIX will display your App.
'If you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	Dim icons(iconmapping.Size + 1) As Int
	Dim i As Int = 0
	icons(i) = icondefault
	For Each key In iconmapping.Keys
		i = i + 1
		icons(i) = iconmapping.Get(key)		
	Next
	App.icons = icons
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	ParseSettings
End Sub

'If you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'If you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)

End Sub

'This sub is called when the user presses the middle touchbutton while the app is running
Sub App_buttonPush
	
End Sub

'It possible to create your own setupscreen in HTML.
'This is a very dirty workaround, but its works:)
'Every input must contains an ID with the corresponding settingskey in lowercase 
Sub App_CustomSetupScreen As String
	Return ""
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
'API documentation
'https://docs.kraken.com/rest/#operation/getTickerInformation
Sub App_startDownload(jobNr As Int)
	Dim cur() As String = pairs.get(jobNr - 1)
	App.Download("https://api.kraken.com/0/public/Ticker?pair=" & cur(0).ToUpperCase & cur(1).ToUpperCase)
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Dim parser As JSONParser
			parser.Initialize(Resp.ResponseString)
			Dim root As Map = parser.NextObject
			Dim pair(3) As String = pairs.get(Resp.jobNr - 1)
			Dim textResult As List
			textResult.Initialize
			If App.get("ShowBaseTarget") Then
				textResult.Add(pair(0) & "/" & pair(1))
			End If
			If root.ContainsKey("result")  Then
				Dim result As Map = root.Get("result")
				Dim resultKeys As List = result.Keys
				If resultKeys.Size <> 1 Then
					Dim key As String = result.GetKeyAt(0)
					Dim firstPair As Map = result.Get(key)
					'Ask
					If firstPair.ContainsKey("a") And App.get("ShowAsk") Then
						Dim ask As List = firstPair.Get("a")
						Dim askPrice As Double = ask.Get(0)						
						'Dim askWholeLotVolume As Double = ask.Get(1)						
						'Dim askLotVolume As Double = ask.Get(2)
						textResult.Add("Ask " & FormatNumber(askPrice))
					Else
						textResult.Add("Error")
					End If
					'Bid
					If firstPair.ContainsKey("b") And App.get("ShowBid") Then
						Dim bid As List = firstPair.Get("b")
						Dim bidPrice As Double = bid.Get(0)
						'Dim bidWholeLotVolume As Double = bid.Get(1)
						'Dim bidLotVolume As Double = bid.Get(2)
						textResult.Add("Bid " & FormatNumber(bidPrice))
					Else
						textResult.Add("Error")
					End If
					'Last trade closed
					If firstPair.ContainsKey("c") And App.get("ShowLastTradeClosed") Then
						Dim lastTradeClosed As List = firstPair.Get("c")
						'Dim lastTradeClosedPrice As Double = lastTradeClosed.Get(0)
						'Dim lastTradeClosedLotVolume As Double = lastTradeClosed.Get(1)
						textResult.Add("Last " & FormatNumber(lastTradeClosed))
					Else
						textResult.Add("Error")
					End If
					'Volume
					If firstPair.ContainsKey("v") And App.get("ShowVolume") Then
						Dim volume As List = firstPair.Get("v")
						Dim volumeToday As Double = volume.Get(0)
						Dim volume24 As Double = volume.Get(1)
						If App.get("ShowToday") Then
							textResult.Add("Vol " & FormatNumber(volumeToday))
						Else
							textResult.Add("Vol " & FormatNumber(volume24))
						End If
					Else
						textResult.Add("Error")
					End If
					'Volume weighted average price
				If firstPair.ContainsKey("p") And App.get("ShowAveragePrice") Then 
						Dim volumeWeightedAveragePrice As List = firstPair.Get("p")
						Dim volumeWeightedAveragePriceToday As Double = volumeWeightedAveragePrice.Get(0)
						Dim volumeWeightedAveragePrice24 As Double = volumeWeightedAveragePrice.Get(1)
						If App.get("ShowToday") Then
							textResult.Add("Avg " & FormatNumber(volumeWeightedAveragePriceToday))
						Else
							textResult.Add("Avg " & FormatNumber(volumeWeightedAveragePrice24))
						End If	
					Else
						textResult.Add("Error")
					End If
					'Number of trades
					If firstPair.ContainsKey("t") And App.get("ShowNumerOfTrades") Then
						Dim numberOfTrades As List = firstPair.Get("t")
						Dim numberOfTradesToday As Double = numberOfTrades.Get(0)
						Dim numberOfTrades24 As Double = numberOfTrades.Get(1)
						If App.get("ShowToday") Then
							textResult.Add("Trades " & FormatNumber(numberOfTradesToday))
						Else
							textResult.Add("Trades " & FormatNumber(numberOfTrades24))
						End If
					Else
						textResult.Add("Error")
					End If
					'Low
					If firstPair.ContainsKey("l") And App.get("ShowLow") Then
						Dim Low As List = firstPair.Get("l")
						Dim LowToday As Double = Low.Get(0)
						Dim Low24 As Double = Low.Get(1)
						If App.get("ShowToday") Then
							textResult.Add("Low " & FormatNumber(LowToday))
						Else
							textResult.Add("Low " & FormatNumber(Low24))
						End If
					Else
						textResult.Add("Error")
					End If
					'High
					If firstPair.ContainsKey("h") And App.get("ShowHigh") Then
						Dim High As List = firstPair.Get("h")
						Dim HighToday As Double = High.Get(0)
						Dim High24 As Double = High.Get(1)
						If App.get("ShowToday") Then
							textResult.Add("High " & FormatNumber(HighToday))
						Else
							textResult.Add("High " & FormatNumber(High24))
						End If
					Else
						textResult.Add("Error")
					End If
					'Today's opening price
					If firstPair.ContainsKey("o") And App.get("ShowOpeningPrice") Then
						Dim TodaysOpeningPrice As List = firstPair.Get("o")
						Dim TodaysOpeningPriceToday As Double = TodaysOpeningPrice.Get(0)
						textResult.Add("Open " & FormatNumber(TodaysOpeningPriceToday))
					Else
						textResult.Add("Error")
					End If
				Else
					textResult.Add("Error")
					Log(App.Name & " More than one result in API response")
				End If
			Else
				textResult.Add("Error")
				Log(App.Name & " No result in API response")
			End If
		End If
		pair(2) = ListToString(textResult, " ")
		pairs.Set(Resp.jobNr - 1, pair)
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub FormatNumber(number As Double) As String
	Dim i As Long = Floor(Logarithm(number, 10))
	Dim exp As Long
	If i >= 3 Then
		exp = 0
	Else
		exp = Abs(i - 3)
	End If
	Return NumberFormat2(number, 1, exp, 0, False)
End Sub

Sub ParseSettings
	'pairs
	Dim down As Int
	pairs.Initialize
	If ValidateCryptoSettings(App.get("CryptoPairs")) Then
		Dim CryptoPairsSplit() As String = Regex.Split(",", App.get("CryptoPairs"))
		down = CryptoPairsSplit.Length
		For Each pair As String In CryptoPairsSplit
			Dim temp(3) As String
			'base
			temp(0) = Regex.Split("/", pair)(0).Trim.ToUpperCase
			'currency
			temp(1) = Regex.Split("/", pair)(1).Trim.ToUpperCase
			'text
			temp(2) = ""
			pairs.add(temp)
		Next
	Else 
		down = 0		
	End If
	App.downloads = down
	
	'icons
	iconmapping.Initialize
	If ValidateCryptoSettings(App.get("CryptoIcons")) Then
		Dim CryptoIconsSplit() As String = Regex.Split(",", App.get("CryptoIcons"))
		Dim key As String
		Dim value As Int
		For Each pair As String In CryptoIconsSplit
			key = Regex.Split("/", pair)(0).Trim.ToUpperCase
			value = ConvertString2IconId(Regex.Split("/", pair)(1).Trim.ToUpperCase)
			If value > 0 Then
				If iconmapping.ContainsKey(key) = False Then
					iconmapping.put(key, value)
				End If	
			End If
		Next
	End If	
End Sub

Sub ValidateCryptoSettings(settings As String) As Boolean
	For Each pair As String In Regex.Split(",", settings)
		If Regex.Split("/", pair).Length <> 2 Then
			Return False
		End If
	Next	
	Return True
End Sub

Sub ValidateColorString(colorstring As String) As Boolean
	Dim c() As String = Regex.Split(",", colorstring)
	If c.Length = 3 Then
		If IsNumber(c(0)) And IsNumber(c(1)) And IsNumber(c(2)) Then
			If c(0) >= 0 And c(0) <= 255 And c(1) >= 0 And c(1) <= 255 And c(2) >= 0 And c(2) <= 255 Then
				Return True
			Else
				Return False
			End If
		Else
			Return False
		End If
	Else
		Return False
	End If
End Sub

Sub ConvertString2IconId(Id As String) As Int
	Dim result As Int
	Try
		result = Id
	Catch
		result = -1
	End Try
	Return result
End Sub

Sub ListToString(list As List, join As String) As String
	If list.Size = 0 Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	For Each s As String In list
		sb.Append(s).Append(join)
	Next
	sb.Remove(sb.Length - join.Length, sb.Length)
	Return sb.ToString
End Sub

'With this sub you build your frame with every Tick.
Sub App_genFrame
	'App.simpleText(price_concat.Trim,True,1,Null,True)
	App.FallingText(displaylist, True)
	'App.drawBMP(0,0,App.getIcon(App.get("IconID")),8,8)
End Sub
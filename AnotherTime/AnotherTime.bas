B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim WeekdaysColor() As Int
	Dim CurrentDayColor() As Int
	Dim weekdaysStyle As String
	Dim temperatureIcon As Boolean
	Dim temperatureIconId As Int
	Dim humidityIcon As Boolean
	Dim humidityIconId As Int
	Dim widgetsScroll As Scroll
	Dim timeBlinking As String
	Dim timeAnimation As String
	Dim timeAnimationDuration As Int
	Dim secondsStyle As String
	Dim secondsColor() As Int
	Dim secondsBackgroundColor() As Int
	Dim showWeekDay As Boolean
	Dim startsSunday As Boolean
	Dim ampmFormat As Boolean
	Dim widgets As List
	Dim fahrenheit As Boolean
	Dim settings As Map
	Dim OPTION_BOOL As Int = 0
	Dim OPTION_COLOR As Int = 1
	Dim OPTION_SELECT As Int = 2
	Dim OPTION_TEXT As Int = 3
	Type Option (description As String, style As Int, value As Object)
	Dim options As Map
	Dim calendarTextColor() As Int
	Dim calendarHeadColor() As Int
	Dim calendarBodyColor() As Int
	Dim calendarStyle As String
	Dim calendarIconId As Int
	Dim iconIconId As Int
	Dim iconXpos As Int
	Dim iconYpos As Int
	Dim middleButton As Button
	Dim drawDateEndTime As Long
	Dim k2000Animation As List
	Dim lastSystemColor As Short
End Sub

'Initializes the object. You can NOT add parameters to this method!
Public Sub Initialize() As String
	

	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="AnotherTime"
	
	'Version of the App
	App.Version="1.3"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows time with temperature and date, maybe more..."
	
	App.Author = "Toinux"
	
	App.CoverIcon = 1742
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $""$
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	
	' duration = 0 to capture the pression in one Tick, but could be longer to keep the pression registered as as timer
	middleButton.Initialize(0, 2, 500)
	

	options.Initialize
	options.Put("SecondsStyle", newOption("Show seconds|Display seconds as a progress bar, or other fun stuff", OPTION_SELECT, Array As String("progress","k2000","none")))
	options.Put("ShowWeekday", newOption("Show Week|Display week day as 7 dots", OPTION_BOOL, True))
	options.Put("TimeAnimation", newOption("Time animation", OPTION_SELECT, Array As String ("scroll", "fade", "none")))
	options.Put("12hrFormat", newOption("Switch from 24hr to 12h timeformat", OPTION_BOOL, False))
	options.Put("TimeBlinking", newOption("Colon animation", OPTION_SELECT, Array As String ("blink", "fade", "none")))
	options.Put("StartsSunday", newOption("Week begins on sunday", OPTION_BOOL, False))
	options.Put("SecondsColor", newOption("Seconds progress color", OPTION_COLOR, "0"))
	options.Put("SecondsBackgroundColor", newOption("Seconds background color", OPTION_COLOR, "#555555"))
	options.Put("WeekdaysColor", newOption("Other days color", OPTION_COLOR, "#555555"))
	options.Put("WeekdaysStyle", newOption("Week style", OPTION_SELECT, Array As String ("dotted", "dotted2", "large", "progress")))
	options.Put("CurrentDayColor", newOption("Current day color", OPTION_COLOR, "0"))
	options.Put("Fahrenheit", newOption("Display temperature as Fahrenheit", OPTION_BOOL, False))
	options.Put("TemperatureIcon", newOption("Temperature icon|Won't be displayed if temperature &gt; 100°", OPTION_BOOL, True))
	options.Put("TemperatureIconID", newOption("Temperature icon ID|Default value : 1738", OPTION_TEXT, 1738))
	options.Put("HumidityIcon", newOption("Humidity icon", OPTION_BOOL, True))
	options.Put("HumidityIconID", newOption("Humidity icon ID|Default value : 1746", OPTION_TEXT, 1746))
	options.Put("CalendarTextColor", newOption("Calendar text color", OPTION_COLOR, "#000000"))
	options.Put("CalendarHeadColor", newOption("Calendar head color", OPTION_COLOR, "#0000ff"))
	options.Put("CalendarBodyColor", newOption("Calendar body color", OPTION_COLOR, "#ffffff"))
	options.Put("CalendarStyle", newOption("Calendar style", OPTION_SELECT, Array As String("icon","small","large")))
	options.Put("CalendarIconID", newOption("Calendar icon ID|Default value : 1740", OPTION_TEXT, 1740))
	options.Put("WidgetCalendar", newOption("Enable calendar", OPTION_BOOL, True))
	options.Put("WidgetTemperature", newOption($"Enable temperature|<a target="_blank" href="https://awtrixdocs.blueforcer.de/#/en-en/hardware?id=temperature-and-humidity-sensor-optional">Temperature sensor</a> required"$, OPTION_BOOL, True))
	options.Put("WidgetHumidity", newOption($"Enable humidity|<a target="_blank" href="https://awtrixdocs.blueforcer.de/#/en-en/hardware?id=temperature-and-humidity-sensor-optional">Humidity sensor</a> required"$, OPTION_BOOL, True))
	options.Put("WidgetIcon", newOption("Enable custom icon", OPTION_BOOL, False))
	options.Put("IconIconID", newOption("Custom icon ID", OPTION_TEXT, "6"))
	options.Put("IconXpos", newOption("Custom icon x position|Between 17 and 31", OPTION_TEXT, 20))
	options.Put("IconYpos", newOption("Custom icon y position|Between -7 and 7", OPTION_TEXT, 0))
	

	settings.Initialize
	For Each option In options.Keys
		Dim opt As Option = options.Get(option)
		Dim value As Object = opt.value
		If opt.style = OPTION_SELECT Then
			Dim values() As String = value
			settings.Put(option, values(0))
		Else
			settings.Put(option, value)
		End If
	Next
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=settings 'needed Settings for this Plugin
	App.MakeSettings
	Return "AWTRIX20"
End Sub


' must be available
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_Started
	
	widgets.Initialize
	If (App.get("WidgetCalendar")) Then
		widgets.Add("calendar")
	End If
	If (App.get("WidgetTemperature")) Then
		widgets.Add("temperature")
	End If
	If (App.get("WidgetHumidity")) Then
		widgets.Add("humidity")
	End If
	If (App.get("WidgetIcon")) Then
		widgets.Add("icon")
	End If

	widgetsScroll.Initialize(App.duration, widgets.Size)
	timeBlinking = App.get("TimeBlinking")
	timeAnimation = App.get("TimeAnimation")
	Select Case timeAnimation
		Case "scroll"
			timeAnimationDuration = 8 * App.tick
		Case "fade"
			timeAnimationDuration = 16 * App.tick
		Case Else
			timeAnimationDuration = 0
	End Select
	
	secondsStyle = App.get("SecondsStyle")
	showWeekDay = App.get("ShowWeekday")
	startsSunday = App.get("StartsSunday")
	ampmFormat = App.get("12hrFormat")
	temperatureIcon = App.get("TemperatureIcon")
	temperatureIconId = App.get("TemperatureIconID")
	fahrenheit = App.get("Fahrenheit")
	humidityIcon = App.get("HumidityIcon")
	humidityIconId = App.get("HumidityIconID")
	
	secondsColor = parseColor(App.get("SecondsColor"), Null)
	secondsBackgroundColor = parseColor(App.get("SecondsBackgroundColor"), Array As Int(80,80,80))
	
	WeekdaysColor = parseColor(App.get("WeekdaysColor"), Array As Int(80,80,80))
	CurrentDayColor = parseColor(App.get("CurrentDayColor"), Null)
	weekdaysStyle = App.get("WeekdaysStyle")
	
	calendarTextColor = parseColor(App.get("CalendarTextColor"), Array As Int(0,0,0))
	calendarHeadColor = parseColor(App.get("CalendarHeadColor"), Array As Int(0,0,255))
	calendarBodyColor = parseColor(App.get("CalendarBodyColor"), Array As Int(255,255,255))
	calendarStyle = App.get("CalendarStyle")
	calendarIconId = App.get("CalendarIconID")
	
	iconIconId = App.get("IconIconID")
	iconXpos = App.get("IconXpos")
	iconYpos = App.get("IconYpos")
	
	If Not(lastSystemColor = colorTo565(App.AppColor)) Then
		' force recalculation of K2000 animation if system color changed
		' only effective after next application cycle
		k2000Animation = Null
		lastSystemColor = colorTo565(App.AppColor)
	End If

	
End Sub

Sub App_SettingsChanged
		' force recalculation of K2000 animation because settings could have changed
	k2000Animation = Null
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons = Array As Int(App.get("TemperatureIconID"), App.get("HumidityIconID"), App.get("CalendarIconID"), App.get("IconIconID"))
End Sub

Sub App_genFrame

	middleButton.update

	' double press = toggle date (1 hour max)
	If middleButton.DoublePressed Then
		If DateTime.Now < drawDateEndTime Then
			drawDateEndTime = 0
		Else
			drawDateEndTime = DateTime.Now + 3600 * 1000
		End If
		
	End If

	' simple press = show date for 5 seconds
	If middleButton.Pressed Then
		drawDateEndTime = DateTime.Now + 5000
	End If

	If DateTime.Now < drawDateEndTime Then
		drawDate
	Else
		drawTime
	End If
	

	If widgets.Size = 1 Then
		CallSub2(Me, "widget_"&widgets.Get(0), 0)
	Else If widgets.Size > 1 Then
		For i=0 To widgets.Size-1
			CallSub2(Me, "widget_"&widgets.Get(i), widgetsScroll.getOffset(i))
		Next
		widgetsScroll.update
	End If	

	If Not(secondsStyle.EqualsIgnoreCase("none")) Then
		drawSeconds
	End If
	
	If showWeekDay Then
		drawWeek
	End If

End Sub

Private Sub drawDate
	DateTime.TimeFormat = "dd.MM"
	Dim xpos As Int = IIf(widgets.Size > 0, -1, 6)
	App.drawText(DateTime.Time(DateTime.Now),xpos, 1,Null)
End Sub

Private Sub drawTime
	Dim now As Long = DateTime.Now

	' number of ms since the beginning of this minute
	Dim millis As Int
	If timeAnimationDuration > 0 Then
		DateTime.TimeFormat = "S"
		millis = DateTime.Time(now) + DateTime.GetSecond(now) * 1000
	End If
	
	Dim separator As String = ":"
	Dim separatorColor() As Int = Null
	Select Case timeBlinking
		Case "blink"
			If DateTime.GetSecond(now) Mod 2 > 0 Then
				separator = " "
			End If

		Case "fade"
			DateTime.TimeFormat = "S"
			Dim sepduration As Int = 2 * App.tick
			Dim sepms As Int = DateTime.Time(now)
			Dim odd As Boolean = DateTime.GetSecond(now) Mod 2 > 0
			Dim separatorColor() As Int = IIf(odd, Array As Int(0,0,0), Null)
			If sepms < sepduration Then
				Dim seppct As Float = IIf(odd, 1 - sepms / sepduration, sepms / sepduration)
				separatorColor = Array As Int(App.AppColor(0) * seppct, App.AppColor(1) * seppct, App.AppColor(2) * seppct)
			End If

		Case Else ' "none"
			separatorColor = Null
	End Select
	
	
	DateTime.TimeFormat = IIf(ampmFormat,"KK", "HH")&"mm"
	Dim timeString As String = DateTime.Time(now)
	
		
	Dim xpos As Int = IIf(widgets.Size > 0, -1, 6)
	
	' Animation during the first animationDuration in ms of the first minute
	If millis < timeAnimationDuration Then

		' percentage of the animation (0 = started, 1 = finished)
		Dim animationPct As Float = millis / timeAnimationDuration
		
		Dim previous As String = DateTime.Time(now - timeAnimationDuration)
		
		' calculate which digits changed
		Dim o() As Boolean = Array As Boolean(False,False,False,False)
		For i = 0 To 3
			o(i) = Not(timeString.CharAt(i) = previous.CharAt(i))
		Next
		
		' animate only digits that changed		
		For i = 0 To 3
			
			' digit changed
			If o(i) Then
				' draw next on top of previous
				Select Case timeAnimation
					Case "scroll"
						Dim ypos As Int = animationPct * 8
						App.drawText(timeString.CharAt(i), xpos, 1+ypos-8, Null)
						App.drawText(previous.CharAt(i), xpos, 1+ypos, Null)
						
					Case Else ' "fade"
						If animationPct < 0.5 Then
							Dim pct As Float = 1 - 2 * animationPct
							App.drawText(previous.CharAt(i),xpos, 1,Array As Int(App.AppColor(0) * pct, App.AppColor(1) * pct, App.AppColor(2) * pct))
						Else
							Dim pct As Float = 2 * animationPct - 1
							App.drawText(timeString.CharAt(i),xpos , 1,Array As Int(App.AppColor(0) * pct, App.AppColor(1) * pct, App.AppColor(2) * pct))
						End If

				End Select

			Else
				' digit did not change : draw previous one
				App.drawText(previous.CharAt(i),xpos , 1,Null)
			End If

			' shift 4 characters after drawing for a digit
			xpos = xpos + 4
		
			' add the separator after the second digit
			If i = 1 Then
				App.drawText(separator,xpos , 1,Null)
				xpos = xpos + 2
			End If
		Next
	Else
		' No animation
		App.drawText(timeString.CharAt(0)&timeString.CharAt(1),xpos, 1,Null)
		App.drawText(separator,xpos + 8 , 1,separatorColor)
		App.drawText(timeString.CharAt(2)&timeString.CharAt(3),xpos + 10, 1,Null)
	End If
	
	
	
End Sub

Private Sub drawSeconds

	Dim secondsProgressSize As Int = 17
		
	Select Case secondsStyle
		Case "progress"
			Dim second As Int = DateTime.GetSecond(DateTime.Now)
			If Not(secondsBackgroundColor = Null) Then
				App.drawLine(0, 7, secondsProgressSize - 1, 7, secondsBackgroundColor)
			End If
			If second > 0 Then
				App.drawLine(0, 7, Floor(second * secondsProgressSize / 60), 7, secondsColor)
			End If
			
		Case "k2000"

			If Not(k2000Animation.IsInitialized) Then
				k2000Animation = makeK2000Animation(secondsProgressSize, 12, secondsColor, secondsBackgroundColor)
			End If

			Dim now As Long = DateTime.Now
			DateTime.TimeFormat = "S"
			Dim duration As Int = 2 * 1000
			Dim millis As Int = (DateTime.Time(now) + DateTime.GetSecond(now) * 1000) Mod duration
			Dim pct As Float = millis / duration
			Dim frame As Int = secondsProgressSize * 2 * pct
			App.drawBMP(0,7,k2000Animation.Get(frame),secondsProgressSize,1)
			
	End Select
	
End Sub

Private Sub drawWeek
	Dim weekday As Int = DateTime.GetDayOfWeek(DateTime.Now)
	If Not(startsSunday) Then
		weekday=weekday-1
		If (weekday = 0) Then
			weekday = 7
		End If
	End If
	
	Dim xpos As Int = 18
	
	Select Case weekdaysStyle

		Case "large"
			App.drawLine(xpos,7,31,7,WeekdaysColor)
			App.drawLine(xpos+(weekday-1)*2,7, xpos+(weekday-1)*2+1,7,CurrentDayColor)

		Case "progress"
			App.drawLine(xpos,7,31,7,WeekdaysColor)
			App.drawLine(xpos,7, xpos+(weekday-1)*2+1,7,CurrentDayColor)

		Case "dotted2"
			App.drawLine(xpos,7,31,7,Array As Int(0,0,0))
	
			For i=0 To 6
				If i=weekday-1 Then
					App.drawLine(xpos,7, xpos+1, 7,CurrentDayColor)
					xpos = xpos + 3
				Else
					App.drawPixel(xpos,7,WeekdaysColor) 
					xpos = xpos + 2
				End If
			Next
			
		Case Else ' "dotted"
			App.drawLine(xpos,7,31,7,Array As Int(0,0,0))
	
			For i=0 To 6
				If i=weekday-1 Then
					App.drawPixel(xpos+i*2,7,CurrentDayColor)
				Else
					App.drawPixel(xpos+i*2,7,WeekdaysColor)
				End If
			Next

	End Select
	
End Sub

Private Sub widget_temperature(offset As Int)
	If outboundOffset(offset) Then
		Return
	End If
	
	Dim xpos As Int = 19

	Dim temp As Int = NumberFormat(getTemperature,0,0)

	Dim tempNegative As Boolean = False
	If temp < 0 Then
		tempNegative = True
		temp = Abs(temp)
	End If
	
	If temp < 10 Then
		xpos = xpos + 4
	End If
	
	Dim tooLarge As Boolean = temp > 99
	If tooLarge Then
		xpos = xpos - 4
	End If
	
	If temperatureIcon And Not(tooLarge) Then
		App.drawBMP(IIf(tempNegative, IIf(temp > 9, xpos-1,xpos-3), xpos),offset,App.getIcon(temperatureIconId),8,8)
		xpos = xpos + 2
	End If
	
	' smaller - sign
	If tempNegative Then
		If Not(temperatureIcon) Or temp < 10 Then
			App.drawLine(xpos+1, 3+offset, xpos+2, 3+offset, Null)
		Else
			' Very small space : shift - sign next to the temperature digits when temperature icon
			App.drawLine(xpos+2, 3+offset, xpos + 3, 3+offset, Null)
		End If
	End If
	App.drawText(temp,xpos + 3,1+offset,Null)
	' smaller ° sign
	If Not(temperatureIcon) Or tooLarge Then
		App.drawPixel(31, 1+offset, Null)
	End If
End Sub

Private Sub widget_humidity(offset As Int)
	If outboundOffset(offset) Then
		Return
	End If
	
	Dim xpos As Int = 19

	' Won't manage 100%, cap to 99%
	Dim hum As Int = Min(NumberFormat(getHumidity,0,0),99)

	If hum < 10 Then
		xpos = xpos + 4
	End If
	
	If humidityIcon Then
		App.drawBMP(xpos,offset,App.getIcon(humidityIconId),8,8)
		App.drawText(hum,xpos + 5,1+offset,Null)
	Else
		App.drawText(hum&"%",xpos+1,1+offset,Null)
	End If
	
End Sub

Private Sub widget_calendar(offset As Int)
	If outboundOffset(offset) Then
		Return
	End If

	Dim currentDay As Int = DateTime.GetDayOfMonth(DateTime.Now)

	' text position
	Dim tpos As Int
	
	Select Case calendarStyle
		Case "icon"

			' icon position
			Dim ipos As Int = 19

			tpos = 23
			
			If (currentDay < 10) Then
				ipos = 23
				tpos = 27
			End If
			
			App.drawBMP(ipos,offset,App.getIcon(calendarIconId),8,8)
			App.drawText(currentDay, tpos+1, offset+1,  Null)

		Case "large"
			
			tpos = 21
			
			If (currentDay < 10) Then
				tpos = tpos + 2
			End If

			For i=0 To 1
				App.drawLine(18, offset+i, 31, offset+i, calendarHeadColor)
			Next
			For i=2 To 6
				App.drawLine(18, offset+i, 31, offset+i, calendarBodyColor)
			Next
			App.drawText(currentDay, tpos, 1+offset,  calendarTextColor)
			
		Case Else ' "small"

			tpos = 23

			If (currentDay < 10) Then
				tpos = tpos + 2
			End If

			For i=0 To 1
				App.drawLine(23, offset+i, 31, offset+i, calendarHeadColor)
			Next
			For i=2 To 6
				App.drawLine(23, offset+i, 31, offset+i, calendarBodyColor)
			Next
			App.drawText(currentDay, tpos, 1+offset,  calendarTextColor)
			
	End Select
	
	
End Sub

Private Sub widget_icon(offset As Int)
	If outboundOffset(offset) Then
		Return
	End If
	
	Dim xpos As Int = Max(17,Min(31,iconXpos))
	Dim ypos As Int = Max(-7,Min(7,iconYpos))

	App.drawBMP(xpos,ypos + offset,App.getIcon(iconIconId),8,8)
End Sub

Private Sub outboundOffset(offset As Int) As Boolean
	Return Abs(offset) > 7
End Sub

Private Sub celciusToFahrenheit(celcius As Double) As Double
	Return celcius * 1.8 + 32	
End Sub

Private Sub getTemperature As Double
	Dim temp As Double = 0
	If App.matrix.Get("Temp") = Null Then
		' temporary workaround
		For Each value As Map In App.matrix.Values
			temp = value.GetDefault("Temp", 0)
			Exit
		Next
	Else
		temp = App.matrix.GetDefault("Temp", 0)
	End If
	Return IIf(fahrenheit, celciusToFahrenheit(temp), temp)
End Sub

Private Sub getHumidity As Double
	Dim hum As Double = 0
	If App.matrix.Get("Hum") = Null Then
		' temporary workaround
		For Each value As Map In App.matrix.Values
			hum = value.GetDefault("Hum", 0)
			Exit
		Next
	Else
		hum = App.matrix.GetDefault("Hum", 0)
	End If
	Return hum
End Sub


Private Sub parseColor(color As String, default() As Int) As Int()
	If color = Null Then
		Return default
	End If
	
	Dim res(3) As Int

	If Regex.IsMatch2("#[a-f0-9]+", Regex.CASE_INSENSITIVE, color) Then
		If color.Length = 4 Then
			For i=0 To 2
				res(i) = Bit.ParseInt(color.CharAt(i+1)&color.CharAt(i+1), 16)
			Next
		Else If color.Length = 7 Then
			For i=0 To 2
				res(i) = Bit.ParseInt(color.SubString2(i*2+1, i*2+3), 16)
			Next
		End If
	Else
		Return default
	End If

	Return res
End Sub

Sub App_CustomSetupScreen As String
	Dim sb As StringBuilder
	sb.Initialize
	
	sb.Append($"
		<p class="text-info">When choosing colors, type '0' to use system or application default. Middle button 1 click : show date with month during 5 seconds, 2 clicks shows it during 1 hour</p>
	 "$)
	
	sb.Append("<h4>Time</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "TimeAnimation")
	appendOption(sb, "12hrFormat")
	appendOption(sb, "TimeBlinking")
	
	sb.Append($"</div>"$)
	sb.Append($"<div class="row">"$)
	appendOption(sb, "SecondsStyle")
	appendOption(sb, "SecondsColor")
	appendOption(sb, "SecondsBackgroundColor")
	sb.Append($"</div>"$)


	sb.Append("<h4>Week days</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "ShowWeekday")
	appendOption(sb, "StartsSunday")
	appendOption(sb, "WeekdaysStyle")
	sb.Append($"</div>"$)
	sb.Append($"<div class="row">"$)
	appendOption(sb, "CurrentDayColor")
	appendOption(sb, "WeekdaysColor")
	sb.Append($"</div>"$)
	
	sb.Append("<h4>Temperature Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetTemperature")
	appendOption(sb, "TemperatureIcon")
	appendOption(sb, "TemperatureIconID")
	appendOption(sb, "Fahrenheit")
	sb.Append($"</div>"$)

	sb.Append("<h4>Humidity Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetHumidity")
	appendOption(sb, "HumidityIcon")
	appendOption(sb, "HumidityIconID")
	sb.Append($"</div>"$)
	
	sb.Append("<h4>Calendar Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetCalendar")
	appendOption(sb, "CalendarStyle")
	appendOption(sb, "CalendarIconID")
	sb.Append($"</div>"$)
	sb.Append($"<div class="row">"$)
	appendOption(sb, "CalendarTextColor")
	appendOption(sb, "CalendarHeadColor")
	appendOption(sb, "CalendarBodyColor")
	sb.Append($"</div>"$)
	
	sb.Append("<h4>Custom Icon Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetIcon")
	appendOption(sb, "IconIconID")
	appendOption(sb, "IconXpos")
	appendOption(sb, "IconYpos")
	sb.Append($"</div>"$)
	
	' little hack : use color #000001 as default system color
	sb.append($"
	<script>
    $(function() {
		$('.option-colorpicker').on('changeColor', function(e) {
			var id = $(e.target).attr('aria-describedby')
			$('#'+id).find('.material-icons').css("color",e.target.value)
		}).trigger('changeColor');
        $('.option-colorpicker').colorpicker({
			colorSelectors: {
				'0': '#000001'
			}
		});
		$('.colorpicker').css("z-index", 1080);
    });
	
	</script>
	"$)
	
	Return sb.ToString
End Sub

Private Sub appendOption(sb As StringBuilder, setting As String)

	Dim option As Option = options.Get(setting)
	
	Dim description As String = option.description
	Dim helpText As String = ""
	
	Dim helpPos As Int = description.IndexOf("|")
	If helpPos > 0 Then
		helpText = description.SubString(helpPos+1)
		description = description.SubString2(0,helpPos)
	End If
	
	If option.style = OPTION_BOOL Then
		sb.Append($"
			<div class="col-md-3">
			<label for="${setting.ToLowerCase}">${description}</label>
			<div class="switch">
				<label>
					<input id="${setting.ToLowerCase}" Type="checkbox"${IIf(App.get(setting)," checked","")}/>
					<span class="lever switch-col-blue"></span>
				</label>
			</div>
			<small class="form-text text-muted">${helpText}</small>
		</div>
		"$)
	Else If option.style = OPTION_COLOR Then
		sb.Append($"
			<div class="col-md-3">
				<label For="${setting.ToLowerCase}">${description}</label>
				<div class="input-group">
					<span class="input-group-addon" id="${setting.ToLowerCase}-addon"><i class="material-icons" style="color: 0">color_lens</i></span>
					<div class="form-line">
			        <input id="${setting.ToLowerCase}" type="text" class="option-colorpicker" value="${App.get(setting)}" data-format="hex" aria-describedby="${setting.ToLowerCase}-addon" />
					</div>
				</div>
				<small class="form-text text-muted">${helpText}</small>
			</div>
	"$)
	Else If option.style = OPTION_SELECT Then
		sb.Append($"
		<div class="col-md-3">
			<label For="${setting.ToLowerCase}">${description}</label>
			<select id="${setting.ToLowerCase}" class="form-control">"$)
		Dim choices() As String = option.value
		For Each o As String In choices
			sb.Append($"<option value="${o}"${IIf(o = App.get(setting)," selected","")}>${o}</option>"$)
		Next
		sb.Append($"
			</select>
			<small class="form-text text-muted">${helpText}</small>
		</div>
	"$)
	Else If option.style = OPTION_TEXT Then
		sb.Append($"
			<div class="col-md-3">
				<label For="${setting.ToLowerCase}">${description}</label>
				<div class="input-group">
					<div class="form-line">
			        <input id="${setting.ToLowerCase}" type="text" value="${App.get(setting)}" />
					</div>
				</div>
				<small class="form-text text-muted">${helpText}</small>
			</div>
	"$)
	End If
End Sub

Private Sub newOption(description As String, style As Int, value As Object) As Option
	Dim option As Option
	option.Initialize
	option.description = description
	option.style = style
	option.value = value
	Return option
End Sub

Sub App_buttonPush
	middleButton.push()
End Sub

Sub interpolateColor(pct As Float, color1() As Int, color2() As Int) As Int()
	If color1 = Null Then
		color1 = App.AppColor
	End If
	If color2 = Null Then
		color2 = App.AppColor
	End If
	Return Array As Int(color2(0) + (color1(0) - color2(0)) * pct, color2(1) + (color1(1) - color2(1)) * pct, color2(2) + (color1(2) - color2(2)) * pct)
End Sub

Sub colorTo565(color() As Int) As Short
	Return Bit.Or(Bit.Or(Bit.ShiftLeft(Bit.ShiftRight(color(0), 3), 11),Bit.ShiftLeft(Bit.ShiftRight(color(1), 2), 5)),Bit.ShiftRight(color(2), 3))
End Sub

Sub makeK2000Animation(size As Int, nbTrails As Int, foregroundColor() As Int, backgroundColor() As Int) As List
	Dim animCache As List
	animCache.Initialize
	For pos = 0 To size - 1
		Dim leds(size) As Short
		Dim secondsBackgroundColor565 As Short = colorTo565(backgroundColor)
		For i = 0 To size - 1
			leds(i) = secondsBackgroundColor565
		Next
		For i = -nbTrails To 0
			Dim x As Int
			x = Abs(i + pos)
			Dim f As Float = (nbTrails + i)  / nbTrails
			leds(x) = colorTo565(interpolateColor(f, foregroundColor, backgroundColor))
		Next
		animCache.Add(leds)
	Next
	For pos = size To size * 2 - 1
		Dim a() As Short = animCache.Get(pos - size)
		Dim mirror(size) As Short
		For i = 0 To size - 1
			mirror(i) = a((size-1) - i)
		Next
		animCache.Add(mirror)
	Next
	
	Return animCache
End Sub
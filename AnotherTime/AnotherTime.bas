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
	Dim temperatureIcon As Boolean
	Dim calendarIcon As Boolean
	Dim scrollObj As Scroll
	Dim disableBlinking As Boolean
	Dim showSeconds As Boolean
	Dim showWeekDay As Boolean
	Dim startsSunday As Boolean
	Dim ampmFormat As Boolean
	Dim niceDate As Boolean
	Dim Widgets As List
	Dim fahrenheit As Boolean
	Dim settings As Map
	Dim OPTION_BOOL As Int = 0
	Dim OPTION_COLOR As Int = 1
	Type Option (description As String, style As Int, value As Object)
	Dim options As Map
End Sub

'Initializes the object. You can NOT add parameters to this method!
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="AnotherTime"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Shows time with temperature and date, maybe more..."
	
	App.Author = "Toinux"
	
	App.CoverIcon = 1742
	
	App.icons = Array As Int (1738, 1740)
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $""$
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65

	options.Initialize
	options.Put("ShowSeconds", newOption("Show seconds|Display seconds as a progress bar", OPTION_BOOL, True))
	options.Put("ShowWeekday", newOption("Show Week|Display week day as 7 dots", OPTION_BOOL, True))
	options.Put("12hrFormat", newOption("Switch from 24hr to 12h timeformat", OPTION_BOOL, False))
	options.Put("DisableBlinking", newOption("Disable the colon blinking", OPTION_BOOL, False))
	options.Put("NiceDate", newOption("Nice Date|Display the date as a nice calendar if calendar icon is disabled", OPTION_BOOL, True))
	options.Put("StartsSunday", newOption("Week begins on sunday", OPTION_BOOL, False))
	options.Put("WeekdaysColor", newOption("Color of the other days highlight", OPTION_COLOR, "#555555"))
	options.Put("CurrentDayColor", newOption("Color of the current day highlight", OPTION_COLOR, "255,255,255"))
	options.Put("Fahrenheit", newOption("Display temperature as Fahrenheit", OPTION_BOOL, False))
	options.Put("TemperatureIcon", newOption("Temperature icon|Won't be displayed if temperature &gt; 100°", OPTION_BOOL, True))
	options.Put("CalendarIcon", newOption("Calendar icon", OPTION_BOOL, True))
	options.Put("WidgetCalendar", newOption("Enable calendar", OPTION_BOOL, True))
	options.Put("WidgetTemperature", newOption($"Enable temperature|<a target="_blank" href="https://awtrixdocs.blueforcer.de/#/en-en/hardware?id=temperature-and-humidity-sensor-optional">Temperature sensor</a> required"$, OPTION_BOOL, True))
	

	settings.Initialize
	For Each option In options.Keys
		settings.Put(option, options.Get(option).As(Option).value)
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
	
	Widgets.Initialize
	If (App.get("WidgetCalendar")) Then
		Widgets.Add("calendar")
	End If
	If (App.get("WidgetTemperature")) Then
		Widgets.Add("temperature")
	End If

	scrollObj.Initialize(App.duration, Widgets.Size)
	disableBlinking = App.get("DisableBlinking")
	showSeconds = App.get("ShowSeconds")
	showWeekDay = App.get("ShowWeekday")
	startsSunday = App.get("StartsSunday")
	ampmFormat = App.get("12hrFormat")
	temperatureIcon = App.get("TemperatureIcon")
	calendarIcon = App.get("CalendarIcon")
	niceDate = App.get("NiceDate")
	fahrenheit = App.get("Fahrenheit")
	
	WeekdaysColor = parseColor(App.get("WeekdaysColor"), Array As Int(80,80,80))
	CurrentDayColor = parseColor(App.get("CurrentDayColor"), Null)
	
End Sub


Sub App_genFrame
	DateTime.TimeFormat = IIf(ampmFormat,"KK", "HH")&IIf(Not(disableBlinking) And DateTime.GetSecond(DateTime.Now) Mod 2 > 0, " ", ":")&"mm"
	
	Dim timeString As String= DateTime.Time(DateTime.Now)

		App.drawText(timeString,IIf(Widgets.Size > 0, -1, 6), 1,Null)


	If Widgets.Size = 1 Then
		CallSub2(Me, "widget_"&Widgets.Get(0), 0)
	Else If Widgets.Size > 1 Then
		For i=0 To Widgets.Size-1
			CallSub2(Me, "widget_"&Widgets.Get(i), scrollObj.getOffset(i))
		Next
		scrollObj.update
	End If	

	If showSeconds Then
		drawSeconds
	End If
	
	If showWeekDay Then
		drawWeek
	End If

End Sub

Private Sub drawSeconds
	
	' Todo : customize
	Dim secondsBackgroundColor() As Int = Array As Int(80,80,80)
	
	
	Dim second As Int = DateTime.GetSecond(DateTime.Now)
	Dim secondsProgressSize As Int = 17
	If Not(secondsBackgroundColor = Null) Then
		App.drawLine(0, 7, secondsProgressSize - 1, 7, secondsBackgroundColor)
	End If
	If second > 0 Then
		App.drawLine(0, 7, Floor(second * secondsProgressSize / 60), 7, CurrentDayColor)
	End If
	
End Sub

Private Sub drawWeek
	Dim weekday As Int = DateTime.GetDayOfWeek(DateTime.Now)
	If Not(startsSunday) Then
		weekday=weekday-1
		If (weekday = 0) Then
			weekday = 7
		End If
	End If
	
	Dim xpos As Int = 17
	
	App.drawLine(xpos,7,31,7,Array As Int(0,0,0))
	
	For i=0 To 6
		If i=weekday-1 Then
			App.drawPixel(xpos+i*2+1,7,CurrentDayColor)
		Else
			App.drawPixel(xpos+i*2+1,7,WeekdaysColor)
		End If
	Next
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
		App.drawBMP(IIf(tempNegative, IIf(temp > 9, xpos-1,xpos-3), xpos),offset,App.getIcon(1738),8,8)
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

Private Sub widget_calendar(offset As Int)
	If outboundOffset(offset) Then
		Return
	End If

	Dim currentDay As Int = DateTime.GetDayOfMonth(DateTime.Now)
	
	' icon position
	Dim ipos As Int = 19
	' text position
	Dim tpos As Int = IIf(calendarIcon, 24, IIf(niceDate, 23, 24))
	
	If (currentDay < 10) Then
		ipos = 23
		tpos = IIf(calendarIcon, 28, IIf(niceDate, 25, 28))
	End If
	
	If calendarIcon Then
		App.drawBMP(ipos,offset,App.getIcon(1740),8,8)
	Else If niceDate Then
		Dim CalendarColor() As Int = Array As Int(0,0,0)
		drawCalendarBackground(offset)
	End If
	
	App.drawText(currentDay, tpos, 1+offset, CalendarColor)
End Sub

Private Sub drawCalendarBackground(offset As Int)
	Dim CalendarColorTop() As Int = Array As Int(128,128,255)
	Dim CalendarColorBottom() As Int = Array As Int(255,255,255)

	For i=0 To 1
		App.drawLine(23, offset+i, 31, offset+i, CalendarColorTop)
	Next
	For i=2 To 6
		App.drawLine(23, offset+i, 31, offset+i, CalendarColorBottom)
	Next

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
	Else if color.Length = 11 And Regex.IsMatch("\d{3},\d{3},\d{3}", color) Then
		For i=0 To 2
			res(i) = color.SubString2(i*4, (i+1)*4-1).As(Int)
			If res(i) > 255 Then
				Return default
			End If
		Next
	Else
		Return default
	End If

	Return res
End Sub

Sub App_CustomSetupScreen As String
	Dim sb As StringBuilder
	sb.Initialize

'	options.Put("WeekdaysColor", newOption("Color of the other days highlight", OPTION_COLOR, "#555555"))
'	options.Put("CurrentDayColor", newOption("Color of the current day highlight", OPTION_COLOR, "255,255,255"))
	
	sb.Append("<h4>Time</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "ShowSeconds")
	appendOption(sb, "12hrFormat")
	appendOption(sb, "DisableBlinking")
	sb.Append($"</div>"$)


	sb.Append("<h4>Week days</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "ShowWeekday")
	appendOption(sb, "StartsSunday")
	sb.Append($"</div>"$)

	
	sb.Append("<h4>Temperature Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetTemperature")
	appendOption(sb, "TemperatureIcon")
	appendOption(sb, "Fahrenheit")
	sb.Append($"</div>"$)
	
	sb.Append("<h4>Calendar Widget</h4>")
	sb.Append($"<div class="row">"$)
	appendOption(sb, "WidgetCalendar")
	appendOption(sb, "CalendarIcon")
	appendOption(sb, "NiceDate")
	sb.Append($"</div>"$)
	
	sb.append($"
	<script>
    $(function() {
        $('.option-colorpicker').colorpicker();
		$('.colorpicker').css("z-index", 1080)
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
				<input id="${setting.ToLowerCase}" Type="text" class="form-control form-line option-colorpicker" value="${App.get(setting)}" data-format="hex" />
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
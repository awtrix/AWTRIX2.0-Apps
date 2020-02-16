B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.5
@EndOfDesignText@
Sub Class_Globals
	Private const pi=3.14159 As Double
	Private degs=180.0/pi As Double
	Private rads=pi/180.0 As Double
	Private L,g,daylen  As Double
	Public latitude,longitude  As Double
	Public tzone As Byte
	Private const SunDia = 0.53  As Double
	Public sunrisetime,sunsettime As Int
	Private AirRefr = 34.0/60.0 As Double 'athmospheric refraction degrees
	Dim SunTime As String
	Dim convert12Hr As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(lat As Double,lon As Double,convert As Boolean)
	latitude=lat
	longitude=lon
	convert12Hr=convert
End Sub

'  Get the days To J2000
'  h Is UT in decimal hours
'  FNday only works between 1901 To 2099 - see Meeus chapter 7
Sub FNday (y As Int, m As Int, d As Int, h As Float) As Double
	Dim luku = - 7 * (y + (m + 9)/12)/4 + 275*m/9 + d As Long
	'' Type casting necessary on PC DOS And TClite To avoid overflow
	luku=y*367 +luku
	Return luku - 730531.5 + h/24.0
End Sub

'   the function below returns an angle in the range
'   0 To 2*pi
Sub  FNrange (x As Double) As Double
	Dim b = 0.5*x / pi As Double
	Dim bl=b As Long
	Dim a = 2.0*pi * (b - (bl)) As Double
	If (a < 0) Then a = 2.0*pi + a
	Return a
End Sub

'Calculating the hourangle
Sub f0(lat As Double, declin As Double) As Double
	Dim fo,dfo As Double
	'Correction: different sign at S HS
	dfo = rads*(0.5*SunDia + AirRefr)
	If (lat < 0.0) Then dfo = -dfo
	fo = Tan(declin + dfo) * Tan(lat*rads)
	If (fo>0.99999) Then fo=1.0 'To avoid overflow
	fo = ASin(fo) + pi/2.0
	Return fo
End Sub

'Calculating the hourangle For twilight times
'
Sub f1(lat As Double , declin As Double) As Double
	Dim fi,df1 As Double
	'Correction: different sign at S HS
	df1 = rads * 6.0
	If (lat < 0.0) Then df1 = -df1
	fi = Tan(declin + df1) * Tan(lat*rads)
	If (fi>0.99999) Then fi=1.0 'To avoid overflow
	fi = ASin(fi) + pi/2.0
	Return fi
End Sub

'Find the ecliptic longitude of the Sun
Sub  FNsun (d As Double) As Double
	'mean longitude of the Sun
	L = FNrange(280.461 * rads + .9856474 * rads * d)
	'mean anomaly of the Sun
	g = FNrange(357.528 * rads + .9856003 * rads * d)
	'Ecliptic longitude of the Sun
	Return FNrange(L + 1.915 * rads * Sin(g) + .02 * rads * Sin(2 * g))
End Sub

' Display decimal hours in hours And minutes
Sub showhrmn( dhr As Double) As String
	Dim hr,mn As Int
	hr= dhr
	mn = (dhr -  hr)*60
	If convert12Hr Then
		Return convertTo12hr(hr,mn)
	Else
		Return (NumberFormat(hr,2,0) & ":" & NumberFormat(mn,2,0))
	End If
End Sub

Sub doCalculation
	Dim y,h,day,m,latit,longit  As Double
	Dim d,lambda  As Double
	Dim obliq,alpha,delta,LL,equation,ha,hb,twx As Double
	Dim altmax,riset,settm As Double

	'read system date And extract the year
	latit = latitude
	longit = longitude

	tzone=DateTime.TimeZoneOffset
	h=DateTime.GetHour(DateTime.Now)
	m=DateTime.GetMonth(DateTime.Now)
	day=DateTime.GetDayOfMonth(DateTime.Now)
	y=DateTime.GetYear(DateTime.Now)
	d = FNday(y, m, day, h)

	'Use FNsun To find the ecliptic longitude of the Sun
	lambda = FNsun(d)

	'Obliquity of the ecliptic
	obliq = 23.439 * rads - .0000004 * rads * d
	
	'Find the RA And DEC of the Sun
	alpha = ATan2(Cos(obliq) * Sin(lambda), Cos(lambda))
	delta = ASin(Sin(obliq) * Sin(lambda))
	
	'Find the Equation of Time in minutes
	LL = L - alpha
	If (L < pi) Then LL = 2.0*pi +LL
	equation = 1440.0 * (1.0 - LL / pi/2.0)
	ha = f0(latit,delta)
	hb = f1(latit,delta)
	twx = hb - ha     'length of twilight in radians
	twx = 12.0*twx/pi 'length of twilight in hours
	'Conversion of angle To hours And minutes
	daylen = degs*ha/7.5
	If (daylen<0.0001) Then  daylen = 0.0
	'arctic winter
	riset = 12.0 - 12.0 * ha/pi + tzone - longit/15.0 + equation/60.0
	settm = 12.0 + 12.0 * ha/pi + tzone - longit/15.0 + equation/60.0
	'noont = riset + 12.0 * ha/pi
	altmax = 90.0 + delta * degs - latit
	'Correction For S HS
	'To express altitude As degrees from the N horizon
	If (latit < delta * degs) Then altmax = 180.0 - altmax
	
	'//twam = riset - twx;    // morning twilight begin
	'//twpm = settm + twx;    // evening twilight End
	
	If (riset > 24.0) Then riset= riset-24.0
	If (settm > 24.0) Then settm= settm-24.0

	SunTime = showhrmn(riset) & "/" & showhrmn(settm)
End Sub

Sub convertTo12hr(hours As Int, minutes As Int) As String
	Dim meridian As String
	If hours < 12 Then meridian = " AM"
	If hours = 12 Then meridian = " PM"
	If hours = 0 Then
		hours = 12
		meridian = " AM"
	End If

	If hours > 12 Then
		hours = hours - 12
		meridian = " PM"
	End If
	Return  NumberFormat(hours, 2, 0) & ":" & NumberFormat(minutes, 2, 0) & meridian
End Sub

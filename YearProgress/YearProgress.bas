B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim percentDone As Double
	
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "YearProgress"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Displays the progress of the year in percent.
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 916
	

	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("time", "date")
	
	'How many downloadhandlers should be generated
	App.downloads = 0
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(916)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = False
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	Dim savedFormat As String= DateTime.DateFormat
	DateTime.DateFormat = "dd/MM/yyyy"
	Dim currentYear As String = DateTime.GetYear(DateTime.Now)
	Dim nextYear As String= DateTime.GetYear(DateTime.Now)+1
	Dim TargetTime As Long = DateTime.DateParse("01/01/" & nextYear)
	Dim StartTime As Long = DateTime.DateParse("01/01/" & currentYear)
	percentDone  = NumberFormat(((DateTime.Now-StartTime)/(TargetTime-StartTime))*100,0,2)
	DateTime.DateFormat=savedFormat
End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	



'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(percentDone&"%" ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(916),8,8)
End Sub
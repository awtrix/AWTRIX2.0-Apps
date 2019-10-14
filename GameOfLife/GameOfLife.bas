B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX

	Dim gameOfLifeStatus(32,8) As Boolean
	Dim numCells As Int= 0
	Dim prevCells As Int= 0
	Dim autoResetCount As Int = 0

	Dim firsttime As Boolean=True
	Dim ColorOld() As Int= Array As Int(50,50,50)
	Dim ColorNew() As Int= Array As Int(0,255,0)
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="GameOfLife"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description=$"Conway's Game of Life"$
	
	App.Author="Blueforcer"
	
	App.CoverIcon=712
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
	<b>Speed:</b> Ticks in ms. The bigger the slower<br/>
	<b>Seeds:</b> Value used to initialize the random number generator for the first cells.<br/>
	<b>ColorOld:</b> Color for old cells (r,g,b)<br/>
	<b>ColorNew:</b> Color for new cells (r,g,b)<br/>
	<b>AutoReset:</b> Autoreset after X ticks <br/>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=0
	
	'IconIDs from AWTRIXER.
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
		
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("AutoReset":10,"Speed":500,"Seeds":65,"ColorOld":"50,50,50","ColorNew":"0,255,0")
	
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

Sub App_Started
	firsttime=True
	Dim old() As String=Regex.Split(",",App.Get("ColorOld"))
	ColorOld(0)=old(0)
	ColorOld(1)=old(1)
	ColorOld(2)=old(2)
	Dim new() As String=Regex.Split(",",App.Get("ColorNew"))
	ColorNew(0)=new(0)
	ColorNew(1)=new(1)
	ColorNew(2)=new(2)
	App.Tick=App.get("Speed")
End Sub

Sub App_genFrame
	Dim x,y As Int
	If firsttime Then
		Do While (numCells < App.get("Seeds"))
			x = Rnd(0, 32)
			y = Rnd(0, 8)
			If Not(gameOfLifeStatus(x,y)) Then
				gameOfLifeStatus(x,y) = True
				App.drawPixel(x,y,ColorNew)
				numCells = numCells+1
			End If
		Loop
		firsttime=False
	Else
		Dim x,y As Int
		Dim gameOfLifeNew(32,8) As Boolean
		numCells = 0
		For x=0 To 31
			For y=0 To 7
				Dim  neighbours As Int = countNeighbours(x, y)
				Dim living As Boolean = isAlive(x, y)

				If (living) Then
					If (neighbours = 2 Or neighbours = 3) Then
						App.drawPixel(x,y,ColorOld)
						gameOfLifeNew(x,y) = True
						numCells=numCells+1
					End If
				Else
					If (neighbours = 3) Then
						App.drawPixel(x,y,ColorNew)
						gameOfLifeNew(x,y) = True
						numCells=numCells+1
					End If
				End If
   
			Next
		Next

		If (numCells = prevCells) Then
			autoResetCount=autoResetCount+1
		End If
	
		If (autoResetCount = App.get("AutoReset")) Then
			numCells = 0
			autoResetCount = 0
		End If
	
		prevCells = numCells
		If (numCells == 0) Then
			For x=0 To 31
				For y=0 To 7
					gameOfLifeStatus(x,y) = False
				Next
			Next
	
			Do While (numCells < App.get("Seeds"))
				x = Rnd(0, 32)
				y = Rnd(0, 8)
				If Not(gameOfLifeStatus(x,y)) Then
					gameOfLifeStatus(x,y) = True
					App.drawPixel(x,y,ColorNew)
					numCells = numCells+1
				End If
			Loop
		Else
			For x=0 To 31
				For y=0 To 7
					gameOfLifeStatus(x,y) = gameOfLifeNew(x,y)
				Next
			Next
    
		End If
	End If
End Sub

Sub countNeighbours(x As Int, y As Int) As Int
	Dim neighbours As Int = 0
	If (isAlive(x-1, y-1)) Then
		neighbours=neighbours+1
	End If
	If (isAlive(x-1, y)) Then
		neighbours=neighbours+1
	End If
	If (isAlive(x-1, y+1))Then
		neighbours=neighbours+1
	End If
	If (isAlive(x, y-1))Then
		neighbours=neighbours+1
	End If
	If (isAlive(x, y+1)) Then
		neighbours=neighbours+1
	End If
	If (isAlive(x+1, y-1)) Then
		neighbours=neighbours+1
	End If
	If (isAlive(x+1, y)) Then
		neighbours=neighbours+1
	End If
	If (isAlive(x+1, y+1)) Then
		neighbours=neighbours+1
	End If
	Return neighbours
End Sub

Sub isAlive(x As Int,  y As Int) As Boolean
	If (x < 0) Then
		x= x + 32
	End If
	If (x >= 32) Then
		x= x - 32
	End If
	If (y < 0) Then
		y=y + 8
	End If
	If (y >= 8)Then
		y= y - 8
	End If
	Return gameOfLifeStatus(x,y)
End Sub


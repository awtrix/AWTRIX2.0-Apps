B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

'Please note, awtrix coordinate system is a bit different due the GFX Libary and Matrix structure

'(0,0) xxxxxxxxxxxxxxxxxxxxx
'	   xxxxxxxxxxxxxxxxxxxxx
'      xxxxxxxxxxxxxxxxxxxxx
'      xxxxxxxxxxxxxxxxxxxxx (31,7)


Sub Class_Globals
	Dim App As AWTRIX
	
	Private started As Boolean
	Private jumpsound,coinsound,winsound,loosesound As Boolean
	Private isJumping, inAir As Boolean
	Private runDir As Int
	Private jumpheight As Int
	Private start As Boolean =True
	Private stopSound As Boolean
	Private points As Int
	Private lifes As Int = 3
	Private currentLevel As Int = 1
	Private levels As List
	Private displaytext As String
	Private texttimer As Timer
	Private textDisplayed As Boolean
	Private textcolor() As Int
	Private frame(256) As Short
	Private mapMusic As Int
	
	Type PlayerPosition (x As Int, y As Int, godMode As Boolean)
	Private player As PlayerPosition
	
	Type coin(x As Int,y As Int,color() As Int,points As Int, isSuperFood As Boolean)
	
	Type Target(x As Int,y As Int)
	Private LevelGoal As Target
	
	Private Blocks As List
	Private Enemies As List
	Private coins As List
	
	Private godMode As Timer
	Private GodMusic As Boolean
	Private godBlink As Boolean
	Private maxJumpHeight As Int = 3
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
	App.name = "SuperAwtrix"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Play a Jump'n'Run Game on your AWTRIX with custom Maps.
	"$
	
	App.howToPlay= $"
	Press D-Pad left or right to move.<br>
	Press A to jump.<br>
	Collect the yellow coins and reach the level goal at the end.<br>
	Avoid the red enemies. You can only kill them with the blue SuperFood.<br>
	Help to create new awesome maps at <a href="https://forum.blueforcer.de/d/655-superawtrix" target="_blank">the Forum</a>
	"$
	
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 1246
	
	'needed Settings for this App wich can be configurate from user via webinterface. Dont use spaces here!
	App.settings = CreateMap("Sounds":True)
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>Sound:</b>activate the sound output<br/>
	<br>
	You can create your own maps or download new ones from the community.
	<a href="https://forum.blueforcer.de/d/655-superawtrix" target="_blank">Visit Forum</a>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("Game")
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 70
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = True
	
	'Hide this app from apploop
	App.Hidden = True

	'Create MapFolder
	File.MakeDir(File.DirApp,"Apps/SuperAwtrix")
	
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	texttimer.Initialize("text",1000)
	godMode.Initialize("godModeEnd",7200)
	levels.Initialize
	Enemies.Initialize
	player.Initialize
	Blocks.Initialize
	coins.Initialize
	If loadLevel(1) Then
		startText("LEVEL " & currentLevel &". Go!",1500,Array As Int (0,255,0))
	Else
		startText("LEVEL 1 dont exist",1500,Array As Int (255,0,0))
	End If
End Sub
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	For Each enemy As Enemy In Enemies
		enemy.stop 'stops every timer in every enemy object when App closes
	Next
	started=False
End Sub

'If you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of the controller, dir is true if it is pressed, false if its released
Sub App_controllerButton(button As Int,dir As Boolean)

	Select button
		Case 0
			If dir And Not(inAir) And Not(textDisplayed) Then
				isJumping=True
				jumpsound=True
			End If
		Case 14
			If dir Then
				runDir=4
			Else
				runDir=5
			End If
		Case 15
			If dir Then
				runDir=6
			Else
				runDir=5
			End If
	End Select
End Sub

'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	DoSounds
	If textDisplayed Then
		App.genSimpleFrame(displaytext,0,False,textcolor,False)
	Else
		'Clear Frame or fill background blue in godMode
		If player.godMode Then
			For i=0 To frame.Length-1
				frame(i)=022
			Next
		Else
			For i=0 To frame.Length-1
				frame(i)=0
			Next
		End If
		drawBlocks
		drawCoins
		drawGoal
		drawEnemies
		moveWorld
		drawPlayer
		
		App.drawBMP(0,0,frame,32,8) 'Show Frame
		App.drawPixel(-1,-1,Array As Int(Rnd(0,255),Rnd(0,255),Rnd(0,255))) 'Show random hidden pixel to disable AWTRIXs Frameskip
	End If
End Sub

Sub win
	godModeEnd_tick
	winsound=True
	currentLevel=currentLevel+1
	Enemies.Initialize
	player.Initialize
	Blocks.Initialize
	coins.Initialize
	start=True
	If loadLevel(currentLevel) Then
		startText("LEVEL " & currentLevel &". Go!",1500,Array As Int (0,255,0))
	Else
		currentLevel=1
		loadLevel(currentLevel)
		startText("Finish. You have " & points & " points",3000,Array As Int (0,0,255))
		points=0
	End If
	stopSound=True
	godModeEnd_tick
End Sub

Sub failed
	godModeEnd_tick
	loosesound=True
	Enemies.Initialize
	player.Initialize
	Blocks.Initialize
	coins.Initialize
	start=True
	lifes=lifes-1
	If lifes<0 Then
		currentLevel=1
		loadLevel(currentLevel)
		startText("Youre Dead. You have " & points & " points. Reset",20000,Array As Int (255,0,0))
		points=0
		lifes=3
	Else
		startText(lifes & " lifes left",5500,Array As Int (255,0,0))
		loadLevel(currentLevel)
	End If
	stopSound=True
End Sub

Sub drawPlayer
	'Jumping
	If isJumping Then
		If jumpheight<maxJumpHeight Then
			If Not(isCollide(player.x,player.y-1)) Then
				player.y=player.y-1
				inAir=True
				jumpheight=jumpheight+1
			Else
				
				jumpheight=0
				isJumping=False
			End If
		Else
			isJumping=False
			jumpheight=0
		End If
	Else
	
		'Gravity
		If Not(isCollide(player.x,player.y+1)) Then
			player.y=player.y+1
		Else
			inAir=False
		End If
	End If
	
	'Movement
	Select runDir
		Case 4
			If Not(isCollide(player.x-1,player.y)) Then
				player.x = player.x-1
			End If
			
		Case 6
			If Not(isCollide(player.x+1,player.y)) Then
				player.x = player.x+1
			End If
	End Select
	
	
	If player.godMode Then 'let player blink while in godmode
		If godBlink Then
			godBlink=Not(godBlink)
			drawPixel(player.x,player.y,Array As Int(255,255,0))
		Else
			godBlink=Not(godBlink)
			drawPixel(player.x,player.y,Array As Int(0,255,255))
		End If
	Else
		drawPixel(player.x,player.y,Array As Int(255,255,255))
	End If
	
	checkCoins
	checkHit
	checkWin
End Sub

'Draw every single pixel into a complete 32x8 BMP to avoid sending massiv amount of drawing commands to the controller.
Sub drawPixel(x As Int, y As Int,color() As Int)
	If x>-1 And x<32 And y>-1 And y<8 Then
		'Calculate RGB585 from RGB888
		Dim NewBlue As Int = Bit.And(Bit.ShiftRight(color(2), 3), 0x1f)
		Dim NewGreen As Int  = Bit.ShiftLeft(Bit.And(Bit.ShiftRight(color(1), 2), 0x3f), 5)
		Dim NewRed As Int  = Bit.ShiftLeft(Bit.And(Bit.ShiftRight(color(0), 3), 0x1f), 11)
		frame(x + 32 * y) =  Bit.Or(Bit.Or(NewRed, NewGreen), NewBlue)
	End If
End Sub

'Checks if the player collides with an enemy
Sub checkHit
	For i=0 To Enemies.Size-1
		Dim e As Enemy = Enemies.Get(i)
		If player.x = e.xpos And player.y =e.ypos Then
			If player.godMode Then
				Enemies.RemoveAt(i)
				Return
			Else
				failed
				Return
			End If
		End If
	Next
	If player.y>7 Then
		failed
	End If
End Sub

'Checks if the player passes the goal
Sub checkWin
	If player.x>LevelGoal.x Then
		win
	End If
End Sub

'Checks if the player touch a coin
Sub checkCoins
	For i=0 To coins.Size-1
		Dim c As coin = coins.Get(i)
		If player.x = c.x And player.y =c.y Then
			coins.RemoveAt(i)
			If c.isSuperFood Then
				player.godMode=True
				godMode.Enabled=False
				godMode.Enabled=True
				maxJumpHeight=4
				GodMusic=True
			Else
				points=points+c.points
				coinsound=True
			End If
			Return
		End If
	Next
End Sub

'Play sounds once and set back the flag
Sub DoSounds
	
	If App.get("Sounds")=False Then Return
	
	If stopSound Then
		App.stopSound
		stopSound=False
	End If
	
	If Not(started) Then
		App.LoopSound(mapMusic)
		started=True
	End If
	
	If GodMusic Then
		App.AdvertiseSound(134)
		App.AdvertiseSound(134)
		GodMusic=False
	End If
	
	If jumpsound And Not(player.godMode) Then
		App.AdvertiseSound(130)
		jumpsound=False
	End If
	
	If coinsound And Not(player.godMode) Then
		App.AdvertiseSound(131)
		coinsound=False
	End If
	
	If loosesound Then
		App.AdvertiseSound(133)
		loosesound=False
	End If
	
	If winsound Then
		App.AdvertiseSound(132)
		winsound=False
	End If
	
End Sub

'draw all blocks wich are in viewing range
Sub drawBlocks
	For Each b As Block In Blocks
		If b.x>-1 And b.x<32 Then
			drawPixel(b.x,b.y,b.color)
		End If
	Next
End Sub

'draw all coins wich are in viewing range
Sub drawCoins
	For Each c As coin In coins
		If c.x>-1 And c.x<32 Then
			drawPixel(c.x,c.y,c.color)
		End If
	Next
End Sub

'draw all enemies wich are in viewing range
Sub drawEnemies
	For Each e1 As Enemy In Enemies
		If e1.xpos>-1 And e1.xpos<32 Then
			drawPixel(e1.xpos,e1.ypos,e1.color)
		End If
	Next
End Sub

'draw goal when in viewing range
Sub drawGoal
	If LevelGoal.x>-1 And LevelGoal.x<32 Then
		drawPixel(LevelGoal.x,LevelGoal.y,Array As Int(255,255,255))
		drawPixel(LevelGoal.x,LevelGoal.y-1,Array As Int(255,255,255))
		drawPixel(LevelGoal.x,LevelGoal.y-2,Array As Int(255,255,255))
		drawPixel(LevelGoal.x+1,LevelGoal.y-1,Array As Int(255,0,0))
		drawPixel(LevelGoal.x+1,LevelGoal.y-2,Array As Int(255,0,0))
	End If
End Sub

'moves everything when the player moves to the left or right screen
Sub moveWorld
	If player.x>20 Then
		For Each b As Block In Blocks
			b.x=b.x-1
		Next
		For Each c As coin In coins
			c.x=c.x-1
		Next
		
		For Each e As Enemy In Enemies
			e.xpos=e.xpos-1
		Next
		LevelGoal.x=LevelGoal.x-1
		player.x=player.x-1
		start=False
	else if player.x<10 And start = False Then
		For Each b As Block In Blocks
			b.x=b.x+1
		Next
		For Each c As coin In coins
			c.x=c.x+1
		Next
		
		For Each e As Enemy In Enemies
			e.xpos=e.xpos+1
		Next
		
		LevelGoal.x=LevelGoal.x+1

		player.x=player.x+1
	End If
End Sub


'check wether given coordinates will collide to any block, remove it from the list if its breakable after hits
Sub isCollide(x As Int, y As Int) As Boolean
	For i=0 To Blocks.Size-1
		Dim b As Block=Blocks.Get(i)
		If x = b.x Then
			If b.y=y Then
				If isJumping Then b.hit
				If b.destroyed Then Blocks.RemoveAt(i)
				Return True
			End If
		End If
	Next
	Return False
End Sub

'Reads the mapfile and build the map
Sub loadLevel(lvl As Int) As Boolean
	If File.Exists(File.DirApp&"/Apps/SuperAwtrix","level-"&lvl&".txt") Then
		Dim map As Map
		map.Initialize
		Dim Reader As TextReader
		Reader.Initialize(File.OpenInput(File.DirApp&"/Apps/SuperAwtrix", "level-"&lvl&".txt"))
		Dim line As String
		line = Reader.ReadLine
		Dim row As Int = 0
		coins.Clear
		Enemies.Clear
		Blocks.Clear
		Do While line <> Null
			
			'Get MapMusic
			If row=1 Then
				If line.StartsWith("# Sound:") Then
					mapMusic=line.SubString(8)
				Else
					mapMusic=130
				End If
			End If
				
			If row>1 Then
				'Find Coin
				Dim Matcher1 As Matcher
				Matcher1 = Regex.Matcher("[O]", line)
				Do While Matcher1.Find
					Dim c As coin
					c.x=Matcher1.GetStart(0)
					c.y=row-2
					c.points=1
					c.color=Array As Int(255,255,0)
					coins.Add(c)
				Loop
				
				'Find SuperFood
				Dim Matcher1 As Matcher
				Matcher1 = Regex.Matcher("[S]", line)
				Do While Matcher1.Find
					Dim c As coin
					c.x=Matcher1.GetStart(0)
					c.y=row-2
					c.isSuperFood=True
					c.points=1
					c.color=Array As Int(0,0,255)
					coins.Add(c)
				Loop
					
				'Find Blocks
				Matcher1 = Regex.Matcher("[#]", line)
				Do While Matcher1.Find
					Dim b As Block
					b.Initialize
					b.x=Matcher1.GetStart(0)
					b.y=row-2
					b.color=Array As Int(160,82,45)
					Blocks.Add(b)
				Loop
		
				'Find Ground (Also a block with different color)
				Matcher1 = Regex.Matcher("[G]", line)
				Do While Matcher1.Find
					Dim ground As Block
					ground.Initialize
					ground.x=Matcher1.GetStart(0)
					ground.y=row-2
					ground.color=Array As Int(0,145,0)
					Blocks.Add(ground)
				Loop
			
				'Find Goal
				Matcher1 = Regex.Matcher("[T]", line)
				Do While Matcher1.Find
					Dim t As Target
					t.x=Matcher1.GetStart(0)
					t.y=row-2
					LevelGoal=t
				Loop
			
				'Find breakable block
				Matcher1 = Regex.Matcher("[+]", line)
				Do While Matcher1.Find
					Dim b As Block
					b.Initialize
					b.x=Matcher1.GetStart(0)
					b.y=row-2
					b.color=Array As Int(230,0,120)
					b.breakable=True
					Blocks.Add(b)
				Loop
			
				'Find enemy start walking to the right
				Matcher1 = Regex.Matcher("[>]", line)
				Do While Matcher1.Find
					Dim e As Enemy
					Dim s As Object
					s = line.SubString2(Matcher1.GetStart(0)+1,Matcher1.GetStart(0)+2)
					If IsNumber(s) Then
						e.Initialize(Matcher1.GetStart(0),row-2,True,s,Blocks)
					Else
						e.Initialize(Matcher1.GetStart(0),row-2,True,1,Blocks)
					End If
					Enemies.Add(e)
				Loop
		
				'Find enemy start walking to the left
				Matcher1 = Regex.Matcher("[<]", line)
				Do While Matcher1.Find
					Dim e As Enemy
					s = line.SubString2(Matcher1.GetStart(0)+1,Matcher1.GetStart(0)+2)
					If IsNumber(s) Then
						e.Initialize(Matcher1.GetStart(0),row-2,True,s,Blocks)
					Else
						e.Initialize(Matcher1.GetStart(0),row-2,True,1,Blocks)
					End If
					Enemies.Add(e)
				Loop
				
			End If
			row=row+1
			line = Reader.ReadLine
		Loop
		Reader.Close
		For Each enemy As Enemy In Enemies
			enemy.blocklist=Blocks
		Next
		Return True
	Else
		Return False
	End If
End Sub

Sub startText(text As String,duration As Int,color() As Int)
	textDisplayed=True
	App.resetScrollposition
	textcolor=color
	texttimer.Interval=duration
	displaytext=text
End Sub

Sub App_ScrollTextFinish
	For Each enemy As Enemy In Enemies
		enemy.reset
	Next
	textDisplayed=False
End Sub

Sub godModeEnd_tick
	jumpsound=False
	coinsound=False
	godBlink=False
	maxJumpHeight=3
	godMode.Enabled=False
	player.godMode=False
	started=False
End Sub
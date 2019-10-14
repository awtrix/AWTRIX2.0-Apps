B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX

	Dim colorLaser() As Int= Array As Int(255,0,0)
	Dim tape As String = "SpaceATTACK!   - Press fire to start "
	Dim gameStart As Boolean = False

	'Ship And laser position variables
	Dim shipx As Byte = 0
	Dim shipy As Short = 0
	Dim lasx As Short
	Dim lasy As Short
	'Lives counter
	Dim lives As Short = 5
	'laser existense variable
	Dim lasExist As Boolean
	'UFO laser position variables
	
	Dim ufoLas1x As Short
	Dim ufoLas1y As Short
	Dim ufoLas2x As Short
	Dim ufoLas2y As Short
	Dim ufoLas3x As Short
	Dim ufoLas3y As Short
	Dim ufoLas4x As Short
	Dim ufoLas4y As Short
	'UFO laser existence variable
	Dim ufoLasExist1 As Boolean = False
	Dim ufoLasExist2 As Boolean = False
	Dim ufoLasExist3 As Boolean = False
	Dim ufoLasExist4 As Boolean = False
	'UFO laser selection variable
	Dim selection As Short
	Dim lastSelection As Short
	'Boss Minion selection variable
	Dim minionSelection As Short
	'UFO position variables
	Dim ufo1x As Short
	Dim ufo1y As Short
	Dim ufo2x As Short
	Dim ufo2y As Short
	Dim ufo3x As Short
	Dim ufo3y As Short
	'Bouncer position variables
	Dim bouncer1x As Short
	Dim bouncer1y As Short
	Dim bouncer2x As Short
	Dim bouncer2y As Short
	Dim bouncer3x As Short
	Dim bouncer3y As Short
	Dim bouncer4x As Short
	Dim bouncer4y As Short
	'Faller position variables
	Dim faller1x As Short
	Dim faller1y As Short
	Dim faller2x As Short
	Dim faller2y As Short
	Dim faller3x As Short
	Dim faller3y As Short
	Dim faller4x As Short
	Dim faller4y As Short
	'Faller speed variables
	Dim faller1Speedx As Short
	Dim faller1Speedy As Short
	Dim faller2Speedx As Short
	Dim faller2Speedy As Short
	Dim faller3Speedx As Short
	Dim faller3Speedy As Short
	Dim faller4Speedx As Short
	Dim faller4Speedy As Short
	Dim fallerxSpeedTarget As Short = 2
	Dim fallerySpeedTarget As Short = 2
	'Riser position variables
	Dim riser1x As Short
	Dim riser1y As Short
	Dim riser2x As Short
	Dim riser2y As Short
	Dim riser3x As Short
	Dim riser3y As Short
	Dim riser4x As Short
	Dim riser4y As Short
	'Riser speed variables
	Dim riser1Speedx As Short
	Dim riser1Speedy As Short
	Dim riser2Speedx As Short
	Dim riser2Speedy As Short
	Dim riser3Speedx As Short
	Dim riser3Speedy As Short
	Dim riser4Speedx As Short
	Dim riser4Speedy As Short
	'LT position variable
	Dim ltx As Short
	Dim lty As Short
	'LT health variable
	Dim ltHealth As Short = 3
	'LT speed variable
	Dim ltxSpeed As Short = 0
	Dim ltxSpeedTarget As Short = 2
	'Boss position variable
	Dim bossx As Short = 34
	Dim bossy As Short = 0
	'Boss movement speed variables
	Dim bossxSpeed As Short = 0
	Dim bossySpeed As Short = 0
	Dim bossxSpeedTarget As Short = 3
	Dim bossySpeedTarget As Short = 1
	'UFO existence variables
	Dim ufo1Exist As Boolean  = False
	Dim ufo2Exist As Boolean  = False
	Dim ufo3Exist As Boolean  = False
	'Bouncer existence variables
	Dim bouncer1Exist As Boolean  = False
	Dim bouncer2Exist As Boolean  = False
	Dim bouncer3Exist As Boolean  = False
	Dim bouncer4Exist As Boolean  = False
	'Faller existence variables
	Dim faller1Exist As Boolean  = False
	Dim faller2Exist As Boolean  = False
	Dim faller3Exist As Boolean  = False
	Dim faller4Exist As Boolean  = False
	'Riser existence variables
	Dim riser1Exist As Boolean  = False
	Dim riser2Exist As Boolean  = False
	Dim riser3Exist As Boolean  = False
	Dim riser4Exist As Boolean  = False
	'LT existence variable
	Dim ltExist As Boolean  = False
	'Boss1 Existence variable
	Dim boss1Exist As Boolean  = False
	'Boss health variable
	Dim bossHealth As Short
	'Bouncer top Or bottom variable
	Dim bouncerOrigin As Short
	'Bouncer gap space variable
	Dim bouncerGap As Short = 6
	'Bouncer direction variables
	Dim bouncer1Direction As Boolean
	Dim bouncer2Direction As Boolean
	Dim bouncer3Direction As Boolean
	Dim bouncer4Direction As Boolean
	Dim bouncer1xSpeed As Short
	Dim bouncer2xSpeed As Short
	Dim bouncer3xSpeed As Short
	Dim bouncer4xSpeed As Short
	Dim bouncer1ySpeed As Short
	Dim bouncer2ySpeed As Short
	Dim bouncer3ySpeed As Short
	Dim bouncer4ySpeed As Short
	Dim ySpeed As Short = 1
	Dim xSpeed As Short = 2

	'spawn timer And spawn time variables For UFO enemies
	Dim startTime As Long 'setting up timer variables
	Dim currentTime As Long
	Dim spawnTime As Long = 3000   'Spawn timer For UFO's
	'spawn timer And spawn time For bouncer enemies
	Dim startTime2 As Long
	Dim currentTime2 As Long
	Dim spawnTime2 As Long = 10000 'Spawn timer For bouncers
	'Spawn timer For LT mini boss
	Dim startTime3 As Long
	Dim currentTime3 As Long
	Dim spawnTime3 As Long  'Spawn timer For LT
	'spawn timer For UFO lasers
	Dim bossStartTime As Long
	Dim bossCurrentTime As Long
	Dim bossStartTime2 As Long
	Dim bossCurrentTime2 As Long
	Dim bossLaserTimer As Long = 1000
	Dim bossMinionTimer As Long = 6000
	'Spawn enabler variable, needed  To temporarily stop spawning For boss battle
	Dim spawnEnabled As Boolean

	'Level variable
	Dim levelNumber As Short = 1
	'Score variable
	Dim score As Short= 0
	'Level progression variables
	Dim kills As Short
	Dim killsTarget As Short
	'Boss battle engaged variable
	Dim bossBattleStarted As Boolean = False

	'Player ship collision detection variable
	Dim collisionDetection As Boolean  = True
	'Coin flip For UFOLaser 4 selection
	Dim coinFlip As Short
	
	Dim input As Byte  = 5
		
	Dim ship() As Short= Array As Short(2016, 0x06DF, 0, 0, 0, 2016, 2016, 2016,0x8C92)
	'UFO', 8x8px
	
	Dim ufo() As Short=  Array As Short(0, 0x37E5, 0, 0x8D55, 0x8D55, 0x8D55 )
	
	'explosion', 8x8px
	Dim explosion() As Short= Array As Short(0xEDA1, 0xF800, 63488, 0xEB21, 63488, 0xE761, 63488, 0xF800)

	'Bouncer', 8x8px
	Dim bouncer() As Short = Array As Short(2016, 2016, 2016, 0, 0, 0, 0, 0)

	'Boss1', 8x8px
	Dim boss() As Short= Array As Short(0,0,0,40147,40147,0,0,0,0,0,40147,0,0,40147,0,0,0,40147,0,0,0,0,40147,0,34198,51590,51590,51590,51590,51590,51590,34198,0,0,19257,0,0,19257,0,0,34198,51590,51590,51590,51590,51590,51590,34198,0,51590,51590,51590,51590,51590,51590,0,0,0,58761,51590,51590,58761,0,0)

	'Faller', 8x8px
	Dim faller() As Short= Array As Short(2016, 2016, 0, 0, 0, 0, 0, 0)

	'Riser', 8x8px
	Dim riser() As Short = Array As Short(2016, 2016, 2016, 0, 0, 0, 0, 0)

	'LT', 8x8px
	Dim LT() As Short = Array As Short(2016, 2016, 2016, 0, 0, 0, 0, 0)

	'UFO laser', 8x8px
	Dim ufoLaser() As Short = Array As Short(0xF800, 0xF800)

	'BossBoom', 8x8px
	Dim bossBoom1() As Short = Array As Short(2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016)
	
	'BossBoom2', 8x8px
	Dim bossBoom2() As Short = Array As Short(2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016)
	
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.Name="SpaceAttack"
	
	App.Author="Blueforcer"
	
	App.CoverIcon=713
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Kill enemies in space"
			
	App.Tags=Array As String("Beta","Games","eractive")

	'Tickerval in ms (should be 65 by default, for smooth scrolling))
	App.Tick=60
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.Lock=True
	
	App.isGame=True
	
	App.Hidden=True
	
	App.ShouldShow=False
	'needed Settings for this App (Wich can be configurate from user via weberface)

	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_externalCommand(cmd As Object)
	input=cmd
End Sub

Sub InputControl
	
	Select input
		Case 0 'Shoot
			ShootLaser
		Case 1 'up
			shipy=shipy-1
		Case 2 'down
			shipy=shipy+1
		Case 3 'left
			shipx=shipx-1
		Case 4 'right
			shipx=shipx+1
	End Select
	input=5
	App.drawBMP(shipx,shipy,ship,4,2)
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
End Sub

Sub App_AppExited
	App.ShouldShow=True
End Sub



'With this sub you build your frame.
Sub App_genFrame
	InputControl
	If (gameStart = False) Then
		Ticker(True)
	Else
		SpawnTimer
		UfoControl
		BouncerControl
		LaserControl
		ScreenLimit
		BossBattle
		BossControl
		UFOLaserControl
		LTControl
		FallerControl
		RiserControl
		ShipCollision
	End If
	

End Sub

Sub setLevel(Level As Int)
	Select Level
		Case 1
			spawnEnabled = True 'Enable spawning
			spawnTime = 3000   'Spawn timer For UFO'a
			spawnTime2 = 10000000 'Spawn timer For bouncers set so high they'll never appear
			spawnTime3 = 10000000 'Spawn timer For LT set so high so they'll never appear
			killsTarget = 10   'Sets kill target. When target reached boss should be spawned
			bossHealth = 10
			bossLaserTimer = 1000
		Case 2
			spawnEnabled = True
			spawnTime = 3000
			spawnTime2 = 8000
			spawnTime3 = 10000000
			killsTarget = 20
			bossHealth = 15
			bossLaserTimer = 900
		Case 3
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 6000
			spawnTime3 = 8000
			killsTarget = 30
			bossHealth = 20
			bossLaserTimer = 800
			
		Case 4
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 40
			bossHealth = 25
			bossLaserTimer = 700
			bossMinionTimer = 6000
		Case 5
			spawnEnabled = True
			spawnTime = 1800
			spawnTime2 = 4500
			spawnTime3 = 6000
			killsTarget = 50
			bossHealth = 30
			bossLaserTimer = 600
			bossMinionTimer = 5500
		Case 6
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 60
			bossHealth = 35
			bossLaserTimer = 500
			bossMinionTimer = 5000
		Case 7
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 70
			bossHealth = 40
			bossLaserTimer = 400
			bossMinionTimer = 4000
		Case 8
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 80
			bossHealth = 45
			bossLaserTimer = 300
			bossMinionTimer = 3000
		Case 9
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 90
			bossHealth = 50
			bossLaserTimer = 200
			bossMinionTimer = 2000
		Case 10
			spawnEnabled = True
			spawnTime = 2000
			spawnTime2 = 5000
			spawnTime3 = 7000
			killsTarget = 100
			bossHealth = 55
			bossLaserTimer = 100
			bossMinionTimer = 1000
	End Select
End Sub

Sub Ticker(resetKills As Boolean)        'Ticker code shamlessly stolen from the Ticker example. Used For Title And score And gameover
	If (gameStart = False) Then
		App.genText(tape,False,1,Array As Int(0,0,255),False)
		If (lasExist) Then       'If trigger pressed Then start the game
			lasExist=False
			bossBattleStarted = False
			gameStart = True
			startTime = DateTime.now  'Setting up spawn timer For UFO
			startTime2 = DateTime.now 'setting up spawn timer For Bouncer
			startTime3 = DateTime.now 'Setting up spawn timer For LT
			currentTime = startTime 'Setting up start timers For SpawnTimer function
			currentTime2 = startTime2
			currentTime3 = startTime3
			spawnEnabled = True 'Enabling spawnTimer
			setLevel(levelNumber) 'Calls Level function To set Level variables
			shipx = 0
			shipy = 3
			If resetKills = True Then
				kills = 0
			else if (resetKills = False) Then
				kills = kills
			End If
			Return
		End If
	End If
End Sub



Sub ShootLaser()

	If (lasExist = False) Then
  
		lasx=shipx+3
		lasy=shipy+1
		lasExist=True
		'    tone(buzzerPin, 400,75)
	End If
End Sub

Sub LaserControl     'Contains control code For the player laser And collision detection routines

	'If the laser exists Then move the laser dot across the screen
	If (lasExist = True) Then
  
		App.drawPixel(lasx,lasy,colorLaser)
		lasx=lasx+2
		'collision detection For UFO's
		'Each If statement covers every pixel with an extra one shadowing the top pixel because the laser can sometimes go through.
		If ufo1Exist = True Then
			For a = 0 To 2
      
				If lasx = ufo1x+a And lasy = ufo1y+1 Then
					ufo1Exist = False
					lasExist = False
					Boom(ufo1x,ufo1y,True,1)
					ufo1x = 34
				End If
			Next
			For a = 1 To 3
				If lasx = ufo1x+a And lasy = ufo1y Then
					ufo1Exist = False
					lasExist = False
					Boom(ufo1x,ufo1y,True,1)
					ufo1x = 34
				End If
			Next
		End If
	
		'collision detection For UFO2
		If ufo2Exist = True Then
			For a = 0 To 3
				If (lasx = ufo2x+a And lasy = ufo2y+1) Then
 
					ufo2Exist = False
					lasExist = False
					Boom(ufo2x,ufo2y,True,1)
					ufo2x = 34
				End If
			Next
	   
			For a = 1 To 3
				If (lasx = ufo2x+a And lasy = ufo2y) Then
					ufo2Exist = False
					lasExist = False
					Boom(ufo2x,ufo2y,True,1)
					ufo2x = 34
				End If
			Next
		End If
    
		'Collision detection For UFO3
		If (ufo3Exist = True) Then
			For a = 0 To 3

				If (lasx = ufo3x+a And lasy = ufo3y+1) Then

					ufo3Exist = False
					lasExist = False
					Boom(ufo3x,ufo3y,True,1)
					ufo3x = 34
				End If
			Next
	    
			For a = 1 To 3

				If (lasx = ufo3x+a And lasy = ufo3y) Then

					ufo3Exist = False
					lasExist = False
					Boom(ufo3x,ufo3y,True,1)
					ufo3x = 34
				End If
			Next
		End If
   

		' Collision detection For Bouncer1
		If (bouncer1Exist = True) Then
    
			For a = 1 To 2
  
				If (lasx = bouncer1x+a And lasy = bouncer1y) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					bouncer1Exist = False
					lasExist=False
					Boom(bouncer1x,bouncer1y,True,2)
					bouncer1x = 34
				End If
			Next
			For  a = 0 To 2
  
				If (lasx = bouncer1x+a And lasy = bouncer1y+1) Then
      
					bouncer1Exist = False
					lasExist=False
					Boom(bouncer1x,bouncer1y,True,2)
					bouncer1x = 34
				End If
			Next
			For a = 1 To 2
      
				If (lasx = bouncer1x+a And lasy = bouncer1y+2) Then
        
					bouncer1Exist = False
					lasExist=False
					Boom(bouncer1x,bouncer1y,True,2)
					bouncer1x = 34
				End If
			Next
		End If
		'Collision detection For Bouncer 2
		If (bouncer2Exist = True) Then

			For a = 1 To 2

				If (lasx = bouncer2x+a And lasy = bouncer2y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
       
					bouncer2Exist = False
					lasExist=False
					Boom(bouncer2x,bouncer2y,True,2)
					bouncer2x = 34
				End If
			Next
			For a = 0 To 2
    
				If (lasx = bouncer2x+a And lasy = bouncer2y+1) Then
     
					bouncer2Exist = False
					lasExist=False
					Boom(bouncer2x,bouncer2y,True,2)
					bouncer2x = 34
				End If
			Next
			For a = 1 To 2
      
				If (lasx = bouncer2x+a And lasy = bouncer2y+2) Then
        
					bouncer2Exist = False
					lasExist=False
					Boom(bouncer2x,bouncer2y,True,2)
					bouncer2x = 34
				End If
			Next
		End If


    
		'Collision detection For Bouncer 3
		If (bouncer3Exist = True) Then
    
			For a = 1 To 2
     
				If (lasx = bouncer3x+a And lasy = bouncer3y) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					bouncer3Exist = False
					lasExist=False
					Boom(bouncer3x,bouncer3y,True,2)
					bouncer3x = 34
				End If
			Next
			For a = 0 To 2
     
				If (lasx = bouncer3x+a And lasy = bouncer3y+1) Then
        
					bouncer3Exist = False
					lasExist=False
					Boom(bouncer3x,bouncer3y,True,2)
					bouncer3x = 34
				End If
			Next
			For a = 1 To  2
      
				If (lasx = bouncer3x+a And lasy = bouncer3y+2) Then
        
					bouncer3Exist = False
					lasExist=False
					Boom(bouncer3x,bouncer3y,True,2)
					bouncer3x = 34
				End If
			Next
		End If
    
		'Collision detection For Bouncer 4
		If (bouncer4Exist = True) Then
    
			For a = 1 To  2
      
				If (lasx = bouncer4x+a And lasy = bouncer4y) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					bouncer4Exist = False
					lasExist=False
					Boom(bouncer4x,bouncer4y,True,2)
					bouncer4x = 34
				End If
			Next
			For a = 0 To  2
      
				If (lasx = bouncer4x+a And lasy = bouncer4y+1) Then
        
					bouncer4Exist = False
					lasExist=False
					Boom(bouncer4x,bouncer4y,True,2)
					bouncer4x = 34
				End If
			Next
			For a = 1 To  2
      
				If (lasx = bouncer4x+a And lasy = bouncer4y+2) Then
        
					bouncer4Exist = False
					lasExist=False
					Boom(bouncer4x,bouncer4y,True,2)
					bouncer4x = 34
				End If
			Next
		End If
    
		'Collision detection For Boss
		If (boss1Exist = True) Then
			For a = 3 To  5        'Top line 0
				If (lasx = bossx+a And lasy = bossy) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
	  
			For a = 2 To  5          'Line 1
				If (lasx = bossx+a And lasy = bossy+1) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 1 To  6           'Line 2
				If (lasx = bossx+a And lasy = bossy+2) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 0 To  7           'Line 3
				If (lasx = bossx+a And lasy = bossy+3) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 2 To  6     'Line 4
				If (lasx = bossx+a And lasy = bossy+4) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 0 To  7       'Line 5
				If (lasx = bossx+a And lasy = bossy+5) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 1 To  6       'Line 6
				If (lasx = bossx+a And lasy = bossy+6) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 2 To  5       'Line 7
				If (lasx = bossx+a And lasy = bossy+7) Then
					bossHealth=bossHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
		End If

		'Collision detection routines For LT
		If (ltExist = True) Then
			For a = 1 To 4     'Top line 0
				If (lasx = ltx+a And lasy = lty) Then
					ltHealth=ltHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 0 To 5     'Line 1
				If (lasx = ltx+a And lasy = lty+1) Then
					ltHealth=ltHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
			For a = 2 To 4            'Line 2
				If (lasx = ltx+a And lasy = lty+2) Then
					ltHealth=ltHealth-1
					lasExist=False
					Boom(lasx,lasy,False,0)
				End If
			Next
		End If
		'Collision detection For Faller 1
		If (faller1Exist = True) Then
			For a = 0 To 2          'Top Line 0
				If (lasx = faller1x+a And lasy = faller1y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller1Exist = False
					lasExist=False
					Boom(faller1x,faller1y,False,0)
					faller1x = 34
				End If
			Next
			For a = 0 To 3           'Line 1
				If (lasx = faller1x+a And lasy = faller1y+1) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller1Exist = False
					lasExist=False
					Boom(faller1x,faller1y,False,0)
					faller1x = 34
				End If
			Next
			For a = 0 To 3           'Line 2
				If (lasx = faller1x+a And lasy = faller1y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller1Exist = False
					lasExist=False
					Boom(faller1x,faller1y,False,0)
					faller1x = 34
				End If
			Next
		End If
		'Collision detection For Faller 2
		If (faller2Exist = True) Then
			For a = 0 To 2          'Top Line 0
				If (lasx = faller2x+a And lasy = faller2y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller2Exist = False
					lasExist=False
					Boom(faller2x,faller2y,False,0)
					faller2x = 34
				End If
			Next
			For a = 0 To 3           'Line 1
				If (lasx = faller2x+a And lasy = faller2y+1) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller2Exist = False
					lasExist=False
					Boom(faller2x,faller2y,False,0)
					faller2x = 34
				End If
			Next
			For a = 0 To 3           'Line 2
				If (lasx = faller2x+a And lasy = faller2y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller2Exist = False
					lasExist=False
					Boom(faller2x,faller2y,False,0)
					faller2x = 34
				End If
			Next
		End If
		'Collision detection For Faller 3
		If (faller3Exist = True) Then
			For a = 0 To 2          'Top Line 0
				If (lasx = faller3x+a And lasy = faller3y)  Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller3Exist = False
					lasExist=False
					Boom(faller3x,faller3y,False,0)
					faller3x = 34
				End If
			Next
			For a = 0 To 3           'Line 1
				If (lasx = faller3x+a And lasy = faller3y+1) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller3Exist = False
					lasExist=False
					Boom(faller3x,faller3y,False,0)
					faller3x = 34
				End If
			Next
			For a = 0 To 3           'Line 2
				If (lasx = faller3x+a And lasy = faller3y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller3Exist = False
					lasExist=False
					Boom(faller3x,faller3y,False,0)
					faller3x = 34
				End If
			Next
		End If
		'Collision detection For Faller 4
		If (faller4Exist = True) Then
			For a = 0 To 2          'Top Line 0
				If (lasx = faller4x+a And lasy = faller4y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller4Exist = False
					lasExist=False
					Boom(faller4x,faller4y,False,0)
					faller4x = 34
				End If
			Next
			For a = 0 To 3           'Line 1
				If (lasx = faller4x+a And lasy = faller4y+1) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller4Exist = False
					lasExist=False
					Boom(faller4x,faller4y,False,0)
					faller4x = 34
				End If
			Next
			For a = 0 To 3           'Line 2
				If (lasx = faller4x+a And lasy = faller4y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					faller4Exist = False
					lasExist=False
					Boom(faller4x,faller4y,False,0)
					faller4x = 34
				End If
			Next
		End If
    
		'Collision detection For Riser 1
		If (riser1Exist = True) Then
			For a = 0 To 3           'Top Line 0
				If (lasx = riser1x+a And lasy = riser1y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
 
					riser1Exist = False
					lasExist=False
					Boom(riser1x,riser1y,False,0)
					riser1x = 34
				End If
			Next
			For a = 0 To 2           'Line 1
				If (lasx = riser1x+0 And lasy = riser1y+1) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
       
					riser1Exist = False
					lasExist=False
					Boom(riser1x,riser1y,False,0)
					riser1x = 34
				End If
			Next
			For a = 0 To 1          'Line 2
				If (lasx = riser1x+a And lasy = riser1y+2) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser1Exist = False
					lasExist=False
					Boom(riser1x,riser1y,False,0)
					riser1x = 34
				End If
			Next
		End If
    

		'Collision detection For Riser 2
		If (riser2Exist = True) Then
			For a = 0 To 3           'Top Line 0
				If (lasx = riser2x+a And lasy = riser2y) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser2Exist = False
					lasExist=False
					Boom(riser2x,riser2y,False,0)
					riser2x = 34
				End If
			Next
			For a = 0 To 2           'Line 1
				If (lasx = riser2x+0 And lasy = riser2y+1) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser2Exist = False
					lasExist=False
					Boom(riser2x,riser2y,False,0)
					riser2x = 34
				End If
			Next
			For a = 0 To 1          'Line 2
				If (lasx = riser2x+a And lasy = riser2y+2) Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser2Exist = False
					lasExist=False
					Boom(riser2x,riser2y,False,0)
					riser1x = 34
				End If
			Next
		End If

		'Collision detection For Riser 3
		If (riser3Exist = True) Then
			For a = 0 To 3           'Top Line 0
      
				If (lasx = riser3x+a And lasy = riser3y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser3Exist = False
					lasExist=False
					Boom(riser3x,riser3y,False,0)
					riser3x = 34
				End If
			Next
			For a = 0 To 2           'Line 1
      
				If (lasx = riser3x+0 And lasy = riser3y+1) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser3Exist = False
					lasExist=False
					Boom(riser3x,riser3y,False,0)
					riser3x = 34
				End If
			Next
			For a = 0 To 1          'Line 2
				If (lasx = riser3x+a And lasy = riser3y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser3Exist = False
					lasExist=False
					Boom(riser3x,riser3y,False,0)
					riser3x = 34
				End If
			Next
		End If
		'Collision detection For Riser 4
		If (riser4Exist = True) Then
			For a = 0 To 3           'Top Line 0
				If (lasx = riser4x+a And lasy = riser4y) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser4Exist = False
					lasExist=False
					Boom(riser4x,riser4y,False,0)
					riser4x = 34
				End If
			Next
			For a = 0 To 2           'Line 1
				If (lasx = riser4x+0 And lasy = riser4y+1)Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
          
					riser4Exist = False
					lasExist=False
					Boom(riser4x,riser4y,False,0)
					riser4x = 34
				End If
			Next
			For a = 0 To 1          'Line 2
				If (lasx = riser4x+a And lasy = riser4y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
					riser4Exist = False
					lasExist=False
					Boom(riser4x,riser4y,False,0)
					riser4x = 34
				End If
			Next
		End If
	End If
End Sub


Sub Boom( x As Int,  y As  Int, addKill As Boolean,  scoreType As Int)  'Spawns explosion bitmap at called coords. Then increments kill count
	App.drawBMP(x,y,explosion,3,3) 'Draw explosion
	'  tone(buzzerPin, 75,75)
	If (addKill = True) Then
		kills=kills+1
	End If
 
	If (scoreType = 1) Then 'score Type For UFOs
		score = score+10
	End If

	If (scoreType = 2) Then'score Type For bouncers
		score = score+20
	End If
  
	If (scoreType = 3) Then 'scoreType For LT
		score = score+70
	End If
  
	'  'If (scoreType = 4) 'score Type For Risers And Fallers.. Currently Not using it
	' '
	' '   score = score+30
	''  }
	If (scoreType = 5) Then 'score Type For Boss
  
		score = score+(100*levelNumber)
	End If
End Sub

Sub ScreenLimit

	'setting boundries of the screen For ship
	If (shipx < 0) Then    shipx = 0
 
	If (shipx > 29) Then   shipx = 29
  
	If (shipy < 0) Then   shipy = 0
 
	If (shipy > 6)Then    shipy = 6

	If (lasExist = True) Then 'When it goes off the screen Then stop drawing it And mark it As not existing
		If (lasx > 31) Then lasExist=False
		If (lasy < 0) Then lasy = 0
		If (lasy > 7) Then lasy = 7
	End If

	'UFO laser screen limit controls
    
	If (ufoLas1x < -2) Then  ufoLasExist1 = False
	If (ufoLas2x < -2) Then    ufoLasExist2 = False
	If (ufoLas3x < -2) Then          ufoLasExist3 = False
	If (ufoLas4x < -2) Then          ufoLasExist4 = False
     
  
	'UFO screen limit controls. Automatically respawning UFO's at a rnd Y coordinate on the right side if they go off the left side
	If (ufo1Exist = True And ufo1x < -3) Then
		ufo1x = 33 'If UFO goes off the left side it gets moved To the right side again
		ufo1y = Rnd(0,7)
		' going To need some sort of sorting code To stop ufo's overlapping
	End If
	If (ufo2Exist = True And ufo2x < -3) Then
		ufo2x = 33 'If UFO goes off the left side it gets moved To the right side again
		ufo2y = Rnd(0,7)
		' going To need some sort of sorting code To stop ufo's overlapping
	End If
	If (ufo3Exist = True And ufo3x < -3)Then
		ufo3x = 33 'If UFO goes off the left side it gets moved To the right side again
		ufo3y = Rnd(0,7)
		' going To need some sort of sorting code To stop ufo's overlapping
	End If
  
	'Bouncer screen limit controls. When bouncers hit top Or bottom the direction variable changes. When off the left they are wiped from existence And respawned at a later time.
  
	If (bouncer1Exist = True And bouncer1y > 5) Then
		bouncer1Direction = False
	else if (bouncer1Exist = True And bouncer1y < 0) Then
		bouncer1Direction = True
	End If
  
	If (bouncer2Exist = True And bouncer2y > 5) Then
		bouncer2Direction = False
	else if (bouncer2Exist = True And bouncer2y < 0)Then
		bouncer2Direction = True
	End If
  
	If (bouncer3Exist = True And bouncer3y > 5)Then
		bouncer3Direction = False
	else if (bouncer3Exist = True And bouncer3y < 0)Then
		bouncer3Direction = True
	End If
 
	If (bouncer4Exist = True And bouncer4y > 5)Then
		bouncer4Direction = False
	else if (bouncer4Exist = True And bouncer4y < 0)Then
		bouncer4Direction = True
	End If

	' If bouncers go off the left side they disappear As despawned
	If (bouncer1x < 0) Then bouncer1Exist = False
	If (bouncer2x < 0) Then bouncer2Exist = False
	If (bouncer3x < 0)Then bouncer3Exist = False
	If (bouncer4x < 0)Then bouncer4Exist = False

	'LT screen limit control
	If (ltExist = True And ltx < -6)Then
		ltx = 33 'If LT goes off the left side it gets moved To the right side again
		lty = Rnd(0,6)
	End If
  
	'Screen limit controls For Risers
	If (faller1Exist = True And faller1y > 7)Then faller1Exist = False
	If (faller2Exist = True And faller2y > 7)Then faller2Exist = False
	If (faller3Exist = True And faller3y > 7)Then faller3Exist = False
	If (faller4Exist = True And faller4y > 7)Then faller4Exist = False

	'Screen limit controls For Risers
	If (riser1Exist = True And riser1y < -2)Then riser1Exist = False
	If (riser2Exist = True And riser2y < -2)Then riser2Exist = False
	If (riser3Exist = True And riser3y < -2)Then riser3Exist = False
	If (riser4Exist = True And riser4y < -2)Then riser4Exist = False
   
End Sub

Sub SpawnTimer
	If (spawnEnabled = True) Then
		'Counting spawn timer
		currentTime = DateTime.Now 'get the current time in milliseconds
		currentTime2 = DateTime.Now'same again For second timer
		currentTime3 = DateTime.Now'And again
		
		If (currentTime - startTime >= spawnTime) Then   'Uses the currentTime, startTime And spawnTime variables To spawn enemies on set times
			'spawn UFO
			SpawnUFO
			'reset timer
			startTime = currentTime  'Saves the start time of the spawn so the If statement works
		End If
  
		If (currentTime2 - startTime2 >= spawnTime2) Then
			'spawn bouncer squad
			SpawnBouncer
			'reset timer
			startTime2 = currentTime2 'Saves the start time of the spawn so the If statement works
		End If

		If (currentTime3 - startTime3 >= spawnTime3) Then
			'spawn LT
			SpawnLT
			'reset timer
			startTime3 = currentTime3  'Saves the start time of the spawn so the If statement works
		End If
	End If
End Sub

Sub SpawnUFO
	If (ufo1Exist = False) Then
		ufo1x = 32          'Spawn off the right side of the screen
		ufo1y = Rnd(0,7)  	'Spawn at a rnd Y coord
		ufo1Exist = True
	else if (ufo2Exist = False) Then
		ufo2x = 32         	'Spawn off the right side of the screen
		ufo2y = Rnd(0,7)   	'Spawn at a rnd Y coord
		ufo2Exist = True
	else if (ufo3Exist = False) Then
		ufo3x = 32         	'Spawn off the right side of the screen
		ufo3y = Rnd(0,7)   	'Spawn at a rnd Y coord
		ufo3Exist = True
	End If
End Sub

Sub UfoControl
	'If the UFO exists Then draw its bitmap
	If (ufo1Exist = True) Then
		ufo1x=ufo1x-1
		App.drawBMP(ufo1x,ufo1y,ufo,3,2)
	End If
	If (ufo2Exist = True)Then
		ufo2x=ufo2x-1
		App.drawBMP(ufo2x,ufo2y,ufo,3,2)
	End If
	If (ufo3Exist = True)Then
		ufo3x=ufo3x-1
		App.drawBMP(ufo3x,ufo3y,ufo,3,2)
	End If
End Sub

Sub SpawnBouncer
	If (bouncer1Exist = False And bouncer2Exist = False And bouncer3Exist = False And bouncer4Exist = False) Then
		bouncer1x = 32           'Spawn off the right side of the screen
		bouncer2x = bouncer1x+bouncerGap'spawn other bouncers spaced out on the x axis
		bouncer3x = bouncer2x+bouncerGap
		bouncer4x = bouncer3x+bouncerGap
		bouncerOrigin = Rnd(0,2)
		If (bouncerOrigin = 0) Then
			bouncer1y = 0   'Spawn at top of screen
			bouncer2y = 1
			bouncer3y = 2
			bouncer4y = 3
		End If
		If (bouncerOrigin = 1) Then
			bouncer1y = 7 'Spawn at bottom
			bouncer2y = 6
			bouncer3y = 5
			bouncer4y = 4
		End If
		bouncer1Exist = True
		bouncer2Exist = True
		bouncer3Exist = True
		bouncer4Exist = True
	End If
End Sub

Sub BouncerControl

	'Bouncer move across To the left And up Or down depending opn direction variable. That variable Is changed in ScreenLimit()
  
	If (bouncer1Exist = True) Then    'If bouncer exists Then increment bouncer x And y counters. These are used To slow the movement.
		bouncer1xSpeed=bouncer1xSpeed+1
		bouncer1ySpeed=bouncer1ySpeed+1
		If (bouncer1xSpeed > xSpeed)  Then   'When the counter goes above the speed value Then If statement executes
			bouncer1x=bouncer1x-1
			bouncer1xSpeed = 0
		End If
		If (bouncer1Direction = True) Then
			If (bouncer1ySpeed > ySpeed) Then
				bouncer1y=bouncer1y+1
				bouncer1ySpeed = 0
			End If
		else if (bouncer1Direction = False) Then
			If (bouncer1ySpeed > ySpeed) Then
				bouncer1y=bouncer1y-1
				bouncer1ySpeed = 0
			End If
		End If
		App.drawBMP(bouncer1x,bouncer1y,bouncer,2,3)
	End If
  
	If (bouncer2Exist = True) Then
		bouncer2xSpeed=bouncer2xSpeed+1
		bouncer2ySpeed=bouncer2ySpeed+1
		If (bouncer2xSpeed > xSpeed) Then
			bouncer2x=bouncer2x-1
			bouncer2xSpeed = 0
		End If
		If (bouncer2Direction = True) Then
			If (bouncer2ySpeed > ySpeed) Then
				bouncer2y=bouncer2y+1
				bouncer2ySpeed = 0
			End If
		else if (bouncer2Direction = False) Then
			If (bouncer2ySpeed > 2) Then
				bouncer2y=bouncer2y-1
				bouncer2ySpeed = 0
			End If
		End If
		App.drawBMP(bouncer2x,bouncer2y,bouncer,2,3)
	End If

	If (bouncer3Exist = True) Then
		bouncer3xSpeed=bouncer3xSpeed+1
		bouncer3ySpeed=bouncer3ySpeed+1
		If (bouncer3xSpeed > xSpeed) Then
			bouncer3x=bouncer3x-1
			bouncer3xSpeed = 0
		End If
		If (bouncer3Direction = True) Then
			If (bouncer3ySpeed > ySpeed) Then
				bouncer3y=bouncer3y+1
				bouncer3ySpeed = 0
			End If
		else if (bouncer3Direction = False) Then
			If (bouncer3ySpeed > 2) Then
				bouncer3y=bouncer3y-1
				bouncer3ySpeed = 0
			End If
		End If
'	App.drawBMP(bouncer3x,bouncer3y,bouncer,2,3,1)
	End If

	If (bouncer4Exist = True) Then
		bouncer4xSpeed=bouncer4xSpeed+1
		bouncer4ySpeed=bouncer4ySpeed+1
		If (bouncer4xSpeed > xSpeed) Then
			bouncer4x=bouncer4x-1
			bouncer4xSpeed = 0
		End If
		If (bouncer4Direction = True) Then
			If (bouncer4ySpeed > 2) Then
				bouncer4y=bouncer4y+1
				bouncer4ySpeed = 0
			End If
		else if (bouncer4Direction = False) Then
			If (bouncer4ySpeed > ySpeed) Then
				bouncer4y=bouncer4y-1
				bouncer4ySpeed = 0
			End If
		End If
		App.drawBMP(bouncer4x,bouncer4y,bouncer,2,3)
	End If
End Sub

Sub SpawnFaller
	If (faller1Exist = False And faller2Exist = False And faller3Exist = False And faller4Exist = False) Then
		faller1x = 15          'Spawn above the boss off the top of the screen
		faller2x = faller1x+bouncerGap 'spawn other bouncers spaced out on the x axis
		faller3x = faller2x+bouncerGap
		faller4x = faller3x+bouncerGap
		faller1y = -1   'Spawn at top of screen
		faller2y = -2
		faller3y = -3
		faller4y = -4
        
		faller1Exist = True
		faller2Exist = True
		faller3Exist = True
		faller4Exist = True
	End If
End Sub

Sub FallerControl
	'Fallers are spawned by the Boss during battle after level 4. Timer For spawning Is in the BossControl function.
	'Control routines For faller 1
	If (faller1Exist = True) Then   'If faller exists Then increment fallerSpeed x And y counters. These are used To slow the movement.
		faller1Speedx=faller1Speedx+1
		faller1Speedy=faller1Speedy+1
		If (faller1Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			faller1x=faller1x-1
			faller1Speedx = 0
		End If
    
		If (faller1Speedy > fallerySpeedTarget) Then
			faller1y=faller1y+1
			faller1Speedy = 0
		End If
		App.drawBMP(faller1x,faller1y,faller,3,3)
	End If
  
	'Control routines For faller 2
	If (faller2Exist = True) Then    'If faller exists Then increment fallerSpeed x And y counters. These are used To slow the movement.
		faller2Speedx=faller2Speedx+1
		faller2Speedy=faller2Speedy+1
		If (faller2Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			faller2x=faller2x-1
			faller2Speedx = 0
		End If
    
		If (faller2Speedy > fallerySpeedTarget) Then
			faller2y=faller2y+1
			faller2Speedy = 0
		End If
		App.drawBMP(faller2x,faller2y,faller,3,3)
	End If

	' Control routines For faller 3
	If (faller3Exist = True) Then    'If faller exists Then increment fallerSpeed x And y counters. These are used To slow the movement.
		faller3Speedx=faller3Speedx+1
		faller3Speedy=faller3Speedy+1
		If (faller3Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			faller3x=faller3x-1
			faller3Speedx = 0
		End If
    
		If (faller3Speedy > fallerySpeedTarget) Then
			faller3y=faller3y+1
			faller3Speedy = 0
		End If
		App.drawBMP(faller3x,faller3y,faller,3,3)
	End If

	' Control routines For faller 4
	If (faller4Exist = True) Then    'If faller exists Then increment fallerSpeed x And y counters. These are used To slow the movement.
		faller4Speedx=faller4Speedx+1
		faller4Speedy=faller4Speedy+1
		If (faller4Speedx > fallerxSpeedTarget) Then   'When the counter goes above the speed value Then If statement executes
			faller4x=faller4x-1
			faller4Speedx = 0
		End If
        
		If (faller4Speedy > fallerySpeedTarget) Then
			faller4y=faller4y+1
			faller4Speedy = 0
		End If
		App.drawBMP(faller4x,faller4y,faller,3,3)
	End If
End Sub

Sub SpawnRiser
	If (riser1Exist = False And riser2Exist = False And riser3Exist = False And riser4Exist = False) Then
		riser1x = 15           'Spawn above the boss off the top of the screen
		riser2x = riser1x+bouncerGap'spawn other bouncers spaced out on the x axis
		riser3x = riser2x+bouncerGap
		riser4x = riser3x+bouncerGap
		riser1y = 7   'Spawn at Bottom of screen
		riser2y = 8
		riser3y = 9
		riser4y = 10
        
		riser1Exist = True
		riser2Exist = True
		riser3Exist = True
		riser4Exist = True
	End If
End Sub

Sub RiserControl
	'Risers are spawned by the Boss during battle after level 5. Timer For spawning Is in the BossControl function.
	'Control routines For riser 1
	If (riser1Exist = True) Then    'If riser exists Then increment riserSpeed x And y counters. These are used To slow the movement.
		riser1Speedx=riser1Speedx+1
		riser1Speedy=riser1Speedy+1
		If (riser1Speedx > fallerxSpeedTarget) Then   'When the counter goes above the speed value Then If statement executes
			riser1x=riser1x-1
			riser1Speedx = 0
		End If
    
		If (riser1Speedy > fallerySpeedTarget) Then
			riser1y=riser1y-1
			riser1Speedy = 0
		End If
		App.drawBMP(riser1x,riser1y,riser,3,3)
	End If
	
	'Control routines For riser 2
	If (riser2Exist = True)Then   'If riser exists Then increment riserSpeed x And y counters. These are used To slow the movement.
		riser2Speedx=riser2Speedx+1
		riser2Speedy=riser2Speedy+1
		If (riser2Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			riser2x=riser2x-1
			riser2Speedx = 0
		End If
    
		If (riser2Speedy > fallerySpeedTarget) Then
			riser2y=riser2y-1
			riser2Speedy = 0
		End If
		App.drawBMP(riser2x,riser2y,riser,3,3)
	End If
	
	'Control routines For riser 3
	If (riser3Exist = True) Then    'If riser exists Then increment riserSpeed x And y counters. These are used To slow the movement.
		riser3Speedx=riser3Speedx+1
		riser3Speedy=riser3Speedy+1
		If (riser3Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			riser3x=riser3x-1
			riser3Speedx = 0
		End If
    
		If (riser3Speedy > fallerySpeedTarget) Then
			riser3y=riser3y-1
			riser3Speedy = 0
		End If
		App.drawBMP(riser3x,riser3y,riser,3,3)
	End If
	
	'Control routines For riser 4
	If (riser4Exist = True) Then    'If riser exists Then increment riserSpeed x And y counters. These are used To slow the movement
		riser4Speedx=riser4Speedx+1
		riser4Speedy=riser4Speedy+1
		If (riser4Speedx > fallerxSpeedTarget) Then    'When the counter goes above the speed value Then If statement executes
			riser4x=riser4x-1
			riser4Speedx = 0
		End If
    
		If (riser4Speedy > fallerySpeedTarget) Then
			riser4y=riser4y-1
			riser4Speedy = 0
		End If
		App.drawBMP(riser4x,riser4y,riser,3,3)
	End If
End Sub

Sub  SpawnLT
	If (ltExist =False) Then
		ltx = 32           'Spawn off the right side of the screen
		lty = Rnd(0,6)   'Spawn at a rnd Y coord
		ltExist = True
	End If
End Sub

Sub LTControl
	'If the UFO exists Then draw its bitmap
	If (ltExist = True) Then
		ltxSpeed=ltxSpeed+1
		If (ltxSpeed = ltxSpeedTarget) Then
			ltxSpeed = 0
			ltx=ltx-1
		End If
		App.drawBMP(ltx, lty, LT, 6, 3)
	End If
	If (ltHealth <= 0) Then
		ltExist = False
		Boom(ltx,lty,False,3)  'Calls Boom() function To add score. Kills are added manually below.
		kills=kills+3
		ltHealth = 3
	End If
End Sub


Sub BossBattle 'Sounds the warning siren Then spawns boss. Still need To finish movement
	If (kills > killsTarget And bossBattleStarted = False) Then
		bossBattleStarted = True
		spawnEnabled = False             'Turns off spawning For other UFO types
		If (boss1Exist = False) Then
			App.drawBMP(bossx, bossy, boss, 8 ,8)
			boss1Exist = True
			bossStartTime = DateTime.Now  'Set start timer For boss weapons
			bossStartTime = DateTime.Now   'Set start timer For boss minions
		End If
	End If
End Sub

Sub BossControl

	If (boss1Exist = True) Then
		bossxSpeed=bossxSpeed+1
		If (bossxSpeed > bossxSpeedTarget And bossx > 24) Then    'When the counter goes above the speed value Then If statement executes
			bossx=bossx-1                'Move the boss x cords To the left
			bossxSpeed = 0
		End If
    
		App.drawBMP(bossx, bossy, boss, 8, 8) 'Draw the boss bitmap at the new coords
		If (bossx = 24) Then
       
			'Counting shoot timer
			bossCurrentTime = DateTime.Now 'get the current time in milliseconds
			bossCurrentTime2 = DateTime.Now
     
			If (bossCurrentTime - bossStartTime >= bossLaserTimer)  Then   'startTimer Is set in BossBattle function
				'shoot laser
				selection = Rnd(1,5)'Select laser cannon at rnd
				Do While (selection = lastSelection)'While Loop To ensure that the same laser isnt fired twice in a row too quick. Prevents timing gaps
					selection = Rnd(1,5)
				Loop
				UFOLaserShoot(selection)'Call UFOLaserShoot function with cannon selection
				'reset timer
				bossStartTime = bossCurrentTime  'Saves the start time of the spawn so the If statement works
			End If
			If (levelNumber >= 4) Then
      
				If (bossCurrentTime2 - bossStartTime2 >= bossMinionTimer) Then  'startTimer Is set in BossBattle function
					'Select minions And spawn them
					minionSelection = Rnd(1,3)
					If (minionSelection = 1) Then  SpawnFaller
					If (minionSelection = 2) Then         SpawnRiser

					'reset timer
					bossStartTime2 = bossCurrentTime2 'Saves the start time of the spawn so the If statement works
				End If
			End If
		End If
		'Boss health counter hits zero, trigger boss death And new level
		If (bossHealth <= 0) Then
    
			boss1Exist = False   'Boss no longer exists
			Boom(bossx,bossy,False,5) 'Calls Boom() function To add score
			'      App.fillScreen(LOW) 'Clear screen
			For i= 5 To 0 Step-1
          
				App.drawBMP(bossx, bossy, bossBoom1 ,8 ,8)    'Boss explosion first frame

				'App.fillScreen(LOW) 'Clear screen
				App.drawBMP(bossx, bossy, bossBoom2 ,8 ,8)    'Boss explosion second frame
      
			Next
    
      
			bossx=39             'Move bossx back To 32
			'      App.fillScreen(LOW) 'clear the screen
			gameStart = False    'Mark game As stopped
			levelNumber=levelNumber+1        'increment level
			If (levelNumber > 10) Then
				GameOver(1)
				Return
			End If
			tape = "Level " &  levelNumber & "  Score: " & score 'Prepare new tape For Ticker function

			ufoLasExist1 = False
			ufoLasExist2 = False
			ufoLasExist3 = False
			ufoLasExist4 = False
			faller1Exist = False
			faller2Exist = False
			faller3Exist = False
			faller4Exist = False
			riser1Exist = False
			riser2Exist = False
			riser3Exist = False
			riser4Exist = False
			ufoLas1x=bossx
			ufoLas2x=bossx
			ufoLas3x=bossx
			ufoLas4x=bossx
			Ticker(True)             'Call Ticker function To show score And new level
      
		End If
	End If
End Sub

Sub UFOLaserShoot(sel As Int)
	If (sel = 1) Then
		If (ufoLasExist1 = False) Then 'Check To see If the UFO laser already exists
			ufoLas1x=bossx+1      'spawn laser in the middle
			ufoLas1y=bossy+4
			ufoLasExist1=True
		End If
	End If
 
	If (sel = 2) Then
		If (ufoLasExist2 = False) Then
			ufoLas2x=bossx+2      'spawn laser at the top side
			ufoLas2y=bossy+1
			ufoLasExist2=True
		End If
	End If
	
	If (sel = 3) Then
		If (ufoLasExist3 = False) Then
			ufoLas3x=bossx+2    'spawn laser at the bottom side
			ufoLas3y=bossy+7
			ufoLasExist3=True
		End If
	End If
  
	If (sel = 4) Then
		If (ufoLasExist4 = False) Then 'Planning To make this one random
			coinFlip = Rnd(0,2)
			If (coinFlip = 0) Then
				ufoLas4x=bossx+2
				ufoLas4y=bossy+2
				ufoLasExist4=True
			End If
			If (coinFlip = 1) Then
				ufoLas4x=bossx+2
				ufoLas4y=bossy+6
				ufoLasExist4=True
			End If
		End If
	End If
End Sub

Sub UFOLaserControl
	If (ufoLasExist1 = True) Then
		ufoLas1x=ufoLas1x-1
		App.drawBMP(ufoLas1x, ufoLas1y, ufoLaser, 2, 1)
	End If
	If (ufoLasExist2 = True) Then
		ufoLas2x=ufoLas2x-1
		App.drawBMP(ufoLas2x, ufoLas2y, ufoLaser, 2, 1)
	End If

	If (ufoLasExist3 = True)Then
		ufoLas3x=ufoLas3x-1
		App.drawBMP(ufoLas3x, ufoLas3y, ufoLaser, 2, 1)
	End If
	If (ufoLasExist4 = True)Then

		ufoLas4x=ufoLas4x-1
		App.drawBMP(ufoLas4x, ufoLas4y, ufoLaser, 2, 1)
	End If
End Sub

Sub ShipCollision
  
	If (gameStart = True And collisionDetection = True) Then
		'Collision detection For line 0 of ship
		'Collision detection For UFO1. Dont need line 0 of UFO because line 0 of ship cannot touch it anyway.
		If (ufo1Exist = True) Then
			For a = 0 To 2
				If (shipx = ufo1x+a And shipy = ufo1y+1) Then '/Line 1
					ShipHit
				End If
			Next
			
			'Collision detection For line 1 of ship..................
			'Contains extra For Loop To Loop through all the ship line 1 pixels
			'Collision detection For UFO1
			For b = 0 To 1    'Had b < 2 And the collision detection worked but looked wonky when moving towards ufos
      
				For a = 0 To 2
        
					If (shipx+b = ufo1x+a And shipy+1 = ufo1y+1) Then     'Line 1
          
						ShipHit
					End If
				Next
           
				For a = 1 To 3
        
					If (shipx+b = ufo1x+a And shipy+1 = ufo1y) Then         'Line 0
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For line 0 of ship
		'collision detection For UFO2
		If (ufo2Exist = True)Then
			For a = 0 To 2
				If (shipx = ufo2x+a And shipy = ufo2y+1) Then '/Line
					ShipHit
				End If
			Next
			'Collision detection For line 1 of ship
			'Collision detection For UFO2
			For b = 0 To 1
      
				For a = 0 To 2
					If (shipx+b = ufo2x+a And shipy+1 = ufo2y+1) Then     'Line 1
          
						ShipHit
					End If
				Next
           
				For a = 1 To 3
        
					If (shipx+b = ufo2x+a And shipy+1 = ufo2y) Then         'Line 0
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For line 0 of ship
		'Collision detection For UFO3
		If (ufo3Exist = True) Then
    
      
			For a = 0 To 2
      
				If (shipx = ufo3x+a And shipy = ufo3y+1) Then '/Line 1
        
					ShipHit
				End If
			Next

			'Contains extra For Loop To Loop through all the ship line 1 pixels
			'Collision detection For UFO3
			For b = 0 To 1
      
				For a = 0 To 2
        
					If (shipx+b = ufo3x+a And shipy+1 = ufo3y+1)  Then    'Line 1
          
						ShipHit
					End If
				Next
           
				For a = 1 To 3
        
					If (shipx+b = ufo3x+a And shipy+1 = ufo3y) Then         'Line 0
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For line 0 of ship
		'Collision detection For Bouncer1. Don't need line 0 and 1 becuase line 0 and 1 of bouncers and line 0 of ship never meet
		If (bouncer1Exist = True) Then
    
			For a = 1 To 2
      
				If (shipx = bouncer1x+a And shipy = bouncer1y+2) Then 'Line 2
        
					ShipHit
				End If
			Next

			'Collision detection For Bouncer1 And Line 1 of ship
			For b = 0 To 1
      
				For a = 1 To 2
        
					If (shipx+b = bouncer1x+a And shipy+1 = bouncer1y) Then   'Line 0
          
						ShipHit
					End If
				Next
				For a = 0 To 2
        
					If (shipx+b = bouncer1x+a And shipy+1 = bouncer1y+1) Then       'Line 1
          
						ShipHit
					End If
				Next
				For a = 1 To 2
        
					If (shipx+b = bouncer1x+a And shipy+1 = bouncer1y+2) Then       'Line 2
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For line 0 of ship
		'Collision detection For Bouncer2. Don't need line 0 and 1 because line 0 and 1 of bouncers and line 0 of ship never meet
		If (bouncer2Exist = True) Then
    
     
			For a = 1 To 2
      
				If (shipx = bouncer2x+a And shipy = bouncer2y+2)  Then'Line 2
        
					ShipHit
				End If
			Next

			'Collision detection For Bouncer2 And Line 1 of ship
          
			For b = 0 To 1
      
				For a = 1 To 2
        
					If (shipx+b = bouncer2x+a And shipy+1 = bouncer2y) Then   'Line 0
          
						ShipHit
					End If
				Next
				For a = 0 To 2
        
					If (shipx+b = bouncer2x+a And shipy+1 = bouncer2y+1) Then       'Line 1
          
						ShipHit
					End If
				Next
				For a = 1 To 2
        
					If (shipx+b = bouncer2x+a And shipy+1 = bouncer2y+2) Then       'Line 2
          
						ShipHit
					End If
				Next
			Next
		End If


    
		'Collision detection for line 0 of ship
		'Collision detection for Bouncer3. Don't need line 0 and 1 becuase line 0 and 1 of bouncers and line 0 of ship never meet
		If (bouncer3Exist = True) Then
    
     
			For a = 1 To 2
      
				If (shipx = bouncer3x+a And shipy = bouncer3y+2) Then 'Line 2
        
					ShipHit
				End If
			Next

			'Collision detection for Bouncer3 and Line 1 of ship
			For b = 0 To 1
      
				For a = 1 To 2
        
					If (shipx+b = bouncer3x+a And shipy+1 = bouncer3y) Then   'Line 0
          
						ShipHit
					End If
				Next
				For a = 0 To 2
        
					If (shipx+b = bouncer3x+a And shipy+1 = bouncer3y+1) Then       'Line 1
          
						ShipHit
					End If
				Next
				For a = 1 To 2
        
					If (shipx+b = bouncer3x+a And shipy+1 = bouncer3y+2) Then       'Line 2
          
						ShipHit
					End If
				Next
			Next
		End If
    
		'Collision detection For line 0 of ship
		'Collision detection For Bouncer4. Don't need line 0 and 1 becuase line 0 and 1 of bouncers and line 0 of ship never meet
		If (bouncer4Exist = True) Then
			For a = 1 To 2
      
				If (shipx = bouncer4x+a And shipy = bouncer4y+2) Then 'Line 2
        
					ShipHit
				End If
			Next

			'Collision detection For Bouncer4 And Line 1 of ship
			For b = 0 To 1
      
				For a = 1 To 2
					If (shipx+b = bouncer4x+a And shipy+1 = bouncer4y) Then   'Line 0
						ShipHit
					End If
				Next
	
				For a = 0 To 2
					If (shipx+b = bouncer4x+a And shipy+1 = bouncer4y+1) Then       'Line 1
						ShipHit
					End If
				Next

				For a = 1 To 2
     
					If (shipx+b = bouncer4x+a And shipy+1 = bouncer4y+2) Then       'Line 2
						ShipHit
					End If
				Next
			Next

		End If

		'Dont need collision detection For lines 0 And 1 of LT And line 0 of ship because they cant touch anyway
		'Collision detection routines for LT
		If (ltExist = True) Then
    
      
			For a = 2 To 4            'Line 2
      
				If (shipx = ltx+a And shipy = lty+2) Then
        
					ShipHit
				End If
			Next

			'Collision detection routines for LT and Ship line 1
			For b = 0 To 2
      
				For a = 1 To 4            'Top line 0
        
					If (shipx+b = ltx+a And shipy+1 = lty) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 5            'Line 1
        
					If (shipx+b = ltx+a And shipy+1 = lty+1) Then
          
						ShipHit
					End If
				Next
				For a = 2 To 4            'Line 2
        
					If (shipx+b = ltx+a And shipy+1 = lty+2) Then
          
						ShipHit
					End If
				Next
			Next
		End If
    
		'Dont need collision detection between line 0 of ship And line 0 And 1 of fallers because they will never touch
		'Collision detection For Faller 1
		If (faller1Exist = True)Then
    
      
			For a = 0 To 3           'Line 2
      
				If (shipx = faller1x+a And shipy = faller1y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection For Faller 1 And ship line 1
			For b = 0 To 1
      
				For a = 0 To 2          'Top Line 0
        
					If (shipx+b = faller1x+a And shipy+1 = faller1y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 1
        
					If (shipx+b = faller1x+a And shipy+1 = faller1y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 2
        
					If (shipx+b = faller1x+a And shipy+1 = faller1y+2) Then
          
						ShipHit
					End If
				Next
			Next
		End If
    
		'Dont need collision detection between line 0 of ship And line 0 And 1 of fallers because they will never touch
		'Collision detection For Faller 2
		If (faller2Exist = True)Then
    
      
			For a = 0 To 3           'Line 2
      
				If (shipx = faller2x+a And shipy = faller2y+2) Then   'Checks to see if laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection for Faller 2 and ship line 1
			For b = 0 To 1
      
				For a = 0 To 2          'Top Line 0
        
					If (shipx+b = faller2x+a And shipy+1 = faller2y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 1
        
					If (shipx+b = faller2x+a And shipy+1 = faller2y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 2
        
					If (shipx+b = faller2x+a And shipy+1 = faller2y+2) Then
          
						ShipHit
					End If
				Next
			Next
		End If
		'Dont need collision detection between line 0 of ship And line 0 And 1 of fallers because they will never touch
		'Collision detection For Faller 3
		If (faller3Exist = True)Then
    
      
			For a = 0 To 3           'Line 2
      
				If (shipx = faller3x+a And shipy = faller3y+2) Then   'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection For Faller 3 And ship line 1
			For b = 0 To 1
      
				For a = 0 To 2          'Top Line 0
        
					If (shipx+b = faller3x+a And shipy+1 = faller3y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 1
        
					If (shipx+b = faller3x+a And shipy+1 = faller3y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 2
        
					If (shipx+b = faller3x+a And shipy+1 = faller3y+2)   Then
          
						ShipHit
					End If
				Next
			Next
		End If
		'Dont need collision detection between line 0 of ship And line 0 And 1 of fallers because they will never touch
		'Collision detection for Faller 4
		If (faller4Exist = True)Then
    
      
			For a = 0 To 3           'Line 2
      
				If (shipx = faller4x+a And shipy = faller4y+2) Then   'Checks to see if laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection for Faller 4 and ship line 1
			For b = 0 To 1
      
				For a = 0 To 2          'Top Line 0
        
					If (shipx+b = faller4x+a And shipy+1 = faller4y)  Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 1
        
					If (shipx+b = faller4x+a And shipy+1 = faller4y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 3           'Line 2
        
					If (shipx+b = faller4x+a And shipy+1 = faller4y+2)  Then
          
						ShipHit
					End If
				Next
			Next
		End If
		'Dont need collision detection between line 0 of ship and lines 0 and 1 of  risers because they'll never touch
		'Collision detection for Riser 1
		If (riser1Exist = True)Then
    
     
			For a = 0 To 1          'Line 2
            
				If (shipx = riser1x+a And shipy = riser1y+2) Then   'Checks to see if laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection for Riser 1 and Ship line 1
			For b = 0 To 1
      
				For a = 0 To 3           'Top Line 0
        
					If (shipx+b = riser1x+a And shipy+1 = riser1y)  Then
          
						ShipHit
					End If
				Next
				For a = 0 To 2           'Line 1
        
					If (shipx+b = riser1x+0 And shipy+1 = riser1y+1)  Then
          
						ShipHit
					End If
				Next
				For a = 0 To 1          'Line 2
              
					If (shipx+b = riser1x+a And shipy+1 = riser1y+2)   Then
          
						ShipHit
					End If
				Next
			Next
		End If
    
		'Dont need collision detection between line 0 of ship And lines 0 And 1 of  risers because they'll never touch
		'Collision detection For Riser 2
		If (riser2Exist = True)Then
    
      
			For a = 0 To 1          'Line 2
            
				If (shipx = riser2x+a And shipy = riser2y+2)  Then  'Checks To see If laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection For Riser 2 And Ship line 1
			For b = 0 To 1
      
				For a = 0 To 3           'Top Line 0
        
					If (shipx+b = riser2x+a And shipy+1 = riser2y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 2           'Line 1
        
					If (shipx+b = riser2x+0 And shipy+1 = riser2y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 1          'Line 2
              
					If (shipx+b = riser2x+a And shipy+1 = riser2y+2) Then
          
						ShipHit
					End If
				Next
			Next
		End If
		'Dont need collision detection between line 0 of ship And lines 0 And 1 of  risers because they'll never touch
		'Collision detection For Riser 3
		If (riser3Exist = True)Then
    
      
			For a = 0 To 1          'Line 2
            
				If (shipx = riser3x+a And shipy = riser3y+2) Then   'Checks to see if laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection for Riser 3 and Ship line 1
			For b = 0 To 1
      
				For a = 0 To 3           'Top Line 0
        
					If (shipx+b = riser3x+a And shipy+1 = riser3y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 2           'Line 1
        
					If (shipx+b = riser3x+0 And shipy+1 = riser3y+1) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 1          'Line 2
              
					If (shipx+b = riser3x+a And shipy+1 = riser3y+2) Then
          
						ShipHit
					End If
				Next
			Next
		End If
		'Dont need collision detection between line 0 of ship and lines 0 and 1 of  risers because they'll never touch
		'Collision detection for Riser 4
		If (riser4Exist = True)Then
    
      
			For a = 0 To 1          'Line 2
            
				If (shipx = riser4x+a And shipy = riser4y+2)  Then  'Checks to see if laser coords match bouncer bitmap coords, including the pixels just behind them.
        
					ShipHit
				End If
			Next

			'Collision detection for Riser 4 and Ship line 1
			For b = 0 To 1
      
				For a = 0 To 3           'Top Line 0
        
					If (shipx+b = riser4x+a And shipy+1 = riser4y) Then
          
						ShipHit
					End If
				Next
				For a = 0 To 2           'Line 1
        
					If (shipx+b = riser4x+0 And shipy+1 = riser4y+1)  Then
          
						ShipHit
					End If
				Next
				For a = 0 To 1          'Line 2
              
					If (shipx+b = riser4x+a And shipy+1 = riser4y+2)   Then
          
						ShipHit
					End If
				Next
			Next
		End If

		'No collision detection For line 0 of ship And boss because they'll never touch anyway.
		'Collision detection For Boss abd Ship line 1
		If (boss1Exist = True)Then
    
			For b = 0 To 1
				For a = 3 To 5        'Top line 0
					If (shipx+b = bossx+a And shipy+1 = bossy) Then
						ShipHit
					End If
				Next
	
				For a = 2 To 5          'Line 1
					If (shipx+b = bossx+a And shipy+1 = bossy+1) Then
						ShipHit
					End If
				Next
	
				For a = 1 To 6           'Line 2
					If (shipx+b = bossx+a And shipy+1 = bossy+2) Then
						ShipHit
					End If
				Next
	
				For a = 0 To 7           'Line 3
					If (shipx+b = bossx+a And shipy+1 = bossy+3) Then
						ShipHit
					End If
				Next
	
				For a = 2 To 6            'Line 4
					If (shipx+b = bossx+a And shipy+1 = bossy+4) Then
						ShipHit
					End If
				Next
	
				For a = 0 To 7            'Line 5
					If (shipx+b = bossx+a And shipy+1 = bossy+5) Then
						ShipHit
					End If
				Next
	
				For a = 1 To 6             'Line 6
					If (shipx+b = bossx+a And shipy+1 = bossy+6) Then
						ShipHit
					End If
				Next

				For a = 2 To 5             'Line 7
					If (shipx+b = bossx+a And shipy+1 = bossy+7) Then
						ShipHit
					End If
				Next
	
			Next
		End If
    
		'Collision detection for UFO Lasers. They only have line 0
		If (ufoLasExist1 = True)Then
    
      
			For a = 0 To 1
      
				If (shipx = ufoLas1x+a And shipy = ufoLas1y) Then '/Line 0
        
					ShipHit
				End If
			Next
			For b = 0 To 1
      
				For a = 0 To 1
        
					If (shipx+b = ufoLas1x+a And shipy+1 = ufoLas1y) Then '/Line 1
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For UFO Lasers. They only have line 0
		If (ufoLasExist2 = True)Then
    
      
			For a = 0 To 1
      
				If (shipx = ufoLas2x+a And shipy = ufoLas2y) Then '/Line 0
        
					ShipHit
				End If
			Next
			For b = 0 To 1
      
				For a = 0 To 1
        
					If (shipx+b = ufoLas2x+a And shipy+1 = ufoLas2y) Then '/Line 1
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For UFO Lasers. They only have line 0
		If (ufoLasExist3 = True)Then
    
      
			For a = 0 To 1
      
				If (shipx = ufoLas3x+a And shipy = ufoLas3y) Then '/Line 0
        
					ShipHit
				End If
			Next
			For b = 0 To 1
      
				For a = 0 To 1
        
					If (shipx+b = ufoLas3x+a And shipy+1 = ufoLas3y) Then '/Line 1
          
						ShipHit
					End If
				Next
			Next
		End If
		'Collision detection For UFO Lasers. They only have line 0
		If (ufoLasExist4 = True)Then
    
      
			For a = 0 To 1
      
				If (shipx = ufoLas4x+a And shipy = ufoLas4y) Then '/Line 0
        
					ShipHit
				End If
			Next
			For b = 0 To 1
      
				For a = 0 To 1
        
					If (shipx+b = ufoLas4x+a And shipy+1 = ufoLas4y) Then '/Line 1
          
						ShipHit
					End If
				Next
			Next
		End If
	End If
End Sub

Sub GameOver(gameStatus As Int)
	spawnEnabled = False
	If (gameStatus = 0) Then   'Game over due To death
		tape = "Game Over :( Your score was " & score
		'   // Ticker(True)
		tape = "UFO ATTACK!   - Press fire to start "
		lives = 5
		score = 0
		levelNumber = 1
	else if (gameStatus = 1) Then'Game over due To winning level 10
		tape = "Congratulations! You defeated the alien invasion :) Your total score was " & score
		'    //Ticker(True)
		lives = 5
		score = 0
		levelNumber = 1
	else if (gameStatus = 2) Then'Life lost
		tape = "Ship destroyed!  Lives left: " & lives
	End If

	ufo1Exist = False
	ufo2Exist = False
	ufo3Exist = False
	bouncer1Exist = False
	bouncer2Exist = False
	bouncer3Exist = False
	bouncer4Exist = False
	faller1Exist = False
	faller2Exist = False
	faller3Exist = False
	faller4Exist = False
	riser1Exist = False
	riser2Exist = False
	riser3Exist = False
	riser4Exist = False
	ltExist = False
	boss1Exist = False
	gameStart = False
	ufoLasExist1 = False
	ufoLasExist2 = False
	ufoLasExist3 = False
	ufoLasExist4 = False
	ufoLas1x = 34
	ufoLas1y = 34
	ufoLas2x = 34
	ufoLas2y = 34
	ufoLas3x = 34
	ufoLas3y = 34
	ufoLas4x = 34
	ufoLas4y = 34
	ufo1x = 34
	ufo2x = 34
	ufo3x = 34
	bouncer1x = 34
	bouncer2x = 34
	bouncer3x = 34
	bouncer4x = 34
	faller1x = 34
	faller2x = 34
	faller3x = 34
	faller4x = 34
	riser1x = 34
	riser2x = 34
	riser3x = 34
	riser4x = 34
	ltx = 34
	bossx = 34
	shipx = 0
	shipy = 3
	lasExist = False
  
	If (gameStatus = 2) Then
		Ticker(False)
	else if (gameStatus = 0 Or gameStatus = 1) Then
		Ticker(True)
	End If
End Sub

Sub ShipHit
	lives=lives-1
	If (lives > 0) Then
		GameOver(2)
	else if (lives <= 0) Then
		GameOver(0)
	End If
End Sub
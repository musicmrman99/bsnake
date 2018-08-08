' Program Notes                                                                                                                                                                             Program Notes
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' Windows version of program (Tested whith Windows 7 64-bit OEM - OEM shouldn't matter, 64-bit will)

' Bugs :
	' (Ref #Bug1) Snake randomly sepperates into (2 sections of head) and (the rest of the snake) when you quickly turn 180 degrees every so often - 
	' more likly earlier in game (1/15 - 1/20 chance approx.) a lot less likly in later game (1/120 chance approx.)
	'   \_ possibally a multikey() issue - pressing more than 1 key at a time

' Things to do :
	' Get Working :
		' Fixed (Ref #1) Log all output to another (terminal) screen - Initalisation
		' (Ref #2) Make all logged output go to another (terminal) screen after it has started (or restart screen with updated text)
		' (Ref #3) Make font larger so draw string (next line) fills the removed section of grid
		' (Ref #4) Find how to write lines to files / clear files contents / load files for reading
		
	' Add :
		' Windows and Linux Versions of game ("taskkill" / "kill", "start [program]" / "[program] &")
		'                                       ^win^      ^nix^        ^win^              ^nix^
		
		' Console and No Console Versions of game (add "-noconsole" as first command-line argument for No Console Version)
		'  \_ Console:
				' Send all text output to console
				' 
		
		'  \_ No Console:
				' Add "if CLOnoconsole=(0|1) then" into program
				' 

' Options
' --------------------------------------------------
#lang "fblite"
option gosub

' Command-Line Options (CLO = Command-Line Option)
' --------------------------------------------------
dim CLOnoconsole as byte = 0
dim CLOdeveloper as byte = 0
for clo as integer = 1 to 2
	if command(clo)="-noconsole" then CLOnoconsole=1 ' Do not show Controls/Log Output screen ; Do not allow use of the In-Game Command Line ("execute" gosub subroutine)
	if command(clo)="-developer" then CLOdeveloper=1 ' Show verbose output in Game Console ("BSnake.bas" - BSnake Host Console) / Game Log ("Controls and Log Output") ; Add extra indicators in-game
next clo

' Vars / Routines                                                                                                                                                                         Vars / Routines
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#include "file.bi" ' Built-in freebasic lib - file operation functions (open/close/read/write/ect...)
#include "BSnakeOrigVarsAlt.bi" ' Variables specific to this program - Original states/values

dim NLOS as integer = 20 ' Num Lines On Screen
sub redrawLogOutput()
	for ln=0 to NLOS-1 ' Line Number
		draw string (620,ln*10),LogOutput(NumLOLines-(1-NLOS)+ln),rgb(255,255,255)
	next ln
end sub

	'color rgb(255,255,255)
	'line (0,0)-(600,600), ,BF
	
sub OutputControls()
	NumLOLines += 12
	redim preserve LogOutput(NumLOLines)
	
	for co=0 to 11 ' Controls Output
		'draw string (620,OutYpos),ControlsOutput(co)
		'OutYpos+=10
		'print LogOutput(NumLOLines-(1+co))
		LogOutput((NumLOLines-1)-NLOS+co)=ControlsOutput(co)
	next co
	
	redrawLogOutput()
end sub

sub addToLogOutput(add2out as string)
	NumLOLines+=1
	redim preserve LogOutput(NumLOLines) as string
	LogOutput(NumLOLines-1)=add2out
	
	redrawLogOutput()
end sub

' Initialisation                                                                                                                                                                           Initialisation
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLOnoconsole=0 then
	screenres graphwidth+600,graphheight, 32, 2
else
	screenres graphwidth,graphheight, 32, 2
end if
screenset 1,0

if CLOnoconsole=0 then
	OutputControls()
	addToLogOutput("Press(schr)space(schr)to(schr)continue...") : screencopy : sleep
end if

' Pre-Loop                                                                                                                                                                                       Pre-Loop
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Restart:
fullrestart=1
gosub ResetVars
do
	if nkpakp=0 then
		if multikey(57) then goto Begin ' " " Key
		if multikey(16) then ' "Q" Key
			if loggame=1 and CLOnoconsole=0 then                                              ' --fix- (ref #2) -fix--
					outputchange=1
					addToLogOutput("-(schr)Quit(schr)Game")
			end if
			
			end
		end if
		if CLOnoconsole=0 then
			if multikey(18) then gosub Execute ' "E" Key
		end if
	end if
   
   nkpakp=0
	for i=1 to 127
		if multikey(i) then nkpakp=1
	next i
	
   ' Main Graphics
   ' --------------------------------------------------
   
   ' Background ----------
   'line (0,0)-step(graphwidth,graphheight),rgb(150,255,0), BF
   line (10,40)-step(580,380),rgb(150,255,0), BF
   
   ' Grid ----------
   color rgb(100,100,100)
   for i=1 to 28
      line ((20*i)+10,40)-((20*i)+10,420) ' Vertical
   next i
   for i=1 to 18
      line (10,(20*i)+40)-(590,(20*i)+40) ' Horizontal
   next i
   
   ' Remove Middle 3 Lines From Grid ----------
   line (60,210)-step(480,60),rgb(150,255,0), BF
   
   ' Text ----------
   '--> font "Tahoma",32,20                                            --fix- (ref #3) -fix--
   '--> draw string (80,183),"Press Space To Begin",rgb(255,80,50)     --fix- (ref #3) -fix--
   draw string (220,235),"Press Space To Begin",rgb(255,80,50)
   
   ' Settings Graphics (no console)
   ' --------------------------------------------------
   if CLOnoconsole=1 then
		' Background ----------
		line (10,40)-(590,80),rgb(60,60,60),BF
		
		' Indicators ----------
		if CLOdeveloper=1 then
			draw string (20,55),"Speed (1-5) = "+str(snakeSpeed)+" (SSEV="+str(SSEV)+")",rgb(180,180,180)
		else
			draw string (20,55),"Speed (1-5) = "+str(snakeSpeed),rgb(180,180,180)
		end if
		'draw string (180,55),""+str()
		
		' Controls ----------
		if multikey(2) then snakeSpeed=1 : SSEV=int(15*(snakeSpeed^-1)+3) ' (multikey(2) = '1' key above 'qwerty')
		if multikey(3) then snakeSpeed=2 : SSEV=int(15*(snakeSpeed^-1)+3) ' (multikey(3) = '2' key above 'qwerty')
		if multikey(4) then snakeSpeed=3 : SSEV=int(15*(snakeSpeed^-1)+3) ' (multikey(4) = '3' key above 'qwerty')
		if multikey(5) then snakeSpeed=4 : SSEV=int(15*(snakeSpeed^-1)+3) ' (multikey(5) = '4' key above 'qwerty')
		if multikey(6) then snakeSpeed=5 : SSEV=int(15*(snakeSpeed^-1)) ' (multikey(6) = '5' key above 'qwerty')
   end if
   
	' Title Bars / Boxes
	color rgb(0,0,0)
	line (0,0)-(600,40), ,BF ' top
	line (0,0)-(10,440), ,BF ' left
	line (590,0)-(600,440), ,BF ' right
	line (0,420)-(600,440), ,BF ' right
	
	color rgb(230,230,230)
	line (3,8)-(597,27), ,BF ' top
	line (3,20)-(4,425), ,BF ' left
	line (596,20)-(597,425), ,BF ' right
	line (3,426)-(597,427), ,BF ' bottom
	
	'line (300,0)-step(0,50)
	draw string (255,14),"Game Window",rgb(50,50,50)
	
   screencopy
   sleep 2,1
loop

Begin:
while multikey(57) ' relese " " before the program moves on
wend

if loggame=1 and CLOnoconsole=0 then                                                    ' --fix- (ref #2) -fix--
	NumLOLines+=1
	outputchange=1
	addToLogOutput("-(schr)Begin")
end if 

' Main Loop                                                                                                                                                                                    Main Loop
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do
	' Keyboard Controls ----------
	nkpakp=0
	for i=1 to SSEV*2 ' 18/10/8/6/3
		if nkpakp=0 then
			if multikey(17) and not direct(0)="up" and not direct(0)="down" then ' "W" Key
				direct(0)="up"
				setOff=1
				nkpakp=1
			end if
			if multikey(30) and not direct(0)="left" and not direct(0)="right" then ' "A" Key
				direct(0)="left"
				setOff=1
				nkpakp=1
			end if
			if multikey(31) and not direct(0)="up" and not direct(0)="down" then ' "S" Key
				direct(0)="down"
				setOff=1
				nkpakp=1
			end if
			if multikey(32) and not direct(0)="left" and not direct(0)="right" then ' "D" Key
				direct(0)="right"
				setOff=1
				nkpakp=1
			end if
		end if
		
		if multikey(16) then ' "Q" Key
			if loggame=1 then                                           ' --fix- (ref #2) -fix--
				if CLOnoconsole=0 then
					addToLogOutput("-(schr)Quit(schr)Game")
				end if
			end if
			
			end
		end if
		if multikey(19) then ' "R" Key
			if loggame=1 then                                           ' --fix- (ref #2) -fix--
				if CLOnoconsole=0 then
					addToLogOutput("-(schr)Restart(schr)Game")
				end if
			end if
			
			score=0
			collisions=0
			timeval=0
			goto Restart
		end if
		if multikey(57) then ' " " (Space) Key
			gosub PauseGame
			while multikey(57) ' relese " " before the program moves on
			wend
		end if
		if CLOnoconsole=0 then
			if multikey(18) then gosub Execute ' "E" Key
		end if
		sleep 5,1
   next i
   
   ' Snake Movement ----------
   for i=0 to snakeLength-1
      if direct(i)="up" then snakeY(i)=snakeY(i)-1
      if direct(i)="left" then snakeX(i)=snakeX(i)-1
      if direct(i)="down" then snakeY(i)=snakeY(i)+1
      if direct(i)="right" then snakeX(i)=snakeX(i)+1
   next i
   
   ' ----->> COME BACK TO HERE <<-----
   
   ' Array Shift To Bend Snake -----
   for i=0 to snakeLength
      if setOff=1 and bend(i)<0 then
         bend(i)=bend(i)+1
         setOff=0
      end if
   next i
   
   for i=0 to snakeLength
      if bend(i)<snakeLength-1 and bend(i)>-1 then
         direct(bend(i)+1)=direct(bend(i))
         bend(i)=bend(i)+1
      else
         bend(i)=-1
      end if
   next i
   
   ' ----->> UP TO HERE <<-----
   
   ' Background ----------
   line (10,40)-step(580,380),rgb(150,255,0), BF
   
   ' Lengthen Snake Block (Apple) ----------
   line (gridX(randBlockX)-9,gridY(randBlockY)-9)-step(19,19),rgb(200,40,40), BF
   if snakeX(0)=randBlockX and snakeY(0)=randBlockY then
      gosub ResizeSnake
   end if
   
   ' Snake Graphics / Collision ----------
   if snakeX(0)>(ubound(gridX)-1) or snakeX(0)<(gridX(0)/20)-1 or snakeY(0)>(ubound(gridY)-12) or snakeY(0)<(gridY(0)/20)-3 then
      gosub Collision
      goPause=1
      goto Begin
   end if
   
   for i=1 to snakeLength-1
      if snakeX(0)=snakeX(i) and snakeY(0)=snakeY(i) then
         gosub Collision
         goPause=1
         goto Begin
      end if
   next i
   
   for i=0 to snakeLength-1
      color rgb(20,20,240) ' Original Blocks
      if i>(SLDefault-1) and i<(SLDefault-1)+(collisions*2)+1 then color rgb(255,100,20) ' Collision Penalty Blocks
      if i>(SLDefault-1)+(collisions*2) then color rgb(40,60,200) ' Score Blocks
      line (gridX(snakeX(i))-9,gridY(snakeY(i))-9)-step(19,19), , BF
   next i
   
   ' Grid ----------
   color rgb(100,100,100)
   for i=1 to 28
      line ((20*i)+10,40)-((20*i)+10,420) ' Vertical
   next i
   for i=1 to 18
      line (10,(20*i)+40)-(590,(20*i)+40) ' Horizontal
   next i
   
   ' Score / Time ----------
   color rgb(0,0,0)
   line (380,410)-(600,420), , BF
   
   timeval=timeval+1
   totalScore=score-(collisions*20)-int(timeval/8)
   
	' "Score = "+str(score)+" - "+str(collisions*20)+" - "+str(int(timeval/8))+" = "+str(totalScore),rgb(240,240,240)
	draw string (390,415),"Score = "+str(score),rgb(240,240,240)
	draw string (470,415)," - "+str(collisions*20),rgb(240,240,240)
	draw string (510,415)," - "+str(int(timeval/8)),rgb(240,240,240)
	draw string (550,415)," = "+str(totalScore),rgb(240,240,240)
	
	' Title Bars / Boxes
	color rgb(0,0,0)
	'line (0,0)-(600,40), ,BF ' top
	'line (0,0)-(10,600), ,BF ' left
	'line (590,0)-(600,600), ,BF ' right
	'line (0,590)-(600,600), ,BF ' right
	
	line (0,0)-(600,40), ,BF ' top
	line (0,0)-(10,440), ,BF ' left
	line (590,0)-(600,440), ,BF ' right
	line (0,420)-(600,440), ,BF ' right

	color rgb(230,230,230)
	line (3,8)-(597,27), ,BF ' top
	line (3,20)-(4,425), ,BF ' left
	line (596,20)-(597,425), ,BF ' right
	line (3,426)-(597,427), ,BF ' bottom
	
	'line (300,0)-step(0,50)
	draw string (255,14),"Game Window",rgb(50,50,50)
	
	'Refresh Screen ----------
	screencopy
	
	'if snakeSpeed=4 or snakeSpeed=5 and goPause=1 then
	'	gosub PauseGame
	'	goPause=0
	'end if
	
	'If (ScreenEvent(@e)) Then
	'	Select Case e.type
	'	
	'	Case EVENT_WINDOW_CLOSE ' user closed the window
	'		Exit Do ' exit to end of program
	'	End Select
	'End If
loop

'end

' Subroutines                                                                                                                                                                                 Subroutines
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

' Resize Snake (ReDim Array Vars)
' --------------------------------------------------
ResizeSnake:
snakeLength=snakeLength+1
randomize
randBlockX=int(rnd*28)
randBlockY=int(rnd*18)

if loggame=1 then                                                    ' --fix- (ref #2) -fix--
	if CLOnoconsole=0 then
		addToLogOutput("- Apple ("+str(snakeLength)+")")
	end if
end if

redim preserve as integer bend(snakeLength+1)
bendSize=snakeLength
bend(bendSize)=-1

' Snake Position / Direction / Bend Positions ----------
redim preserve as integer snakeX(snakeLength)
redim preserve as integer snakeY(snakeLength)
redim preserve as string direct(snakeLength)
snakeXSize=snakeLength-1
snakeYSize=snakeLength-1
directSize=snakeLength-1

if direct(directSize-1)="up" then
   snakeX(snakeXSize)=snakeX(snakeXSize-1)
   snakeY(snakeYSize)=snakeY(snakeYSize-1)+1
end if
if direct(directSize-1)="left" then
   snakeX(snakeXSize)=snakeX(snakeXSize-1)+1
   snakeY(snakeYSize)=snakeY(snakeYSize-1)
end if
if direct(directSize-1)="down" then
   snakeX(snakeXSize)=snakeX(snakeXSize-1)
   snakeY(snakeYSize)=snakeY(snakeYSize-1)-1
end if
if direct(directSize-1)="right" then
   snakeX(snakeXSize)=snakeX(snakeXSize-1)-1
   snakeY(snakeYSize)=snakeY(snakeYSize-1)
end if
direct(directSize)=direct(directSize-1)

if comResizeSnake=0 then score=score+10
return

' Resize Snake Smaller (ReDim Array Vars)
' --------------------------------------------------
ResizeSnakeSmaller:
snakeLength=snakeLength-1

if loggame=1 then                                                    ' --fix- (ref #2) -fix--
	if CLOnoconsole=0 then
		NumLOLines+=1
		outputchange=1
		addToLogOutput("- Apple ("+str(snakeLength)+")")
	end if
end if

redim as integer bend(snakeLength+1)
redim as integer snakeX(snakeLength)
redim as integer snakeY(snakeLength)
redim as string direct(snakeLength)
return

' Bounding Box / Snake Collision
' --------------------------------------------------
Collision:
collisions=collisions+1

if loggame=1 then                                                    ' --fix- (ref #2) -fix--
	if CLOnoconsole=0 then
		NumLOLines+=1
		outputchange=1
		addToLogOutput("- Collide ("+str(collisions)+")")
	end if
end if 

if collisions=5 then
	if CLOnoconsole=0 then                                            ' --fix- (ref #2) -fix--
		addToLogOutput("")
	end if
	if CLOnoconsole=0 then                                            ' --fix- (ref #2) -fix--
		addToLogOutput("You Lose :(")
	end if
	if loggame=1 then                                                 ' --fix- (ref #2) -fix--
		if CLOnoconsole=0 then
			NumLOLines+=1
			outputchange=1
			addToLogOutput("""Score = "+str(score)+" - "+str(collisions*20)+" - "+str(timeval/8)+" = "+str(totalScore)+"""")
		end if
	end if
   
   collisions=0
   goto Restart
end if
gosub ResetVars
return

' Reset Vars
' --------------------------------------------------
ResetVars:
snakeLength=SLDefault+(collisions*2)

if fullrestart=1 then
   snakeLength=SLDefault
   fullrestart=0
end if

redim as integer bend(snakeLength+1)
redim as integer snakeX(snakeLength)
redim as integer snakeY(snakeLength)
redim as string direct(snakeLength)

for i=0 to snakeLength
   bend(i)=-1
next i
for i=0 to snakeLength-1
   snakeX(i)=15
   snakeY(i)=18+i
   direct(i)="up"
next i
return

' Pause Game
' --------------------------------------------------
PauseGame:
gosub PausedGraphics
while multikey(57) ' relese " " before the program moves on
wend

if loggame=1 then                                                    ' --fix- (ref #2) -fix--
	if CLOnoconsole=0 then
		addToLogOutput("- Game Paused")
	end if
end if

do
   ' Space/Enter
   if multikey(57) then
		if loggame=1 then                                              ' --fix- (ref #2) -fix--
			if CLOnoconsole=0 then
				addToLogOutput("- Game Unpaused")
			end if
		end if 
		
      return
   end if
   ' W/UpArrow
   if multikey(17) and not direct(0)="up" and not direct(0)="down" then
		if loggame=1 then                                              ' --fix- (ref #2) -fix--
			if CLOnoconsole=0 then
				addToLogOutput("- Game Unpaused")
			end if
		end if 
		
      direct(0)="up"
      setOff=1
      return
   end if
   ' A/LeftArrow
   if multikey(30) and not direct(0)="left" and not direct(0)="right" then
		if loggame=1 then                                              ' --fix- (ref #2) -fix--
			if CLOnoconsole=0 then
				addToLogOutput("- Game Unpaused")
			end if
		end if 
		
      direct(0)="left"
      setOff=1
      return
   end if
   ' S/DownArrow
   if multikey(31) and not direct(0)="down" and not direct(0)="up" then
		if loggame=1 then                                              ' --fix- (ref #2) -fix--
			if CLOnoconsole=0 then
				addToLogOutput("- Game Unpaused")
			end if
		end if 
		
      direct(0)="down"
      setOff=1
      return
   end if
   ' D/RightArrow
   if multikey(32) and not direct(0)="right" and not direct(0)="left" then
		if loggame=1 then                                              ' --fix- (ref #2) -fix--
			if CLOnoconsole=0 then
				NumLOLines+=1
				outputchange=1
				addToLogOutput("- Game Unpaused")
			end if
		end if 
		
      direct(0)="right"
      setOff=1
      return
   end if
   
   if CLOnoconsole=0 then
		if multikey(18) then gosub Execute ' "E" Key
   end if
loop

' Paused Graphics
' --------------------------------------------------
PausedGraphics:
color rgb(0,0,0)
line (0,380)-step(80,20), , BF

'--> font "Tahoma",12,0                                                --fix- Put in the right place -fix--
color rgb(240,240,240)
draw string (14,380),"Paused"
return

' Execute A Program Command                                                                                                                                                     Execute A Program Command
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Execute:

' OLD VERSION:
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

' /----------------------------------------------------------------------------------------------------\ --fix- (ref #1) -fix--
if CLOnoconsole=0 then
	
	gosub PausedGraphics
	
	screenres 650,350
	input "> ", commandexec
	commandexec=lcase(commandexec)
	
	if commandexec>"" then
		' Output In-Game Commands (Primary)
		' --------------------------------------------------
		if lcase(commandexec)="commandlist" or lcase(commandexec)="cl" then
			print
			print "In-Game Command Line Commands (Capitals aren't nessesary):"
			print "   (CommandList) or (cl) = Print list of In-Game Commands"
			print
			print "   (Log) or (l) = Turn simple game log output on or off"
			print
			print "   (LogQuit) or (lq) = Log the simple game log to the specified file, then quit the game"
			print "     ^^ Input Filename ^^"
			print
			print "   (SnakeLength) or (sl) = Change Snake length to the specified value"
			print "     ^^ Input Value ^^"
			print
			print "   (SnakeSpeed) or (ss) = Change the speed of the snake, Virtually synonomous with dificulty level (3 is standard)"
			print "     ^^ Input Speed Level ^^"
			print
		end if
		
		' Log Game Log To Specified File (Primary)
		' --------------------------------------------------
		if left(lcase(commandexec),7)="logquit" or left(lcase(commandexec),2)="lq" then
			input "  > ",logquitfile
			if logquitfile>"" and fileexists(logquitfile)<>0 then
				open logquitfile for output as 0
				' -o = Overwrite Output file ----------
				if instr(lcase(commandexec)," -o") then reset
				'--> writeline "this is 1 line"                          ' --fix- (ref #4) -fix--
				'--> writeline "this is 2 line"                          ' --fix- (ref #4) -fix--
				'--> writeline "this is last line"                       ' --fix- (ref #4) -fix--
				close
				
				if loggame=1 then                                        ' --fix- (ref #2) -fix--
					if CLOnoconsole=0 then
						NumLOLines+=1
						outputchange=1
						addToLogOutput("- Logged Score and Quit Program")
					end if
				end if
				
				end
			end if
		end if
		
		' Output Game Log To Text Output (Primary)
		' --------------------------------------------------
		if lcase(commandexec)="log" or lcase(commandexec)="l" then
			if loggame=0 then
				loggame=1
				print "- Game Log On"
			else
				loggame=0
				print "- Game Log off"
			end if
		end if
		
		' Set Value For Variable (Primary)
		' --------------------------------------------------
		if left(commandexec,7)="setval " then
			commandexec=ltrim(commandexec, "setval ")
			
			' Change Length Of Snake (Secondary)
			' --------------------------------------------------
			if commandexec="snakelength" or commandexec="sl" then
				input "  > ", newSnakeLength
				if newSnakeLength>0 then
					if newSnakeLength>snakeLength then
						for i=snakeLength to newSnakeLength-1
							comResizeSnake=1
							gosub ResizeSnake
							comResizeSnake=0
						next i
					else
						for i=newSnakeLength to snakeLength-1
							gosub ResizeSnakeSmaller
						next i
					end if
				end if
			end if
			
			' Change Speed Of Snake (Dificulty) (Secondary)
			' --------------------------------------------------
			if lcase(commandexec)="snakespeed" or lcase(commandexec)="ss" then
				input "  > ",newSnakeSpeed
				if newSnakeSpeed>0 then snakeSpeed=newSnakeSpeed
			end if
		end if
	end if
	
	print "Press Space to continue"
	gosub PauseGame

	screen 1,24,2
	screenres graphwidth,graphheight, 24, 2
	screenset 1,0
	return
end if
' \----------------------------------------------------------------------------------------------------/ --fix-


' NEW VERSION:
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

' /----------------------------------------------------------------------------------------------------\ --fix- (ref #1) -fix--
if CLOnoconsole=0 then
	
	gosub PausedGraphics
	
	screenres 650,350
	input "> ", commandexec
	commandexec=lcase(commandexec)
	
	if commandexec>"" then
		' (Primary)   = Primary command - Can me executed on its own
		' (Secontary) = Secondary command - Executed as first Command-Line Argument
		' 
		
		' Output In-Game Commands (Primary)
		' --------------------------------------------------
		if lcase(commandexec)="commandlist" or lcase(commandexec)="cl" then
			print
			print "In-Game Command Line Commands (Capitals aren't nessesary):"
			print "   ""CommandList"" or ""cl"" : Print list of In-Game Commands"
			print
			print "   ""Log"" or ""l"" : Turn simple game log output on or off"
			print
			print "   ""LogQuit"" or ""lq"" : Log the simple game log to the specified file, then quit the game"
			print "      [-o] : Overwrite file's current contents (optional)"
			print
			print "   ""SetVal"" or ""sv"" : Set a variable value"
			print "      ""SnakeLength"" or ""sl"" : Change Snake length to the specified value"
			print "         [Value] : Value to set the Variable ""snakeLength"" to (Required)"
			print
			print "      ""SnakeSpeed"" or ""ss"" : Change the speed of the snake, Virtually synonomous with dificulty level (3 is standard)"
			print "         [Value] : Value to set the Variable ""snakeSpeed"" to (Required)"
			print
		end if
		
		' Log Game Log To Specified File (Primary)
		' --------------------------------------------------
		if left(lcase(commandexec),7)="logquit" or left(lcase(commandexec),2)="lq" then
			input "  > ",logquitfile
			if logquitfile>"" and fileexists(logquitfile)<>0 then
				open logquitfile for output as 0
				' -o = Overwrite Output file ----------
				if instr(lcase(commandexec)," -o") then reset
				'--> writeline "this is 1 line"                          ' --fix- (ref #4) -fix--
				'--> writeline "this is 2 line"                          ' --fix- (ref #4) -fix--
				'--> writeline "this is last line"                       ' --fix- (ref #4) -fix--
				close
				
				if loggame=1 then                                        ' --fix- (ref #2) -fix--
					if CLOnoconsole=0 then
						NumLOLines+=1
						outputchange=1
						addToLogOutput("- Logged Score and Quit Program")
					end if
				end if
				
				end
			end if
		end if
		
		' Output Game Log To Text Output (Primary)
		' --------------------------------------------------
		if lcase(commandexec)="log" or lcase(commandexec)="l" then
			if loggame=0 then
				loggame=1
				print "- Game Log On"
			else
				loggame=0
				print "- Game Log off"
			end if
		end if
		
		' Set Value For Variable (Primary)
		' --------------------------------------------------
		if left(commandexec,7)="setval " then
			commandexec=ltrim(commandexec, "setval ")
			
			' Change Length Of Snake (Secondary)
			' --------------------------------------------------
			if commandexec="snakelength" or commandexec="sl" then
				input "  > ", newSnakeLength
				if newSnakeLength>0 then
					if newSnakeLength>snakeLength then
						for i=snakeLength to newSnakeLength-1
							comResizeSnake=1
							gosub ResizeSnake
							comResizeSnake=0
						next i
					else
						for i=newSnakeLength to snakeLength-1
							gosub ResizeSnakeSmaller
						next i
					end if
				end if
			end if
			
			' Change Speed Of Snake (Dificulty) (Secondary)
			' --------------------------------------------------
			if lcase(commandexec)="snakespeed" or lcase(commandexec)="ss" then
				input "  > ",newSnakeSpeed
				if newSnakeSpeed>0 then snakeSpeed=newSnakeSpeed
			end if
		end if
	end if
	
	print "Press Space to continue"
	gosub PauseGame

	screen 1,24,2
	screenres graphwidth,graphheight, 24, 2
	screenset 1,0
	return
end if
' \----------------------------------------------------------------------------------------------------/ --fix-

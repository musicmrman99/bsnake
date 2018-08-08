' Built-in freebasic lib - for some graphics defenitions
#include "fbgfx.bi"

' use FB namespace for easy access to types/constants
'Using FB

Dim e As EVENT

' Global
' ----------------------------------------------------------------------------------------------------
dim i as integer
dim fullrestart as integer

const graphwidth as integer = 600
const graphheight as integer = 440
dim as byte frompage = 1
dim as byte topage = 0

' User Set
' ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
dim loggame as integer = 1 ' Log The Game At Start
dim SLDefault as integer = 3 ' Snake Length Default (Normally 3 | Maximum 17)
dim snakeLength as integer = SLDefault ' -- Do not change --
dim snakeSpeed as integer = 2 ' Starting Snake Speed
dim SSEV as integer = int(15*(snakeSpeed^-1)+3) ' Snake Speed Exact Value (how many times the for loop loops)
' ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

' Components Of Total Score
' ----------------------------------------------------------------------------------------------------
dim totalScore as integer = 0
dim score as integer = 0
dim collisions as integer = 0
dim timeval as integer = 0

' Snake Position / Direction / Bend Positions
' ----------------------------------------------------------------------------------------------------
dim bendSize as integer = snakeLength+6
dim bend(bendSize) as integer
for i=0 to bendSize-1
   bend(i)=-1
next i

dim snakeXSize as integer = snakeLength
dim snakeYSize as integer = snakeLength
dim directSize as integer = snakeLength
dim snakeX(snakeXSize) as integer
dim snakeY(snakeYSize) as integer
dim direct(directSize) as string
for i=0 to snakeLength-1
   snakeX(i)=14
   snakeY(i)=18+i
   direct(i)="up"
next i

' Grid Positions
' ----------------------------------------------------------------------------------------------------
dim gridX(29) as integer
dim gridY(30) as integer
for i=0 to 28
   gridX(i)=(20*i)+20
   'gridY(i)=(20*i)+50
   if i<19 then gridY(i)=(20*i)+50
next i

' Other
' ----------------------------------------------------------------------------------------------------
randomize
dim goPause as byte = 0 ' pause after you crash on dificulty level (snakeSpeed) 4 and 5
dim setoff as integer = 0
dim commandexec as string = ""
dim comResizeSnake as integer = 0
dim randBlockX as integer = int(rnd*28)
dim randBlockY as integer = int(rnd*18)

dim nkpakp as byte = 0 ' No Key Press After Key Press - to fix a bug VVVVV
' example: if you are facing up and you press "A" to go left, and then press "S" very quickly afterwards, 
' you will colide with your snake because after pressing "A" the snake's head direction = left 
' that makes

' Logging Output
' ----------------------------------------------------------------------------------------------------
dim logquitfile as string
dim shared OutYpos as integer ' Output Y Position - Y pos on screen to output text

dim shared ControlsOutput(12) as string
ControlsOutput(0)="Controls:"
ControlsOutput(1)="  (W/A/S/D) or (Arrow Keys) to turn the Snake"
ControlsOutput(2)="  (Q) to quit game"
ControlsOutput(3)="  (R) to restart game"
ControlsOutput(4)="  (Space) to pause game"
ControlsOutput(5)="  (E) to pause game and open the In-Game Command Line"
ControlsOutput(6)="Game Conceps:"
ControlsOutput(7)="  Score = (Apples x 10) - (Collisions x 20) - (Time / 8) = Total Score"
ControlsOutput(8)="  Coliding with walls or your Snake adds 2 blocks to your Snake and resets its position"
ControlsOutput(9)=""
ControlsOutput(10)="See all In-Game Commands with the command: (CommandList) or (cl)"
ControlsOutput(11)=""

dim shared NumLOLines as integer = 0 ' Number of Log Output Lines
if loggame=1 then NumLOLines=2

dim shared LogOutput(NumLOLines) as string ' Line By Line Log Output
if loggame=1 then LogOutput(0)="- Snake Default Length ("+str(SLDefault)+")"
if loggame=1 then LogOutput(1)=""

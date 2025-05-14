;**************************Final Project Spring 2025*********************************
;This is a little animation of a car driving that hits some debris
;R0 unused
;R1 keeps track of which car image im working with
;R2 temp calculations/loading
;R3 keeps track of the loop count for printing roads
;R4 keeps track of how many main loops we have gone through
;R5 unused
;R6 keeps track of which loop we are currently in
;R7 keeps track of 
.orig x3000

reset  
    ; AND R3,R3,#0
    ; ADD R3,R3,#4 ; the number i will modulo by "%4"
    ; AND R1,R1,#0
    AND R4,R4,#0
    ADD R4,R4,#3 ;controls how many big loops go 
MainLoop
    AND R3,R3,#0
    LD R2,roadLoopStart ;just before the loop starts i am using R2 to load the start position for the loop
    ADD R3,R3,R2 ;keeps track of the loop count for road printing
    AND R1,R1,#0 ; resets which car i am calling
    
    JSR Clear
    JSR roadLoopF ;prints the beginning roads
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction ;print the road with the car on it
    ADD R3,R3,#15
    ADD R3,R3,#9
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#-15
    ADD R3,R3,#-4
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#14
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#-9
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#4
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#1
    JSR roadLoopF
    ADD R1,R1,#-1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-6
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#11
    JSR roadLoopF
    ADD R1,R1,#-1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-16
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#15
    ADD R3,R3,#6
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-16
    ADD R3,R3,#-10
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#15
    ADD R3,R3,#15
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-16
    ADD R3,R3,#-16
    JSR roadLoopF
    JSR Pause
    
    ADD R4,R4,#-1
    BRnz finishScene ;will jump to the end scene after 3 iterations

    BR MainLoop ;will continue the main loop unless its been long enough and we want to go the end scene
    
finishScene
    JSR toEndScreen
    
finish    Halt
mainSaveR7 .BLKW 1
roadLoopStart .fill #3
roadLoopHelper .fill #20

;**************************PrintFunction*********************************
;R7 saved for return value
PrintFunction
    ST R7,PrintSaveR7
    TRAP x22
    LD R7,PrintSaveR7
    RET
PrintSaveR7 .BLKW 1
;**************************RoadLoop*********************************
;R0 loads address of the road to print
;R3 decrements to keep track of how many road segments need printed
;R7 saved for return value
roadLoopF
    ST R0,roadLoopSaveR0
    ST R3,roadLoopSaveR3
    ST R7,roadLoopSaveR7
    ADD R3,R3,#0
    BRz returnFromRoadLoop
roadLoop
    LEA R0,road
    JSR PrintFunction
    ADD R3,R3,#-1
    BRp roadLoop
returnFromRoadLoop    
    LD R0,roadLoopSaveR0
    LD R3,roadLoopSaveR3
    LD R7,roadLoopSaveR7
    RET
roadLoopSaveR0 .blkw 1    
roadLoopSaveR3 .blkw 1
roadLoopSaveR7 .blkw 1
road .stringz "   |                             |\n"
;*****************************Pause******************************
;R1 keeps track of a time counter so that i can iterate decrementing it to have a nice long ish pause
Pause
    ST R1,PauseSaveR1
    LD R1,PauseCount
PauseLoop    
    ADD R1,R1,#-1
    BRp PauseLoop
    
    LD R1,PauseSaveR1
    RET
    
PauseSaveR1 .blkw 1
PauseCount .fill x4000
;*****************************Clear******************************
;R0 holds address of a clearing page
;R7 holds return address
Clear
    ST R0,ClearSaveR0
    ST R7,ClearSaveR7
    LEA R0,clearRoad
    TRAP x22
    ST R0,ClearSaveR0
    LD R7,ClearSaveR7
    RET
clearRoad .stringz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
ClearSaveR7 .blkw 1
ClearSaveR0 .blkw 1

;**************************getCar*********************************
;R0 loads the car into R0 to display back in main
;R1 used to ensure that i have the correct car from mains interaction with R1
;R7 saved for return value
getCar
    ST R1,getCarSaveR1
    ST R7,getCarSaveR7
    ADD R1,R1,#-1
    BRz Car1
    ADD R1,R1,#-1
    BRz Car2
    ADD R1,R1,#-1
    BRz Car3
Car3   
    JSR getCar3 
    BR returnCar    
Car2    
    JSR getCar2 
    BR returnCar
car1
    LEA R0,bigCar1
    BR returnCar
returnCar   
    LD R1,getCarSaveR1
    LD R7,getCarSaveR7
    RET
    
getCarSaveR1 .BLKW 1    
getCarSaveR7 .BLKW 1

; upCar1 .stringz "|    _               |\n|  {`-`{             | \n|  (==(|             | \n|  { _ {             | \n|  _/_\_             | \n"
;up car looks like this:
;|    _            |
;|  {`-`{          |
;|  (==(|          |
;|  { _ {          |
;|  _/_\_          |
; upCar2 .stringz "|        _           |\n|      {`-`{         | \n|      (==(|         | \n|      { _ {         | \n|      _/_\_         | \n"
;up car looks like this:
;|      _          |
;|    {`-`{        |
;|    (==(|        |
;|    { _ {        |
;|    _/_\_        |
; upCar3 .stringz "|            _       |\n|          {`-`{     | \n|          (==(|     | \n|          { _ {     | \n|          _/_\_     | \n"
;up car looks like this: 
;|        _        |
;|      {`-`{      |
;|      (==(|      |
;|      { _ {      |
;|      _/_\_      |


bigCar1 .stringz "   |  ______________             |\n   |  \_____________\            |\n   |    __\\__//__                |\n   |    |        | '\            |\n   |    |________|   /=\         |\n   |   /_______ / \ |   |        |\n   |  |        |  .\ \=/         |\n   |  |        |___| |           |\n   |  | _______|  .| |           |\n   |   \ _______\  | |           |\n   |    |         |  /=\         |\n   |    |         | |   |        |\n   |     \_o____o_\ _\=/         |\n"
;   |    ______________           |
;   |    \_____________\          |
;   |      __\\__//__             |
;   |      |        | '\          |
;   |      |________|   /=\       |
;   |     /_______ / \ |   |      |
;   |    |        |  .\ \=/       |
;   |    |        |___| |         |
;   |    | _______|  .| |         |
;   |     \ _______\  | |         |
;   |      |         |  /=\       |
;   |      |         | |   |      |
;   |       \_o____o_\ _\=/       |

;**************************toEndScreen*********************************
;kind of an awkward place for this, but it allows me to span my entire code
;R0 holds the address of the rocks to be printed, and then holds the address of the end screen portion
;R1 Holds address of end screen that gets transfered to R0 for printing
;R3 Helps us count how many roads to print before printing the last segment so that it all flows better
;R7 holds return values
toEndScreen
    ST R7, toEndSaveR7
    JSR Clear
    JSR printEndScreen
    AND R3,R3,#0
    ADD R3,R3,#15
    ADD R3,R3,#15
    JSR roadLoopF
    
    JSR PrintFunction ;prints the rocks for the car to hit.
    AND R0,R0,#0
    ADD R0,R1,#0 ;loads the end screen that was saved in R1 into R0 to be printed
    JSR PrintFunction
    LD R7,toEndSaveR7
    RET
toEndSaveR7 .blkw 1

;**************************Car2*********************************
;R0 loads the car into R0 to display back in main
;R1 used to ensure that i have the correct car from mains interaction with R1
;R7 saved for return value
getCar2
    LEA R0,bigCar2
    RET
bigCar2 .stringz "   |     ______________          |\n   |     \_____________\         |\n   |       __\\__//__             |\n   |       |        | '\         |\n   |       |________|   /=\      |\n   |      /_______ / \ |   |     |\n   |     |        |  .\ \=/      |\n   |     |        |___| |        |\n   |     | _______|  .| |        |\n   |      \ _______\  | |        |\n   |       |         |  /=\      |\n   |       |         | |   |     |\n   |        \_o____o_\ _\=/      |\n"
;   |    ______________           |
;   |    \_____________\          |
;   |      __\\__//__             |
;   |      |        | '\          |
;   |      |________|   /=\       |
;   |     /_______ / \ |   |      |
;   |    |        |  .\ \=/       |
;   |    |        |___| |         |
;   |    | _______|  .| |         |
;   |     \ _______\  | |         |
;   |      |         |  /=\       |
;   |      |         | |   |      |
;   |       \_o____o_\ _\=/       |

;**************************Car3*********************************
;R0 loads the car into R0 to display back in main
;R1 used to ensure that i have the correct car from mains interaction with R1
;R7 saved for return value
getCar3
    LEA R0,bigCar3
    RET

bigCar3 .stringz "   |         ______________      |\n   |         \_____________\     |\n   |           __\\__//__         |\n   |           |        | '\     |\n   |           |________|   /=\  |\n   |          /_______ / \ |   | |\n   |         |        |  .\ \=/  |\n   |         |        |___| |    |\n   |         | _______|  .| |    |\n   |          \ _______\  | |    |\n   |           |         |  /=\  |\n   |           |         | |   | |\n   |            \_o____o_\ _\=/  |\n"
;   |    ______________           |
;   |    \_____________\          |
;   |      __\\__//__             |
;   |      |        | '\          |
;   |      |________|   /=\       |
;   |     /_______ / \ |   |      |
;   |    |        |  .\ \=/       |
;   |    |        |___| |         |
;   |    | _______|  .| |         |
;   |     \ _______\  | |         |
;   |      |         |  /=\       |
;   |      |         | |   |      |
;   |       \_o____o_\ _\=/       |


;**************************PrintEndScreen*********************************
;R0 used to load address of the rocks
;R1 used to load address of the end screen
PrintEndScreen 
    ST R7,endScreenSaveR7
    LEA R1, EndScreen
    JSR getCrash
    LD R7,endScreenSaveR7
    RET
    endScreenSaveR7 .blkw 1

EndScreen .stringz "\nCars die, but I do not... Death comes for you all\n\n\n                     |           \n                     ;           \n                    / \          \n                   |   |         \n          ||       /   \       ||\n          ||_      |   |      _||\n          |  \__   |   |   __/  |\n          |     \==|   |==/     |\n          |__    __     __    __|\n          .  \__  o     o  __/  .\n          |     \___/ \___/     |\n          |   __/  ||_||  \__   |\n          |_/       `=`       \_|\n"

;*************************getCrash*********************************
;R0 holds the address of the rocks to crash into
getCrash
    LEA R0, carCrash
    RET
carCrash .stringz "   |    ______________           |\n   |    \_____________\          |\n   |       __\\__//__             |\n   |      |        | '\          |\n   |      |________|   /=\       |\n   |     /_______ / \ |   |      |\n   |    |        |  .\ \=/       |\n   |    | _______|  /\| |        |\n   |    /\ ___/ __\ /\ |         |\n   |   |   \_   / \ |  /=\___    |\n     _/       \/   |   __/    \   \n    /               \ /         | \n   |                 \           \\n"
;carCrash .stringz "     /\_      _                \n    |   \_   / \       ___     \n  _/       \/   |   __/    \   \n /               \ /         | \n|                 \           \\"

;this is pile of rocks that car hits
;   |    ______________           | 
;   |    \_____________\          | 
;   |      __\\__//__             | 
;   |      |        | '\          |
;   |      |________|   /=\       | 
;   |     /_______ / \ |   |      |    
;   |    |        |  .\ \=/       |  
;   |    | _______|  /\| |        |              
;   |    /\ ___/ __\ /\ |         |                     
;   |   |   \_   / \ |  /=\___    | 
;     _/       \/   |   __/    \   
;    /               \ /         |  
;   |                 \           \



;           |           
;           ;           
;          / \          
;         |   |         
;||       /   \       ||
;||_      |   |      _||
;|  \__   |   |   __/  |
;|     \==|   |==/     |
;|__    __     __    __|
;.  \__  o     o  __/  .
;|     \___/ \___/     |
;|   __/  ||_||  \__   |
;|_/       `=`       \_|



















; ;|          {`-`{  |
; ;|          (==(|  |
; ;|          { _ {  |
; ;|          _/_\_  |





; ; downCar .Stringz "|           _____ |\n|            \_/  |\n|           {   { |\n|           (==(| |\n|           {.,.{ |\n"
; ;down car looks like this:
; ;|           _____ |
; ;|            \_/  |
; ;|           {   { |
; ;|           (==(| |
; ;|           {.,.{ |


.end

;***********************************************************
;
;
;R0
;R1
;R2
;R3
;R4
;R5
;R6
;R7

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

    AND R4,R4,#0
    ADD R4,R4,#4 ;controls how many big loops go 
MainLoop
    AND R3,R3,#0 
    AND R1,R1,#0 ; resets which car i am calling
    
    JSR Clear
    ADD R3,R3,#3
    JSR roadLoopF ;prints the beginning roads
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction ;print the road with the car on it
    ADD R3,R3,#13
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#-9 ;reposition car
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#5 ;reposition car
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#-1 ;reposition car
    JSR roadLoopF
    ADD R1,R1,#1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-3 ;reposition car
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#7 ;reposition car
    JSR roadLoopF
    ADD R1,R1,#-1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-11 ;reposition car
    JSR roadLoopF 
    JSR Pause
    JSR Clear
    
    ADD R3,R3,#15 ;reposition car
    JSR roadLoopF
    ADD R1,R1,#-1 ;will set up cc for getting the upCar, will be set to negative to get the downCar
    JSR getCar ;grabs the car because its too far away
    JSR PrintFunction
    ADD R3,R3,#-16 ;reposition car
    ADD R3,R3,#-3 ;reposition car
    JSR roadLoopF
    JSR Pause
    JSR Clear
    
    ADD R4,R4,#-1
    BRnz finishScene ;will jump to the end scene after 3 iterations

    BR MainLoop ;will continue the main loop unless its been long enough and we want to go the end scene
    
finishScene
    JSR toEndScreen
    
finish    Halt
mainSaveR7 .BLKW 1


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
    ADD R3,R3,#0 ;double check we are using R3 correctly
    BRz returnFromRoadLoop
roadLoop
    LEA R0,road
    JSR PrintFunction
    ADD R3,R3,#-1 ;iterate through however many road loops we need
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
PauseLoop     ;iterates pauseCount amount of times
    ADD R1,R1,#-1
    BRp PauseLoop
    
    LD R1,PauseSaveR1
    RET
    
PauseSaveR1 .blkw 1
PauseCount .fill x4500
;*****************************Clear******************************
;R0 holds address of a clearing page
;R7 holds return address
Clear
    ST R0,ClearSaveR0
    ST R7,ClearSaveR7
    LEA R0,clearRoad ;load the clearing of the console
    TRAP x22
    ST R0,ClearSaveR0
    LD R7,ClearSaveR7
    RET
clearRoad .stringz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
ClearSaveR7 .blkw 1
ClearSaveR0 .blkw 1

;**************************getCar*********************************
;R0 loads the car into R0 to display back in main
;R1 used to ensure that i have the correct car from mains interaction with R1
;R7 saved for return value
getCar
    ST R1,getCarSaveR1
    ST R7,getCarSaveR7
    ADD R1,R1,#-1 ;go through and check which car we need in main
    BRz Car1
    ADD R1,R1,#-1
    BRz Car2
    ADD R1,R1,#-1
    BRz Car3
Car3   
    JSR getCar3 ;the string was too far away so i made subroutines to grab them
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
    ST R3, toEndSaveR3
    ST R0, toEndSaveR0
    
    JSR Clear
    JSR printEndScreen
    AND R3,R3,#0  ;reset how many roads will be printed
    ADD R3,R3,#15
    ADD R3,R3,#15
    JSR roadLoopF
    
    JSR PrintFunction ;prints the rocks for the car to hit.
    AND R0,R0,#0
    ADD R0,R1,#0 ;loads the end screen that was saved in R1 into R0 to be printed
    JSR PrintFunction ;print the end screen with the dragonfly guy
    
    LD R0,toEndSaveR0
    LD R3,toEndSaveR3
    LD R7,toEndSaveR7
    RET
toEndSaveR7 .blkw 1
toEndSaveR3 .blkw 1
toEndSaveR0 .blkw 1

;**************************getCar2*********************************
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

;**************************getCar3*********************************
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

EndScreen .stringz "\n                      Apparently rocks are hard to drive through...\n\n                  ";  Cars might fail you, and you might die, but I shall not...          " ;             |           \n                       ;           \n                       / \          \n                       |   |         \n               ||       /   \       ||\n                ||_      |   |      _||\n                 |  \__   |   |   __/  |\n                  |     \==|   |==/     |\n                   |__    __     __    __|\n                    .  \__  o     o  __/  .\n                     |     \___/ \___/     |\n                      |   __/  ||_||  \__   |\n                       |_/       `=`       \_|\n"

;*************************getCrash*********************************
;R0 holds the address of the rocks to crash into
getCrash
    LEA R0, carCrash
    RET
carCrash .stringz "   |    ______________           |\n   |    \_____________\          |\n   |       __\\__//__             |\n   |      |        | '\          |\n   |      |________|   /=\       |\n   |     /_______ / \ |   |      |\n   |    |        |  .\ \=/       |\n   |    | _______|  /\| |        |\n   |    /\ ___/ __\ /\ |         |\n   |   |   \_   / \ |  /=\___    |\n     _/       \/   |   __/    \   \n    /               \ /         | \n   |                 \           \\"
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


.end



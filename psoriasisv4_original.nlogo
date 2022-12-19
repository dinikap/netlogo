turtles-own
[
  stem?                ;; true for stem cells, false for TA or diff
  TA?                  ;; true for TA cells, false for others
  diff?                ;; true for differentiating cells, false for others
  arrest?              ;; cells that arrest but don't die after UV
  dermis?              ;; turtle to draw the dermis
  stem-factor          ;;level of factor x within cell, determining whether the cell can divide or not
  time-as-differentiated ;; no. hours since cell derived  TA as a differentiated cell
  stem-clock           ;;hours for stem cell division
  TA-clock             ;;hours for a TA to divide 
  time-since-stem      ;; hours since stem for TA
  age-of-cell          ;; turover time for the cell
  m                    ;; turtle to move
  divide               ;; number of divisions for each TA cell
  add                  ;; for increasing bm
  minus                ;; for decreasing bm 
  grey-clock           ;; time from apoptosis for stem cell
]

patches-own
[
  gradient  
  ?
  patch-ycor
  patch-xcor
]

globals
[ 
  TA-count
  diff-count
  stem-count
  total-count
  treatments            ;; number of UVB epidsodes
  UV-gap                ;;hours between UV irradiations
  positions
  psos
  clock
  change
  shift-up
  me
  add-
  minus-
  max-turtle
  cycle-count
  active-TA
  TA-divisions
  adding
  reducing
]


to setup
;; setup the basement membrane and create a gradient
  clear-all
  ask patches
    [
    set pcolor black
    ]
  setup-epidermis
  set-default-shape turtles "circle"
  set-stem
  ask patches with [pcolor = yellow]
     [
     set gradient 10000
     ]
  ask patches with [pycor = max-pycor] 
     [
     set gradient 0
     ]
  repeat 80 
     [
     diffuse gradient 0.25
     ] 
   setup-plot
  evaluate-params
  set treatments 0
  set UV-gap 0  
  movie-start "skin.mov"
  movie-set-frame-rate 30
 end


to setup-epidermis
;; create the epidermis as either the normal or psoriatic morphology
  clear-all
  let normal    [0 0 1 1 2 2 2 1 0 1 0 -1 0 -1 -2 -2 -2  -1 -1  0 ]
  let pso        [0 1 2 3 8 8 2 1 0 1 0 -1 0 -1 -2 -8 -8 -3 -2 -1 ]
  ifelse Psoriasis 
      [
      set positions 7
      crt 1
      let newx -1
      let newy -5
      ask patches with [pxcor = 80] 
         [if pycor <= -5
             [
             set pcolor yellow
             ]
         ]
      ask turtles
           [
           let q 0
           loop
               [
               foreach pso
                   [
                   set newx newx + 1
                   set newy newy - ?
                   setxy newx newy
                   facexy newx min-pycor
                   let r 1
                   set pcolor yellow
                   while [r <= world-height]     
                       [
                       fd 1
                       set pcolor yellow
                       set r r + 1 
                       ]
                   ]
               set q q + 1
               if (q > 3) [stop]
              ]
           ]
       ]
       [
       set positions 1
       crt 1
       let newx -1
       let newy -5
       ask patches with [pxcor = 80] 
         [if pycor <= -5
             [
             set pcolor yellow
             ]
         ]
 ask turtles
           [
           let q 0
           loop
               [
               foreach normal
                   [
                   set newx newx + 1
                   set newy newy - ?
                   setxy newx newy
                   facexy newx min-pycor
                   let r 1
                   set pcolor yellow
                   while [r <= world-height]     
                       [
                       fd 1
                       set pcolor yellow
                       set r r + 1 
                       ]
                   ]
               set q q + 1
               if (q > 3) [stop]
              ]
           ]
       ]
set clock 0
end


to set-stem  
;;create stem cells
   crt 50
   ifelse Psoriasis    
      [
      set positions 7 
      ask turtles 
         [ 
        if (who = 3)  [setxy 1 -5]
        if (who = 4) [setxy 2 -7]
        if (who = 5) [setxy 3 -10]
        if (who = 6)or (who = 43) [setxy 4 -18]
        if (who = 7) [setxy 5 -26]
        if (who = 8) [setxy 14 -26]
        if (who = 9)or (who = 44) [setxy 15 -18]
        if (who = 10) [setxy 16 -10]
        if (who = 11)  [setxy 17 -7]
        if (who = 12) [setxy 22 -7]
        if (who = 13) [setxy 23 -10]
        if (who = 14)or (who = 45) [setxy 24 -18]
        if (who = 15) [setxy 25 -26]
        if (who = 16) [setxy 34 -26]
        if (who = 17)or (who = 46) [setxy 35 -18]
        if (who = 18) [setxy 36 -10]
        if (who = 19)[setxy 37 -7]
        if (who = 20) [setxy 38 -5]
        if (who = 21) [setxy 18 -5]
        if (who = 22) [setxy 21 -5]
        if (who = 23) [setxy 41 -5]
        if (who = 24) [setxy 42 -7]
        if (who = 25) [setxy 43 -10]
        if (who = 26)or (who = 47) [setxy 44 -18]
        if (who = 27) [setxy 45 -26]
        if (who = 28) [setxy 54 -26]
        if (who = 29)or (who = 48) [setxy 55 -18]      
        if (who = 30) [setxy 56 -10]      
        if (who = 31) [setxy 57 -7]      
        if (who = 32) [setxy 58 -5]      
        if (who = 33) [setxy 61 -5]  
        if (who = 34) [setxy 62 -7]  
        if (who = 35) [setxy 63 -10]  
        if (who = 36)or (who = 49) [setxy 64 -18]      
        if (who = 37) [setxy 65 -26]      
        if (who = 38) [setxy 74 -26]      
        if (who = 39)or (who = 50) [setxy 75 -18]  
        if (who = 40) [setxy 76 -10]  
        if (who = 41) [setxy 77 -7]      
        if (who = 42) [setxy 78 -5] 
        set size 1
        set stem-clock random 150
        set stem? true
        set TA? false
        set diff? false
        set dermis? false
        set color blue
  
        if (who = 1)[die]
        if (who = 2) [die]
        if (who = 0) [die]
        ]
   ]
   [set positions 1 
    ask turtles 
        [
        if (who = 3) [setxy 1 -4]
        if (who = 4) [setxy 2 -5]
        if (who = 5) [setxy 3 -6]
        if (who = 6)or (who = 43) [setxy 4 -8]
        if (who = 7) [setxy 5 -10]
        if (who = 8) [setxy 14 -10]
        if (who = 9)or (who = 44) [setxy 15 -8]
        if (who = 10) [setxy 16 -6]
        if (who = 11) [setxy 17 -5]
        if (who = 12)[setxy 22 -5]
        if (who = 13) [setxy 23 -6]
        if (who = 14)or (who = 45) [setxy 24 -8]
        if (who = 15)[setxy 25 -10]
        if (who = 16) [setxy 34 -10]
        if (who = 17)or (who = 46) [setxy 35 -8]
        if (who = 18) [setxy 36 -6]
        if (who = 19) [setxy 37 -5]
        if (who = 20) [setxy 38 -4]
        if (who = 21) [setxy 18 -4]
        if (who = 22) [setxy 21 -4]
        if (who = 23) [setxy 41 -4]
        if (who = 24) [setxy 42 -5]
        if (who = 25)[setxy 43 -6]
        if (who = 26)or (who = 47) [setxy 44 -8]
        if (who = 27) [setxy 45 -10]
        if (who = 28) [setxy 54 -10]
        if (who = 29)or (who = 48) [setxy 55 -8]      
        if (who = 30) [setxy 56 -6]      
        if (who = 31) [setxy 57 -5]      
        if (who = 32) [setxy 58 -4]      
        if (who = 33) [setxy 61 -4]  
        if (who = 34) [setxy 62 -5]  
        if (who = 35) [setxy 63 -6]  
        if (who = 36)or (who = 49) [setxy 64 -8]      
        if (who = 37) [setxy 65 -10]      
        if (who = 38) [setxy 74 -10]      
        if (who = 39)or (who = 50) [setxy 75 -8]  
        if (who = 40) [setxy 76 -6]  
        if (who = 41) [setxy 77 -5]      
        if (who = 42) [setxy 78 -4]
        set size 1
        set stem-clock random 150
        set stem? true
        set TA? false
        set diff? false
        set arrest? false
        set dermis? false
        set color blue

       if (who = 1)[die]
       if (who = 2) [die]
       if (who = 0) [die]
       ]
    ]
 end
 
 
to go
;; run the model
repeat 500
[

if epidermis-adjust
  [
  ;; Rechecks the number of dividing cells adjacent to the basal layer, and expands / contracts the epidermis accordingly. Check is set for every 5h.
  set clock clock + 1
  if clock >= 5
      [
      bm
      ask turtles
         [
         if stem?
            [
            ;;ask stem cells to move down if a space has been created below them by a shift in the basement membrane
            ask patch-at-heading-and-distance 180 1
                [
                if pcolor = black
                   [
                   ask turtles-on patch-at-heading-and-distance 0 1
                      [
                      shift-down
                      ]
                   ]
                ]
             ]
          ]
      set clock 0
      ] 
 
   ] 
ask turtles
   [
   ;; allow normal cell division to occur, with cells differentiating when they reach a threshold gradient
   set-stem-division
   set-TA-division
   set-diff
   let nb5 max-one-of neighbors with [pcolor = black][gradient] 
   if (TA? or diff?) and (count turtles-on nb5 = 0) 
       [
       move-to nb5
       ]
   if stem? 
      [
      set stem-clock stem-clock + 1
      set grey-clock grey-clock + 1
      ]
   if TA? 
      [
      set TA-clock TA-clock + 1 
      set time-since-stem time-since-stem + 1
      set age-of-cell age-of-cell + 1
      ] 
   if diff? 
      [
      set time-as-differentiated time-as-differentiated + 1
      set age-of-cell age-of-cell + 1
      smoother
      ]             
   if TA? and (divide > TA-divide) and ([gradient] of patch-here < 1800) 
      [
      set TA? false 
      set diff? true 
      set color 65 
      set time-as-differentiated 0
      ]
  ]
 ;; irradiate the epidermis at the specified frequency and time interval
 if (irradiation-frequency > 0) and (UV-gap >= irradiation-frequency) and (Number-of-treatments > treatments)
  [
  uv
  ask turtles
    [
    ;; check that the youngest most actively dividing cells have not been displaced from the basal and suprabasal layers by cells with less proliferative ability
     check-position
    ]
  ]
 ;; close any gaps that appear in the epidermis, especially after irradiation
 repeat 10
  [ask turtles 
     [
     if (TA? or diff? or stem?) 
        [
        let shifting turtles-here 
        ask patch-at-heading-and-distance 180 1 
            [
            if (pcolor = black) and (count turtles-here = 0)
                [
                ask shifting 
                    [
                    shift-down 
                    ]
                 ]
            ]
        ]         
      ]
    ]
;; stop cells piling-up on top of each other    
ask turtles with [TA?]
  [
  if count turtles-here > 2
    [
    relocate
    ]
  ]
;; create a flat surface to the top the epidermis
ask turtles with [diff? and pycor = -1]
      [
      smoother
      ]
;; turtles die as they fall off the top of the epidermis
ask turtles
   [ 
   if diff? and pycor >= 0      
      [
      death
      ]


   ]  
;;set the counter for when to give the next irradiation
set uv-gap uv-gap + 1
;; adjust the cytokine level according to the total keratinocyte number
divide-change
evaluate-params  
tick
if ticks < 500 [movie-grab-view]
]
if ticks = 500[movie-close]

end


to check-position
;; check the most proliferative cells are closest to the basal layer
if count turtles-here = 1
 [
  if stem? 
         [
         stop
         ]
if any? turtles-on patches with [pycor >= -2]
    [
    ask turtles-on patches with [pycor >= -2]
        [
        smoother
        ]
    ]
  ]
if count turtles-here = 1
 [
 if TA? or diff?
    [
    repeat 3
 
            [
            let friends-patch max-one-of neighbors with [(pcolor = black) and ((count turtles-here = 0) or ( [time-since-stem] of min-one-of turtles-here [time-since-stem] > [time-since-stem] of myself))] [gradient] 
            ifelse friends-patch = nobody 
                [
                stop
                ]
                [
                if turtles-on friends-patch != stem?
                  [
                  move-to friends-patch
                  relocate
                  ]
                ]
            ]
      ]
 ]
end


to divide-change
;; if cytokine-stimulus is on, the maximum cytokine production occurs in keeping with psoriasis, 
;; if not the amount of cytokines produced is relative to the total keratinocyte load
;; and this affects the proportion of TA cells whicvh divide 5 times instead of 4
ifelse cytokine-stimulus
  [
  ask turtles with [color = pink]
       [
            let s random 99
            ifelse s < 50
               [set TA-divisions 5]
               [set TA-divisions 4]
            ]
  ask turtles with [color = blue]
     [
     set percent-stem 80
     ]
    ]
    [
  ask turtles 
      [
   if (count turtles with [color = pink] >= 200)
         [
         ask turtles with [(color = pink) ]
            [
            let s random 99
            ifelse s < 50
               [set TA-divisions 5]
               [set TA-divisions 4]
            ]
         ]  
     
     if (count turtles with [color = pink] < 200) and (count turtles with [color = pink] >= 150)
         [
         ask turtles with [(color = pink) ]
            [
            let s random 99
            ifelse s < 37.5
               [set TA-divisions 5]
               [set TA-divisions 4]
            ]
         ]
     if (count turtles with [color = pink] < 150) and (count turtles with [color = pink] >= 100)
         [
          ask turtles with [(color = pink) ]
            [
            let s random 99
            ifelse s < 25
               [set TA-divisions 5]
               [set TA-divisions 4]
            ]
         ]
     if (count turtles with [color = pink] < 100) and (count turtles with [color = pink] >= 50)
         [
         ask turtles with [(color = pink) ]
            [
          let s random 99
            ifelse s < 12.5
               [set TA-divisions 5]
               [set TA-divisions 4]
            ]
         ]
  if (count turtles with [color = pink] < 50)
         [
         ask turtles with [(color = pink) ]
            [
            set TA-divisions 4
            ]
         ]
   
       ]
  ]
end


to bm
;; changes size of basement membrane according to the number of actively dividing cells
 ask turtles
    [
    set add 0
    set minus 0
    if (TA?)  and (color = pink) 
     [
     if ([gradient] of patch-here <= 4000)
             [
              set add 1
              set minus 0
             ]  
       ]
     ask patches with [gradient > 4000]
          [
          ask turtles-here with [(color = 134) or diff?]
             [
             set minus 1
             set add 0
             ]
          
        ]    
     ] 
set change 0
set shift-up 0
if count turtles with [add  = 1] = 0
  [
  stop
  ]
set adding (active-TA / (active-TA - (count turtles with [add = 1]) + (count turtles with [minus = 1])))
set reducing (((count turtles with [minus = 1]) - (count turtles with [add = 1])) / (active-TA - (count turtles with [add = 1]) + (count turtles with [minus = 1])))

if  adding > 1.20
       [
    
       set positions positions + 1
       set shift-up 1
       set change 1
       if positions > 7 
           [
           set positions 7
           set change 0
          ]
      ]
   
if  reducing > 0.40
       [
        set positions positions - 1
         set change 1
         if positions < 1 
           [
           set positions 1
           set change 0
           ]
       ]
      
 if change = 0     
      [
      stop
      ]
 cp
 crt 1 
      [
      set TA? false 
      set diff? false 
      set stem? false 
      set dermis? true 
      ]
 let newx -1
 let newy -5
 ask patches with [pxcor = 80] 
         [if pycor <= -5
             [
             set pcolor yellow
             ]
         ]    
 if positions = 7
      [
 set psos    [0 1 2 3 8 8 2 1 0 1 0 -1 0 -1 -2 -8 -8 -3 -2 -1 ]
 ask turtles
     [
     if dermis?
         [
         let q 0
         loop
            [ 
            foreach psos
                [
                set newx newx + 1
                set newy newy - ?
                setxy newx newy
                facexy newx min-pycor
                let r 1
                set pcolor yellow
                while [r <= world-height]     
                    [
                    fd 1
                    set pcolor yellow
                    set r r + 1 
                    ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                      ] 
                 ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
              ]   
          ]
      ]
    ask turtles 
        [ 
        if dermis? 
           [
           die
           ] 
        ]
             ]  
 if positions = 6
      [
 set psos     [0 1 2 3 7 7 2 1 0 1 0 -1 0 -1 -2 -7 -7 -3 -2 -1 ]
 ask turtles
     [
     if dermis?
         [
         let q 0
         loop
            [ 
            foreach psos
                [
                set newx newx + 1
                set newy newy - ?
                setxy newx newy
                facexy newx min-pycor
                let r 1
                set pcolor yellow
                while [r <= world-height]     
                    [
                    fd 1
                    set pcolor yellow
                    set r r + 1 
                    ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                      ] 
                 ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
              ]   
          ]
      ]
    ask turtles 
        [ 
        if dermis? 
           [
           die
           ] 
        ]
     ]  
 if positions = 5
     [
     set psos [0 1 2 2 6 6 2 1 0 1 0 -1 0 -1 -2 -6 -6 -2 -2 -1 ]
     ask turtles
         [
         if dermis?
            [
            let q 0
            loop
               [ 
               foreach psos
                  [
                  set newx newx + 1
                  set newy newy - ?
                  setxy newx newy
                  facexy newx min-pycor
                  let r 1
                  set pcolor yellow
                  while [r <= world-height]     
                     [
                     fd 1
                     set pcolor yellow
                     set r r + 1 
                     ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                     ] 
                ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
               ]  
         ]
     ]
    ask turtles 
        [ 
        if dermis? 
            [
            die
            ] 
         ]
     ]  
 if positions = 4
  [
  set psos  [0 1 2 2 5 5 2 1 0 1 0 -1 0 -1 -2 -5 -5 -2 -2 -1 ]
   ask turtles
     [
     if dermis?
         [
          let q 0
          loop
            [ 
             foreach psos
                [
                 set newx newx + 1
                 set newy newy - ?
                 setxy newx newy
                 facexy newx min-pycor
                 let r 1
                 set pcolor yellow
                 while [r <= world-height]     
                    [
                     fd 1
                     set pcolor yellow
                     set r r + 1 
                     ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                     ] 
                ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
              ]  
         ]
      ]
  ask turtles 
      [ 
      if dermis? 
      [
      die
      ] 
    ]
  ]  
 if positions = 3
  [
  set psos  [0 0 1 2 4 4 2 1 0 1 0 -1 0 -1 -2 -4 -4 -1 -2  0 ]
  ask turtles
     [
     if dermis?
         [
          let q 0
          loop
            [ 
             foreach psos
                [
                 set newx newx + 1
                 set newy newy - ?
                 setxy newx newy
                 facexy newx min-pycor
                 let r 1
                 set pcolor yellow
                 while [r <= world-height]     
                    [
                     fd 1
                     set pcolor yellow
                     set r r + 1 
                     ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                     ] 
                ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
              ]  
         ]
      ]
        ask turtles 
            [ 
            if dermis? 
               [
               die
               ] 
            ]
  ]  
 if positions = 2
  [
  set psos [0 0 1 1 3 3 2 1 0 1 0 -1 0 -1 -2 -3 -3 -1 -1  0 ]
  ask turtles
     [
     if dermis? 
         [
          let q 0
          loop
            [ 
             foreach psos
                [
                 set newx newx + 1
                 set newy newy - ?
                 setxy newx newy
                 facexy newx min-pycor
                 let r 1
                 set pcolor yellow
                 while [r <= world-height]     
                    [
                     fd 1
                     set pcolor yellow
                     set r r + 1 
                     ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                     ] 
                ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
             ]  
         ]
    ]
    ask turtles [ if dermis? [die] ]
   ]  
if positions = 1
  [    
  set psos  [0 0 1 1 2 2 2 1 0 1 0 -1 0 -1 -2 -2 -2  -1 -1  0 ]
   ask turtles
     [
     if dermis?
          [
          let q 0
          loop
            [ 
            foreach psos
                 [
                 set newx newx + 1
                 set newy newy - ?
                 setxy newx newy
                 facexy newx min-pycor
                 let r 1
                 set pcolor yellow
                 while [r <= world-height]     
                     [
                     fd 1
                     set pcolor yellow
                     set r r + 1 
                     ask patches with [pcolor = yellow and pxcor = newx]
                         [
                          if any? turtles-here with [TA? or stem? or diff?]
                               [
                             ifelse (shift-up = 1)
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift-down
                                       ]
                                  ]
                                  [
                                  ask turtles-here with [TA? or stem? or diff?]
                                       [
                                       shift
                                       ]
                                  ]
                              ]
                          ] 
                     ] 
                ]
           set q q + 1
           if (q > 3)
                   [ 
                    stop
                   ]
             ]  
         ]
      ]
      ask turtles 
          [ 
          if dermis? 
              [
              die
              ] 
           ]
   ]  
 ;;reset the gradient
 ask turtles 
   [
   set add 0
   set minus 0
   ]
 ask patches with [pcolor = black]
     [
     set gradient 0
     ] 
  ask patches with [pcolor = yellow]
     [
     set gradient 10000
     ]

  repeat 80 
     [
     diffuse gradient 0.25
     ] 
ask turtles
    [
    check-position
    ]                     
end


to shift-down
;; if there is a gap in the epidermis, close it
set heading 180 
fd 1
ask patch-at-heading-and-distance 180 1 
   [
   if (pcolor = black) and (count turtles-here = 0)
        [
         ask turtles-on patch-at-heading-and-distance 0 1 
             [
             if stem? or TA? or diff?
                [
                shift-down
                ]
             ]
        ]
    ]
end


to shift
;; change the cell position if basement membrane changes shape (called by BM)
if stem? or TA? or diff? or arrest?
    [
    set heading 0 
    fd 1
    if any? other turtles-here
       [
       ask other turtles-here
          [
          shift
          ]
       ] 
    ]

end


to set-stem-division
;; stem cells each have a % probability of dividing according to the user defined setting on the interface 
if (color = blue) and (stem-clock > stemcell-divide) 
      [
      let s random 99
      if s < percent-stem
          [    
          hatch 1 
             [ 
            show ""
            set stem? false
            set TA? true 
            set diff? false
            set dermis? false
            set color pink
            set TA-clock -10 + random 15
            set time-since-stem 1
            set age-of-cell 0
            set divide 0
            relocate             
            ]                   
         ]
         set stem-clock 0
  
      ]
;; grey cells are stem cells which have undergone UV-induced apoptosis and have later been replaced by symmetrical stem cell division
  if (color = grey) and (stem-clock > stemcell-divide) and (grey-clock > 200)
      [
      let s random 99
      if s < 20
          [    
          hatch 1 
             [ 
            show ""
            set stem? false
            set TA? true 
            set diff? false
            set dermis? false
            set color pink
            set TA-clock -10 + random 15
            set time-since-stem 1
            set age-of-cell 0
            set divide 0
            relocate             
            ]                   
         ]
         set stem-clock 0
  
      ] 
 end
 

to set-TA-division
;; cell divides specified number of times then rests (turns dark pink)      
if TA? and color = 134
  [stop]        
 if (TA?) and (divide >= TA-divisions) 
             [ 
             set color 134
             set time-since-stem 1000
             ]  
 if (TA?) and ((TA-clock >= TA-divide) and (divide < TA-divisions))
      [
      set divide divide + 1 
      set age-of-cell 0
      set TA-clock -10 + random 15
      hatch 1
                 [
                 show ""
                 set TA? true
                 set TA-clock -10 + random 15
                 set stem? false
                 set diff? false
                 set dermis? false
                 set color pink
                 set age-of-cell 0
                 relocate
                 stop
                 ]    
         
          stop
       ]
end
        

to set-diff
;; cells differentiate when they reach a defined threshold in the gradient of the underlying patches
  if (TA?) and ([gradient] of patch-here < 1800)
    [
    set TA? false
    set stem? false
    set diff? true
    set dermis? false
    set color 65
    set time-as-differentiated 0 
    set time-since-stem time-since-stem + 1000
    set add 0
    set minus 0
    stop
    ]
end


to death
  die
end


to relocate
;; only allows 1 turtle per patch, moving cells away from a single patch after division

;; don't do anything if you've reached the top of the world
if pycor = max-pycor 
   [
   stop
   ]
if count turtles-on patch-here < 2 
   [
   stop
   ]

 ;; to assign each turtle a different moving priority
 ifelse (max-one-of turtles-here([time-since-stem]) = (min-one-of turtles-here [time-since-stem])) 
   [
   set m (min-one-of turtles-here [who]) 
   if m = stem?
      [
      set m (max-one-of turtles-here [time-since-stem])
      ]
   ]
   [
   set m max-one-of turtles-here [time-since-stem]
   ]      
  if count turtles-on patch-here < 2 
   [
   stop
   ]

 ;; move to neighbour with highest gradient and not occupied
 let nb max-one-of neighbors with [(pcolor = black) and (count turtles-here = 0)] [gradient]
 if nb != nobody
 ;;get the correct turtle to move
    [
    ifelse [gradient] of nb < [gradient] of patch-here
        [
        ask m
           [
           move-to nb
           check-position
           stop
           ]
        ]
        [
        ifelse turtles-on patch-here = stem?
           [
          set m min-one-of turtles-here [time-since-stem]
           ask m
              [
              move-to nb    
              ]
            ]
            [
            move-to nb
            ]
         ]
         if count turtles-here < 1
            [
            stop
            ]
         if any? turtles-here = stem?
            [
            if count turtles-here = 2
               [
               stop
               ]
            ]
            relocate
       ]
  if count turtles-here < 2
     [
     stop
     ]
  ;; turtle to move to patch with highest gradient, black and older than myself   
  let aged [time-since-stem] of m
  if any? neighbors with [(pcolor = black) and ([time-since-stem] of min-one-of turtles-here [time-since-stem] > aged) ]
     [
     let nb2 max-one-of neighbors with [(pcolor = black) and ([time-since-stem] of min-one-of turtles-here [time-since-stem] > aged)] [gradient]
     if nb2 != nobody 
         [
          if ([gradient] of patch-here > [gradient] of nb2) and (turtles-on nb2 != stem?) 
            [
            ask m 
                [
                 move-to nb2
                 ask other turtles-here
                      [
                      relocate
                       ]
                   stop
                   ]
              ]
          ]
          check-position
      ]    
  if count turtles-here < 2 
       [
        check-position
       stop
       ]  
  ;; otherwise look at lowest gradient patch and move here    
  let nb3 min-one-of neighbors with [pcolor = black] [gradient] 
  if m != nobody
    [ 
    ask m 
       [
       if stem? 
          [
          stop
          ]
       if diff? and (pycor > -1)
          [
          die
          stop
          ]
       if [gradient] of patch-here > [gradient] of nb3
           [
            move-to nb3
            relocate
            stop
           ]
       ]
      check-position
   ]
end
          

to uv
;; irradiate the epidermis
  set UV-gap 0
  set cycle-count 0
  set treatments treatments + 1
 
   ask turtles with [(color = pink) or (color = 134) ]
      [
      let s random 99
      if s < 20
         [
        die
         ]
      ]
  ask turtles with [color = blue]
      [
      let t random 99
      if t < 13
             [
            set color grey
            set grey-clock 0
             ]
       ]
    ask turtles with [color = 65]
      [
      let t random 99
      if t < 8
             [
            die
             ]
       ]
end
   

to setup-plot
 set-current-plot "Populations"

end


to evaluate-params
  set TA-count count turtles with [color = pink or color = 134 or color = white]
  set diff-count count turtles with [color = 65]
  set stem-count count turtles with [color = blue]
  set add- count turtles with [add = 1]
  set minus- count turtles with [minus = 1]
  set total-count count turtles
  set active-TA count turtles with [color = pink]
  set-current-plot-pen "TA cells"
  plot count turtles with [color = pink or color = 134 or color = white]
  set-current-plot-pen "Differentiated"
  plot count turtles with [color = 65]
  let file "ps-80 params"
  file-open file
  file-print ""
  file-write ticks
  file-write stem-count
  file-write TA-count
  file-write diff-count
  file-write treatments
  file-write total-count
  file-write add-
  file-write minus-
  file-close
end


;; to movie     
;;     movie-start "c:\\users\\njsh\\unisoned\\projects\\skin\\sophies\\psoriasis1.mov"    
;;   repeat 200
;;     [       
;;       movie-grab-interface
;;       ]
;;if ticks = 200
;;      [
;;      movie-close
;;      ]
;;end


to smoother
;; keep the top of the epidermis flat
ask patch-here
      [
      if [pycor] of myself > ([pycor] of min-one-of patches with [pcolor = black and count turtles-here = 0] [pycor])
            [
            ask turtles-on myself
                 [
                 move-to (min-one-of patches with [pcolor = black and count turtles-here = 0] [pycor])
                 ]
               
             ]
       ]
end
@#$#@#$#@
GRAPHICS-WINDOW
203
10
699
527
-1
40
6.0
1
10
1
1
1
0
1
0
1
0
80
-40
40
1
1
1
ticks

BUTTON
12
17
76
50
setup
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
88
16
151
49
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

MONITOR
707
18
764
63
TA cells
TA-count 
0
1
11

MONITOR
772
18
831
63
Diff cells
diff-count
0
1
11

PLOT
698
72
1047
328
Populations
time
population
0.0
100.0
0.0
10.0
true
true
PENS
"TA cells" 1.0 0 -2064490 true
"Differentiated" 1.0 0 -13840069 true

SLIDER
9
176
181
209
stemcell-divide
stemcell-divide
1
500
150
1
1
hours
HORIZONTAL

SLIDER
12
275
184
308
TA-divide
TA-divide
0
400
60
1
1
hours
HORIZONTAL

SLIDER
707
338
904
371
Irradiation-frequency
Irradiation-frequency
0
200
56
1
1
Hours
HORIZONTAL

SLIDER
710
393
882
426
Number-of-treatments
Number-of-treatments
0
40
0
1
1
NIL
HORIZONTAL

MONITOR
990
345
1047
390
UVB
treatments
17
1
11

SWITCH
715
457
818
490
psoriasis
psoriasis
1
1
-1000

MONITOR
843
17
970
62
Total number of cells
total-count
17
1
11

SWITCH
900
461
1047
494
Epidermis-adjust
Epidermis-adjust
1
1
-1000

MONITOR
714
496
776
541
positions
positions
1
1
11

SLIDER
9
82
181
115
percent-stem
percent-stem
1
100
20
1
1
NIL
HORIZONTAL

SWITCH
11
367
163
400
Cytokine-stimulus
Cytokine-stimulus
1
1
-1000

MONITOR
817
495
874
540
NIL
add-
17
1
11

MONITOR
891
503
948
548
NIL
minus-
17
1
11

MONITOR
907
385
973
430
NIL
active-TA
17
1
11

MONITOR
990
409
1047
454
NIL
uv-gap
17
1
11

MONITOR
955
491
1012
536
NIL
clock
17
1
11

@#$#@#$#@
WHAT IS IT?
-----------
This section could give a general understanding of what the model is trying to show or explain.


HOW IT WORKS
------------
This section could explain what rules the agents use to create the overall behavior of the model.


HOW TO USE IT
-------------
This section could explain how to use the model, including a description of each of the items in the interface tab.


THINGS TO NOTICE
----------------
This section could give some ideas of things for the user to notice while running the model.


THINGS TO TRY
-------------
This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.


EXTENDING THE MODEL
-------------------
This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.


NETLOGO FEATURES
----------------
This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.


RELATED MODELS
--------------
This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.


CREDITS AND REFERENCES
----------------------
This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cell
false
0
Polygon -7500403 true true 0 150 75 60 225 60 300 150 225 240 75 240

circle
false
0
Circle -7500403 true true 0 0 300
Circle -1184463 true false 117 117 66

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

square2
true
0
Rectangle -1184463 true false 0 0 0 150
Rectangle -1184463 true false 0 0 300 300

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
false
0
Circle -7500403 true true 75 75 150
Polygon -7500403 true true 300 150 240 120 240 180
Polygon -7500403 true true 150 0 120 60 180 60
Polygon -7500403 true true 150 300 120 240 180 240
Polygon -7500403 true true 0 150 60 120 60 180
Polygon -7500403 true true 60 195 105 240 45 255
Polygon -7500403 true true 60 105 105 60 45 45
Polygon -7500403 true true 195 60 240 105 255 45
Polygon -7500403 true true 240 195 195 240 255 255

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 4.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@

turtles-own
[
  stem?
  TA? ;; true for TA cells, false for others
  diff? ;; true for differentiating cells, false for others
  arrest? ;; cells that arrest but don't die after UV
  dermis? ;; turtle to draw the dermis
  stem-factor ;;level of factor x within cell, determining whether the cell can divide or not
  time-as-differentiated ;; no. hours since cell derived TA as a differentiated cell
  stem-clock ;;hours for stem cell division
  TA-clock ;;hours for a TA to divide
  time-since-stem ;; hours since stem for TA
  age-of-cell ;; turover time for the cell
  m ;; turtle to move
  divide ;; number of divisions for each TA cell
  add ;; for increasing bm
  minus ;; for decreasing bm
  grey-clock ;; time from apoptosis for stem cell
  dying? ;; cells undergoing apoptosis
]

patches-own
[
  gradient
  ?
]

globals
[
  TA-count
  diff-count
  stem-count
  total-count
  treatments
  UV-gap
  positions
  psos
  clock
  change
  shift-up
  add-
  minus-
  active-TA
  adding
  reducing
  percent-stem
  turn-clock
  tx-count
  ;;change-frequency
]

to setup
  ;; setup the basement membrane and create a gradient
  clear-all
  random-seed 11111
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
  ask patches with [pycor = -2]
  [
    set gradient 100
  ]
  ask patches with [pycor = -1]
  [
    set gradient 50
  ]
  ask patches with [pycor >= 0]
  [
    set gradient 0
  ]
  setup-plot
  evaluate-params
  set treatments 0 
  set UV-gap 0
  ;;set clock 0
  set turn-clock 0
  ;;recording of simulation 
  movie-start "psoriasis-v5-days-1.mov"
  movie-set-frame-rate 10
end

to setup-epidermis
;; create the epidermis as either the normal or psoriatic morphology
  clear-all
  let normal [0 0 1 1 2 2 2 1 0 1 0 -1 0 -1 -2 -2 -2 -1 -1 0 ]
  let pso [0 1 2 3 8 8 2 1 0 1 0 -1 0 -1 -2 -8 -8 -3 -2 -1 ]
  ifelse Start-with-psoriasis-phenotype
  [
    set percent-stem 80
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
    set percent-stem 20
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
  ;;dinika - move this here as in Jen's version 
  set clock 0
end

to set-stem
;;create stem cells
  crt 50
  ifelse Start-with-psoriasis-phenotype
  [
    set positions 7
    ask turtles
    [
      if (who = 3) [setxy 1 -5]
      if (who = 4) [setxy 2 -7]
      if (who = 5) [setxy 3 -10]
      if (who = 6)or (who = 43) [setxy 4 -18]
      if (who = 7) [setxy 5 -26]
      if (who = 8) [setxy 14 -26]
      if (who = 9)or (who = 44) [setxy 15 -18]
      if (who = 10) [setxy 16 -10]
      if (who = 11) [setxy 17 -7]
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
      set color 85
      set dying? false
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
      set color 85
      set dying? false
      if (who = 1)[die]
      if (who = 2) [die]
      if (who = 0) [die]
    ]
  ]
end

to go
;; run the model
;; Rechecks the number of dividing cells adjacent to the basal layer, and expands /contracts the epidermis accordingly.
  no-display
  ;;so if the number of cells reach the top of the normal epi and there are more than 0 turtles in the black patches that are at least 98% full? 
  ;; then adjust the basement membrane 
 ;; if (count turtles with [pycor = -4] > 75) and (ticks > 400) and ((count patches with [(pycor < -1 and pcolor = black) and count turtles-here > 0] / count patches with [pycor < -1 and pcolor = black]) >= 0.98)
  if epidermis-adjust
  [
    set clock clock + 1 
    if clock >= 5
    [
    bm
    ask-concurrent (turtles with [stem?])
    ;;ask turtles with [stem?]
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
    set clock 0
  ]
  ]
  ask turtles
  [
    if any? neighbors with [(count turtles-here = 0) and ([pycor] of self < [pycor] of myself)]
    [
      check-position
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
    ]
    if TA? and (divide > TA-cell-cycle) and ([gradient] of patch-here < 1800)
    [
      set TA? false
      set diff? true
      set color 65
      set time-as-differentiated 0
    ]
    ;;din - maybe not necessary to ask turtles to check position 
    if color = pink
    [
      check-position
    ]
  ]
;; irradiate the epidermis at the specified frequency and time interval
  ;;set change-frequency (treatments-per-week + tx-count)
  if (irradiation-frequency > 0) and (UV-gap >= irradiation-frequency) and (Number-of-treatments > treatments)
  [
    uv
  if (count turtles with [color = pink] >= 200)
    [ set percent-stem 70 ]
  if (count turtles with [color = pink] < 200) and (count turtles with [color = pink] >= 150)
    [ set percent-stem 60 ]
  if (count turtles with [color = pink] < 150) and (count turtles with [color = pink] >= 100)
    [ set percent-stem 50 ]
  if (count turtles with [color = pink] < 100) and (count turtles with [color = pink] >= 75)
    [ set percent-stem 40 ]
  if (count turtles with [color = pink] < 75)
    [ set percent-stem 20 ]
    ask turtles
    [
;; check that the youngest most actively dividing cells have not been displaced from the basal and suprabasal layers by cells with less proliferative ability
      check-position
    ]
   ;;if there is treatments added and if it hits the same number of treatments per week
   ;; then it takes into account the weekends and changes accordingly
	if (treatments-per-week = 5)
	[
    	ifelse (treatments = (treatments-per-week + tx-count))
    	[
      	set irradiation-frequency 48
      	set tx-count (tx-count + treatments-per-week)
    	]
   		 [ set irradiation-frequency 24 ]
	] 
	if (treatments-per-week = 3)
	[
		ifelse (treatments = (treatments-per-week + tx-count))
    	[
      	set irradiation-frequency 72
      	set tx-count (tx-count + treatments-per-week)
    	]
   		 [ set irradiation-frequency 48 ]
	]
  ]
;; close any gaps that appear in the epidermis, especially after irradiation
  repeat 5
  ;;[ask-concurrent turtles
  [ask turtles
    [
      if (TA? or diff?)
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
  ask turtles with [stem?]
  [
    if count turtles-here with [TA?] > 0
    [
      ask turtles-here with [TA?]
      [
        relocate
      ]
    ]
  ]
  ask turtles with [TA?]
  [
    if count turtles-here > 2
    [
      relocate
    ]
  ]
  set clock clock + 1
;;set the counter for when to give the next irradiation
  set uv-gap uv-gap + 1
  if turn-clock = 1 
  [if any? turtles with [dying?]
    [
      ask turtles with [dying?]
      [
        die
      ]
    ]
  ]
  if (turn-clock > 0)
  [
    set turn-clock turn-clock - 1
  ]
  if (turn-clock > 0) and (turn-clock <= 24)
  [
    ask turtles with [dying?]
    [
      let s random 24
      if s < 2
      [
        die
      ]
    ]
  ]
  ask turtles with [(diff?) and (pycor > -4)]
  [
    if count turtles-on patch-at-heading-and-distance 180 1 = 0
    [
      ask turtles-on patch-at-heading-and-distance 0 1
      [
        set heading 180
        fd 1
      ]
    ]
  ]
;; adjust the cytokine level according to the total keratinocyte number
  divide-change
;; turtles die as they fall off the top of the epidermis
  surface
  display
  evaluate-params
  tick
  if ((ticks = 1200) and (ticks mod 2 = 0)) 
  [
    ;;movie-start "psoriais_1.mov"
    movie-grab-interface
  ]
  if ticks = 1200
  [
    set cytokine-stimulus true
    set percent-stem 80
    set epidermis-adjust true
  ]
  if ticks = 2300 [
    set cytokine-stimulus false
    set Number-of-treatments 24
    set treatments-per-week 3
    set irradiation-frequency 48
	]
	if ticks = 2804 [
	set treatments-per-week 5
	set irradiation-frequency 24
	]

  if ticks = 5000 [movie-close stop]
end

to surface
;; if lowest level is top of the epidermis, don't go higher
  if any? turtles with [pycor > -1]
  [
    ask turtles-on patches with [pycor > -1]
    [
      set heading 180
      fd 1
      if pycor > -1 [fd 1]
    ]
  ]
  if count turtles-on patches with [pycor = -1] > 80
  [
    ask turtles-on patches with [(count turtles-here > 1) and (pycor = -1)]
    [
      ask min-one-of turtles-here [time-since-stem]
      [
        stop
      ]
      roll
    ]
  ]
  if count patches with [(pycor = -1) and (count turtles-here > 0)] < 80
  [
    ask patches with [(count turtles-here > 1) and (pycor = -1)]
    [
      ask max-one-of turtles [time-since-stem]
      [
        roll
      ]
    ]
  ]
end

to roll
  let x (count turtles-on patches with [pycor = -1]) - 81
  if x >= 1
  [
    ask n-of x turtles-on patches with [(pycor = -1) and (count turtles-here > 1)] [die]
  ]
  if ((count turtles-here > 1) and (pycor = -1))
  [
    ask max-one-of turtles-here [time-since-stem]
    [
      set heading 90
      fd 1
      roll
      if count turtles-here <= 1 [stop]
    ]
  ]
end

to check-position
;; check the most proliferative cells are closest to the basal layer
  if stem?
  [
    stop
  ]
  if ((TA?) or (diff?))
  [
    repeat 25
    [
      let friends-patch max-one-of neighbors with [(pcolor = black) and ((count turtles-here = 0) or ( [time-since-stem] of min-one-of turtles-here [time-since-stem] > [time-since-stem] of myself))] [gradient]
      ifelse friends-patch = nobody
      [
        ask patch-at-heading-and-distance 180 1
        [
          if (pcolor = black) and ((count turtles-here = 0) or ( [time-since-stem] of
            min-one-of turtles-here [time-since-stem] > [time-since-stem] of myself))
          [
            ask turtles-on patch-at-heading-and-distance 0 1
            [
              set heading 180
              fd 1
              relocate
            ]
          ]
        ]
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
      [
        set Number-of-TA-divisions 5
      ]
      [
        set Number-of-TA-divisions 4
      ]
    ]
    ask turtles with [color = 85]
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
          [
            set Number-of-TA-divisions 5
          ]
          [
            set Number-of-TA-divisions 4
          ]
        ]
      ]
      if (count turtles with [color = pink] < 200) and (count turtles with [color = pink] >= 150)
      [
        ask turtles with [(color = pink) ]
        [
          let s random 99
          ifelse s < 37.5
          [
            set Number-of-TA-divisions 5
          ]
          [
            set Number-of-TA-divisions 4
          ]
        ]
      ]
      if (count turtles with [color = pink] < 150) and (count turtles with [color = pink] >= 100)
      [
        ask turtles with [(color = pink) ]
        [
          let s random 99
          ifelse s < 25
          [
            set Number-of-TA-divisions 5
          ]
          [
            set Number-of-TA-divisions 4
          ]
        ]
      ]
      if (count turtles with [color = pink] < 100) and (count turtles with [color = pink] >= 75)
      [
        ask turtles with [(color = pink) ]
        [
          let s random 99
          ifelse s < 12.5
          [
            set Number-of-TA-divisions 5
          ]
          [
            set Number-of-TA-divisions 4
          ]
        ]
      ]
      if (count turtles with [color = pink] < 75)
      [
        set percent-stem 20
        ask turtles with [(color = pink)]
        [
          set Number-of-TA-divisions 4
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
    if (TA?) and (color = pink)
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
  if count turtles with [add = 1] = 0
  [
    stop
  ]
  ;;let k (active-TA - (count turtles with [add = 1]) + (count turtles with [minus = 1]))
  set adding (active-TA / (active-TA - (count turtles with [add = 1]) + (count turtles with [minus = 1])))
  set reducing (((count turtles with [minus = 1]) - (count turtles with [add = 1])) / (active-TA - (count turtles with [add = 1]) + (count turtles with [minus = 1])))
 
  if adding > 1.20
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
  if reducing > 0.4
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
    set psos [0 1 2 3 8 8 2 1 0 1 0 -1 0 -1 -2 -8 -8 -3 -2 -1 ]
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
    set psos [0 1 2 3 7 7 2 1 0 1 0 -1 0 -1 -2 -7 -7 -3 -2 -1 ]
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
    set psos [0 1 2 2 5 5 2 1 0 1 0 -1 0 -1 -2 -5 -5 -2 -2 -1 ]
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
    set psos [0 0 1 2 4 4 2 1 0 1 0 -1 0 -1 -2 -4 -4 -1 -2 0 ]
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
    set psos [0 0 1 1 3 3 2 1 0 1 0 -1 0 -1 -2 -3 -3 -1 -1 0 ]
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
  if positions = 1
  [
    set psos [0 0 1 1 2 2 2 1 0 1 0 -1 0 -1 -2 -2 -2 -1 -1 0 ]
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
  ask patches with [pycor = -2]
  [
    set gradient 100
  ]
  ask patches with [pycor = -1]
  [
    set gradient 50
  ]
  ask patches with [pycor >= 0]
  [
    set gradient 0
  ]
surface
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
        shift-down
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
  if (color = 85) and (stem-clock > stem-cell-cycle)
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
  if (color = grey) and (stem-clock > stem-cell-cycle) and (percent-stem = 20)
  ;;if (color = grey) and (stem-clock > stem-cell-cycle) and (grey-clock > 200)
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
  [
    stop
  ]
  if (TA?) and (divide >= Number-of-TA-divisions)
  [
    set color 134
    ;;set time-since-stem time-since-stem + 1000
    set time-since-stem 1000
  ]
  if (TA?) and (((TA-clock >= TA-cell-cycle) and (divide < Number-of-TA-divisions)) and not (dying?))
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
  if (color = 134) and ([gradient] of patch-here < 1900)
  [
    set TA? false
    set stem? false
    set diff? true
    set dermis? false
    set color 65
    set time-as-differentiated 0
    set time-since-stem time-since-stem + 5000
    ;;set time-since-stem time-since-stem + 1000
    set add 0
    set minus 0
    stop
  ]
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
  set treatments treatments + 1
  set turn-clock 36
    ;;TODO - set criteria for the number of apoptotic cells 
    ask turtles with [(color = pink) or (color = 134)]
    [
    if random 99 < 3
    [ set dying? true ]
    ]
   
    ask turtles with [color = 85]
    [
      if random 99 < 2
        [ set color grey
          set grey-clock 0
        ]
      ]
    ask turtles with [color = 65]
    [
      if random 99 < 1
        [ set dying? true ]
      ]
end

to setup-plot
  set-current-plot "Populations"
end

to evaluate-params
  set TA-count count turtles with [color = pink or color = 134 or color = white]
  set diff-count count turtles with [color = 65]
  set stem-count count turtles with [color = 85]
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
@#$#@#$#@
GRAPHICS-WINDOW
267
16
763
533
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
19
10
90
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
129
10
192
43
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

SLIDER
15
135
218
168
stem-cell-cycle
stem-cell-cycle
0
300
150
1
1
hours
HORIZONTAL

SLIDER
15
188
201
221
TA-cell-cycle
TA-cell-cycle
0
200
60
1
1
hours
HORIZONTAL

SWITCH
951
515
1130
548
cytokine-stimulus
cytokine-stimulus
1
1
-1000

SWITCH
865
562
1134
595
Start-with-psoriasis-phenotype
Start-with-psoriasis-phenotype
1
1
-1000

SLIDER
14
240
230
273
Number-of-TA-divisions
Number-of-TA-divisions
0
10
4
1
1
NIL
HORIZONTAL

SLIDER
11
480
258
513
irradiation-frequency
irradiation-frequency
0
100
48
1
1
hours
HORIZONTAL

SLIDER
13
527
225
560
Number-of-treatments
Number-of-treatments
0
50
0
1
1
NIL
HORIZONTAL

MONITOR
778
22
835
67
TA cells
TA-count
17
1
11

MONITOR
897
413
961
458
NIL
positions
17
1
11

MONITOR
824
412
881
457
UVB
treatments
17
1
11

MONITOR
889
28
953
73
Diff cells
diff-count
17
1
11

MONITOR
1013
30
1145
75
Total number of cells
total-count
17
1
11

PLOT
781
91
1208
399
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
"Differentiated" 1.0 0 -10899396 true
"TA cells" 1.0 0 -2064490 true

MONITOR
1139
407
1196
452
NIL
uv-gap
17
1
11

MONITOR
975
412
1032
457
NIL
add-
17
1
11

MONITOR
1042
411
1100
456
NIL
minus-
17
1
11

MONITOR
785
471
857
516
NIL
active-TA
17
1
11

SWITCH
15
438
192
471
epidermis-adjust
epidermis-adjust
1
1
-1000

MONITOR
880
478
945
523
NIL
tx-count
17
1
11

SLIDER
13
400
211
433
treatments-per-week
treatments-per-week
0
50
3
1
1
NIL
HORIZONTAL

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

circle
false
0
Circle -7500403 true true 0 0 300

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

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

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
NetLogo 4.1.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@

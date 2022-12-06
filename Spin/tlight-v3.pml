mtype = { GREEN, AMBER, RED };
mtype = { GO, GSCHANGE, SGCHANGE, STOP };
bool tick = false;
mtype vstatus = GO;   /* variable to keep track of vehicle movement */
mtype vlight = GREEN; /* variable to keep track of vehicle traffic light */
bool cbutton = false; /* variable to keep track of cross button */
byte vctr = 0;        /* vehicle counter */
byte pctr = 0;        /* pedastrian counter */
mtype pstatus = STOP; /* variable to keep track of pedestrian movement */
mtype plight = RED;   /* variable to keep track of pedestrian traffic light */

active proctype trafficlight() 
{
    do
    :: atomic
    {

      if
        :: cbutton = false;
        :: cbutton = true;
      fi;

      if                                   
        :: tick = false;                 
        :: tick = true;                  
      fi;                                    
          
      if                                   
        :: vstatus == GO -> vlight = GREEN;    
        :: vstatus == GSCHANGE -> vlight = AMBER;
        :: vstatus == SGCHANGE -> vlight = AMBER;  
        :: vstatus == STOP -> vlight = RED;        
      fi; 

      if
        ::pstatus == GO -> plight = GREEN;
        ::pstatus == STOP -> plight = RED;
      fi;

     if 
        /* when the vstatus is go and a new pedestrian comes (and no one is there at the crossing from previous) then
        make pctr 1 */
        :: (vstatus == GO) && (vctr >= 3) && (cbutton == true) && (pctr == 0) && (tick) -> 
          vstatus = GSCHANGE; 
          vctr = 0; 
          pctr = 1;

        /* when the vstatus is go and atleast one pedestrian is waiting then pctr will be incremented by else part */
        :: (vstatus == GO) && (vctr >= 3) && (pctr != 0) && (tick) ->
          vstatus = GSCHANGE; 
          vctr = 0; 
          pstatus = STOP;

        /* when vstatus is gschange and vctr is 1 then make the vstaus stop. */
        :: (vstatus == GSCHANGE) && (vctr == 1) && tick -> 
          vstatus = STOP; 
          vctr = 0;
          pstatus=GO; 
          pctr = 0;

      /* When a new pedestrian comes (and no one is there at the crossing from previous) and vstatus is sgchange, set pctr to 1 and make vstatus go */
      :: (vstatus == SGCHANGE) && (vctr == 1) && (cbutton == true) && (pctr == 0) && (tick) -> 
          vstatus = GO; 
          vctr = 0;
          pstatus = STOP;
          pctr = 1;

      /* when the vstatus is sgchange and if cross button is true and there is at least one pedestrian or cross button is false then: pctr will be incremented by the else part */
      :: (vstatus == SGCHANGE) && (vctr == 1) && ((cbutton == true && pctr!=0) || cbutton == false) && tick -> 
          vstatus = GO; 
          vctr = 0;
          pstatus = STOP;

      /* vlight can't remain red for more than 3 units of time at a stretch, so changing the vstatus irrespective of
      variable status of pctr and cbutton */
      :: (vstatus == STOP) && (vctr == 3) && (tick) ->
          vstatus = SGCHANGE; 
          vctr = 0;
          pstatus = STOP;
          cbutton = false;
     
      :: else -> 
     
          if
              /* When a new pedestrian comes (and no one is there at the crossing from previous)
              and plight is not green, increase the pctr to 1 */
              :: (pstatus!=GO) && (pctr == 0) && (cbutton==true) && (tick) -> pctr = 1;

              /* When the plight is not green, and some pedestrians (is/are) waiting then increase the pctr by 1 */
              :: (pstatus!=GO) && (pctr != 0) && (tick) -> pctr = pctr + 1;

              /* Else keep the pctr as it is */
              ::  else -> pctr = pctr;
          fi;

          if 
              /* Increase vctr if its valus is < 3 and tick is true */
              :: (vctr < 3) && (tick) -> vctr = vctr + 1;

              /* Round off the value of vctr. It is needed for the VehGreen ltl. */
              :: (vctr >= 3) && (tick) -> vctr = 4;

              /* Else keep the vctr as it is */
              :: else -> vctr = vctr;
          fi;

      fi;

    }

  od;
}

ltl safety { []<> tick -> ((plight == GREEN) -> (vlight == RED)) };
ltl PedLiveness { []<> tick -> ([] (((cbutton && tick) == true) -> <> ((plight == GREEN) && (pctr<=5))))};
ltl VehLiveness { []<> tick -> ([] ((vlight == RED) -> <> (vlight == GREEN))) };
ltl VehGreen { []<> tick ->  ([] (cbutton == false) -> <>[] (vlight == GREEN)) };

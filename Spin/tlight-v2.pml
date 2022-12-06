mtype = { GREEN, AMBER, RED };
mtype = { GO, GSCHANGE, SGCHANGE, STOP };
bool tick = false;
mtype vstatus = GO;
mtype vlight = GREEN;
bool cbutton = false;
byte vctr = 0;
byte pctr = 0;
mtype plight = RED;
mtype pstatus = STOP;

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
        :: (vstatus == GO) && (vctr >= 3) && (cbutton == true) && (pctr == 0) && (tick) -> 
          vstatus = GSCHANGE; 
          vctr = 0; 
          pctr = 1;

        :: (vstatus == GO) && (vctr >= 3) && (pctr != 0) && (tick) ->
          vstatus = GSCHANGE; 
          vctr = 0; 
          pstatus = STOP;

      :: (vstatus == GSCHANGE) && (vctr == 1) && tick -> 
          vstatus = STOP; 
          vctr = 0;
          pstatus=GO; 
          pctr = 0;

      :: (vstatus == SGCHANGE) && (vctr == 1) && (cbutton == true) && (pctr == 0) && (tick) -> 
          vstatus = GO; 
          vctr = 0;
          pstatus = STOP;
          pctr = 1;

      :: (vstatus == SGCHANGE) && (vctr == 1) && ((cbutton == true && pctr!=0) || cbutton==false) && (tick) -> 
          vstatus = GO; 
          vctr = 0;
          pstatus = STOP;

      :: (vstatus == STOP) && (vctr == 3) && (cbutton == true) && (pctr == 0) && (tick) -> 
          vstatus = SGCHANGE; 
          vctr = 0;
          pstatus = STOP;
          pctr = 1;
          cbutton = false;

      :: (vstatus == STOP) && (vctr <= 3) && (cbutton == false) && (pctr == 0) && (tick) -> 
          vstatus = SGCHANGE; 
          vctr = 0;
          pstatus = STOP;
          cbutton = false;

      :: (vstatus == STOP) && (vctr == 3) && (pctr != 0) && (tick) ->
          vstatus = SGCHANGE; 
          vctr = 0;
          pstatus = STOP;
          cbutton = false;
     
      :: else -> 
     
          if
              :: (pstatus!=GO) && (pctr == 0) && (cbutton==true) && (tick) -> pctr = 1;
              :: (pstatus!=GO) && (pctr != 0) && (tick) -> pctr = pctr + 1;
              ::  else -> pctr = pctr;
          fi;

          if 
              :: (vctr < 3) && (tick) -> vctr = vctr + 1;
              :: (vctr >= 3) && (tick) -> vctr = 4;
              :: else -> vctr = vctr;
          fi;

      fi;

    }

  od;
}

ltl safety { []<> tick -> ((plight == GREEN) -> (vlight == RED)) };
ltl PedLiveness { []<> tick -> ([] (((cbutton && tick) == true) -> <> ((plight == GREEN) && (pctr<=6))))};
ltl VehLiveness { []<> tick -> ([] ((vlight == RED) -> <> (vlight == GREEN))) };
ltl VehGreen { []<> tick ->  ([] (cbutton == false) -> <>[] (vlight == GREEN)) };
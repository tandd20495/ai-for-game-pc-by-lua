LuaQ     @D:\TanDD8\yProject\Source\feature_yBreaker_Develop\AgeOfWushu_AUTO\Support\LuaCompile\sources\lua\admin_zdn\zdn_logic_nghe.lua                  A@  @    A    ÁĀ   A Ī      A ĪA               Ī      Á ĪÁ        Ī A ĪA               require    admin_zdn\zdn_util           ð?        
   IsRunning    Start    Stop 	   loopNghe    isCurseLoading    processGame        
                                                Running               Ä   Ú         H   Â  Č   Ä   Ú   @Å   Ü@ Å@    Ü@ ý     	   loopNghe 	   nx_pause đ?                                                                      profession        
   formulaId           num              Running    Profession 
   FormulaId    MaxTurn             
            A@    ÅĀ  Ü  @        nx_execute    admin_zdn\zdn_event_manager    TriggerEvent    nx_current    on-task-stop     
                                           Running     "   5     <              @  A   EĀ     \ Z   ĀF A Z    E@    Á  \@  E@   \    EĀ     \ Z   ĀF A Z    E@    Á \@  EĀ    \  Â     E@  ÁĀ  D  EA  \  Á \@EĀ \ H           isCurseLoading 	   nx_value 6   form_stage_main\form_small_game\form_game_handwriting    nx_is_valid    Visible    processGame 2   form_stage_main\form_small_game\form_game_picture 
   TimerDiff       ð?   nx_execute    custom_sender    custom_send_compose 
   nx_string    nx_int         
   TimerInit     <   #   #   #   #   $   &   &   &   '   '   '   '   '   '   '   '   (   (   (   (   )   +   +   +   +   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   .   0   0   0   0   0   1   3   3   3   3   3   3   3   3   3   3   3   3   4   4   4   5         form    ;         TimerStartCompose 
   FormulaId     7   =            A@   E     \ Z   @FĀ@ Z    E@ \ G  E   \ XĀÁ   B@  B  ^       	   nx_value 1   form_stage_main\form_main\form_main_curseloading    nx_is_valid    Visible    TimerCurseLoading 
   TimerInit 
   TimerDiff       ā?       8   8   8   9   9   9   9   9   9   9   9   :   :   :   <   <   <   <   <   <   <   <   =         load               ?   K           Æ@@      @@ @    Ā  Ä     A    @ Ā   FA@ @    A  Ā        B@ @ @   
      nx_is_valid 
   btn_start    Visible 
   TimerDiff       ð?   nx_execute    on_btn_start_click 
   TimerInit            Stop         @   @   @   @   @   @   @   @   @   A   A   A   A   A   B   D   D   D   D   D   E   E   E   F   F   F   H   H   H   I   I   K         form           formStr              TimerStartGame    MaxTurn                                      
                              5   5   5   "   =   7   K   K   K   ?   K         Running       
   FormulaId          Profession          MaxTurn          TimerStartGame          TimerStartCompose 	          
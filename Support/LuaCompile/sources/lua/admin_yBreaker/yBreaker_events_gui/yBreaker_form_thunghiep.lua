LuaQ  ¢   @D:\TanDD8\yProject\Source\feature_yBreaker_Develop\AgeOfWushu_AUTO\Support\LuaCompile\sources\lua\admin_yBreaker\yBreaker_events_gui\yBreaker_form_thunghiep.lua           ;      A@  @    A  @    AÀ  @    A  @    A@ @    A @    AÀ @    A  @    A@ @    A @    AÀ ¤     ¤@  @ ¤   ¤À     À ¤       ¤@    @ ¤         ¤À     À ¤    ¤@ @         require    const_define 	   util_gui    util_functions    share\server_custom_define    define\sysinfo_define    share\chat_define    define\request_type 
   util_move 2   admin_yBreaker\yBreaker_admin_libraries\tool_libs    admin_zdn\zdn_util '   admin_yBreaker\yBreaker_form_thunghiep    on_form_main_init    on_main_form_open    on_main_form_close    change_form_size    on_btn_close_click    show_hide_form_thunghiep    on_btn_thunghiep_click    start_thu_nghiep    thu_nghiep 
   checktime 
                  	@@	@@        Fixed     is_minimize                       form                           E   \@ 	ÀFÀ@ I@F@A I@FA   Á@  IFA I Ã        change_form_size    is_minimize     cbtn_tiendo    Visible    lbl_tiendo    btn_control    Text    nx_function    ext_utf8_to_widestr    Cháº¡y 
   ForeColor    255,255,255,255                                                              form                    "        E      \@         nx_destroy        !   !   !   "         form                $   .           D    E@     \ Z@      E     \ 	 ÁÁ ÀA		 B  	   	   nx_value    nx_is_valid    gui    Left       Y@   Top    Height        @     V@       %   %   %   &   &   &   &   &   '   *   *   *   +   ,   ,   ,   -   .         form          gui          
   THIS_FORM     0   6       E      \ @  À   @        À  @      	   nx_value    nx_is_valid    on_main_form_close        1   1   1   2   2   2   2   2   3   5   5   5   6         btn           form          
   THIS_FORM     8   :           D   @         util_auto_show_hide_form        9   9   9   :          
   THIS_FORM     =   S    4   F @ @  À   @        Ä     B   Å@    Ü Ú   @Ä  Ú   Å  A A Ü	À	 ÂÂ   È  Å@  AA  Ü@  ÀÅ  A AÁ Ü	À	 ÃÂ  È  Å@  AA A Ü@  Å Ü@         ParentForm    nx_is_valid    util_get_form    Text    nx_function    ext_utf8_to_widestr    Cháº¡y 
   ForeColor    255,255,255,255    tools_show_notice     Káº¿t thÃºc treo thá»¥ nghiá»p    Dá»«ng    255,220,20,60 !   Báº¯t Äáº§u treo thá»¥ nghiá»p    start_thu_nghiep     4   >   @   @   @   @   @   A   D   D   D   D   D   E   E   E   E   E   F   F   F   G   G   G   G   G   H   I   I   J   J   J   J   J   J   J   L   L   L   L   L   M   N   N   O   O   O   O   O   O   P   P   S         btn     3      form    3      form    3      
   THIS_FORM    is_running     V   ó     Ê      @ @q@  A  À           E  @ \   Á  ÅÀ   Ü Ú@       Ã  @  Â  À  Á @ A       AÂ  KAB\  Ê  ÉÁBÉAC
  	C	ÂCJ  IDIBD  DÂDÊ  ÉEÉBE
  	E	ÃEJ  IFICF  FÃF¢A Å Ü Ú  @^Å B Ü  @ ^ÚA   ^ @     Â A B B[  KHÁÂ \	  W@IÀ 	  I@  À5Â À     
HÃ  @ÀÂIÃ Á
  A
 àÆÆÂÀÅ	 Ü CW ÀÅ	 Ü W@ÉÀ Å	 Ü É@  ÅC  D
 A
 ÜCÅÃ
  ÜC ßÂø@*Â À    'HC  @@&ÂIC Å   Ü ÀË A	 C Ã
 A C  $	  FCÌ@@  @"	  FÌ@@Ã E	 \ ÍÅC ÍFÄÍÎÀ  @ ÜÀÀÅ Ü ÚC  @ÅÃ 	  @ À ÜC@ËÏÜ 
 ED FÏ\ 
  Ä AE  E  Å FÅ   @ÅH
Å   ÀÅÅI
Å  P
@ÅÅI
E FÍ@
	B  ÀË
E  ÁE
  FÆFÆÐE Å
 Á E E Á  FÅQûÅ
 Á E ÒÁ
  A
 àÅÅF   AG ÜF ÅÆ
  ÜF ßýÅÅ
  ÜE  î  ÀR AC	 C Ã
 A C À EC   Á C Ã
 A C @ ÁB	 B Â
 Á B  ÁB   @À B  @ ÅB  Ü Ã @ C  @	  EÃ  \ WÀËÃ Å	 Ü ÍED ÍÆÄÍÎ@ À \@ÀE \ ZD  ÀEÄ 	  À  @ \DÀE \D ED \D KÏ\ 
 ÅD ÆÏ	 Ü 
  DÅ ÆE    EHÆ   
EÅIÆ  P 	EÅIF ÆÍÀ@Â  ÀËF  AF
  ÆFÆÆÐF Æ
 A F F A  ÆÅQûÆ
 A F F  A F ÆÒF Æ
 A F   òÄ
 Á
 D À ÅÃ  AD ÜC  Ã
 Á C @Å Â A Â ÜA  ÅÁ
  ÜA   X      nx_execute    admin_zdn\zdn_logic_skill    IsPlayerDead 	   nx_value    game_client    game_visual    nx_is_valid 	   GetScene 
   GetPlayer    name    school_jinyiwei    map 	   school01    school_gaibang 	   school02    school_junzitang 	   school03    school_jilegu 	   school04    school_tangmen 	   school05    school_emei 	   school06    school_wudang 	   school07    school_shaolin 	   school08 
   checktime    loading    X_DeadState 	   X_Relive    near       (@	   FindProp    School    map_id    city04    city05 
   QueryProp       ð?   custom_sender     custom_return_school_home_point 	   nx_pause       $@
   NewSchool    atData  	   tele_map    related_map    telemap    find_npc_pos    npc_id    distance3d 
   PositionX 
   PositionY 
   PositionZ       @   be_finding    move_    GetSceneObjList    table    getn    Type       @	   ConfigID    custom_select    Ident É?   util_get_form     form_stage_main\form_talk_movie    Visible 
   talk_code    menu_select    X_GetHomeSchool     send_homepoint_msg_to_server    Use_HomePoint ;   form_stage_main\form_school_dance\form_school_dance_member    thu_nghiep    X_StopFinding 
   xuongngua    tools_show_notice    nx_function    ext_utf8_to_widestr    Sai vá» trÃ­!        @"   ChÆ°a Äáº¿n giá» thá»¥ nghiá»p     Ê  X   X   X   Z   Z   Z   Z   Z   Z   [   ^   _   _   _   `   `   `   a   a   a   a   a   b   d   e   e   f   f   f   g   g   g   g   g   h   l   l   m   m   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   p   p   p   p   q   q   q   r   r   r   r   s   s   s   s   s   t   t   t   t   t   v   w   w   w   x   x   x   x   x   x   x   x   y   y   z   z   z   z   z   z   z   z   z   z   {   {   {   |   |   |   |   }   }   }   }   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~                              |                                                                                                                                                                                                                                                                                                                                                                                £   £   £   ¥   ¦   ¦   ¦   ¦   §   §   §   §   §   ¨   ¨   ¨   ¦   ª   ª   ª   «      ¯   ±   ±   ±   ±   ²   ²   ²   ³   ³   ³   ³   µ   µ   µ   µ   µ   µ   ¶   ¶   ¶   ¸   º   º   º   »   »   »   ¾   ¾   ¾   ¿   ¿   ¿   ¿   À   À   À   Á   Á   Á   Á   Á   Â   Â   Ã   Ã   Ã   Å   Å   Æ   Æ   Æ   Æ   Æ   Ç   Ç   Ç   Ç   Ç   Ç   Ç   Ç   Ç   Ç   È   È   È   È   É   É   É   É   É   É   É   Ê   Í   Í   Î   Î   Ï   Ï   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ò   Ò   Ò   Ò   Ó   Ó   Ó   Õ   Ö   Ö   ×   ×   ×   ×   ×   ×   Ø   Ø   Ø   Ù   Ù   Ù   Ù   Ú   Ú   Ý   Ý   Ý   Þ   Þ   Þ   Þ   Þ   ß   ß   ß   à   Ð   ä   ä   ä   å   ç   ç   ç   ç   ç   ç   è   è   è   í   ï   ï   ï   ï   ï   ï   ñ   ñ   ñ   ñ   ó   0      is_vaild_data    È     game_client    È     game_visual    È     game_scence    È     client_player %   È     visual_player '   È     batphai A   È     loading_flag H   ¾  
   ok_letsgo W   ¾     check_batphai Z   ¾     playerschool q         (for index) t         (for limit) t         (for step) t         i u         playerNewSchool    5     data ¢   5     npcx ¼         npcy ¼         npcz ¼         game_scence_objs Ô         (for index) Ú         (for limit) Ú         (for step) Ú         k Û        npc_id õ        is_talking ù     
   form_talk   	     TT_code        (for index)        (for limit)        (for step)        j        loading_flag ?  ¾     FORM_SCHOOL_MEMBER F  ¾     city M  ¾     data P  ¾     npcx W  ´     npcy W  ´     npcz W  ´     game_scence_objs s  ´     (for index) y  ±     (for limit) y  ±     (for step) y  ±     k z  °     npc_id   °     is_talking   °  
   form_talk ¢  £        is_running     ö   I    q    @  JÀ  IÀÀ  @AÀA@BIIÀB^   C  JÀ  I@ÃÀ  CÀC DIIÀB^  @D  JÀ  IÄÀ  ÀD E@EIIÀB^  E  JÀ  IÀÅÀ   F@FFIIÀB^  ÀF  JÀ  I ÇÀ  @GGÀGIIÀB^   H  JÀ  I@ÈÀ  HÀH IIIÀB^  @I  JÀ  IÉÀ  ÀIÀH JIIÀB^  @J  JÀ  IÊÀ  ÀJÀH KIIÀB^  @K  JÀ  IËÀ  ÀKÀH LIIÀB^  @L  JÀ  IÌÀ  ÀL M@MIIÀB^  B   ^    6      city05    npc_id    SMSY_School09    toa_do    x fffff@   y ÀÊ¡E7@   z ü©ñÒM@
   talk_code   L2ÃÊA   city04    SMSY_School10      x@      .@     @y@	   school01    SMSY_School01       o@'1¬RP@     RÀ	   school02    SMSY_School02 ¬Zd@ôýÔxé1@Ãõ(\èy@	   school03    SMSY_School03      @     ÀY@     Pr@	   school04    SMSY_School04      Àa@              DÀ	   school05    SMSY_School05       @      5À	   school06    SMSY_School06      ¸@     s@	   school07    SMSY_School07      Ð~@     pq@	   school08    SMSY_School08      è@     @S@      {@    q   ù   ù   ú   û   ü   ü   ü   ü   ü   ý   þ                         	  	  
                                                              !  !  "  #  $  $  $  $  $  %  &  )  )  *  +  ,  ,  ,  ,  ,  -  .  1  1  2  3  4  4  4  4  4  5  6  9  9  :  ;  <  <  <  <  <  =  >  A  A  B  C  D  D  D  D  D  E  F  H  H  I        map     p           K  _    ,   E   @  \   À   @  @      ÀÀ  Ð AÀ Á   À  Â   ÀÀ Â    À  Ã   @         	   nx_value    MessageDelay    nx_is_valid    GetServerSecond      õ@      @      ¼@     ÚÖ@      Ü@     ùå@     è@     ^ê@     í@    ,   L  L  L  M  M  M  M  M  N  N  P  P  Q  T  T  T  T  U  U  U  V  V  V  V  W  W  W  X  X  X  X  Y  Y  Y  Z  Z  Z  Z  [  [  [  ]  ]  _        arg     +      Message_Delay    +      Server_Second    +      Server_Time    +       ;                                                                           	   	   	   
   
   
                     "       .   .   $   6   6   0   :   :   8   S   S   S   =   ó   ó   V   I  ö   _  K  _        is_running    :   
   THIS_FORM     :       
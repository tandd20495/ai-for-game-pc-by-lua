LuaQ  �   @D:\TanDD8\yProject\Source\feature_yBreaker_Develop\AgeOfWushu_AUTO\Support\LuaCompile\sources\lua\admin_yBreaker\yBreaker_events_gui\yBreaker_form_customscan.lua           L      A@  @    A�  @    A�  @    A  @    A@ @    A� @    A� @    A  @ @ A� �   �   �� �@  �  �  �@ ��  ǀ �     �� �@    �  �     �@ ��    ǀ �      �� �@ �  �     �@ ��   � ǀ �    � �� �@   � �  �   � �@ ��   � ǀ �    �        ��  �       require    const_define 	   util_gui 
   util_move    util_functions    share\server_custom_define    define\sysinfo_define    share\chat_define    define\request_type (   admin_yBreaker\yBreaker_form_customscan ,   admin_yBreaker\yBreaker_form_customscan_set    on_form_main_init    on_form_setting_init    on_setting_open    on_setting_close    on_main_form_open    on_main_form_close    on_btn_close_click    on_btn_control_click    change_form_size    get_current_map    show_hide_form_custom    show_form_custom_set    on_btncheck_player    on_btncheck_guild    on_btncheck_npc    on_btncheck_checkbufplayer 	   auto_run                   	@@�	@@� �       Fixed     is_minimize                    
   form_main                           	@@�	@@�	@��	@@�	@�� �       Fixed     player    guild    npc    checkbufplayer                                form_setting                            �                     form_setting                             �                     form_setting                     %       E   \@� B   H   F@@ ��  �  A ���I� �F@@ I�A� �       change_form_size 
   btn_start    Text    nx_function    ext_utf8_to_widestr    Chạy 
   ForeColor    255,255,255,255        !   !   "   "   #   #   #   #   #   #   $   $   %      
   form_main              auto_is_running     &   )       B   H   E   �   \@  �       nx_destroy        '   '   (   (   (   )      
   form_main              auto_is_running     *   0       E   �   \� �@  � � �� �@    � � ��  � � �@  �    	   nx_value    nx_is_valid    on_main_form_close        +   +   +   ,   ,   ,   ,   ,   -   /   /   /   0         btn        
   form_main          
   THIS_FORM     2   A       F @ �@  � � �� �@    � � �   �    ��   �   ��  �  A ���	� �	�A�@�� � �   ��  �   ���	� �	@B��� �@�  �       ParentForm    nx_is_valid    Text    nx_function    ext_utf8_to_widestr    Chạy 
   ForeColor    255,255,255,255    Dừng    255,220,20,60 	   auto_run        3   4   4   4   4   4   5   7   7   7   8   8   9   9   9   9   9   :   :   <   <   =   =   =   =   =   >   ?   ?   A         btn        
   form_main             auto_is_running     C   L           D   � E@  �   \� Z@    � � 	�@�	@A� �    	   nx_value    nx_is_valid    Left       Y@   Top      �a@       D   D   D   E   E   E   E   E   F   I   K   L      
   form_main          
   THIS_FORM     N   P            A@  � �@    �    	   nx_value (   form_stage_main\form_map\form_map_scene    current_map        O   O   O   O   O   P               R   T           D   @  �       util_auto_show_hide_form        S   S   S   T          
   THIS_FORM     V   X           D   @  �       util_auto_show_hide_form        W   W   W   X             FORM_SETTING     Z   ]       E   �   � � \����@ I��� �       util_get_form    player    Checked        [   [   [   [   \   \   ]         cbtn           form_setting             FORM_SETTING     _   b       E   �   � � \����@ I��� �       util_get_form    guild    Checked        `   `   `   `   a   a   b         cbtn           form_setting             FORM_SETTING     d   g       E   �   � � \����@ I��� �       util_get_form    npc    Checked        e   e   e   e   f   f   g         cbtn           form_setting             FORM_SETTING     i   l       E   �   � � \����@ I��� �       util_get_form    checkbufplayer    Checked        j   j   j   j   k   k   l         cbtn           form_setting             FORM_SETTING     n   �     &     D   � � ��D � @� @��B � �  Ł  �  ܁ � ��   ܁ �A    �B   Ł  B ܁ � ��  �܁ �A    �B   @� ��ˁ�܁  ��   ܁ �A    �B   ˁA܁ @��  �܁ �A    �B   ��A܁ ���   ܁ �A    �B   Ł   ܁  @�� B    �B   @� �p�B� EB F��� \� ����C�B �B ��C �Bm��� �C���A ܃��   ��C�C�A ܃���ƃD �  ���� E DE܃ ��@��E���C�C�A ܃�W@�@��C�C�AD ܃�D�FFDKD��� \����  ����   	܄ �  ���D Ƅ�	� FH	܄�E �G
A� �EH	��FH	��H	�EH	���H��  �	 �� �FI��I� A�	 � E
 ��\� �
 ��	�� �
   
܇ 
 EH
 \� �  E
 ��
\� �
 � �� �
  	�܈ 	
 @	 � @	��� ��
 F ƃD �C  @���J �C  � ��K �  �:��E :��
 DDD�D �܃  
 FE FD�� W �@��
 DDD�� �܃  
 FDK FD�� W �@�Ń � FD�� �L �D�	� ܃  �  �1��C�C�A ܃�W@� 0��C�C�AD ܃�D�FFDKD��� \����  ����   	܄ �  �+��D Ƅ�	� FH	܄�E �G
A� �EH	��FH	��H	�EH	�D   ��
 FFKF��F \��  E
 �E �FE\� @�	����H��  �	 �� �FI��I� A�	 � E
 ��\� �
 ��	�� �
   
܇ 
 EH
 \� �  E
 ��
\� �
 � �� �
  	�܈ 	
 @	 � @	��� ��
 F ��K   @�� A� �F�� L GE� �    �	����H��  �	 �� �FI��I� AG � E
 ��\� �
 ��	�� �
   
܇ 
 EH
 \� �  E
 ��
\� �
 � �� �
  	�܈ 	
 @	 � @	��� ��
 F @��J   ��
 FFKF��� \��  E
 �FK �FE\� @�	����H��  �	 �� �FI��I� A� � E
 ��\� �
 ��	�� �
   
܇ 
 EH
 \� �  E
 ��
\� �
 � �� �
  	�܈ 	
 @	 � @	��� ��
 F ��L �  �� M@��C �C�� FDKD��� \��  E� ��M �DE	\ ܃  W ����C DDD�� �܃  D�FE�  �� \� F����  ����   	܄ �  ���D Ƅ�	� FH	܄�E �G
A� �EH	��FEF�
�E�EO�Eƅ����H��  �	 �� �FI��I� A� � E
 ��\� �
 ��	�� �
   
܇ 
 EH
 \� �  E
 ��
\� �
 � �� �
  	�܈ 	
 @	 � @	��� ��
 F �� AB B �} � A      util_get_form 	   nx_value    game_client    nx_is_valid    game_visual 
   GetPlayer 	   GetScene    GetSceneObjList    table    getn    mltbox_content    Clear       �?        	   FindProp    Type 
   QueryProp    player 
   nx_string    Edit_box_1    Text    all        @   OffLineState    Name    Ident 
   GuildName    GetSceneObj    string    format    %.0f 
   PositionX 
   PositionZ 
   PositionY    AddHtmlText    gui    TextManager    GetFormatText �   <font color="#00a8ff">{@0:name}</font> (<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>) <font color="#EA2027">{@8:bang}</font>    nx_widestr    get_current_map       �   guild    checkbufplayer    Edit_box_2    nx_function    find_buffer    Edit_box_4 �   <font color="#f6b93b">{@0:name}</font> (<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>) <font color="#EA2027">{@8:bang}</font> �   <font color="#4cd137">{@0:name}</font> (<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>) <font color="#EA2027">{@8:bang}</font>    npc       @   find 	   ConfigID    Edit_box_3  
   util_text (   form_stage_main\form_map\form_map_scene    current_map    DestX    DestY    DestZ �   <font color="#ff2bdf">{@0:name}</font> (<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>) 	   nx_pause       o   o   o   o   p   p   p   q   r   x   x   x   x   y   y   y   y   y   z   |   |   |   |   }   }   }   }   }   ~   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   *      form_setting         is_vaild_data         game_client 	        game_visual 	        game_player 	        player_client 	        game_scence 	     
   form_main =        game_scence_objs G   	  	   num_objs K   	     (for index) Q   	     (for limit) Q   	     (for step) Q   	     i R     	   obj_type S        player_dan_name s   �      player_dan_ident u   �      player_dan_bang y   �      player_target |   �      display_player_posX �   �      display_player_posZ �   �      pathX �   �      pathY �   �      pathZ �   �      player_dan_name �   �     player_dan_ident �   �     player_dan_bang �   �     player_target �   �     display_player_posX �   �     display_player_posZ   �     pathX   �     pathY   �     pathZ   �  	   npc_name �    
   npc_ident �       map �       npc_target �    	   npc_posX �    	   npc_posZ �       pathX �       pathY �       pathZ �          FORM_SETTING    auto_is_running 
   THIS_FORM L                                                                           
                                 %   %       )   )   &   0   0   *   A   A   2   L   L   C   P   N   T   T   R   X   X   V   ]   ]   Z   b   b   _   g   g   d   l   l   i   �   �   �   �   n   �      
   THIS_FORM    K      FORM_SETTING    K      auto_is_running    K       
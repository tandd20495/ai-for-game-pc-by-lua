LuaQ  �   @D:\TanDD8\yProject\Source\feature_yBreaker_Develop\AgeOfWushu_AUTO\Support\LuaCompile\sources\lua\admin_yBreaker\yBreaker_events_gui\yBreaker_form_jingmai.lua           *      A@  @ �  A�  �  �   �@ �@  ǀ �  �� ��      �  �      �@ �@     ǀ � �� �� �  �  �@ �@ ǀ � �� �� �  �     �@ �@   � ǀ � ��  �       require 2   admin_yBreaker\yBreaker_admin_libraries\tool_libs %   admin_yBreaker\yBreaker_form_jingmai       �?       @   on_form_main_init    on_main_form_open    on_main_form_close    on_btn_close_click    change_form_size    reload_form    on_btn_jingmai_in_click    on_btn_jingmai_out_click    on_btn_jingmai_inboss_click    on_btn_jingmai_outboss_click    on_btn_jingmai_close_click    on_btn_neigong_close_click    close_all_jingmai    active_jingmai    show_hide_form_jingmai           
        	@@�	@@� �       Fixed     is_minimize           	   
         form                           E   \@� 	���E�  \@�  �       change_form_size    is_minimize     reload_form                                form                           E   �   \@  �       nx_destroy                          form                          E   �   \� �@  � � �� �@    � � ��  � � �@  �    	   nx_value    nx_is_valid    on_main_form_close                                                     btn           form          
   THIS_FORM        (           D   � E@  �   \� Z@    � � 	�@�	@A� �    	   nx_value    nx_is_valid    Left       Y@   Top      �a@                                    !   &   '   (         form          
   THIS_FORM     -   �     3     D   � E@  �   \� Z@    � � E   ��  \� ��� �� � AAA ܀�
  � � �A� ���� `��KB�B �AAC \��W@� ��� ��B�  ��B�_��E  � \� �A�Ł � ܁ B  @�� B    � �   AB B��
  J  �� �� 
  J  �� �� ���   ��� A� ��  ���E �� �� �E � @�	F܅ F ��W@B
��E� F��
� � 
\E�E � 
� \��Z    ���AD�� A� ��  ���E �E �� �E � @�	F܅ F ��W@B
��E� F��
��� 
\E�E � 
� \��Z    ����D�� A� ��  ���E �� �� �E � @�	F܅ F ��W@B
��E� F��
� � 
\E�E � 
� \��Z    ���AD�� A� ��  ���E �� �� �E � @�	F܅ F ��W@B
��E� F��
��� 
\E�E � 
� \��Z    ����D� @�D � DG@ � �A���G E �D �� \��	D���G 	ɑ�G 	�ɒ���G E �D ��	 \��	D���G 	ʒ� DG@ �   �DJ E �D ��
 \��	D��DJ 	�ɒ��DJ E �D ��
 \��	D��DJ 	ʒ� DG@��  � �K E �D �D \��	D��K 	�ɒ��K E �D �� \��	D��K 	ʒ� DG@ �   ��K E �D � \��	D���K 	�ɒ���K E �D �D \��	D���K 	ʒ� DG@��  � ��L E �D �� \��	D���L 	�ɒ���L E �D � \��	D���L 	ʒ � 5   	   nx_value    nx_is_valid    game_client 
   GetPlayer    GetRecordRows    active_jingmai_rec               �?   QueryRecord        table    insert    game_config    login_account 
   nx_create    IniDocument 	   FileName    \yBreaker_config.ini    LoadFromFile        @   ReadString 
   nx_string    jingmai_in    jingmai 	   in_array    jingmai_out    jingmai_inboss    jingmai_outboss    nx_destroy    getn    btn_jingmai_close    Text    nx_function    ext_utf8_to_widestr    Đã tắt hết mạch 
   ForeColor    255,220,20,60    Enable     Tắt hết mạch    btn_jingmai_in    Đã kích Nội MAX BQ    Kích Nội MAX BQ     btn_jingmai_out    Đã kích Ngoại MAX STBK    Kích Ngoại MAX STBK    btn_jingmai_inboss    Đã kích Nội + LT    Kích Nội + LT    btn_jingmai_outboss    Đã kích Ngoại + Thủ    Kích Ngoại + Thủ     3  .   .   .   /   /   /   /   /   0   3   3   3   4   4   5   5   5   6   7   7   8   8   8   8   9   9   9   9   9   :   :   ;   ;   ;   ;   ;   8   @   @   @   A   B   B   B   C   C   C   C   C   D   F   F   F   F   G   H   I   J   K   L   M   N   O   O   O   O   Q   Q   Q   Q   R   R   R   R   R   R   R   R   R   R   R   S   S   T   T   T   T   T   U   U   U   U   U   U   V   Q   [   [   [   [   \   \   \   \   \   \   \   \   \   \   \   ]   ]   ^   ^   ^   ^   ^   _   _   _   _   _   _   `   [   e   e   e   e   f   f   f   f   f   f   f   f   f   f   f   g   g   h   h   h   h   h   i   i   i   i   i   i   j   e   o   o   o   o   p   p   p   p   p   p   p   p   p   p   p   q   q   r   r   r   r   r   s   s   s   s   s   s   t   o   y   y   y   {   {   {   {   {   {   |   |   |   |   |   |   }   }   ~   ~   ~   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   )      form    2     game_client    2     player_client    2     total    2     cur_actived_jingmai    2     (for index)    %      (for limit)    %      (for step)    %      i    $      jingmai    $      game_config (   2     account )   2     ini ,   2     jingmais_in 7   2     jingmais_out 8   2     matched_jingmai_in 9   2     matched_jingmai_out :   2     jingmais_inboss ;   2     jingmais_outboss <   2     matched_jingmai_inboss =   2     matched_jingmai_outboss >   2     (for index) E   `      (for limit) E   `      (for step) E   `      i F   _      jm Q   _      (for index) c   ~      (for limit) c   ~      (for step) c   ~      i d   }      jm o   }      (for index) �   �      (for limit) �   �      (for step) �   �      i �   �      jm �   �      (for index) �   �      (for limit) �   �      (for step) �   �      i �   �      jm �   �      
   THIS_FORM     �   �        F @ �@  � � �� �@    � � ��  ��  �@  �       ParentForm    nx_is_valid    active_jingmai    jingmai_in        �   �   �   �   �   �   �   �   �   �   �         btn     
      form    
           �   �        F @ �@  � � �� �@    � � ��  ��  �@  �       ParentForm    nx_is_valid    active_jingmai    jingmai_out        �   �   �   �   �   �   �   �   �   �   �         btn     
      form    
           �   �        F @ �@  � � �� �@    � � ��  ��  �@  �       ParentForm    nx_is_valid    active_jingmai    jingmai_inboss        �   �   �   �   �   �   �   �   �   �   �         btn     
      form    
           �   �        F @ �@  � � �� �@    � � ��  ��  �@  �       ParentForm    nx_is_valid    active_jingmai    jingmai_outboss        �   �   �   �   �   �   �   �   �   �   �         btn     
      form    
           �   �     
   F @ �@  � � �� �@    � � ��  �@�  �       ParentForm    nx_is_valid    close_all_jingmai     
   �   �   �   �   �   �   �   �   �   �         btn     	      form    	           �   �     ,   F @ �@  � � �� �@    � � ��  ��  �� �@    ܀ �@    � � � A܀ A  @�� A    � � A A� �� ��W B���A�� ���W ���A ��  EB � \ �A  	�C� �       ParentForm    nx_is_valid 	   nx_value    game_client 
   GetPlayer    nx_execute 2   admin_yBreaker\yBreaker_admin_libraries\tool_libs    getMinAndMaxNeigong     
   QueryProp    CurNeiGong    custom_sender    custom_use_neigong 
   nx_string 
   ForeColor    255,220,20,60     ,   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         btn     +      form    +      game_client 
   +      player_client    +      minNeigongID    +      maxNeigongID    +           �   �           A@  � K�@ \� ���  ����������   A� ������ A ��A� ܁�W ���B A� �� �   @� B  ��� �    	   nx_value    game_client 
   GetPlayer    GetRecordRows    active_jingmai_rec               �?   QueryRecord        nx_execute    custom_sender    custom_jingmai_msg 
   nx_string        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         game_client          player_client          total          (for index)          (for limit)          (for step)          i          jingmai             SUB_CLIENT_CLOSE_JINGMAI          Q   E   �@  \� ��� ��   ܀ A @�� A    � �   A� A� �
  K�\� Z  ��AA �� �A `A�K���    ܂  AC � U��� A� \��W�� ��� �D�  ��B�_�EA ��\A E� F��� \� ����E �A �� � ���� \A� � EA \A� AA �� ��D� �� �A `��E� �� �   E �\ \B  _�� �    	   nx_value    game_config    login_account 
   nx_create    IniDocument    nx_is_valid 	   FileName    \yBreaker_config.ini    LoadFromFile       �?       @   ReadString 
   nx_string    jingmai        table    insert    nx_destroy    getn            tools_show_notice    nx_function    ext_utf8_to_widestr m   Chưa thiết lập mạch nội, ngoại. Vui lòng thiết lập trước ở mục Thiết lập theo acc        @   close_all_jingmai    nx_execute    custom_sender    custom_jingmai_msg     Q                                     	  
  
  
  
                                                                                                                              type     P      game_config    P      account    P      ini    P   	   jingmais    P      (for index)    -      (for limit)    -      (for step)    -      i    ,      jm %   ,      (for index) F   P      (for limit) F   P      (for step) F   P      i G   O         SUB_CLIENT_ACTIVE_JINGMAI        "           A@  @  �       util_auto_show_hide_form %   admin_yBreaker\yBreaker_form_jingmai        !  !  !  "          *                     
                           (   (      �   �   -   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         "     "     
   THIS_FORM    )      SUB_CLIENT_ACTIVE_JINGMAI    )      SUB_CLIENT_CLOSE_JINGMAI    )       
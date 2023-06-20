 interface game_set_if();
   
     logic [4:0] button_num;
     //logic [5:0] mines;
     logic [9:0] board_size;
     logic [10:0] board_xpos;
     logic [10:0] board_ypos;
     logic [6:0] button_size;
     
     modport in (
         input button_num,
         //input mines,
         input board_size,
         input board_xpos,
         input board_ypos,
         input button_size
     );
     
     modport out (
         output button_num,
         //output mines,
         output board_size,
         output board_xpos,
         output board_ypos,
         output button_size
     );
     
 endinterface
 
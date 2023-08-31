 /**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Wojciech Miskowicz
 * 
 * Description:
 * Interface with game related parameters
 */

 interface game_set_if();
   
     logic [4:0] button_num;
     logic [9:0] board_size;
     logic [10:0] board_xpos;
     logic [10:0] board_ypos;
     logic [6:0] button_size;
     
     modport in (
         input button_num,
         input board_size,
         input board_xpos,
         input board_ypos,
         input button_size
     );
     
     modport out (
         output button_num,
         output board_size,
         output board_xpos,
         output board_ypos,
         output button_size
     );
     
 endinterface
 
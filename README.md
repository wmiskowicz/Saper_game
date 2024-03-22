Project: SAPER  
Author: Wojciech Miskowicz, Microelectronics in Technics and Medicine  
AGH University of Cracow  
Supervisor: dr Piotr Kaczmarczyk

The project was realised as part of subject Electronic Digital Circuts.  
The target device for this game is Digilent Basys3 z FPGA Artix-7.  
In order to play a mouse and monitor with VGA input is required.  

====== HOW TO PLAY ======  
Once the bitstream is loaded to the device a gray backround should appear.  
To start a game you need to press one of the following buttons to select level:  

BTNL - easy  
BTNC - medium  
BTNR - hard  

To enable a game please make sure that the SW0 is turned off.  
If you want to pause the game turn it on. It will stop a countdown.  

Left mouse button is for defusing and right for marking a flag.  
When you mark a flag you will see decresing index on digits 3 and 2.  
Also when SW0 is down you will see second countdown on digits 1 and 0.  

If you manage to defuse board before countown reaches 0, a "Game won" writing should appear.  
If you click left on the mine or countdown reaches 0, a "Game over" writing sould appear.  

If you feel like playing another game press BTND, for resetting a game.  

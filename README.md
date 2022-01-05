
Original Author: Justin Richards<br>
Modified by: Bao Pham<br>
Date: 28/Oct/2015<br>
Revision Date: 04/Jan/2021<br>

Title: Swampy Controller v1.0 for NodeMCU V3.0 (lua)

Description: Runs as webserver and webclient to control
and monitor Celair Evaporative Airconditioner (aka Swampy) by directly
interfacing to the LEDS and Button contacts on the remote controller.
The remote controller is connect to the main Control Box TEKELEK TEK632 v8
via 4 wires. +5V,+5 Return,Comms,Gnd
webserver provides status of 2 LEDS and control of 2 buttons
webclient regularly sends status via get method to log status

Runs on a ESP8266MOD from JayCar to IO breakout carrier board
https://www.jaycar.com.au/wifi-mini-esp8266-main-board/p/XC3802

Parts:

*D1 Wifi Mini Board<br>



Firmware Created From nodeMCU-build.com
https://nodemcu-build.com/

NodeMCU 3.0.0.0 built on nodemcu-build.com provided by frightanic.com
	branch: release
	commit: f25dc56d3c6213b8ac7ce46d1293466137746eae
	release: 
	release DTS: 202112300746
	SSL: false
	build type: float
	LFS: 0x0 bytes total capacity
	modules: adc,file,gpio,net,node,tmr,uart,wifi
 build 2022-01-04 07:16 powered by Lua 5.1.4 on SDK 3.0.1-dev(fce080e)

Initial Boot Normal Mode connected at 115,200 outputs 

ReFlashed with esptool.py
https://github.com/espressif/esptool

Pre-requisite Python Libraries - pyserial


Config 
     - INTERNAL://NODEMCU  0x00000
     - INTERNAL://BLANK    0x7E000
     - INTERNAL://DEFAULT  0x7C000
 Advanced
     -Baudrate 115,200
     -Flash Size 4MByte
     -Flash speed 40MHz   
     -SPI Mode DIO

To Change Baud Rate to 9600 issue: uart.setup(0,9600,8,0,1,1) 

Flash Commmand:

esptool.py --port com7 write_flash -fm dio 0x00000 nodemcu-release-8-modules-2022-01-04-07-16-58-float.bin

After Flashing, Boot in Normal Mode Connected at 115,200 on COM7 using ESPlorer v0.2.0 by 4refr0nt
https://github.com/4refr0nt/ESPlorer

LUA Files:
init.lua   - contains SSID/WIFI Network Settings
Swampy.lua - contains code for Webserver and toggle logic to control board

Upload Swampy.lua to Controller first
Load init.lua using "Save to ESP" Button


IO index    ESP8266 pin
0 [*]GPIO16 N/C
1    GPIO5  swFAN Output
2    GPIO4  swCOOL Output
3    GPIO0  N/C
4    GPIO2  N/C
5    GPIO14 ledFAN Input  When 0 LED is on
6    GPIO12 ledCOOL Input When 0 LED is on
7    GPIO13 N/C
8    GPIO15 N/C
9    GPIO3  N/C
10   GPIO1  N/C
11   GPIO9  N/C
12   GPIO10 N/C

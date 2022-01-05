# CELAIR Evaporative Cooler Controller aka Swampy
Original Author: Justin Richards<br>
Modified by: Bao Pham<br>
Date: 28/Oct/2015<br>
Revision Date: 04/Jan/2021<br>

Title: Swampy Controller v1.0 for NodeMCU V3.0 (lua)

Description: Runs as webserver and webclient to control
and monitor Celair Evaporative Airconditioner (aka Swampy) by directly
interfacing to the LEDS and Button contacts on the remote controller.
The remote controller is connect to the main Control Box TEKELEK TEK632 v8 via 4 wires.<br>

__PIN:__<br>
1. = RED +5V
2. = WHT +5 Return
3. = BLU Comms
4. = BLK Gnd

Webserver provides status of 2 LEDS and control of 2 push buttons
webclient regularly sends status via get method to log status<br>

Runs on a ESP8266MOD from JayCar to IO breakout carrier board<br>
https://www.jaycar.com.au/wifi-mini-esp8266-main-board/p/XC3802

#### Parts:

* 1 x XC3802 D1 Wifi Mini Board ESP8266MOD
* 1 x XC4514 Adruino Compatible DC Voltage Regulator
* 4 x RR0548 100ohm 0.5w Resistors<br>
* 1 x HM3414 4 Pin 0.1 Straight Locking Header 2.54 Pitch
* 1 x HM3404 4 Pin 0.1 Crimp Pins 2.54 Pitch
* 2 x HM3412 2 Pin 0.1 Straight Locking Header 2.54 Pitch
* 2 x HM3402 2 Pin 0.1 Header Crimp Pins 2.54 pitch
* 1m x WM4516 16 Core Rainbow Cable 0.12mm2 (26AWG)



__NodeMCU Documentation__<br>
https://nodemcu.readthedocs.io/en/release/upload/<br>

Firmware Created From nodeMCU-build.com<br>
https://nodemcu-build.com/<br>

NodeMCU 3.0.0.0 built on nodemcu-build.com provided by frightanic.com<br>
	branch: release<br>
	commit: f25dc56d3c6213b8ac7ce46d1293466137746eae<br>
	release: <br>
	release DTS: 202112300746<br>
	SSL: false<br>
	build type: float<br>
	LFS: 0x0 bytes total capacity<br>
	modules: adc,file,gpio,net,node,tmr,uart,wifi<br>
 build 2022-01-04 07:16 powered by Lua 5.1.4 on SDK 3.0.1-dev(fce080e)

Initial Boot Normal Mode connected at 115,200 outputs <br>

ReFlashed with esptool.py<br>
https://github.com/espressif/esptool<br>

Pre-requisite Python Libraries - pyserial<br>


Config <br>
* INTERNAL://NODEMCU  0x00000
* INTERNAL://BLANK    0x7E000
* INTERNAL://DEFAULT  0x7C000
 Advanced<br>
* Baudrate 115,200
* Flash Size 4MByte   
* SPI Mode DIO

To Change Baud Rate to 9600 issue:<br> 
`uart.setup(0,9600,8,0,1,1)`

Flash Commmand:<br>
`esptool.py --port com7 write_flash -fm dio 0x00000 nodemcu-release-8-modules-2022-01-04-07-16-58-float.bin`

After Flashing, Boot in Normal Mode Connected at 115,200 assuming COM7 is being used, via ESPlorer v0.2.0 by 4refr0nt<br>
https://github.com/4refr0nt/ESPlorer<br>

LUA Files:<br>
init.lua   - contains SSID/WIFI Network Settings<br>
Swampy.lua - contains code for Webserver and toggle logic to control board<br>

Upload Swampy.lua to Controller first<br>
Load init.lua using "Save to ESP" Button<br>


#### IO index    ESP8266 pin<br>
0.    RST N/C<br>
1.    A0  to TTC103 Thermistor<br>
2.    D0  N/C<br>
3.    D5  ledFAN<br>
4.    D6  ledCOOL<br>
5.    D7  N/C<br>
6.    D8  N/C<br>
7.    3V3 3.3V+ From StepDown Regulator<br>
8.    TX  N/C<br>
9.    RX  N/C<br>
10.   D1  swFAN Output<br>
11.   D2  swCOOL Output<br>
12.   D3  N/C
13.   D4  N/C
14.   G   3.3V- From StepDown Regulator<br>
15.   5V  N/C<br>

--[[

Original Author: Justin Richards
Modified by: Bao Pham
Date: 28/Oct/2015
Revision Date: 04/Jan/2021

Title: Swampy Controller v1.0

Description: Runs as webserver and webclient to control
and monitor Celair Evaporative Airconditioner (aka Swampy) by directly
interfacing to the LEDS and Button contacts on the remote controller.
The remote controller is connect to the main Control Box TEKELEK TEK632 v8
via 4 wires. +5V,+5 Return,Comms,Gnd
webserver provides status of 2 LEDS and control of 2 buttons
webclient regularly sends status via get method to log status

Runs on a ESP8266MOD from JayCar to IO breakout carrier board
https://www.jaycar.com.au/wifi-mini-esp8266-main-board/p/XC3802

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

--]]
swFAN = 1
swCOOL = 2
ledFAN = 5
ledCOOL = 6

gpio.write(swFAN, gpio.HIGH)
gpio.write(swCOOL, gpio.HIGH)

gpio.mode(swFAN, gpio.OUTPUT)
gpio.mode(swCOOL, gpio.OUTPUT)
gpio.mode(ledFAN, gpio.INPUT)
gpio.mode(ledCOOL, gpio.INPUT)

print()
print("Evaporative Cooler Web Controller Version 1.0 - Bao Pham")
print("January 2021")
print("-----------------------")
print("1 = LED OFF, 0 = LED ON")
print("-----------------------")
print ("FAN:" .. gpio.read(ledFAN))
print ("COOL:" .. gpio.read(ledCOOL))
print()


srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<title>Swampy</title><h1> JB's ESP8266 Evaporative Cooler Controller </h1>";
                 
        if (gpio.read(ledFAN)==0) then
                 buf = buf.."<p>GPI14 FAN LED is ON   ->  <a href=\"?pin=toggleFAN\"><button> Press for FAN mode OFF </button></a></p>";
        else
                 buf = buf.."<p>GPI14 FAN LED is OFF  ->  <a href=\"?pin=toggleFAN\"><button> Press for FAN mode ON  </button></a></p>";
        end
        if (gpio.read(ledCOOL)==0) then
                 buf = buf.."<p>GPI12 COOL LED is ON  ->  <a href=\"?pin=toggleCOOL\"><button>Press for COOL mode OFF</button></a></p>";
        else
                 buf = buf.."<p>GPI12 COOL LED is OFF ->  <a href=\"?pin=toggleCOOL\"><button>Press for COOL mode ON </button></a></p>";
        end
        
        --y = -4E-05x2 + 0.1079x - 4.9662
        -- Function produced from excel trendline polynomial formula. Data obtained by attaching
        -- thermistor to thermocouple. ADC/thermistor plotted against thermocouple readings
        -- auto logged values as temperature was slowly varied from 70deg to 16 deg
        -- this version of nodemcu only supports integer math so calcs below approximate
        -- Used TL431 to provide vRef of 2.5v across 10k thermistor in series with 1k5 res
        -- ADC value read using python script response = urllib2.urlopen('http://172.16.1.242/?pin=ADC')
        x = adc.read(0)
        a = x * x
        a = x / -25000
        b = x / 9
        c = 11
        y = a + b 
        y = y - c
        a = nil
        b = nil
        c = nil
   
        buf = buf .. "<p>ADC is ->  " .. x .. " Deg C is -> " .. y .. " <a href=\"?pin=ADC\"><button>ADC </button></a></p>"
        adc.read(0)
        local _on,_off = "",""
        if(_GET.pin == "toggleFAN")then
              gpio.write(swFAN, gpio.LOW);
              tmr.delay(100000) --100000 us to counter the switch debounce circuit 10000us for debug
              gpio.write(swFAN, gpio.HIGH);
              print ("GPIO5 swFAN pulsed LOW");
               buf = buf..[[<meta http-equiv="refresh" content="0; url=http://192.168.1.145/" />]]
        elseif(_GET.pin == "toggleCOOL")then
              gpio.write(swCOOL, gpio.LOW);
              tmr.delay(100000) --100000 us to counter the switch debounce circuit 10000us for debug
              gpio.write(swCOOL, gpio.HIGH);
              print ("GPIO4 swCOOL pulsed LOW");
               buf = buf..[[<meta http-equiv="refresh" content="0; url=http://192.168.1.145/" />]]
        elseif(_GET.pin == "ADC")then --Just gives plain text Status for Easy Read IoT-Buddy
               --buf = adc.read(0)
               buf = " Deg C is -> " .. y .. "\n";
               if (gpio.read(ledFAN)==0) then
                 buf = buf.." FAN is ON\n";
               else
                 buf = buf.." FAN is OFF\n";
               end
               if (gpio.read(ledCOOL)==0) then
                 buf = buf.." COOL is ON\n";
               else
                 buf = buf.." COOL is OFF\n";
               end 
              print ("STATUS Request");
        end
        y = nil
        x = nil

        print ("Web Server Accessed");
        --print(wifi.sta.getip());
        
        client:send("HTTP/1.1 200 OK\nContent-Type: text/html\n\n");
        --print(request)
        client:send(buf);
        --client:close();
       -- collectgarbage();
    end)
    conn:on("sent", function(client) client:close() end)
end)

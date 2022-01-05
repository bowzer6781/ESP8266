--[[

Author: Bao Pham
Date: 04/Jan/2022

Title: Init.lua
--]]

--init.lua

wifi.setmode(wifi.STATION)
station_cfg={ssid="SSID",pwd="PASSWORD"}
station_cfg.save=true
wifi.sta.config(station_cfg)

--wifi.sta.sethostname("SWAMPYESP")

if WIFI_STATIC_IP then
  wifi.sta.setip({ip = "192.168.1.145", netmask = "255.255.255.0", gateway = "192.168.1.1"})
end
wifi.sta.connect()

local tObj = tmr.create()
tObj:alarm(2000, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      tObj:unregister()
      print("WIFI Config Applied, IP is " .. wifi.sta.getip())
      print()
      print("Launch Web Browser to http://" .. wifi.sta.getip())
      dofile("Swampy.lua")
    end
  end)

Temp_Humi_Pin = 1
id  = 0
sda = 5 -- GPIO14
scl = 6 -- GPIO12
sla = 0x3c
i2c.setup(id, sda, scl, i2c.SLOW)
disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
disp:clearBuffer();
disp:setFontPosTop()
disp:setFont(u8g2.font_unifont_t_symbols);
disp:drawStr(0,15,"Hello World!")
disp:drawStr(0,30,"--Created By RXD")
disp:sendBuffer();
cnt = 0
Net = 0
Refresh = 20
function showZH(x,y,w,h,str)
    file.open(str)
    local s=file.read()
    file.close()
    disp:drawXBM(x,y,w,h,s)
   end
function Acquire_Data()
    if wifi.sta.getip()==nil then
    Net=0
    else
    Net=1
    end
   local status,temp,humi,temp_dec,humi_dec = dht.read11(Temp_Humi_Pin)
   file.close()
   standardTime()
   disp:clearBuffer()
   disp:setFont(u8g2.font_unifont_t_symbols);
   showZH(0,0,16,16,"wendu")
   disp:drawStr(16,2,temp..string.char(176)..'C')
   disp:drawVLine(60,0,16)
   showZH(64,0,16,16,"shui")
   disp:drawStr(85,2,humi.."%")
   disp:drawHLine(0,16,128)
   showZH(0,17,16,16,"xiao")
   showZH(16,17,16,16,"yuan")
   showZH(32,17,16,16,"ka")
   showZH(0,34,16,16,"dian")
   showZH(16,34,16,16,"fei")
   if(card)
    then
        disp:drawStr(64,17,string.char(165)..' '..card)
    end
  if(room)
    then
        disp:drawStr(64,34,string.char(165)..' '..room)
    end
    disp:setFont(u8g2.font_6x10_tf);
    disp:drawHLine(0,51,128)
   disp:drawStr(0,53,cnt%100)
   if Net~=0 then
   disp:drawStr(14,53,string.rep("=",20-Refresh))
   else
   disp:drawStr(14,53,string.rep("+",20-Refresh))
   end
   disp:sendBuffer()
end
function getBalance()
if Net==1 then
    http.post('http://tysf.ahpu.edu.cn:8063/web/Common/Tsm.html',
               'Content-Type:application/x-www-form-urlencoded\r\n',
               'jsondata=%7B+%22query_elec_roominfo%22%3A+%7B+%22aid%22%3A%220030000000002501%22%2C+%22account%22%3A+%221953%22%2C%22room%22%3A+%7B+%22roomid%22%3A+%22219%22%2C+%22room%22%3A+%22219%22+%7D%2C++%22floor%22%3A+%7B+%22floorid%22%3A+%22%22%2C+%22floor%22%3A+%22%22+%7D%2C+%22area%22%3A+%7B+%22area%22%3A+%22%E5%AE%89%E5%BE%BD%E5%B7%A5%E7%A8%8B%E5%A4%A7%E5%AD%A6%22%2C+%22areaname%22%3A+%22%E5%AE%89%E5%BE%BD%E5%B7%A5%E7%A8%8B%E5%A4%A7%E5%AD%A6%22+%7D%2C+%22building%22%3A+%7B+%22buildingid%22%3A+%2252%22%2C+%22building%22%3A+%22%E7%94%B716%23%E6%A5%BC%22+%7D+%7D+%7D&funname=synjones.onecard.query.elec.roominfo&json=true',
  function(code, data, header)
    if (code < 0) then
        Net = 0
        cnt=cnt+1
      print("HTTP request failed")
    else
       room = string.sub(sjson.decode(data)["query_elec_roominfo"]["errmsg"],28,-1)
        http.post('http://220.178.164.65:8063/web/Common/Tsm.html',
        'Content-Type:application/x-www-form-urlencoded\r\n',
          'jsondata=%7B%22query_accinfo%22%3A%7B%22account%22%3A%221953%22%2C%22acctype%22%3A%22%22%7D%7D&funname=synjones.onecard.query.accinfo&json=true',
        function(code, data, header)
             if (code < 0) then
                  print("HTTP request failed")
             else
                  card = sjson.decode(data)["query_accinfo"]["accinfo"][1]["balance"]/100
                  print(card)
                  Net = 1
             end
            end)
             end
        end)
   else
       Net = 0
   end
end
function initWifi()
    time2=tmr.create()
    wifi.setmode(wifi.STATION)
    station_cfg={}
    station_cfg.ssid="RXD"
    station_cfg.pwd="19990511"
    station_cfg.save=true
    wifi.sta.config(station_cfg)
    wifi.sta.connect()
    time2:alarm(1000, tmr.ALARM_AUTO,function ()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
        getBalance()
        time2:unregister()
    end
end)Temp_Humi_Pin = 1
id  = 0
sda = 5 -- GPIO14
scl = 6 -- GPIO12
sla = 0x3c
i2c.setup(id, sda, scl, i2c.SLOW)
disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
disp:clearBuffer();
disp:setFontPosTop()
disp:setFont(u8g2.font_unifont_t_symbols);
disp:drawStr(0,15,"Hello World!")
disp:drawStr(0,30,"--Created By RXD")
disp:sendBuffer();
cnt = 0
Net = 0
Refresh = 0
loc = {}
function showZH(x,y,w,h,str)
    --print(str)
    file.open(str)
    local s=file.read()
    file.close()
    disp:drawXBM(x,y,w,h,s)
   end
function Acquire_Data()
    if wifi.sta.getip()==nil then
    Net=0
    else
    cnt = cnt + 1
    Net=1
    if cnt == 100 then
    getInfo()
    cnt = 0
    end
    end
    status,temp,humi,temp_dec,humi_dec = dht.read11(Temp_Humi_Pin)
end

function initWifi()
    time2=tmr.create()
    wifi.setmode(wifi.STATION)
    station_cfg={}
    station_cfg.ssid="ai"
    station_cfg.pwd="19990511"
    station_cfg.save=true
    wifi.sta.config(station_cfg)
    wifi.sta.connect()
    time2:alarm(1000, tmr.ALARM_AUTO,function ()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
        time2:unregister()
    end
end)
end

function Page1()
   disp:clearBuffer()
   disp:setFont(u8g2.font_unifont_t_symbols);
   showZH(0,0,16,16,"wendu")
   disp:drawStr(23,1,temp)
   showZH(39,0,16,16,"sheshidu")
   --disp:drawVLine(60,0,16)
   showZH(62,0,16,16,"shui")
   disp:drawStr(85,0,humi.."%")
   --disp:drawHLine(0,16,128)
   showZH(0,16,16,16,"xiao")
   showZH(16,16,16,16,"yuan")
   showZH(32,16,16,16,"ka")
   showZH(0,32,16,16,"dian")
   showZH(16,32,16,16,"fei")
   if(card)
    then
        disp:drawStr(64,17,string.char(165)..' '..card)
    end
  if(room)
    then
        disp:drawStr(64,33,string.char(165)..' '..room)
    end
    disp:setFont(u8g2.font_6x10_tf);
    disp:drawHLine(0,49,128)
    --if time and date then 
    --disp:drawStr(0,49,date)
    disp:drawStr(0,52,string.rep('-',cnt*1.28/6)..'>')
    --disp:drawStr(80,49,time)
    --end
   disp:sendBuffer()
end
function getInfo()
   if Net==1 then
    http.post('http://tysf.ahpu.edu.cn:8063/web/Common/Tsm.html',
               'Content-Type:application/x-www-form-urlencoded\r\n',
               'jsondata=%7B+%22query_elec_roominfo%22%3A+%7B+%22aid%22%3A%220030000000002501%22%2C+%22account%22%3A+%221953%22%2C%22room%22%3A+%7B+%22roomid%22%3A+%22219%22%2C+%22room%22%3A+%22219%22+%7D%2C++%22floor%22%3A+%7B+%22floorid%22%3A+%22%22%2C+%22floor%22%3A+%22%22+%7D%2C+%22area%22%3A+%7B+%22area%22%3A+%22%E5%AE%89%E5%BE%BD%E5%B7%A5%E7%A8%8B%E5%A4%A7%E5%AD%A6%22%2C+%22areaname%22%3A+%22%E5%AE%89%E5%BE%BD%E5%B7%A5%E7%A8%8B%E5%A4%A7%E5%AD%A6%22+%7D%2C+%22building%22%3A+%7B+%22buildingid%22%3A+%2252%22%2C+%22building%22%3A+%22%E7%94%B716%23%E6%A5%BC%22+%7D+%7D+%7D&funname=synjones.onecard.query.elec.roominfo&json=true',
                 function(code, data, header)
                    if code<0 then
                        Net = 0
                        print("HTTP request failed")
                    else
                        room = string.sub(sjson.decode(data)["query_elec_roominfo"]["errmsg"],28,-1)
                        http.post('http://220.178.164.65:8063/web/Common/Tsm.html','Content-Type:application/x-www-form-urlencoded\r\n','jsondata=%7B%22query_accinfo%22%3A%7B%22account%22%3A%221953%22%2C%22acctype%22%3A%22%22%7D%7D&funname=synjones.onecard.query.accinfo&json=true',
                        function(code, data, header)
                            if (code < 0) then
                                print("HTTP request failed")
                            else
                                card = sjson.decode(data)["query_accinfo"]["accinfo"][1]["balance"]/100
                                http.get('http://api.seniverse.com/v3/weather/now.json?key=SUrpogQUQqrS3OL8K&location=WTS4JZ3WMZMC&language=en&unit=c',nil,
                                    function(code,data,header)
                                    print('hello')
                                        if code < 0 then
                                            print('get weather failed')
                                        else
                                            weather = sjson.decode(data)['results'][1]['now']['text']
                                            loc[1] = '    '..sjson.decode(data)['results'][1]['now']['temperature']
                                            loc[2] = weather
                                            --print(weather)
                                        end
                                       end)
                                    Net = 1
                            end
                            end)
             end
        end)
      
   else
       Net = 0
   end
end
function Page2()
disp:clearBuffer()
disp:setFont(u8g2.font_unifont_t_symbols);
if weather then
    --disp:drawStr(76,0,weather)
    showZH(112,0,16,16,"sheshidu")
    if loc then
    for k,v in pairs(loc) do
    disp:drawStr(64,(k-1)*16,v)
    end
    end
    showZH(0,0,64,64,weather)
else
    disp:drawStr(0,0,"Waitting...")
end
disp:sendBuffer()
end
initWifi()
time1 = tmr.create()
time1:alarm(3000, tmr.ALARM_AUTO, Acquire_Data)
time3 = tmr.create()
local mode = 0
time3:alarm(1000,tmr.ALARM_AUTO,function()
    mode = mode + 1
    mode = mode % 10
    if mode >= 3 then
    Page1()
    else
    Page2()
    end
    end
)
end
function standardTime()
    Refresh = Refresh - 1
    if Refresh == 0 then
    getBalance()
    Refresh = 20
    end
  end
time1 = tmr.create()
time1:alarm(3000, tmr.ALARM_AUTO, Acquire_Data)
initWifi()

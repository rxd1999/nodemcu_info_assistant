dic ={0xE0,0x00,0xA0,0x00,0xA0,0x00,0xE0,0x00,0xA0,0x00,0xE0,0x00,0xA0,0x00,0xA0,0x00,0xA0,0x00,0xF0,0x00,0x08,0x01,0x44,0x02,0x84,0x02,0x04,0x02,0x08,0x01,0xF0,0x00}
a = ''
for k,v in pairs(dic)
do print(v)
a=a..string.char(v)
end
file.open("wendu","w")
file.write(a)
file.close()
dic=nil
file.remove("wendu.lua")
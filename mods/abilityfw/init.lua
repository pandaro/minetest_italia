abilityfw={}
dofile(minetest.get_modpath("abilityfw").."/abilities.lua")


abilityfw.ability_list={
	pick = 0,
	sword = 0,
	durability = 0,
	tool = 0,
	weaponspeed= 0,
	tooldrop = 0,
	jump = 0,
	speed= 0 ,
	gravity = 0,
	
}
abilityfw.base=[[  
size[12,12]
bgcolor[#5A5A5A;false]
label[0,0;XP points]

label[1,1;ABILITY]


label[0,1;CURRENT]

label[3,1;ADD]




]]	

minetest.register_on_newplayer(function(obj)
	--print(dump(obj))
	obj:set_attribute('xpPoints',100)
	for name, value in pairs( abilityfw.ability_list )do
		obj:set_attribute(name,value)
		print(tostring(name .. '' ..value))
		
	end

print('join')
end)
minetest.register_on_joinplayer(function(obj)
minetest.after(1, function(obj) 
	abilityfw.jump(obj,nil)
	abilityfw.speed(obj,nil)
	abilityfw.gravity(obj,nil)
end, obj)



	obj:set_attribute('xpPoints',100)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	
	print('field received')
	print(tostring(formname))
	print(dump(fields))
	if formname == 'abilityfw' and not fields.quit then 
		for name, value in pairs(fields) do
			if tonumber(player:get_attribute('xpPoints')) < 1 then break end
			print(tostring(player:get_attribute(name))) 
			
			player:set_attribute(name,player:get_attribute(name)+1)
			player:set_attribute('xpPoints',player:get_attribute('xpPoints')-1)
			print(tostring(player:get_attribute(name))) 
			if abilityfw[name] then
				
				abilityfw[name](player,name)
			end
			
		end
		abilityfw.redraw(player)
		minetest.show_formspec(player:get_player_name(), 'abilityfw', player:get_attribute('ability_layout'))
		
	end
end)
abilityfw.redraw = function(player)
			local abilities = abilityfw.base .. 'label[2,0;'..player:get_attribute('xpPoints')..']'
			local posy = 3
			for name,value in pairs(abilityfw.ability_list) do
				abilities = abilities .. 'label[0,' .. posy ..';' .. player:get_attribute(name).. ']'
				abilities = abilities .. 'label[1,' .. posy ..';' .. name.. ']'
				abilities = abilities .. 'button[3,' .. posy ..';1,0.5;' .. name.. ';+]'
				abilities = abilities .. 'background[0,' .. posy ..';1,0.5;' .. name.. ']'
				posy = posy +1
			end
			player:set_attribute('ability_layout',abilities)

end
	
minetest.register_node('abilityfw:table',{
	description = "test 1",
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		print(tostring(clicker:get_attribute('xpPoints')))
		abilityfw.redraw(clicker)
		minetest.show_formspec(clicker:get_player_name(), 'abilityfw', clicker:get_attribute('ability_layout'))
	end,
	
})
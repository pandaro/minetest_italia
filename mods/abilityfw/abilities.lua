print('abilities loaded') 
abilityfw.jump = function (player,points)
	print('jumpset')
	player:set_physics_override({jump = 1 + player:get_attribute('jump') / 100})
end
abilityfw.speed = function (player,points)
	print('speedset')
	player:set_physics_override({speed = 1 + player:get_attribute('speed') / 100})
end
abilityfw.gravity = function (player,points)
	print('Gset')
	player:set_physics_override({gravity = 1 - player:get_attribute('gravity') / 100})
end

abilityfw.getCaps = function(caps,player)
	local new_tool_caps = {}
	new_tool_caps.full_punch_interval = caps.full_punch_interval * 1 - player:get_attribute('weaponspeed')/100 
	new_tool_caps.max_drop_level = caps.max_drop_level * 1 + player:get_attribute('tooldrop')/100
	new_tool_caps.groupcaps = {}
	for t, table in pairs(caps.groupcaps) do
		new_tool_caps.groupcaps[t]={}
		new_tool_caps.groupcaps[t].uses = table.uses + player:get_attribute('durability') 
		new_tool_caps.groupcaps[t].times = {}
		for i,value in pairs(table.times) do
			new_tool_caps.groupcaps[t].times[i] = --[[table.times[i] * 1 - (player:get_attribute('tool')/10)]]0.1
		end
	end
	new_tool_caps.damage_groups = {}
	for name, value in pairs(caps.damage_groups) do
		new_tool_caps.damage_groups[name] = value * 1 + player:get_attribute('sword')/10
	end
	return new_tool_caps
			
end
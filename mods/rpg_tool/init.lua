rpg_tool={}
local timer = 0


rpg_tool.tool_set = function(self,stack,player,external)
print(dump(stack:to_table()))
	print(dump(player:get_player_name()))
	--local stack = player:get_wielded_item()
	local rpgTool = stack:get_definition()._rpg
	if not rpgTool then 
		print('no rpg tool')
		return 
	end
 	local meta = stack:get_meta()
	local caps = stack:get_definition().tool_capabilities
	local get_caps = abilityfw.getCaps(caps,player)
	print(dump(xxx))
	meta:set_int('palette_index',1)
	meta:set_int('level',xp.getLvl(player))
	meta:set_string('owner',player:get_player_name())
	meta:set_tool_capabilities({
		full_punch_interval = get_caps.full_punch_interval,
		max_drop_level = get_caps.max_drop_level,
		groupcaps = get_caps.groupcaps,
		damage_groups = get_caps.damage_groups
	})

		return stack
	
end


minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 1 then
		-- Send "Minetest" to all players every 5 seconds
		for i, v in pairs(minetest.get_connected_players())do
			print(' globalstep')
			local stack= v:get_wielded_item()
			if stack:get_definition()._rpg then
				local meta = stack:get_meta()
				local name = meta:get_string('owner')
				local level = meta:get_int('level')
				print(tostring('name '..name))
				if name ~= v:get_player_name() or level ~= xp.getXp(v)  then
					print('no name')
					print('nolevel')
					local new_stack = rpg_tool:tool_set(stack,v)
					v:set_wielded_item(new_stack)
					print(' global STOP')
					
				end
			end
		end
		timer = 0
	end
end)
-- minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
-- 		print('punchnode')
-- 		local stack = puncher:get_wielded_item()
-- 		local new_stack = rpg_tool:tool_set(stack,puncher)
-- 		puncher:set_wielded_item(new_stack)
-- 		
-- 	end)
-- 
-- minetest.register_on_punchplayer(function(player, hitter)
-- 	print(tostring('punchplayer'))
-- 	local stack = hitter:get_wielded_item()
-- 	local new_stack = rpg_tool:tool_set(stack,hitter)
-- 	hitter:set_wielded_item(new_stack)
-- 	
-- 
-- end)
	
minetest.register_tool("rpg_tool:1", {
	description = "rpg_tool 1",
	inventory_image = "default_tool_steelaxe.png",
	palette='m.png',
	_rpg = true,
	base_tool = 'rpg_tool:2',
-- 	on_place = function(itemstack, placer, pointed_thing)
-- 		print('on_placestart')
-- 		rpg_tool:tool_set(itemstack,placer)
-- 		return itemstack
-- 	end,
-- 	on_secondary_use = function(itemstack, user, pointed_thing)
-- 		print('on_placestart')
-- 		rpg_tool:tool_set(itemstack,user)
-- 		return itemstack
-- 	end,

	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			cracky={times={[2]=2.00, [3]=2.00}, uses=10, maxlevel=1}
		},
		damage_groups = {fleshy=2},
	},
})
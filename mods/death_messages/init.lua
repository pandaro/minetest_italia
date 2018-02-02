--[[
death_messages - A Minetest mod which sends a chat message when a player dies.
Copyright (C) 2016  EvergreenTree

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]
--Carbone death coords
--License of media (textures and sounds) From carbone subgame
--------------------------------------
--mods/default/sounds/player_death.ogg: from OpenArena – GNU GPL v2.
-----------------------------------------------------------------------------------------------
local title = "Death Messages"
local version = "0.2.0"
local mname = "death_messages"
-----------------------------------------------------------------------------------------------
dofile(minetest.get_modpath("death_messages").."/settings.txt")
-----------------------------------------------------------------------------------------------

--
-- Intllib support added by Hamlet for CarlBishop's Minetest Italia server
--

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


-- A table of quips for death messages.  The first item in each sub table is the
-- default message used when RANDOM_MESSAGES is disabled.
local messages = {}

-- Toxic death messages
messages.toxic = {
	S(" melted into a ball of radioactivity."),
	S(" thought chemical waste was cool."),
	S(" melted into a jittering pile of flesh."),
	S(" couldn't resist that warm glow of toxic water."),
	S(" dug straight down."),
	S(" went into the toxic curtain."),
	S(" thought it was a toxic-tub."),
	S(" is radioactive."),
	S(" didn't know toxic water was radioactive.")
}

-- Lava death messages
messages.lava = {
	S(" melted into a ball of fire."),
	S(" thought lava was cool."),
	S(" melted into a ball of fire."),
	S(" couldn't resist that warm glow of lava."),
	S(" dug straight down."),
	S(" went into the lava curtain."),
	S(" thought it was a hottub."),
	S(" is melted."),
	S(" didn't know lava was hot.")
}

-- Drowning death messages
messages.water = {
	S(" drowned."),
	S(" ran out of air."),
	S(" failed at swimming lessons."),
	S(" tried to impersonate an anchor."),
	S(" forgot he wasn't a fish."),
	S(" blew one too many bubbles.")
}

-- Burning death messages
messages.fire = {
	S(" burned to a crisp."),
	S(" got a little too warm."),
	S(" got too close to the camp fire."),
	S(" just got roasted, hotdog style."),
	S(" got burned up. More light that way.")
}

-- Other death messages
messages.other = {
	S(" died."),
	S(" did something fatal."),
	S(" gave up on life."),
	S(" is somewhat dead now."),
	S(" passed out -permanently."),
	S(" kinda screwed up."),
	S(" couldn't fight very well."),
	S(" got 0wn3d."),
	S(" got SMOKED."),
	S(" got hurted by Oerkki."),
	S(" got blowed up.")
}

-- PVP Messages
messages.pvp = {
	S(" fisted"),
	S(" sliced up"),
	S(" rekt"),
	S(" punched"),
	S(" hacked"),
	S(" skewered"),
	S(" blasted"),
	S(" tickled"),
	S(" gotten"),
	S(" sword checked"),
	S(" turned into a jittering pile of flesh"),
	S(" buried"),
	S(" served"),
	S(" poked"),
	S(" attacked viciously"),
	S(" busted up"),
	S(" schooled"),
	S(" told"),
	S(" learned"),
	S(" chopped up"),
	S(" deader than ded ded ded"),
	S(" CHOSEN to be the ONE"),
	S(" all kinds of messed up"),
	S(" smoked like a Newport"),
	S(" hurted"),
	S(" ballistic-ed"),
	S(" jostled"),
	S(" messed-da-frig-up"),
	S(" lanced"),
	S(" shot"),
	S(" knocked da heck out"),
	S(" pooped on")
}

-- Player Messages
messages.player = {
	S(" for talking smack about thier mother."),
	S(" for cheating at Tic-Tac-Toe."),
	S(" for being a stinky poop butt."),
	S(" for letting Baggins grief."),
	S(" because it felt like the right thing to do."),
	S(" for spilling milk."),
	S(" for wearing a n00b skin."),
	S(" for not being good at PVP."),
	S(" because they are a n00b."),
	S(" for reasons uncertain."),
	S(" for using a tablet."),
	S(" with the quickness."),
	S(" while texting.")
}

-- MOB After Messages
messages.mobs = {
	S(" and was eaten with a gurgling growl."),
	S(" then was cooked for dinner."),
	S(" then went to the supermarket."),
	S(" badly."),
	S(" terribly."),
	S(" horribly."),
	S(" in a haphazard way."),
	S(" that sparkles in the twilight with that evil grin."),
	S(" and now is covered by blood."),
	S(" so swiftly, that not even Chuck Norris could block."),
	S(" for talking smack about Oerkkii's mother."),
	S(" and grimmaced wryly.")
}

function get_message(mtype)
	if RANDOM_MESSAGES then
		return messages[mtype][math.random(1, #messages[mtype])]
	else
		return messages[1] -- 1 is the index for the non-random message
	end
end





minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
	local pos = player:getpos()
	local death = {x=0, y=23, z=-1.5}
	minetest.sound_play("player_death", {pos = pos, gain = 1})
	pos.x = math.floor(pos.x + 0.5)
	pos.y = math.floor(pos.y + 0.5)
	pos.z = math.floor(pos.z + 0.5)
	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	local player_name = player:get_player_name()
	if minetest.is_singleplayer() then
		player_name = S("You")
	end
	
	-- Death by lava
	if node.name == "default:lava_source" then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("lava"))
		--player:setpos(death)
	elseif node.name == "default:lava_flowing"  then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("lava"))
		--player:setpos(death)
	-- Death by drowning
	elseif player:get_breath() == 0 then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("water"))
		--player:setpos(death)
	-- Death by fire
	elseif node.name == "fire:basic_flame" then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("fire"))
		--player:setpos(death)
	-- Death by Toxic water
	elseif node.name == "es:toxic_water_source" then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("toxic"))
		--player:setpos(death)
	elseif node.name == "es:toxic_water_flowing" then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("toxic"))
		--player:setpos(death)
	elseif node.name == "groups:radioactive" then
		minetest.chat_send_all(
		string.char(0x1b).."(c@#00CED1)"..player_name .. 
		string.char(0x1b).."(c@#ff0000)"..get_message("toxic"))
		--player:setpos(death)	
		
	-- Death by something else
	else
		--minetest.chat_send_all(
		--string.char(0x1b).."(c@#ffffff)"..player_name .. 
		--string.char(0x1b).."(c@#ff0000)"..get_message("other"))  --toospammy
		--minetest.after(0.5, function(holding)
			--player:setpos(death)  --gamebreaker?
		--end)
	end
	
	
	--minetest.chat_send_all(string.char(0x1b).."(c@#000000)".."[DEATH COORDINATES] "..string.char(0x1b).."(c@#ffffff)" .. player_name .. string.char(0x1b).."(c@#000000)".." left a corpse full of diamonds here: " ..
	--minetest.pos_to_string(pos) .. string.char(0x1b).."(c@#aaaaaa)".." Come and get them!")
	--player:setpos(death)
	--minetest.sound_play("pacmine_death"), { gain = 0.35})  NOPE!!!
	
end)

--bigfoot code
-- bigfoot547's death messages
-- hacked by maikerumine

-- get tool/item when  hitting   get_name()  returns item name (e.g. "default:stone")
minetest.register_on_punchplayer(function(player, hitter)
	local pos = player:getpos()
	local death = {x=0, y=23, z=-1.5}
   if not (player or hitter) then
      return false
   end
   if not hitter:get_player_name() == "" then
      return false
   end
   minetest.after(0, function(holding)
      if player:get_hp() == 0 and hitter:get_player_name() ~= "" and holding == hitter:get_wielded_item() ~= "" then
	  
			local holding = hitter:get_wielded_item() 
				if holding:to_string() ~= "" then  
				local weap = holding:get_name(holding:get_name())
					if holding then  
					minetest.chat_send_all(
					string.char(0x1b).."(c@#00CED1)"..player:get_player_name()..
					string.char(0x1b).."(c@#ff0000)"..S(" was")..
					string.char(0x1b).."(c@#ff0000)"..get_message("pvp")..
					string.char(0x1b).."(c@#ff0000)"..S(" by ")..
					string.char(0x1b).."(c@#00CED1)"..hitter:get_player_name()..
					string.char(0x1b).."(c@#ffffff)"..S(" with ")..
					string.char(0x1b).."(c@#FF8C00)"..weap..
					string.char(0x1b).."(c@#00bbff)"..get_message("player"))  --TODO: make custom mob death messages
					
					end 	
				end

		if player=="" or hitter=="" then return end -- no killers/victims
        return true
	

		elseif hitter:get_player_name() == "" and player:get_hp() == 0 then
					minetest.chat_send_all(
					string.char(0x1b).."(c@#00CED1)"..player:get_player_name()..
					string.char(0x1b).."(c@#ff0000)"..S(" was")..
					string.char(0x1b).."(c@#ff0000)"..get_message("pvp")..
					string.char(0x1b).."(c@#ff0000)"..S(" by ")..
					string.char(0x1b).."(c@#FF8C00)"..hitter:get_luaentity().name..  --too many mobs add to crash
					string.char(0x1b).."(c@#00bbff)"..get_message("mobs"))  --TODO: make custom mob death messages
					
		if player=="" or hitter=="" or hitter=="*"  then return end -- no mob killers/victims
		else
		
        return false
      end
	   
   end)
   
end)

-----------------------------------------------------------------------------------------------
print("[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------

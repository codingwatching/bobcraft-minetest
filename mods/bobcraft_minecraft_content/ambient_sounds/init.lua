-- Plays ambient sounds. Such as cave sounds, water, lava, music, etc.
-- Reference taken from PilzAdam's ambient mod https://github.com/PilzAdam/MinetestAmbience/blob/master/init.lua

local music = {
	handler = {},
	frequency = 1,
	positioned = false,
	{name="plainsong", length = 1*60 + 14, gain = 0.3}
}

local lava_sounds = {
	handler = {},
	frequency = 900,
	positioned = true,
	{name="lava_pops", length=3, gain = 0.5}
}
local water_sounds = {
	handler = {},
	frequency = 750,
	positioned = true,
	{name="water_ambience", length=3, gain = 0.5}
}
local waterfall_sounds = {
	handler = {},
	frequency = 1000,
	positioned = true,
	{name="waterfall_ambience", length=3, gain = 0.5}
}

local function get_ambience(player)
	local table = {}

	table.music = music

	local lava = minetest.find_node_near(player:get_pos(), 15, "group:lava")
	if lava then
		table.lava = lava_sounds
		table.lava.position = lava
	end

	local water = minetest.find_node_near(player:get_pos(), 15, "group:water_source")
	if water then
		table.water = water_sounds
		table.water.position = water
	end
	local waterfall = minetest.find_node_near(player:get_pos(), 15, "group:water_flow")
	if water then
		table.waterfall = waterfall_sounds
		table.waterfall.position = waterfall
	end

	return table
end

local function play_sound(player, list, number, pos)
	local player_name = player:get_player_name()

	if list.handler[player_name] == nil then
		local gain = 1.0
		if list[number].gain ~= nil then
			gain = list[number].gain
		end

		local handler = minetest.sound_play(list[number].name, {to_player=player_name, gain=gain,
		pos = list.position})

		if handler ~= nil then
			list.handler[player_name] = handler
			minetest.after(list[number].length, function(args)
				local list = args[1]
				local player_name = args[2]
				if list.handler[player_name] ~= nil then
					minetest.sound_stop(list.handler[player_name])
					list.handler[player_name] = nil
				end
			end, {list, player_name})
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 1 then
		return
	end
	timer = 0
	
	for _,player in ipairs(minetest.get_connected_players()) do
		local ambiences = get_ambience(player)
		for _,ambience in pairs(ambiences) do
			if math.random(1, 1000) <= ambience.frequency then
				play_sound(player, ambience, math.random(1, #ambience), ambience.position)
			end
		end
	end
end)
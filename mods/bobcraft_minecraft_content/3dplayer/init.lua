-- Influence taken from minetest_game

player_model = {}
player_model.models = {}
player_model.players_model = {}
player_model.players_animation = {}

function player_model.register_model(name, def) 
	player_model.models[name] = def
end
function player_model.get_model(playername) 
	return player_model.players_model[playername]
end

function player_model.set_player_animation(player, animation_name) 
	local playername = player:get_player_name()
	local modelname = player_model.get_model(playername)
	local model = player_model.models[modelname]
	if not (model and model.animations[animation_name]) then
		return
	end

	player_model.players_animation[playername] = animation_name
	player:set_animation(anim, model.animation_speed, 0)
end

function player_model.set_model(player, modelname)
	local playername = player:get_player_name()
	local model = player_model.models[modelname]
	if model then
		player:set_properties({
			mesh = modelname,
			textures = model.textures,
			visual = "mesh",
			visual_size = {x=1, y=1},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			stepheight = 0.55,
			eye_height = 1.7,
		})
		player_model.players_model[playername] = modelname
	end
end

----
-- Globalstep
----
minetest.register_globalstep(function()
	for _, player in pairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local model_name = player_model.get_model(player_name)
		local model = model_name and player_model.models[model_name]
		if model then
			local controls = player:get_player_control()

			if controls.up or controls.down or controls.right or controls.left then
				player_model.set_player_animation(player, "walk")
			else
				player_model.set_player_animation(player, "walk")
			end
		end
	end
end)

----
-- Default stuff
----
player_model.register_model("player.b3d", {
	animation_speed = 30,
	textures = {"aeternitas.png"},
	animations = {
		stand = {
			x = 0,
			y = 10
		},
		walk = {
			x = 15,
			y = 25
		}
	}
})

minetest.register_on_joinplayer(function(player)
	player_model.set_model(player, "player.b3d")
	player:set_local_animation(
		{x = 0, y = 10}, -- Idle/stand
		{x = 15, y = 25}, -- Walk
		{x = 65, y = 70}, -- Dig
		{x = 0, y = 10}, -- WalkDig
		15 -- FPS
	)
end)

local path = minetest.get_modpath("3dplayer")

dofile(path .. "/hand.lua")
dofile(path .. "/weild.lua")
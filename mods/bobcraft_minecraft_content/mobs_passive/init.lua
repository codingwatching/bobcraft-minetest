local function brain(self)
	mobkit.vitals(self)

	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return		
	end

	if mobkit.timer(self, 1) then
		local priority = mobkit.get_queue_priority(self)

		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
		end
	end
end

minetest.register_entity("bobcraft_mobs:sheep", {
	physical = true,
	stepheight = 0.6,
	collide_with_objects = true,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5,},
	visual = "mesh",
	mesh = "sheep.b3d",
	textures = {"sheep.png"},
	static_save = true,
	makes_footstep_sound = true,
	
	-- Required Mobkit
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,

	springiness = 0, -- TODO: Investigate
	buoyancy = 0.75,
	max_speed = 5,
	view_range = 16,
	lung_capacity = 10,
	max_hp = 8,
	timeout = 600, -- TODO: Investigate
	sounds = {
		idle = "pig_idle" -- PIG SOUND?
	},

	jump_height = 1,

	brainfunc = brain,
	
	-- animations
	animation = {
		stand = {
			range = {
				x = 0,
				y = 0,
			},
			speed = 15,
			loop = true,
		},
		walk = {
			range = {
				x = 15,
				y = 25,
			},
			speed = 15,
			loop = true,
		}
	}
})

-- Pigge ;D
minetest.register_entity("bobcraft_mobs:pig", {
	physical = true,
	stepheight = 0.6,
	collide_with_objects = true,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5,},
	visual = "mesh",
	mesh = "pig.b3d",
	textures = {"pig.png"},
	static_save = true,
	makes_footstep_sound = true,
	
	-- Required Mobkit
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,

	springiness = 0, -- TODO: Investigate
	buoyancy = 0.75,
	max_speed = 5,
	view_range = 16,
	lung_capacity = 10,
	max_hp = 8,
	timeout = 600, -- TODO: Investigate
	sounds = {
		idle = "pig_idle"
	},

	jump_height = 1,

	brainfunc = brain,
	
	-- animations
	animation = {
		stand = {
			range = {
				x = 0,
				y = 0,
			},
			speed = 15,
			loop = true,
		},
		walk = {
			range = {
				x = 15,
				y = 25,
			},
			speed = 15,
			loop = true,
		}
	}
})

-- debugging
minetest.register_on_chat_message(function(name, message)
	local player = minetest.get_player_by_name(name)
	local pos = player:get_pos()
	if message == "baa" then
		minetest.add_entity(pos, "bobcraft_mobs:sheep")
	elseif message == "oink" then
		minetest.add_entity(pos, "bobcraft_mobs:pig")
	end
end)
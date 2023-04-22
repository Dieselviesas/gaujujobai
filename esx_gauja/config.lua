Config                            = {}
Config.DrawDistance               = 50.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.EnablePlayerManagement     = true -- Enable if you want society managing.
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true -- Enable if you're using esx_identity.
Config.EnableLicenses             = true -- Enable if you're using esx_license.
Config.EnableHandcuffTimer        = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer              = 10 * 60000 -- 10 minutes.
Config.EnableJobBlip              = false -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.
Config.EnableESXService           = false -- Enable esx service?
Config.MaxInService               = -1 -- How much people can be in service at once?

Config.Locale                     = 'en'

Config.CloakroomsMarker = {
	Size = {x = 0.5, y = 0.5, z = 0.5},
	Color = {r = 66, g = 135, b = 245},
	Type = 6,

	Size2 = {x = 0.25, y = 0.25, z = 0.25},
	Color2 = {r = 255, g = 255, b = 255},
	Type2 = 21
}

Config.ArmoriesMarker = {
	Size = {x = 0.5, y = 0.5, z = 0.5},
	Color = {r = 66, g = 135, b = 245},
	Type = 6,

	Size2 = {x = 0.20, y = 0.20, z = 0.20},
	Color2 = {r = 255, g = 255, b = 255},
	Type2 = 30
}

Config.BossActionsMarker = {
	Size  = {x = 0.5, y = 0.5, z = 0.5},
	Color = {r = 66, g = 135, b = 245},
	Type  = 6,

	Size2  = {x = 0.25, y = 0.25, z = 0.25},
	Color2 = {r = 255, g = 255, b = 255},
	Type2 = 32
}

Config.VehiclesMarker = {
	Size  = {x = 0.5, y = 0.5, z = 0.5},
	Color = {r = 66, g = 135, b = 245},
	Type  = 6,

	Size2  = {x = 0.35, y = 0.35, z = 0.35},
	Color2 = {r = 255, g = 255, b = 255},
	Type2 = 36
}

Config.HelicoptersMarker = {
	Size  = {x = 0.5, y = 0.5, z = 0.5},
	Color = {r = 66, g = 135, b = 245},
	Type  = 6,

	Size2  = {x = 0.35, y = 0.35, z = 0.35},
	Color2 = {r = 255, g = 255, b = 255},
	Type2 = 34
}

Config.GaujaStations = {
	PaletoBay = {

		Cloakrooms = {
			vector3(-2674.3428, 1319.3313, 152.0137)
		},

		Armories = {
			vector3(2443.3120, 4977.1519, 1.5646)
		},

		Vehicles = {
			{
				Spawner = vector3(-2661.4756, 1307.6543, 0.1185),
				InsideShop = vector3(-2661.4756, 1307.6543, 147.1185),
				SpawnPoints = {
					{coords = vector3(-2662.99, 1307.72, 147.12), heading =263.43, radius = 6.0}
				}
			}
		},

		BossActions = {
			vector3(-2676.51, 1310.23, 152.01)
		}
	}

}

Config.AuthorizedVehicles = {
	car = {
		naujokas = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 5000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
                        		},

		apsiprates = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 500, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
		},

		savasveidas = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 500, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
		},

		patikimas = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 500, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
		},

		pavaduotojas = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 500, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
		},

		boss = {
			{model = 'raid', price = 1000, props = {color1 = 12, color2 = 12, pearlescentColor = 12}},
			{model = 'dubsta3', price = 500, props = {color1 = 12, color2 = 12, pearlescentColor = 12}}
		}
	}
}

Config.Uniforms = {
	gauja_wear = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 1,
			torso_1 = 143,  torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 30,
			pants_1 = 59,  pants_2 = 5,
			shoes_1 = 119,   shoes_2 = 5,
			mask_1 = 68, mask_2 = 2,
			bproof_1 = 0, bproof_2 = 0,
			glasses_1 = 0, glasses_2 = 0,
			chain_1 = 169,    chain_2 = 0,
			helmet_1 = -1,  helmet = 0
		},
		female = { tshirt_1 = 2,  tshirt_2 = 1,
		torso_1 = 446,  torso_2 = 2,
		decals_1 = 0,   decals_2 = 0,
		arms = 89,
		pants_1 = 61,  pants_2 = 9,
		shoes_1 = 25,   shoes_2 = 0,
		mask_1 = 51, mask_2 = 7,
		bproof_1 = 0, bproof_2 = 0,
		glasses_1 = 5, glasses_2 = 0,
		chain_1 = 142,    chain_2 = 1,
		helmet_1 = -1,  helmet = 0  }
	},

	gauja_wear2 = {
		male = {
			tshirt_1 = 22,  tshirt_2 = 4,
			torso_1 = 120, torso_2 = 4,
			decals_1 = 0,   decals_2 = 0,
			arms = 77,
			pants_1 = 49, pants_2 = 2,
			shoes_1 = 30,  shoes_2 = 1,
			mask_1 = 111,	mask_2 = 15,
			bproof_1 = 0, bproof_2 = 0,
			chain_1 = 11,    chain_2 = 2,
			helmet_1 = 12, helmet_2 = 1,
			bags_1 = 0, bags_2 = 0
            

		},
		female = {}
	},
}

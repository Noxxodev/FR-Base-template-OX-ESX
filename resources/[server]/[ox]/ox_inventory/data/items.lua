return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Argent Sale ($)',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'Vous venez de manger un délicieux burger au poisson !'
		},
	},

	['cola'] = {
		label = 'Coca-Cola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with cola'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
	},

	['money'] = {
		label = 'Argent ($)',
	},

	['mustard'] = {
		label = 'Moutarde',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Vous venez de manger de la moutarde'
		}
	},

	['water'] = {
		label = 'Bouteille d\'eau',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Vous venez de vous rafraîchir !'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Gilet pare-balles',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 5000,
		notification = 'Gilet pare-balles correctement équipé'
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Mastercard',
		stack = false,
		weight = 10,
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["bag"] = {
		label = "Sac de braquage",
		weight = 2,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["drill"] = {
		label = "Perceuse",
		weight = 4,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},

	["ring"] = {
		label = "Bague en Or",
		weight = 1,
		stack = true,
		close = true,
	},

	["rolex"] = {
		label = "Rolex en Or",
		weight = 1,
		stack = true,
		close = true,
	},

	["gasmask"] = {
		label = "Masque à Gaz",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanBottle"] = {
		label = "Bottle Hacking Glass",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanDiamond"] = {
		label = "Diamond Hacking Glass",
		weight = 2,
		stack = true,
		close = true,
	},

	["vanNecklace"] = {
		label = "Necklace Hacking Glass",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanPanther"] = {
		label = "Panther Hacking Glass",
		weight = 1,
		stack = true,
		close = true,
	},

	["necklace"] = {
		label = "Collier en Or",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutter"] = {
		label = "Cutter",
		weight = 1,
		stack = true,
		close = true,
	},

	['handcuffs'] = {
		label = 'Paire de Menottes',
		weight = 100,
		stack = false,
		allowArmed = true
	  },

	['rope'] = {
		label = 'Corde',
		weight = 100,
		stack = false,
		allowArmed = true
	  },

	["contract"] = {
		label = "Contrat automobile",
		weight = 1,
		stack = true,
		close = true,
	},

	['backpack'] = {
		label = 'Sac à dos',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'wasabi_backpack.openBackpack'
		}
	},

	['id_card'] = {
		label = 'Carte identiter',
	},

	['license_drive'] = {
		label = 'Permis de conduire',
	},

	['license_weapon'] = {
		label = 'Permis darmes',
	},

	["jeton"] = {
		label = "Jeton(s)",
		weight = 1,
		stack = true,
		close = true,
	},
	["billing"] = {
		label = "Facture",
		weight = 1,
		stack = true,
		close = true,
	},
	["locationcontract"] = {
		label = "Contrat de location",
		weight = 1,
	},
	['carkey'] = {
        label = 'Clé de véhicule utilitaire | ',
        weight = 160,
    },
	['hdirectorkey'] = {
        label = 'Clé de l\'hôpital',
        weight = 160,
    },

	["cle_menotte"] = {
		label = "Clés de menotte",
		weight = 3,
		stack = true,
		close = true,
	},

	["menotte"] = {
		label = "Menotte",
		weight = 3,
		stack = true,
		close = true,
	},
	['garsudkey'] = {
		label = 'Clé de catégorie S',
		weight = 80,
	},
	-- DROGUE (FALSEDEV)
	['beuh'] = {
		label = 'Weed',
		weight = 300,
	},

	['pochon_de_beuh'] = {
		label = 'Pochon de Weed',
		weight = 300,
	},

	['beuh_traité'] = {
		label = 'Weed traité',
		weight = 300,
	},

	['coka'] = {
		label = 'Coke',
		weight = 300,
	},

	['pochon_de_coke'] = {
		label = 'Pochon de Coke',
		weight = 300,
	},

	['coka_traité'] = {
		label = 'Coke traité',
		weight = 300,
	},

	['opium'] = {
		label = 'Opium',
		weight = 300,
	},

	['pochon_de_opium'] = {
		label = 'Pochon d\'Opium',
		weight = 300,
	},

	['opium_traité'] = {
		label = 'Opium traité',
		weight = 300,
	},
		-- DROGUE (FALSEDEV)



	
['burger2'] = {
    label = 'Hamburger',
    weight = 220,
    client = {
        status = { hunger = 200000 },
        anim = 'eating',
        prop = 'burger',
        usetime = 2500,
        notification = 'Tu a manger un delicieux hamburger'
    },
},

['frites2'] = {
    label = 'Frites',
    weight = 220,
    client = {
        status = { hunger = 200000 },
        anim = 'eating',
        prop = { model = `prop_food_bs_chips`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-4.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a manger des frites'
    },
},

['hotdog'] = {
    label = 'Hotdog',
    weight = 220,
    client = {
        status = { hunger = 200000 },
        anim = 'eating',
        prop = { model = `prop_cs_hotdog_02`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-4.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a manger un hotdog'
    },
},

['pogo'] = {
    label = 'Pogo',
    weight = 220,
    client = {
        status = { hunger = 200000 },
        anim = 'eating',
    --	prop = { model = `prop_cs_hotdog_02`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-4.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a manger un pogo'
    },
},

['burgerpoulet'] = {
    label = 'Hamburger Poulet',
    weight = 220,
    client = {
        status = { hunger = 200000 },
        anim = 'eating',
        prop = 'burger',
        usetime = 2500,
        notification = 'Tu a manger un hamburger au poulet'
    },
},

['slush'] = {
    label = 'Slush',
    weight = 220,
    client = {
        status = { thirst = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `scully_boba3`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-5.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu viens de boire une slush'
    },
},

['biere'] = {
    label = 'Biere',
    weight = 220,
    client = {
        status = { drunk = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `prop_amb_beer_bottle`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-5.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu viens de boire une déclieuse bière !'
    },
},

['whisky'] = {
    label = 'whisky',
    weight = 220,
    client = {
        status = { drunk = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `prop_cs_whiskey_bottle`, pos = vec3(0.01, 0.01, 0.01), rot = vec3(-5.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a bu un bon whisky !'
    },
},

['limonade'] = {
    label = 'Limonade',
    weight = 220,
    client = {
        status = { thirst = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `scully_boba`, pos = vec3(0.01, 0.01, 0.00), rot = vec3(-5.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a bu une limonade !'
    },
},

['coca'] = {
    label = 'Coca',
    weight = 220,
    client = {
        status = { thirst = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `prop_food_bs_juice01`, pos = vec3(0.01, 0.01, -0.10), rot = vec3(-6.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu viens de boire un coca bien frais chacal !'
    },
},

['jusorange'] = {
    label = 'Jus d\'orange',
    weight = 220,
    client = {
        status = { thirst = 200000 },
        anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
        prop = { model = `prop_plastic_cup_02`, pos = vec3(0.01, 0.01, 0.09), rot = vec3(-6.0, 5.0, -180.5) },
        usetime = 2500,
        notification = 'Tu a bu un jus d\'orange'
    },
},

--- test
['shovel'] = {
    label = 'Pelle',
    weight = 220,
},
--- done test
['boulette'] = {
    label = 'Boulette',
    weight = 220,
},

['croquette'] = {
    label = 'Poulet',
    weight = 220,
},

['patate'] = {
    label = 'Patates',
    weight = 220,
},

['glaces'] = {
    label = 'Glaces',
    weight = 220,
},

['saucisse'] = {
    label = 'Saucisse',
    weight = 220,
},

['limon'] = {
    label = 'Limon',
    weight = 220,
},

	["accesscard"] = {
		label = "Access Card",
		weight = 10,
		stack = true,
		close = true,
	},

	["goldnecklace"] = {
		label = "Gold Necklace",
		weight = 150,
		stack = true,
		close = true,
	},

	["goldwatch"] = {
		label = "Gold Watch",
		weight = 200,
		stack = true,
		close = true,
	},

	["hackerDevice"] = {
		label = "Hacker Device",
		weight = 10,
		stack = true,
		close = true,
	},

	["hammerwirecutter"] = {
		label = "Hammer And Wire Cutter",
		weight = 10,
		stack = true,
		close = true,
	},

	["goldbar"] = {
		label = "Gold Bar",
		weight = 100,
		stack = true,
		close = true,
	},

	["phone"] = {
		label = "Phone",
		weight = 1,
		stack = true,
		close = true,
	},
	
	['phone_hacking'] = {
		label = 'Hacking System',
		weight = 190,
	},


	["grand_cru"] = {
		label = "Grand cru",
		weight = 1,
		stack = true,
		close = true,
	},

	["vine"] = {
		label = "Vin",
		weight = 1,
		stack = true,
		close = true,
	},

	["raisin"] = {
		label = "Raisin",
		weight = 1,
		stack = true,
		close = true,
	},

	["jus_raisin"] = {
		label = "Jus de raisin",
		weight = 1,
		stack = true,
		close = true,
	},

	["bouteillevinblanc"] = {
		label = "Bouteille de vin blanc",
		weight = 1,
		stack = true,
		close = true,
	},

	["bouteillevinrouge"] = {
		label = "Bouteille de vin rouge",
		weight = 1,
		stack = true,
		close = true,
	},

	["raisinrouge"] = {
		label = "Raisin rouge",
		weight = 1,
		stack = true,
		close = true,
	},

	["vinblanc"] = {
		label = "Vin blanc",
		weight = 1,
		stack = true,
		close = true,
	},

	["vinrouge"] = {
		label = "Vin rouge",
		weight = 1,
		stack = true,
		close = true,
	},

	["raisinblanc"] = {
		label = "Raisin blanc",
		weight = 1,
		stack = true,
		close = true,
	},

	["repairkit"] = {
		label = "Kit de réparation",
		weight = 1,
		stack = true,
		close = true,
	},

	["kitrepa"] = {
		label = "Kit de réparation",
		weight = 1,
		stack = true,
		close = true,
	},

	["sponge"] = {
		label = "Éponge",
		weight = 1,
		stack = true,
		close = true,
	},

	["laitcoco"] = {
		label = "Lait de coco",
		weight = 1,
		stack = true,
		close = true,
	},

	["noixcoco"] = {
		label = "Noix de coco",
		weight = 1,
		stack = true,
		close = true,
	},

	["tableau"] = {
		label = "Tableau",
		weight = 1,
		stack = true,
		close = true,
	},

	["pc"] = {
		label = "Pc",
		weight = 1,
		stack = true,
		close = true,
	},

	["vase"] = {
		label = "Vase",
		weight = 1,
		stack = true,
		close = true,
	},

	["bijoux"] = {
		label = "Bijoux",
		weight = 1,
		stack = true,
		close = true,
	},

	["enceinte"] = {
		label = "Enceinte",
		weight = 1,
		stack = true,
		close = true,
	},

	["tele"] = {
		label = "Télé",
		weight = 1,
		stack = true,
		close = true,
	},


	['medicalbag'] = {
		label = 'Medical Bag',
		weight = 220,
		stack = true,
		description = "A comprehensive medical kit for treating injuries and ailments.",
	},
	
	['defibrillator'] = {
		label = 'Defibrillator',
		weight = 100,
		stack = true,
		description = "Used for reviving patients.",
	},
	
	['tweezers'] = {
		label = 'Tweezers',
		weight = 100,
		stack = true,
		description = "Precision tweezers for safely removing foreign objects, such as bullets, from wounds.",
	},
	
	['burncream'] = {
		label = 'Burn Cream',
		weight = 100,
		stack = true,
		description = "Specialized cream for treating and soothing minor burns and skin irritations.",
	},
	
	['suturekit'] = {
		label = 'Suture Kit',
		weight = 100,
		stack = true,
		description = "A kit containing surgical tools and materials for stitching and closing wounds.",
	},
	
	['icepack'] = {
		label = 'Ice Pack',
		weight = 200,
		stack = true,
		description = "An ice pack used to reduce swelling and provide relief from pain and inflammation.",
	},
	
	['stretcher'] = {
		label = 'Ice Pack',
		weight = 200,
		stack = true,
		description = "An ice pack used to reduce swelling and provide relief from pain and inflammation.",
	},
	
	['emstablet'] = {
		label = 'Ems tablet',
		weight = 200,
		stack = true,
		client = {
			export = 'Ambulance.openDistressCalls'
		}
	},
}
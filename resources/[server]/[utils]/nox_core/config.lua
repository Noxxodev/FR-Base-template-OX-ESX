---------------------------------------------------------------------------------------------------
-- /me

-- Global configuration
Config = {
    language = 'fr',
    color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
    font = 0, -- Text font
    time = 5000, -- Duration to display the text (in ms)
    scale = 0.5, -- Text scale
    dist = 250, -- Min. distance to draw 
}

-- Languages available
Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"scratch his nose" for example.'}},
        prefix = 'the person '
    },
    ['fr'] = {
        commandName = 'me',
        commandDescription = 'Affiche une action au dessus de votre tête.',
        commandSuggestion = {{ name = 'action', help = '"se gratte le nez" par exemple.'}},
        prefix = 'l\'individu '
    },
    ['dk'] = {
        commandName = 'me',
        commandDescription = 'Viser en handling over hovedet.',
        commandSuggestion = {{ name = 'Handling', help = '"Tager en smøg op ad lommen" for eksempel.'}},
        prefix = 'Personen '
    },
}

---------------------------------------------------------------------------------------------------
-- Location de voiture 

Config.notif = 2 -- Type de notification 1 = ESX notification | 2 = OX notification

Config.localisation = {
    {
        pos = { x = -231.547, y = -898.141, z = 29.886, h = 342.99 }, -- Position du blips ainsi que du ped
        name = 'csb_car3guy1', -- Nom du ped
        blocking = true, -- true = ped bloquer | false = ped qui change de place si vous le frapper
        invincible = true, -- true = ped imortel | false = ped susceptible de mourir
        freeze = true, -- true = le ped reste statique | false = le ped n'est pas statique
        icon = 'fa-solid fa-car-side', -- Icône de l'interaction alt : https://fontawesome.com/search
        titre = 'Location de voiture', -- Nom de l'interaction alt
        distance = 2.5, -- Distance à laquelle vous pouvez interagir
        menu = 1, -- Numéro du menu a mettre le même avec nombre plus bas pour relier les 2
        blip = {
            sprite = 464, -- Icon du blip : https://docs.fivem.net/docs/game-references/blips/
            scale = 0.8, -- Taille du blip
            colour = 11,  -- Couleur du blip : https://docs.fivem.net/docs/game-references/blips/
            name = "Location de véhicule", -- Nom du blip
        },
    },
    {
        pos = { x = 151.23, y = -1000.23, z = 29.34, h = 161.57 },
        name = 'csb_car3guy1',
        blocking = true,
        invincible = true,
        freeze = true,
        icon = 'fa-solid fa-car-side',
        titre = 'Location de voiture',
        distance = 2.5,
        menu = 2,
        blip = {
            sprite = 464,
            scale = 0.8,
            colour = 11,
            name = "Location de véhicule",
        },
    },
}

Config.vehicule = {
    {
        label = "Sultan", -- Nom du menu
        vehicule = "sultan", -- nom du véhicule
        description = "Vous pouvez louer une sultan pour : 200$", -- Descritption du menu
        prix = 200, -- Prix du véhicule
        image = "https://cdn.discordapp.com/attachments/1116084412233289758/1243256276289327195/sultan.png?ex=666496a2&is=66634522&hm=f4329c0ab2773fc872620f8244ee0772226f26eda2763f8954244f28f096231e&", -- Image du véhicule
    },
    {
        label = "Faggio",
        vehicule = "faggio",
        description = "Vous pouvez louer un faggio pour : 10$",
        prix = 10,
        image = "https://cdn.discordapp.com/attachments/1116084412233289758/1248727017625747678/faggio.png?ex=6664b729&is=666365a9&hm=bab58bb84f1c1ab8241fe9edbeec5ac792df2cab196c0d60be1f47cd84fe485f&",
    }
}

Config.posvehicule = {
    [1] = {
        posspawn = { x = -228.15, y = -888.52, z = 29.92, h = 249.44 }, -- Position de spawn du véhicule
        tempsfinlocation = 0, -- A quelle moment le temps de location s'arrète en seconde
        tempslocation = 30, -- Temps de location en seconde
        nombre = 1, -- -- Numéro du menu a mettre le même avec le nombre haut pour relier les 2
    },
    [2] = {
        posspawn = { x = 150.36, y = -1004.36, z = 29.33, h = 70.86 },
        tempsfinlocation = 0,
        tempslocation = 30,
        nombre = 2,
    },
}

---------------------------------------------------------------------------------------------------
-- Job center 

Config.Target = 'ox_target'
Config.notif = 1 -- 1 = Ox Notification | 2 = ESX Notification

Config.Blipsss = {
	Text = 'Job center',
	Sprite = 498,
	Size = 0.5,
	Color = 26,
	Display = 4
}

Config.Locations = {
	{
		Ped = `a_f_y_business_01`,
		Coords = vector4(-364.430756, -249.283508, 36.070312, 420.4116),
	}
}

--Optional fontawesome icons for jobs.
Config.JobIcons = {
	['unemployed'] = 'fa-solid fa-user',
	['taxi'] = 'fa-solid fa-taxi',
	['trucker'] = 'fa-solid fa-truck',
}

Config.Licenses = {
	{
		Item = 'id_card',
		Label = 'Carte identité',
		Icon = 'fa-solid fa-id-card',
		LicenseNeeded = false, --['license'/false] verify license ownership through esx_license
		Price = 25
	},
	{
		Item = 'license_drive',
		Label = 'Permis de conduire',
		Icon = 'fa-solid fa-car',
		LicenseNeeded = 'dmv', --['license'/false] verify license ownership through esx_license
		Price = 50
	},
	{
		Item = 'license_weapon',
		Label = 'Permis d\'arme',
		Icon = 'fa-solid fa-gun',
		LicenseNeeded = 'weapon', --['license'/false] verify license ownership through esx_license
		Price = 75
	},
}

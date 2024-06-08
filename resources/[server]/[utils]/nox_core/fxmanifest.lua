fx_version 'adamant'
game 'gta5'
lua54 'yes'

this_is_a_map 'yes'

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

dependencies {
	'es_extended'
}

shared_scripts {
    '@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',
}

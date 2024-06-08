fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/client.lua',
	'client/cl_edit.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
	'server/sv_edit.lua'
}

files {
    'locales/*.json'
}

escrow_ignore {
	'locales/*.json',
	'config.lua',
	'client/cl_edit.lua',
	'server/sv_edit.lua'
}



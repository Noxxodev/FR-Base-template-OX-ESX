fx_version 'adamant'

game 'gta5'
lua54 'yes'
description 'ESX Service'

version '1.9.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
    'addonaccount/classes/addonaccount.lua',
	'addonaccount/main.lua',
	'addoninventory/classes/addoninventory.lua',
	'addoninventory/main.lua',
	'datastore/classes/datastore.lua',
	'datastore/main.lua',
	'service/server/main.lua'
}

client_scripts {
	'service/client/main.lua'
}

dependency 'es_extended'

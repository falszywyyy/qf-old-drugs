fx_version 'adamant'
game 'gta5'
lua54 'yes'
author 'QF DevTeam'
description 'esx_drugs'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
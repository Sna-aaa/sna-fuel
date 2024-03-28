fx_version 'cerulean'
game 'gta5'

description 'Sna Fuel'

author 'Sna'

version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
	'bridge/locale.lua',
    'locales/en.lua',
	'locales/*.lua',
    'config.lua'
}


server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'bridge/**/server.lua',
	'prg/server.lua'
}

client_scripts {
	'bridge/**/client.lua',
	'prg/client.lua'
}

lua54 'yes'

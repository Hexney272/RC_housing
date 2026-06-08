fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.4'

shared_scripts {
	'@ox_lib/init.lua',
	
	'config/config.translation.lua',

	'config/config.lua',
	'config/config.regions.lua',

	'shared/*.lua',
	'integration/[shells]/*.lua',
	'integration/[ipl]/*.lua',
}
client_scripts {
	'config/config.client.lua',
	
	'integration/[weather]/*.lua',
	'integration/[clothing]/*.lua',
	'integration/[garages]/**/client.lua',
	'integration/[inventory]/**/client.lua',
	'integration/[dispatch]/**/client.lua',

	'client/lib.lua',
	'client/init.lua',
	'client/functions.lua',
	'client/main.lua',
	'client/nui.lua',
	'client/modules/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	
	'config/config.webhooks.lua',
	'config/config.server.lua',

	'integration/[garages]/**/server.lua',
	'integration/[inventory]/**/server.lua',
	'integration/[dispatch]/**/server.lua',
	'integration/[migration]/*.lua',

	'server/lib.lua',
	'server/init.lua',
	'server/main.lua',
	'server/modules/*.lua',
}

ui_page 'html/ui.html'

files {
	'html/*.*',
	'html/**/*.*',
	'config/*.js',
	'config/*.json',
}

escrow_ignore {
    'stream/*.*',
    
    'integration/*.lua',
    'integration/**/*.lua',
    
    'config/*.lua',
    
    'server/version_check.lua',
}
dependency '/assetpacks'
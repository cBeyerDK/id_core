fx_version 'cerulean'
game 'gta5'

author 'cBeyer'
description 'Identity Store Core'
version '2.5.1'

lua54 'yes'

dependencies {
    -- Server Settings
    '/server:5181',
    '/gameBuild:mptuner',
    '/onesync',
}

shared_scripts {
    'config.lua',
    'shared/language.lua',
    'shared/langs/*.lua',
    'shared/utils.lua',
}

server_scripts {
    'server/utils.lua',
    'server/main.lua',
    'server/events.lua',
    'server/anticheat.lua',
    'server/logs.lua',
}

client_scripts {
    'client/utils.lua',
    'client/main.lua',
    'client/events.lua',
}

escrow_ignore {
    'shared/langs/*.lua',
    'config.lua',
}
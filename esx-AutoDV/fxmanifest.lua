fx_version 'cerulean'
game 'gta5'

description 'Auto DV (ESX + ox_lib) sweet21'
version '1.0.0'
lua54 'yes'

-- ox_lib
shared_script '@ox_lib/init.lua'
dependency 'ox_lib'

client_scripts {
    'Client/client.lua'
}

server_scripts {
    'Server/server.lua'
}

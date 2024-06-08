fx_version 'cerulean'
games {"gta5", "rdr3"}
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'SUP2Ak#3755'
version '1.0'
description 'Thanks to project error for boilerplate svelte'

ui_page 'web/build/index.html'

client_script "client/main.lua"

files {
  'web/build/index.html',
  'web/build/**/*'
}

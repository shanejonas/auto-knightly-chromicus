#!/usr/bin/env coffee

#includes
request = require 'request'
jsdom = require 'jsdom'

###
  WARNING: ninjas only
###
########################
FFI = require('node-ffi')
libc = new FFI.Library null,
  "system": ["int32", ["string"]]
run = libc.system
########################

#Auto-Knight - Chrome-icus
###
   _         _                          _       _     _   _       
  /_\  _   _| |_ ___         /\ /\_ __ (_) __ _| |__ | |_| |_   _ 
 //_\\| | | | __/ _ \ _____ / //_/ '_ \| |/ _` | '_ \| __| | | | |
/  _  \ |_| | || (_) |_____/ __ \| | | | | (_| | | | | |_| | |_| |
\_/ \_/\__,_|\__\___/      \/  \/|_| |_|_|\__, |_| |_|\__|_|\__, |
                                          |___/             |___/ 
  CHROMICUS
TODO: 
    - refactor a ton
    - config object
    - commonjs this shit?
###

console.log '+-+-+-+-+-+-+-+-+-+-+-+-+-+'
console.log '|A|u|t|o|-|K|n|i|g|h|t|l|y|'
console.log '+-+-+-+-+-+-+-+-+-+-+-+-+-+'
console.log '|CHROMICUS|--+-+-+-|+-+-+-|'
console.log '+-+-+-+-+-+-+-+-+-+-+-+-+-+'

#configs
build = null
#tmp zip
tmp = '/tmp/chrome-mac.zip'
#chromium app location
chromium = '/Applications/Chromium.app'
#chrome temp location
chromium_tmp = '/tmp/chrome-mac/Chromium.app/'

#throw a status update
console.log 'Searching for latest build..'

#get latest build from scraping page
request { uri: 'http://build.chromium.org/f/chromium/snapshots/Mac/LATEST' }, (error, response, body) ->

  #log some error shit if needed
  if error && response.statusCode isnt 200
    console.log 'Error when contacting chromium.org'

  console.log body
  build = body

  uri = "http://build.chromium.org/f/chromium/snapshots/Mac/#{build}/chrome-mac.zip"
  console.log uri

  #shell commands
  commands = [
    #delete any tmp chromium
    "rm -rf #{tmp}"
    #download chromium
    "curl #{uri} -o #{tmp}"
    #unzip it into tmp
    "unzip -qod /tmp #{tmp}"
    #remove current chromium
    "rm -rf #{chromium}"
    #move unzipped newest chromium into applications
    "mv #{chromium_tmp} #{chromium}"
    #delete tmp chromium
    "rm -rf #{chromium_tmp}"
  ]

  run command for command in commands
  console.log '+-+Auto-Knightly Complete+-+'

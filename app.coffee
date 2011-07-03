#!/usr/bin/env coffee

#includes
request = require 'request'
jsdom = require 'jsdom'
#{spawn} = require 'child_process'

#node-ffi ftw for system calls
#WARNING: ninjas only
FFI = require('node-ffi')
libc = new FFI.Library null,
  "system": ["int32", ["string"]]

run = libc.system

#Auto-Knight - Chrome-icus
###
  TODO: ascii art this shit up
###

console.log 'Chromium Nightly Downloader/Upgrader'

#get latest build from scraping page
request { uri: 'http://build.chromium.org/f/chromium/snapshots/Mac/' }, (error, response, body) ->
  build = null

  #log some error shit if needed
  if error && response.statusCode isnt 200
    console.log 'Error when contacting chromium.org'

  #throw a status update
  console.log 'Searching for latest build..'

  #use jsdom to grab build #
  jsdom.env
    html: body
    scripts: [ 'http://code.jquery.com/jquery-1.5.min.js' ]
  , (err, window) ->
    #set jquery
    $ = window.jQuery

    #jquery hackery to get the right build #
    build = $('tr').last().prev().prev()
    build = $('td a', build).attr('href').split('/')[0]

    console.log 'Latest Build = ' + build

    #variables
    uri = "http://build.chromium.org/f/chromium/snapshots/Mac/#{build}/chrome-mac.zip"
    tmp = '/tmp/chrome-mac.zip'
    chromium = '/Applications/Chromium.app'
    chromium_tmp = '/tmp/chrome-mac/Chromium.app/'

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
    
    console.log 'Chromium Upgrade Complete..'

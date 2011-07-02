#!/usr/bin/env coffee

#includes
request = require 'request'
jsdom = require 'jsdom'
{spawn} = require 'child_process'
Seq = require 'seq'

#Script Title
#TODO: ascii art this shit up
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

    #Seq().seq(->) chaining
    #see https://github.com/substack/node-seq

    #variables
    uri = "http://build.chromium.org/f/chromium/snapshots/Mac/#{build}/chrome-mac.zip"
    tmp = '/tmp/chrome-mac.zip'
    chromium = '/Applications/Chromium.app'
    chromium_tmp = '/tmp/chrome-mac/Chromium.app/'

    Seq()
      #download chromium
      .seq ->
        spawn 'curl', [uri, '-o', tmp]
      #unzip it into tmp
      .seq ->
        spawn 'unzip', ['-qod', '/tmp/', tmp]
      #remove current chromium
      .seq ->
        spawn 'rm', ['-rf', chromium]
      #move unzipped newest chromium into applications
      .seq ->
        spawn 'mv', [chromium_tmp, chromium]
      #delete tmp chromium
      .seq ->
        spawn 'rm', [chromium_tmp]

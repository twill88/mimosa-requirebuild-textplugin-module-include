"use strict"

path = require 'path'
fs = require 'fs'

wrench = require "wrench"

config = require './config'

registration = (mimosaConfig, register) ->
  if mimosaConfig.isOptimize
    e = mimosaConfig.extensions
    register ['add','update','remove'], 'beforeOptimize', _appendFilesToInclude, [e.javascript..., e.template...]
    register ['postBuild'],             'beforeOptimize', _appendFilesToInclude


_appendFilesToInclude = (mimosaConfig, options, next) ->
  return next() unless options.runConfigs?.length > 0
  return next() unless mimosaConfig.requireBuildTextPluginInclude.extensions.length > 0

  options.runConfigs.forEach (runConfig) ->
    files = wrench.readdirSyncRecursive runConfig.baseUrl
    files = files.map (file) ->
      path.join runConfig.baseUrl, file
    .filter (file) ->
      fs.statSync(file).isFile()

    files.forEach (file) ->
      ext = path.extname(file).substring(1)
      if mimosaConfig.requireBuildTextPluginInclude.extensions.indexOf(ext) > -1
        fileAMD = file.replace(runConfig.baseUrl, '').substring(1)
        runConfig.include.push "#{mimosaConfig.requireBuildTextPluginInclude.pluginPath}!#{fileAMD}"

  next()

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate
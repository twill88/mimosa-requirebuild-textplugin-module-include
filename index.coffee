"use strict"

path = require 'path'
fs = require 'fs'

wrench = require "wrench"

config = require './config'

windowsDrive = /^[A-Za-z]:\\/

registration = (mimosaConfig, register) ->
  if mimosaConfig.isOptimize
    e = mimosaConfig.extensions
    register ['add','update','remove'], 'beforeOptimize', _appendFilesToInclude, [e.javascript..., e.template...]
    register ['postBuild'],             'beforeOptimize', _appendFilesToInclude


_appendFilesToInclude = (mimosaConfig, options, next) ->
  return next() unless options.runConfigs?.length > 0
  return next() unless mimosaConfig.requireBuildTextPluginInclude.extensions.length > 0

  options.runConfigs.forEach (runConfig) ->
    includeFolder = __determinePath mimosaConfig.requireBuildTextPluginInclude.folder, runConfig.baseUrl
    files = wrench.readdirSyncRecursive includeFolder
    files = files.map (file) ->
      path.join includeFolder, file
    .filter (file) ->
      fs.statSync(file).isFile()

    files.forEach (file) ->
      ext = path.extname(file).substring(1)
      if mimosaConfig.requireBuildTextPluginInclude.extensions.indexOf(ext) > -1
        fileAMD = (file.replace(runConfig.baseUrl, '').substring(1)).replace(/\\/g, "/")
        runConfig.include.push "#{mimosaConfig.requireBuildTextPluginInclude.pluginPath}!#{fileAMD}"

  next()

__determinePath = (thePath, relativeTo) ->
  return thePath if windowsDrive.test thePath
  return thePath if thePath.indexOf("/") is 0
  path.join relativeTo, thePath

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate
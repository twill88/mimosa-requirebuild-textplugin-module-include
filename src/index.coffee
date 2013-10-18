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
  hasRunConfigs = options.runConfigs?.length > 0
  return next() unless hasRunConfigs

  hasExtensions = mimosaConfig.requireBuildTextPluginInclude.extensions.length > 0
  return next() unless hasExtensions

  hasModulesDefined = mimosaConfig.requireBuildTextPluginInclude.modules?.length > 0
  if hasModulesDefined
    __appendFilesToModuleInclude mimosaConfig, options 
  else
    __appendFilesToMainInclude mimosaConfig, options

  next()

__appendFilesToModuleInclude = (mimosaConfig, options) ->
  options.runConfigs.forEach (runConfig) ->
    if runConfig.modules?.length > 0
      for moduleEntry in runConfig.modules
        for moduleConfig in mimosaConfig.requireBuildTextPluginInclude.modules
          if moduleConfig.name is moduleEntry.name
            includeFolder = __determinePath moduleConfig.folder, runConfig.baseUrl
            files = wrench.readdirSyncRecursive includeFolder
            files = files.map (file) ->
              path.join includeFolder, file
            .filter (file) ->
              fs.statSync(file).isFile()

            files.forEach (file) ->
              ext = path.extname(file).substring(1)
              if moduleConfig.extensions.indexOf(ext) > -1
                fileAMD = (file.replace(runConfig.baseUrl, '').substring(1)).replace(/\\/g, "/")
                moduleEntry.include.push "#{moduleConfig.pluginPath}!#{fileAMD}"


__appendFilesToMainInclude = (mimosaConfig, options) ->
  options.runConfigs.forEach (runConfig) ->
    return unless runConfig.include
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


__determinePath = (thePath, relativeTo) ->
  return thePath if windowsDrive.test thePath
  return thePath if thePath.indexOf("/") is 0
  path.join relativeTo, thePath

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate
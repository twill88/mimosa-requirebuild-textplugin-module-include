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

  hasModulesDefined = mimosaConfig.requireBuildTextPluginModuleInclude.modules?.length > 0
  return next() unless hasModulesDefined

  __appendFilesToModule(moduleConfig, options) for moduleConfig in mimosaConfig.requireBuildTextPluginModuleInclude.modules
  
  next()

__appendFilesToModule = (moduleConfig, options) ->
  options.runConfigs.forEach (runConfig) ->
    includeFolder = __determinePath moduleConfig.folder, runConfig.baseUrl
    files = wrench.readdirSyncRecursive includeFolder
    files = files.map (file) ->
      path.join includeFolder, file
    .filter (file) ->
      fs.statSync(file).isFile() and moduleConfig.extensions.indexOf(path.extname(file).substring(1)) > -1

    files = files.map (file) -> __getFileAMD file, runConfig.baseUrl, moduleConfig.pluginPath

    if runConfig.modules?.length > 0
      matchedModules = runConfig.modules.filter (m) -> m.name is moduleConfig.name
      if matchedModules.length > 0
        __appendToModule(moduleEntry, files) for moduleEntry in matchedModules
        return

    runConfig.modules = [] unless Array.isArray(runConfig.modules)
    moduleEntry = {name: moduleConfig.name, create: true, include: []}
    __appendToModule moduleEntry, files
    runConfig.modules.push moduleEntry

__getFileAMD = (file, baseUrl, pluginPath) ->
  return "#{pluginPath}!#{(file.replace(baseUrl, '').substring(1)).replace(/\\/g, "/")}"

__appendToModule = (moduleEntry, files) ->
  moduleEntry.include = [] unless Array.isArray(moduleEntry.include)
  moduleEntry.include.push file for file in files

__determinePath = (thePath, relativeTo) ->
  return thePath if windowsDrive.test thePath
  return thePath if thePath.indexOf("/") is 0
  path.join relativeTo, thePath

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate
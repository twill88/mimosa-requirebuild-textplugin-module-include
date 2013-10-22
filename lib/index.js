"use strict";
var config, fs, path, registration, windowsDrive, wrench, __appendFilesToModule, __appendToModule, __determinePath, __getFileAMD, _appendFilesToInclude,
  __slice = [].slice;

path = require('path');

fs = require('fs');

wrench = require("wrench");

config = require('./config');

windowsDrive = /^[A-Za-z]:\\/;

registration = function(mimosaConfig, register) {
  var e;
  if (mimosaConfig.isOptimize) {
    e = mimosaConfig.extensions;
    register(['add', 'update', 'remove'], 'beforeOptimize', _appendFilesToInclude, __slice.call(e.javascript).concat(__slice.call(e.template)));
    return register(['postBuild'], 'beforeOptimize', _appendFilesToInclude);
  }
};

_appendFilesToInclude = function(mimosaConfig, options, next) {
  var hasModulesDefined, hasRunConfigs, moduleConfig, _i, _len, _ref, _ref1, _ref2;
  hasRunConfigs = ((_ref = options.runConfigs) != null ? _ref.length : void 0) > 0;
  if (!hasRunConfigs) {
    return next();
  }
  hasModulesDefined = ((_ref1 = mimosaConfig.requireBuildTextPluginModuleInclude.modules) != null ? _ref1.length : void 0) > 0;
  if (!hasModulesDefined) {
    return next();
  }
  _ref2 = mimosaConfig.requireBuildTextPluginModuleInclude.modules;
  for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
    moduleConfig = _ref2[_i];
    __appendFilesToModule(moduleConfig, options);
  }
  return next();
};

__appendFilesToModule = function(moduleConfig, options) {
  return options.runConfigs.forEach(function(runConfig) {
    var files, includeFolder, matchedModules, moduleEntry, _i, _len, _ref;
    includeFolder = __determinePath(moduleConfig.folder, runConfig.baseUrl);
    files = wrench.readdirSyncRecursive(includeFolder);
    files = files.map(function(file) {
      return path.join(includeFolder, file);
    }).filter(function(file) {
      return fs.statSync(file).isFile() && moduleConfig.extensions.indexOf(path.extname(file).substring(1)) > -1;
    });
    files = files.map(function(file) {
      return __getFileAMD(file, runConfig.baseUrl, moduleConfig.pluginPath);
    });
    if (((_ref = runConfig.modules) != null ? _ref.length : void 0) > 0) {
      matchedModules = runConfig.modules.filter(function(m) {
        return m.name === moduleConfig.name;
      });
      if (matchedModules.length > 0) {
        for (_i = 0, _len = matchedModules.length; _i < _len; _i++) {
          moduleEntry = matchedModules[_i];
          __appendToModule(moduleEntry, files);
        }
        return;
      }
    }
    if (!Array.isArray(runConfig.modules)) {
      runConfig.modules = [];
    }
    moduleEntry = {
      name: moduleConfig.name,
      create: true,
      include: []
    };
    __appendToModule(moduleEntry, files);
    return runConfig.modules.push(moduleEntry);
  });
};

__getFileAMD = function(file, baseUrl, pluginPath) {
  return "" + pluginPath + "!" + ((file.replace(baseUrl, '').substring(1)).replace(/\\/g, "/"));
};

__appendToModule = function(moduleEntry, files) {
  if (!Array.isArray(moduleEntry.include)) {
    moduleEntry.include = [];
  }
  return moduleEntry.include = moduleEntry.include.concat(files);
};

__determinePath = function(thePath, relativeTo) {
  if (windowsDrive.test(thePath)) {
    return thePath;
  }
  if (thePath.indexOf("/") === 0) {
    return thePath;
  }
  return path.join(relativeTo, thePath);
};

module.exports = {
  registration: registration,
  defaults: config.defaults,
  placeholder: config.placeholder,
  validate: config.validate
};

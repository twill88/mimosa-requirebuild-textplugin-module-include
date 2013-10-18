"use strict";
var config, fs, path, registration, windowsDrive, wrench, __appendFilesToMainInclude, __appendFilesToModuleInclude, __determinePath, _appendFilesToInclude,
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
  var hasExtensions, hasModulesDefined, hasRunConfigs, _ref, _ref1;
  hasRunConfigs = ((_ref = options.runConfigs) != null ? _ref.length : void 0) > 0;
  if (!hasRunConfigs) {
    return next();
  }
  hasExtensions = mimosaConfig.requireBuildTextPluginInclude.extensions.length > 0;
  if (!hasExtensions) {
    return next();
  }
  hasModulesDefined = ((_ref1 = mimosaConfig.requireBuildTextPluginInclude.modules) != null ? _ref1.length : void 0) > 0;
  if (hasModulesDefined) {
    __appendFilesToModuleInclude(mimosaConfig, options);
  } else {
    __appendFilesToMainInclude(mimosaConfig, options);
  }
  return next();
};

__appendFilesToModuleInclude = function(mimosaConfig, options) {
  return options.runConfigs.forEach(function(runConfig) {
    var files, includeFolder, moduleConfig, moduleEntry, _i, _len, _ref, _ref1, _results;
    if (((_ref = runConfig.modules) != null ? _ref.length : void 0) > 0) {
      _ref1 = runConfig.modules;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        moduleEntry = _ref1[_i];
        _results.push((function() {
          var _j, _len1, _ref2, _results1;
          _ref2 = mimosaConfig.requireBuildTextPluginInclude.modules;
          _results1 = [];
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            moduleConfig = _ref2[_j];
            if (moduleConfig.name === moduleEntry.name) {
              includeFolder = __determinePath(moduleConfig.folder, runConfig.baseUrl);
              files = wrench.readdirSyncRecursive(includeFolder);
              files = files.map(function(file) {
                return path.join(includeFolder, file);
              }).filter(function(file) {
                return fs.statSync(file).isFile();
              });
              _results1.push(files.forEach(function(file) {
                var ext, fileAMD;
                ext = path.extname(file).substring(1);
                if (moduleConfig.extensions.indexOf(ext) > -1) {
                  fileAMD = (file.replace(runConfig.baseUrl, '').substring(1)).replace(/\\/g, "/");
                  return moduleEntry.include.push("" + moduleConfig.pluginPath + "!" + fileAMD);
                }
              }));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        })());
      }
      return _results;
    }
  });
};

__appendFilesToMainInclude = function(mimosaConfig, options) {
  return options.runConfigs.forEach(function(runConfig) {
    var files, includeFolder;
    if (!runConfig.include) {
      return;
    }
    includeFolder = __determinePath(mimosaConfig.requireBuildTextPluginInclude.folder, runConfig.baseUrl);
    files = wrench.readdirSyncRecursive(includeFolder);
    files = files.map(function(file) {
      return path.join(includeFolder, file);
    }).filter(function(file) {
      return fs.statSync(file).isFile();
    });
    return files.forEach(function(file) {
      var ext, fileAMD;
      ext = path.extname(file).substring(1);
      if (mimosaConfig.requireBuildTextPluginInclude.extensions.indexOf(ext) > -1) {
        fileAMD = (file.replace(runConfig.baseUrl, '').substring(1)).replace(/\\/g, "/");
        return runConfig.include.push("" + mimosaConfig.requireBuildTextPluginInclude.pluginPath + "!" + fileAMD);
      }
    });
  });
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

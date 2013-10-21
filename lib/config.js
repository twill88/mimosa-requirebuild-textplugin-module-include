"use strict";
exports.defaults = function() {
  return {
    requireBuildTextPluginModuleInclude: {
      folder: "",
      pluginPath: "vendor/text",
      extensions: ["html"],
      modules: [
        {
          name: "main"
        }
      ]
    }
  };
};

exports.placeholder = function() {
  return "\t\n\n  # requireBuildTextPluginModuleInclude:\n    # folder: \"\"                       # A subdirectory of the javascriptDir used to narrow\n                                       # down the location of included files.\n    # pluginPath: \"vendor/text\"        # AMD path to the text plugin\n    # extensions: [\"html\"]             # A list of extensions for files to include in the r.js\n                                       # config's 'include' array attached to the text plugin\n                                       # path listed above.  Ex: vendor/text!app/foo.html\n                                       # All files in the folder that match this\n                                       # extension will be pushed into the array and already\n                                       # present array entries will be left alone. Extensions\n                                       # should not include the period.\n    # modules: [{                      # Specify modules to build included files into seperate \n                                       # modules. This should be used in conjunction with r.js\n                                       # modules.\n    #   name: \"\"                       # Name of the module in which to include the files. If\n                                       # the name matches that of a module specified in the\n                                       # r.js config, it will include the files in that module.\n                                       # If the name doesn't match a r.js module, a new module\n                                       # will be created with this name.\n    #   folder: \"\"                     # A subdirectory of the javascriptDir used for this\n                                       # specific module. If not specified, uses the folder\n                                       # specified above. Must be specified here or above.\n    #   pluginPath: \"\"                 # Allows the use of a different plugin path for this\n                                       # module. If not specified, uses the pluginPath\n                                       # specified above. Must be specified here or above.\n    #   extensions: []                 # Allows the use of different extensions for this module.\n    # }]                               # If not specified, uses the extensions specified above.\n                                       # Must be specified here or above.\n";
};

exports.validate = function(config, validators) {
  var errors, moduleConfig, _i, _len, _ref;
  errors = [];
  if (validators.ifExistsIsObject(errors, "requireBuildTextPluginModuleInclude config", config.requireBuildTextPluginModuleInclude)) {
    validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.pluginPath", config.requireBuildTextPluginModuleInclude.pluginPath);
    validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.folder", config.requireBuildTextPluginModuleInclude.folder);
    validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginModuleInclude.extensions", config.requireBuildTextPluginModuleInclude.extensions);
    if (validators.isArrayOfObjects(errors, "requireBuildTextPluginModuleInclude.modules", config.requireBuildTextPluginModuleInclude.modules)) {
      _ref = config.requireBuildTextPluginModuleInclude.modules;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        moduleConfig = _ref[_i];
        validators.stringMustExist(errors, "requireBuildTextPluginModuleInclude.modules.name", moduleConfig.name);
        if (!validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.modules.folder", moduleConfig.folder)) {
          if (validators.isString(errors, "requireBuildTextPluginModuleInclude.folder", config.requireBuildTextPluginModuleInclude.folder)) {
            moduleConfig.folder = config.requireBuildTextPluginModuleInclude.folder;
          }
        }
        if (!validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.modules.pluginPath", moduleConfig.pluginPath)) {
          if (validators.isString(errors, "requireBuildTextPluginModuleInclude.pluginPath", config.requireBuildTextPluginModuleInclude.pluginPath)) {
            moduleConfig.pluginPath = config.requireBuildTextPluginModuleInclude.pluginPath;
          }
        }
        if (!validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginModuleInclude.modules.extensions", moduleConfig.extensions)) {
          if (validators.isArrayOfStringsMustExist(errors, "requireBuildTextPluginModuleInclude.extensions", config.requireBuildTextPluginModuleInclude.extensions)) {
            moduleConfig.extensions = config.requireBuildTextPluginModuleInclude.extensions;
          }
        }
      }
    }
  }
  return errors;
};

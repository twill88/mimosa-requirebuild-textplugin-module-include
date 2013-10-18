"use strict";
exports.defaults = function() {
  return {
    requireBuildTextPluginInclude: {
      folder: "",
      pluginPath: "vendor/text",
      extensions: ["html"]
    }
  };
};

exports.placeholder = function() {
  return "\t\n\n  # requireBuildTextPluginInclude:\n    # folder: \"\"                       # A subdirectory of the javascriptDir used to narrow\n                                       # down the location of included files.\n    # pluginPath: \"vendor/text\"        # AMD path to the text plugin\n    # extensions: [\"html\"]             # A list of extensions for files to include in the r.js\n                                       # config's 'include' array attached to the text plugin\n                                       # path listed above.  Ex: vendor/text!app/foo.html\n                                       # All files in the folder that match this\n                                       # extension will be pushed into the array and already\n                                       # present array entries will be left alone. Extensions\n                                       # should not include the period.\n    # modules: [{                      # Specify modules to build included files into seperate \n                                       # modules. This should be used in conjunction with r.js\n                                       # modules, and will prevent the default behaviour of\n                                       # including the text files in a single built file.\n    #   name: \"\"                       # Name of the module in which to include the files. If\n                                       # the name matches that of a module specified in the\n                                       # r.js config, it will include the files in that module.\n                                       # If the name doesn't match a r.js module, this entry\n                                       # will be ignored.\n    #   folder: \"\"                     # A subdirectory of the javascriptDir used for this\n                                       # specific module. If not specified, uses the folder\n                                       # specified above.\n    #   pluginPath: \"\"                 # Allows the use of a different plugin path for this\n                                       # module. If not specified, uses the pluginPath\n                                       # specified above.\n    #   extensions: []                 # Allows the use of different extensions for this module.\n    # }]\n";
};

exports.validate = function(config, validators) {
  var errors, moduleConfig, _i, _len, _ref;
  errors = [];
  if (validators.ifExistsIsObject(errors, "requireBuildTextPluginInclude config", config.requireBuildTextPluginInclude)) {
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.pluginPath", config.requireBuildTextPluginInclude.pluginPath);
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.folder", config.requireBuildTextPluginInclude.folder);
    validators.isArrayOfStringsMustExist(errors, "requireBuildTextPluginInclude.extensions", config.requireBuildTextPluginInclude.extensions);
    if (validators.ifExistsIsArrayOfObjects(errors, "requireBuildTextPluginInclude.modules", config.requireBuildTextPluginInclude.modules)) {
      _ref = config.requireBuildTextPluginInclude.modules;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        moduleConfig = _ref[_i];
        validators.stringMustExist(errors, "requireBuildTextPluginInclude.modules.name", moduleConfig.name);
        if (!validators.ifExistsIsString(errors, "requireBuildTextPluginInclude.modules.folder", moduleConfig.folder)) {
          moduleConfig.folder = config.requireBuildTextPluginInclude.folder;
        }
        if (!validators.ifExistsIsString(errors, "requireBuildTextPluginInclude.modules.pluginPath", moduleConfig.pluginPath)) {
          moduleConfig.pluginPath = config.requireBuildTextPluginInclude.pluginPath;
        }
        if (!validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginInclude.modules.extensions", moduleConfig.extensions)) {
          moduleConfig.extensions = config.requireBuildTextPluginInclude.extensions;
        }
      }
    }
  }
  return errors;
};

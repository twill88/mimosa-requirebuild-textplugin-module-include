"use strict"

exports.defaults = ->
  requireBuildTextPluginModuleInclude:
    folder: ""
    pluginPath: "vendor/text"
    extensions: ["html"]
    modules: [{
      name: "main"
    }]

exports.placeholder = ->
  """
  \t

    # requireBuildTextPluginModuleInclude:
      # folder: ""                       # A subdirectory of the javascriptDir used to narrow
                                         # down the location of included files.
      # pluginPath: "vendor/text"        # AMD path to the text plugin
      # extensions: ["html"]             # A list of extensions for files to include in the r.js
                                         # config's 'include' array attached to the text plugin
                                         # path listed above.  Ex: vendor/text!app/foo.html
                                         # All files in the folder that match this
                                         # extension will be pushed into the array and already
                                         # present array entries will be left alone. Extensions
                                         # should not include the period.
      # modules: [{                      # Specify modules to build included files into seperate 
                                         # modules. This should be used in conjunction with r.js
                                         # modules.
      #   name: ""                       # Name of the module in which to include the files. If
                                         # the name matches that of a module specified in the
                                         # r.js config, it will include the files in that module.
                                         # If the name doesn't match a r.js module, a new module
                                         # will be created with this name.
      #   folder: ""                     # A subdirectory of the javascriptDir used for this
                                         # specific module. If not specified, uses the folder
                                         # specified above. Must be specified here or above.
      #   pluginPath: ""                 # Allows the use of a different plugin path for this
                                         # module. If not specified, uses the pluginPath
                                         # specified above. Must be specified here or above.
      #   extensions: []                 # Allows the use of different extensions for this module.
      # }]                               # If not specified, uses the extensions specified above.
                                         # Must be specified here or above.

  """

exports.validate = (config, validators) ->
  errors = []
  if validators.ifExistsIsObject(errors, "requireBuildTextPluginModuleInclude config", config.requireBuildTextPluginModuleInclude)
    validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.pluginPath", config.requireBuildTextPluginModuleInclude.pluginPath)
    validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.folder", config.requireBuildTextPluginModuleInclude.folder)
    validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginModuleInclude.extensions", config.requireBuildTextPluginModuleInclude.extensions)
    if validators.isArrayOfObjects(errors, "requireBuildTextPluginModuleInclude.modules", config.requireBuildTextPluginModuleInclude.modules)
      for moduleConfig in config.requireBuildTextPluginModuleInclude.modules
        validators.stringMustExist(errors, "requireBuildTextPluginModuleInclude.modules.name", moduleConfig.name)
        unless validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.modules.folder", moduleConfig.folder)
          if validators.isString(errors, "requireBuildTextPluginModuleInclude.folder", config.requireBuildTextPluginModuleInclude.folder)
            moduleConfig.folder = config.requireBuildTextPluginModuleInclude.folder
        unless validators.ifExistsIsString(errors, "requireBuildTextPluginModuleInclude.modules.pluginPath", moduleConfig.pluginPath)
          if validators.isString(errors, "requireBuildTextPluginModuleInclude.pluginPath", config.requireBuildTextPluginModuleInclude.pluginPath)
            moduleConfig.pluginPath = config.requireBuildTextPluginModuleInclude.pluginPath
        unless validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginModuleInclude.modules.extensions", moduleConfig.extensions)
          if validators.isArrayOfStringsMustExist(errors, "requireBuildTextPluginModuleInclude.extensions", config.requireBuildTextPluginModuleInclude.extensions)
            moduleConfig.extensions = config.requireBuildTextPluginModuleInclude.extensions

  errors

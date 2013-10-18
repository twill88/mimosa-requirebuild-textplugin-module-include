"use strict"

exports.defaults = ->
  requireBuildTextPluginInclude:
    folder: ""
    pluginPath: "vendor/text"
    extensions: ["html"]

exports.placeholder = ->
  """
  \t

    # requireBuildTextPluginInclude:
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
                                         # modules, and will prevent the default behaviour of
                                         # including the text files in a single built file.
      #   name: ""                       # Name of the module in which to include the files. If
                                         # the name matches that of a module specified in the
                                         # r.js config, it will include the files in that module.
                                         # If the name doesn't match a r.js module, this entry
                                         # will be ignored.
      #   folder: ""                     # A subdirectory of the javascriptDir used for this
                                         # specific module. If not specified, uses the folder
                                         # specified above.
      #   pluginPath: ""                 # Allows the use of a different plugin path for this
                                         # module. If not specified, uses the pluginPath
                                         # specified above.
      #   extensions: []                 # Allows the use of different extensions for this module.
      # }]

  """

exports.validate = (config, validators) ->
  errors = []
  if validators.ifExistsIsObject(errors, "requireBuildTextPluginInclude config", config.requireBuildTextPluginInclude)
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.pluginPath", config.requireBuildTextPluginInclude.pluginPath)
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.folder", config.requireBuildTextPluginInclude.folder)
    validators.isArrayOfStringsMustExist(errors, "requireBuildTextPluginInclude.extensions", config.requireBuildTextPluginInclude.extensions)
    if validators.ifExistsIsArrayOfObjects(errors, "requireBuildTextPluginInclude.modules", config.requireBuildTextPluginInclude.modules)
      for moduleConfig in config.requireBuildTextPluginInclude.modules
        validators.stringMustExist(errors, "requireBuildTextPluginInclude.modules.name", moduleConfig.name)
        unless validators.ifExistsIsString(errors, "requireBuildTextPluginInclude.modules.folder", moduleConfig.folder)
          moduleConfig.folder = config.requireBuildTextPluginInclude.folder
        unless validators.ifExistsIsString(errors, "requireBuildTextPluginInclude.modules.pluginPath", moduleConfig.pluginPath)
          moduleConfig.pluginPath = config.requireBuildTextPluginInclude.pluginPath
        unless validators.ifExistsIsArrayOfStrings(errors, "requireBuildTextPluginInclude.modules.extensions", moduleConfig.extensions)
          moduleConfig.extensions = config.requireBuildTextPluginInclude.extensions

  errors

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

  """

exports.validate = (config, validators) ->
  errors = []
  if validators.ifExistsIsObject(errors, "requireBuildTextPluginInclude config", config.requireBuildTextPluginInclude)
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.pluginPath", config.requireBuildTextPluginInclude.pluginPath)
    validators.stringMustExist(errors, "requireBuildTextPluginInclude.folder", config.requireBuildTextPluginInclude.folder)
    validators.isArrayOfStringsMustExist(errors, "requireBuildTextPluginInclude.extensions", config.requireBuildTextPluginInclude.extensions)

  errors

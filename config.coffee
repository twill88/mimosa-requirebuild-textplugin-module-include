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
      # folder: ""                       # A subdirectory of the javascriptDir used to narrow down the location of included files.
      # pluginPath: "vendor/text"        # AMD path to the text plugin
      # extensions: ["html"]             # A list of extensions for files to include in the r.js
                                         # config's 'include' array attached to the text plugin
                                         # path listed above.  Ex: vendor/text!app/foo.html
                                         # All files in the folder that match this
                                         # extension will be pushed into the array and already
                                         # present array entries will be left alone. Extensions
                                         # should not include the period.

  """

exports.validate = (config) ->
  errors = []
  if config.requireBuildTextPluginInclude?
    rbtpi = config.requireBuildTextPluginInclude
    if typeof rbtpi is "object" and not Array.isArray(rbtpi)

      if rbtpi.pluginPath?
        unless typeof rbtpi.pluginPath is "string"
          errors.push "requireBuildTextPluginInclude.pluginPath must be a string."
      else
        errors.push "requireBuildTextPluginInclude.pluginPath must be present."

      if rbtpi.folder?
        unless typeof rbtpi.folder is "string"
          errors.push "requireBuildTextPluginInclude.folder must be a string."
      else
        errors.push "requireBuildTextPluginInclude.folder must be present."


      if rbtpi.extensions?
        if Array.isArray(rbtpi.extensions)
          for ex in rbtpi.extensions
            unless typeof ex is "string"
              errors.push "requireBuildTextPluginInclude.extensions must be an array of strings."
              break
        else
          errors.push "requireBuildTextPluginInclude.extensions configuration must be an array."
      else
        errors.push "requireBuildTextPluginInclude.extensions must be present."


    else
      errors.push "requireBuildTextPluginInclude configuration must be an object."

  errors

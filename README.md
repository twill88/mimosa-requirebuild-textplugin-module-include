mimosa-requirebuild-textplugin-include
===========

Say that 3 times fast.

## Overview

This is a Mimosa module.  It both serves as a module to be used with Mimosa, and also serves as an example for how one would write a module to intercept the r.js configurations before optimization occurs.

The actual function of this module is to find text dependencies and include them in the `include` array for a r.js run via the requirejs text plugin.

For more information regarding Mimosa, see http://mimosa.io

## Usage

Add `'mimosa-requirebuild-textplugin-include'` to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

## Functionality

The `'mimosa-requirebuild-textplugin-include'` module configuration is a pointer to a directory of files to include, the requirejs text plugin and a list of extensions to include in the r.js `include` array appended to the text plugin.

## Default Config

```
requireBuildTextPluginInclude:
  folder: ""
  pluginPath: "vendor/text"
  extensions: ["html"]
```

* `folder`: a string, a directory within the `watch.javascriptDir` that narrows down the search for files to include.  If left alone, `watch.javascriptDir` is used.
* `pluginPath`: a string, the AMD path to your requirejs text plugin
* `extensions`: an array of strings,  list of extensions for files to include in the r.js config's 'include' array attached to the text plugin at `pluginPath` path listed above.  Ex: vendor/text!app/foo.html. All files in the watch.javascriptDir/folder that match this extension will be pushed into the array and already present array entries will be left alone. Extensions should not include the period.

## Optional Config

```
requireBuildTextPluginInclude:
  modules: [{
    name: ""
    folder: ""
    pluginPath: ""
    extensions: []
  }]
```

`modules`: an array of objects, can be used to specify specific modules in which to include the files. This should be used in conjunction with r.js modules, and will prevent the default behaviour of including the files in a single built file. This is useful if you want to combine your more commonly used assets into one file, and some of the lesser used assets into another file that can be loaded after the initial page load and app start.

  * `name`: a string, the name of the module in which to include the files. If the name matches that of a module in the r.js config, it will include the files in that module. If no matching module is found, this entry will be ignored.
  * `folder`: a string, a subdirectory of the javascriptDir used for this specific module. If not specified, uses the folder specified using the default config settings.
  * `pluginPath`: a string, allows the use of a different pluginPath for this module. If not specified, uses the pluginPath specified using the default config settings.
  * `extensions`: an array of strings, allows the use of different extensions for this module. If not specified, uses the extensions specified using the default config settings.
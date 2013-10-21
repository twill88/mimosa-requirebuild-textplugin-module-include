mimosa-requirebuild-textplugin-module-include
===========

This is a Mimosa module. It is really an extension of the [requirebuild-textplugin-include](https://github.com/dbashford/mimosa-requirebuild-textplugin-include) module. The function of this module is to find text dependencies and include them in the `include` array for r.js modules. This module can either include the text dependencies in already defined r.js modules by matching module name, or it can create new modules for you.

This behaviour can be useful if you want to combine your more commonly used assets into one file, and some of the lesser used assets into another file that can be loaded after the initial page-load/app-start.

For more information regarding Mimosa, see http://mimosa.io

## Usage

Add `'mimosa-requirebuild-textplugin-module-include'` to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

## Functionality

The `'mimosa-requirebuild-textplugin-module-include'` module configuration is a pointer to a directory of files to include, the requirejs text plugin, a list of extensions to include in the r.js `include` array appended to the text plugin, and a list of modules in which to include the files. Each setting can be customized or overridden for each module. 

## Default Config

```
requireBuildTextPluginInclude:
  folder: ""
  pluginPath: "vendor/text"
  extensions: ["html"]
  modules: [{
    name: ""
    folder: ""
    pluginPath: ""
    extensions: []
  }]
```

* `folder`: a string, a directory within the `watch.javascriptDir` that narrows down the search for files to include.  If left alone, `watch.javascriptDir` is used.
* `pluginPath`: a string, the AMD path to your requirejs text plugin
* `extensions`: an array of strings,  list of extensions for files to include in the r.js config's 'include' array attached to the text plugin at `pluginPath` path listed above.  Ex: vendor/text!app/foo.html. All files in the watch.javascriptDir/folder that match this extension will be pushed into the array and already present array entries will be left alone. Extensions should not include the period.
* `modules`: an array of objects, specifies the modules in which to include the files. This can be used to include files in seperately define r.js modules, or to create new r.js modules.  

    -- `name`: a string, the name of the module in which to include the files. If the name matches that of a module in the r.js config, it will include the files in that module. If no matching module is found, a new module will be created and added to the r.js modules list.  
    -- `folder`: a string, a subdirectory of the javascriptDir used for this specific module. If not specified, uses the folder specified above.  
    -- `pluginPath`: a string, allows the use of a different pluginPath for this module. If not specified, uses the pluginPath specified above.  
    -- `extensions`: an array of strings, allows the use of different extensions for this module. If not specified, uses the extensions specified above.

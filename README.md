# Global Modules

This is where you can put Masa CMS modules that are globally accessible. In previous versions of Masa CMS modules were referred to as "display objects".

You can copy core modules (https://github.com/MasaCMS/MasaCMS/tree/main/core/modules/v1) here to makes global customizations or add new modules.

# Shop module
## Logo location
add your `logo.png` into `modules\shop\assets\images`
## Java libs
This module requires these two library's that are present under `modules/shop/lib`. To initialize these you need to add these two lines to your module `Application.cfc`:
```java
// shop libarys
this.javaSettings.loadPaths = [getDirectoryFromPath(getCurrentTemplatePath()) & "shop/lib/"];
this.javaSettings.reloadOnChange=true;
```
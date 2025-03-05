# Global Modules

This is where you can put Masa CMS modules that are globally accessible. In previous versions of Masa CMS modules were referred to as "display objects".

You can copy core modules (https://github.com/MasaCMS/MasaCMS/tree/main/core/modules/v1) here to makes global customizations or add new modules.

# Shop module
## Logo location
add your `logo.png` into `modules\shop\assets\images`
## Java libs
> for development in docker place under `/usr/local/lib/CommandBox/lib`

**I've not gotten thee seperate jars to work under lucee**
```bash
curl -O https://github.com/manuelbl/SwissQRBill/releases/download/v3.3.1/qrbill-generator-3.3.1.jar
curl -O https://github.com/nayuki/QR-Code-generator/releases/download/v1.8.0/qrcodegen-1.8.0.jar
```

So you'll probably want to use my [merged jar](https://ori.comfy.one/static/archives/qrbill-generator-3.3.1_qrcodegen-1.8.0.jar) or merge them yourself. To merge them you just need to move the `io` folder from the root of `qrcodegen-1.8.0.jar` into the root of `qrbill-generator-3.3.1.jar`.
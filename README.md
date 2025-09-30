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
## ORM
This module makes use of the built in coldfusion ORM so you will have ti enable that via `/config/cfapplication.cfc`
```java
this.ormEnabled = true;
this.ORMSettings = {
    datasource = "[YOUR DATASOURCE HERE]",
    dbcreate = "dropcreate",
    cfclocation = ["/modules/shop/model/beans"],
};
```
## Shipping cost's
The default shipping categories are based of [swiss postal inland pricing](https://www.post.ch/-/media/post/pk/dokumente/das-angebot-im-ueberblick.pdf). To change or expand this one needs to edit the `OptionList` & `OptionLabelList` for `shippingCostCategory` in both [pageArticle.cfc](./model/handlers/pageArticle.cfc) & [pageArticleVariation](./model/handlers/pageArticleVariation.cfc)

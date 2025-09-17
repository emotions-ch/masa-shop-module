component
  accessors="false"
  displayname="Cart Handler"
  hint="Cart Handler"
  output="false"
{
  /**
   * @hint initialize component
   * @return this.component
   */
  public component function init(){
    if (!isDefined("session.cart")) {
      session.cart = new Cart();
    }

    if (structKeyExists(url, 'ajax')) ajaxHandler();
    return this;
  }

  /**
   * todo:      implement functions to process cart actions
   *            e.g.: addArticle, removeArticle, updateArticle
   * structure: split in multiple functions bundling single functionalities
   */


  private void function ajaxHandler(){
    switch (url.ajax) {
      case 'updateCart':
        updateCart();
        break;
      case 'getCart':
        getCart();
        break;
      case "getNextCheckoutStep":
        getNextCheckoutStep();
        break;
      default:
        break;
    }
  }

  /**
   * update cart with actions
   */
  private void function updateCart() {
    local.set = false;
    if (structKeyExists(url, "set") && url.set == 1) {
      local.set = true;
    }
		local.variants = deserializeJSON(urlDecode(url.variants));

    local.article = new CartArticle(id=url.articleId, quantity=url.quantity, variants=local.variants);
    session.cart.updateArticle(local.article, local.set);
  }

  /**
   * @hint 
   */
  public any function getNextCheckoutStep() output=false {
    // validation logic here

    local.nextCheckoutStep = "stub";

    return local.nextCheckoutStep;
  }
}

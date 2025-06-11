component
  accessors="false"
  displayname="Class Cart"
  hint="Cart Class"
  output="true"
{
  property type="array" name="articles";

  /**
   * @hint initialize component
   * @return this.component
   */
  public component function init(){
    variables.articles = [];
    session.shippingCost = 10;

    return this;
  }

  /**
   * @hint adds article or upates quantity of existing article in cart
   * @return void
   */
  public void function updateArticle(
    required component article,
    boolean set = false
    ){
    local.currentArticleId = arguments.article.getId();
    if (hasArticle(local.currentArticleId)) {
      local.cartArticle = getArticleById(local.currentArticleId);

      if (arguments.article.getQuantity() == 0) {
        local.removed = removeArticle(local.cartArticle);
      } else {
        if (arguments.set) {
          local.cartArticle.setQuantity(arguments.article.getQuantity());
        } else {
          local.cartArticle.setQuantity(local.cartArticle.getQuantity() + arguments.article.getQuantity());
        }
      }
    } else {
      arrayAppend(variables.articles, arguments.article);
    }
    return;
  }

  
  private boolean function removeArticle(required component article){
    return arrayDelete(variables.articles, arguments.article);  
  }

  /**
   * @hint remove article from cart
   * @return article component
   */
  private component function getArticleById(required String id){
    for (local.article in variables.articles) {
      if (local.article.getId() == arguments.id) {
        return local.article;
      }
    }
    return new CartArticle(id=arguments.id, quantity=0);
  }

  /**
   * @hint check if article exists
   * @return boolean
   */
  private boolean function hasArticle(required String id){
    for (local.article in variables.articles) {
      if (local.article.getId() == arguments.id) {
        return true;
      }
    }
    return false;
  }

  /**
   * @hint get total amount of articles in cart
   * @return numeric
   */
  public numeric function getTotalQuantity() {
    local.totalQuantity = 0;
    for (local.article in variables.articles) {
      local.totalQuantity += local.article.getQuantity();
    }
    return local.totalQuantity;
  }

  public numeric function getTotalPrice(
    numeric shippingCost
  ) {
    local.totalPrice = 0;
    for (local.article in variables.articles) {
      local.totalPrice += local.article.getTotalPrice();
    }

    if (isDefined("arguments.shippingCost")) {
      local.totalPrice += arguments.shippingCost;
    }

    return local.totalPrice;
  }

  /**
   * 
   */
  public array function getArticles(){
    return variables.articles;
  }

  /**
   * @hint get all articleIds in cart as json
   * @return query
   */
  public string function getCartJson() {
    local.json;

    for (local.article in getArticles()) {
      if (len(local.json)) {
        local.json &= ",";
      }
      local.json &= serializeJSON({
        "id": local.article.getId(),
        "quantity": local.article.getQuantity()
      });
    }

    return local.json;
  };
}
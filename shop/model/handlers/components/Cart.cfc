component
  accessors="false"
  displayname="Class Cart"
  hint="Cart Class"
  output="false"
{
  property type="array" name="articles";

  /**
   * @hint initialize component
   * @return this.component
   */
  public component function init(){
    variables.articles = [];

    return this;
  }

  /**
   * @hint adds or removes article depending if quantity is Positive or negative to cart
   * @return void
   */
  public void function updateArticle(required component article){
    local.currentArticleId = arguments.article.getId();
    if (hasArticle(local.currentArticleId)) {
      local.currentArticleQuantity = arguments.article.getQuantity();

      local.cartArticle = getArticleById(local.currentArticleId);
      local.cartArticle.setQuantity(local.cartArticle.getQuantity() + local.currentArticleQuantity);
      
    } else {
      arrayAppend(variables.articles, arguments.article);
    }
    return;
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
      local.totalPrice += local.article.getPrice() * local.article.getQuantity();
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
}
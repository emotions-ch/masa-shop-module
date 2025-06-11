component
  accessors="false"
  displayname="Class CartArticle"
  hint="CartArticle Class"
  output="false"
{
  property type="String" name="id";
  property type="numeric" name="quantity";
  property type="String" name="articleNumber";

  /**
   * @hint initialize component
   * @return this.component
   */
  public component function init(
    required String id,
    required numeric quantity
  ){
    variables.id = arguments.id;
    variables.quantity = arguments.quantity;
    variables.articleBean = getArticleBean();
    variables.articleNumber = getArticleNumber();

    return this;
  }

  /**
   * get article id
   */
  public string function getId(){
    return variables.id;
  }

  /**
   * get quantity 
   */
  public numeric function getQuantity(){
    return variables.quantity;
  }

  public string function getArticleNumber(){
    return variables.articleBean.get("articleNumber");
  }

  public string function getPrice(){
    return variables.articleBean.get("articlePrice");
  }

  public string function getUrl(){
    return variables.articleBean.get("url");
  }

  public string function getTotalPrice(){
    return getPrice() * variables.quantity;
  }

  public string function getTitle(){
    return variables.articleBean.get("title");
  }

  public string function getImageUrl(
    string size="small"
  ){
    return variables.articleBean.getImageUrl(arguments.size);
  }

  private component function getArticleBean(){
    return application.serviceFactory.getBean('m').getBean('content').loadBy(contentid=variables.id);
  }

  /**
   * set quantity
   */
  public void function setQuantity(
    required numeric quantity
  ){
    variables.quantity = arguments.quantity;
  }
}
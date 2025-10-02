component
  accessors="false"
  displayname="Class CartArticle"
  hint="CartArticle Class"
  output="false"
{
  property type="String" name="id";
  property type="numeric" name="quantity";
  property type="String" name="articleNumber";
	property type="struct" name="variants";

  /**
   * @hint initialize component
   * @return this.component
   */
  public component function init(
    required String id,
    required numeric quantity,
    struct variants = {}
  ){
    variables.id = arguments.id;
    variables.quantity = arguments.quantity;
    variables.variants = arguments.variants;
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
		for (local.variant in getVariants()) {
			local.variantBean = getContentBean().loadBy(contentid=getVariants()[local.variant]);

			if (local.variantBean.get('subtype') == "ArticleVariation" && local.variantBean.get("articleNumber") != "") {
				return local.variantBean.get("articleNumber");
			}
		}
    return variables.articleBean.get("articleNumber");
  }

  public string function getPrice(){
		for (local.variant in getVariants()) {
			local.variantBean = getContentBean().loadBy(contentid=getVariants()[local.variant]);

			if (local.variantBean.get('subtype') == "ArticleVariation" && local.variantBean.get("articlePrice") != "") {
				return local.variantBean.get("articlePrice");
			}
		}
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

	public struct function getVariants(){
		return variables.variants
	}

	public array function getVariantNames() {
		local.names = [];
		for (local.variant in getVariants()) {
			arrayAppend(local.names, getContentBean().loadBy(contentid=getVariants()[local.variant]).get('title'));
		}

		return local.names;
	}

	public numeric function getShippingPrice() {
		local.shippingCost = 0;

		if (getVariantNames().len() == 0) {
			return ((variables.articleBean.get("shippingCostCategory") != "") ? variables.articleBean.get("shippingCostCategory") : 0);
		} else {
			for (local.variant in getVariants()) {
				local.variantBean = getContentBean().loadBy(contentid=getVariants()[local.variant]);

				if (local.variantBean.get('subtype') == "ArticleVariation" && local.variantBean.get("shippingCostCategory") != "") {
					return ((variables.variantBean.get("shippingCostCategory") != "") ? variables.variantBean.get("shippingCostCategory") : 0);
				} else if (local.variantBean.get('subtype') == "ArticleVariation") {
					return ((variables.articleBean.get("shippingCostCategory") != "") ? variables.articleBean.get("shippingCostCategory") : 0);
				}
			}
		}
	}

  public string function getImageUrl(
    string size="small"
  ){
    return variables.articleBean.getImageUrl(arguments.size);
  }

	private component function getArticleBean(){
		return getContentBean().loadBy(contentid=variables.id);
	}

  private component function getContentBean(
		string siteId = session.siteid 
	) {
		return application.serviceFactory.getBean('m').getBean('content').loadBy(siteId=arguments.siteId);
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

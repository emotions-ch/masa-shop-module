component
	extends="mura.cfobject"
	output=true
	{

	function onRenderStart(m, application){
		// writeDump(var=objectParams, abort=true);
		if (!structKeyExists(session, 'cart')) {
			session.cart = new components.Cart();
		}
		
		if (structKeyExists(url, 'ajax')) ajaxHandler();
		return this;

	}

	function onApplicationLoad() {
	}


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
		private void function updateCart(){
			local.article = new components.CartArticle(id=url.articleId, quantity=url.quantity);
			session.cart.updateArticle(local.article);
			local.out = {
				"ArticleId":#url.articleId#,
				"Quantity":#url.quantity#
			}
		
			// writeOutput(serializeJSON(local.out));
			abort;
		}
	
		/**
		 * get cart
		 */
		public array function getCart() {
			local.currentCart = session.cart.getArticles();
		
			writeOutput(serializeJSON(local.currentCart));
			return "meow";
			// abort;
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

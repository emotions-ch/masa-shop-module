<cfoutput>
  <nav aria-label="breadcrumb">
    <div class="breadcrumb mt-3 flex-column flex-sm-row">
      <div class="ml-sm-auto">
        <a class="btn btn-primary" href="#local.cleanRequestUrl#">Zurück zum Shop</a>
      </div>
    </div>
  </nav>
  <div class="container" id="cart-module-object">
    <h1>Warenkorb</h1>
    <cfif session.cart.getTotalQuantity() eq 0>
      <p>Ihr Warenkorb ist leer.</p>
      <p><a href="#local.cleanRequestUrl#">Zurück zum Shop</a></p>
    <cfelse>
      <div class="cart-items">
        <cfloop array="#session.cart.getArticles()#" index="local.article">
          <div class="article" article-id="#local.article.getId()#" variant="#encodeForHTMLAttribute(local.article.getVariants().toJSON())#">
            <img src="#local.article.getImageUrl()#" alt="#local.article.getTitle()#">
            <div class="item-details">
              <a href="#local.article.getUrl()#" target="_blank"><h3>#local.article.getTitle()#</h3></a>
							<cfif local.article.getVariantNames().len() NEQ 0 >
								<p class="article-variant">Variante: #right(left(local.article.getVariantNames().toString(),-1),-1)#</p>
							</cfif>
              <div class="item-pricing">
                <p id="total-item-price">CHF #NumberFormat(local.article.getTotalPrice(), '.00')#</p>
              </div>
            </div>
            <div class="product-action">
              <button class="btn btn-danger remove-item" onclick="removeFromCart('#local.article.getId()#','#encodeForHTMLAttribute(local.article.getVariants().toJSON())#');">Entfernen</button>
              <div class="quantity">
                <input type="number" class="form-control" value="#local.article.getQuantity()#" min="1" max="99" article-id="#local.article.getId()#" setter="1" onchange="updateCart(this, '#local.article.getPrice()#', '#encodeForHTMLAttribute(local.article.getVariants().toJSON())#'); ">
              </div> <!-- quantity -->
            </div>
          </div>
        </cfloop>
      </div>

      <div class="cart-actions">
        <p class="total-price">Gesamtpreis: CHF #NumberFormat(session.cart.getTotalPrice(), '.00')#</p>
        <a class="btn btn-primary" href="#local.cleanRequestUrl#?checkout=1">Zur Kasse</a>
      </div>
    </cfif>
  </div>
</cfoutput>

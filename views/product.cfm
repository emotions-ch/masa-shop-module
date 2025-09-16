<cfoutput>
  <div class="main-wrapper">
    <article class="product ">

      <br>
      <div class="right">
        <button class="btn btn-primary mt-3"  onclick="window.location.href='#local.cleanRequestUrl#'">&##8592; Zurück zum Shop</button>
      </div>

      <div class="shop-row">
        <picture id="product-image" style="background-image: url(#local.productContent.getImageUrl()#)"></picture>

        <div id="product-info">
          <h2>#local.productContent.get('title')#</h2>

          <cfif local.productContent.get("articleAmount").len()>
            <p id="amount">Menge: #local.productContent.get("articleAmount")#</p>
          </cfif>

          <cfset local.productContent.categoryIterator = local.productContent.getCategoriesIterator()>
          <cfif local.productContent.categoryIterator.hasNext()>
            <h3>Variationen:</h3>
            <select name="variations" id="productVariations" class="form-select">
              <cfloop condition="local.productContent.categoryIterator.hasNext()">
                <cfset local.category = local.productContent.categoryIterator.next()>
                <option value="#local.category.get('categoryId')#">
                  #local.category.get('name')#
                </option>
              </cfloop>
            </select>
          </cfif>

					<p>#local.productContent.get('summary')#</p>
					<cfif condition=isNumeric(local.productContent.get("articlePrice"))>
						<span id="price">CHF #NumberFormat(local.productContent.get("articlePrice") ,'.00')#</span>
					<cfelse>
						<span id="price">CHF #local.productContent.get("articlePrice")#</span>
					</cfif>
						
          
          <div class="product-action">
            <div class="quantity">
              <input type="number" class="form-control" value="1" min="1" max="99">
            </div> <!-- quantity -->
            <button href="##" class="article-to-cart form-control" article-id="#local.productContent.get('contentId')#">In den Warenkorb</button>
          </div> <!-- product-action -->
        </div>
      </div>

      <div id="product-description" class="row">
        #local.productContent.get('body')#
      </div>
    </article>
  </div>
</cfoutput>

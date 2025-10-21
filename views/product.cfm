<cfoutput>
  <div class="main-wrapper">
    <article class="product ">

      <br>
      <div class="right">
        <button class="btn btn-primary" onclick="window.location.href='#local.cleanRequestUrl#'"><i class="fas fa-arrow-left"></i> Zurück zum Shop</button>

				<div class="ml-sm-auto">
					<a class="btn btn-primary" href="#local.cleanRequestUrl#?cart=1"><i class="fas fa-shopping-cart"></i> Zum Warenkorb</a>
				</div>
      </div>

      <div class="shop-row">
        <picture id="product-image" style="background-image: url(#local.productContent.getImageUrl()#)"></picture>

        <div id="product-info">
          <h2>#local.productContent.get('title')#</h2>

          <cfif local.productContent.get("articleAmount").len()>
            <p id="amount">Menge: #local.productContent.get("articleAmount")#</p>
          </cfif>

          <cfset local.productContent.kidsIterator = local.productContent.getKidsIterator()>
          <cfif local.productContent.kidsIterator.hasNext()>
						<cfloop condition=local.productContent.kidsIterator.hasNext()>
							<cfset local.variationContent = local.productContent.kidsIterator.next()>
							<cfset local.variantsContentKidsIterator = local.variationContent.getKidsIterator()>

							<cfif local.variantsContentKidsIterator.hasNext()>
								<div>
									<h3>#local.variationContent.get('title')#</h3>

									<select name="variations-#lCase(local.variationContent.get('title'))#" id="productVariation-#local.variationContent.get('contentId')#" class="form-select">
									<option value="#local.productContent.get('contentId')#" cType="parent" selected>Bitte wählen</option>
										<cfloop condition=local.variantsContentKidsIterator.hasNext()>
											<cfset local.variant = local.variantsContentKidsIterator.next()>
											<option value="#local.variant.get('contentId')#" cType="#local.variant.get('type')#/#local.variant.get('subtype')#">
												#local.variant.get('title')#
											</option>
										</cfloop>
									</select>
								</div>
							</cfif>
						</cfloop>
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
            <button href="##" class="article-to-cart form-control" article-id="#local.productContent.get('contentId')#"><i class="fas fa-cart-plus"></i> In den Warenkorb</button>
          </div> <!-- product-action -->
        </div>
      </div>

      <div id="product-description" class="row">
        #local.productContent.get('body')#
      </div>
    </article>
  </div>

</cfoutput>

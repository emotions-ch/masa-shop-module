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

          <cfset local.productContent.kidsIterator = local.productContent.getKidsIterator()>
          <cfif local.productContent.kidsIterator.hasNext()>
						<cfloop condition=local.productContent.kidsIterator.hasNext()>
							<cfset local.variationContent = local.productContent.kidsIterator.next()>
							<cfset local.variantsContentKidsIterator = local.variationContent.getKidsIterator()>

							<cfif local.variantsContentKidsIterator.hasNext()>
								<div>
									<h3>#local.variationContent.get('title')#</h3>

									<select name="variations" id="productVariation-#local.variationContent.get('contentId')#" class="form-select">
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
            <button href="##" class="article-to-cart form-control" article-id="#local.productContent.get('contentId')#">In den Warenkorb</button>
          </div> <!-- product-action -->
        </div>
      </div>

      <div id="product-description" class="row">
        #local.productContent.get('body')#
      </div>
    </article>
  </div>

<!--- 	TEMP STUFF WHILE DEV --->
	<script src="#cgi.request_url.listFirst(":")#://#cgi.http_host#/core/modules/v1/core_assets/js/mura.min.js"></script>
	<script>
		Mura.init({
			siteid:'#m.content().get('siteId')#',
			rootpath:'#cgi.request_url.listFirst(":")#://#cgi.http_host#'
		});

		document.querySelectorAll('select[id^="productVariation-"]').forEach(function(select) {
			select.addEventListener('change', function(event) {
				let selectedOption = event.target.selectedOptions[0];
				let cType = selectedOption.getAttribute('cType');
				
				if (cType === "File/Default") {
					Mura.getEntity('content').loadBy('contentid', event.target.value)
					.then(function(item){
						let image = item.get('images').source;

						document.getElementById('product-image').style.backgroundImage = 'url(' + image + ')';
					});	
				}
			});
		});

		Mura.getEntity('content').loadBy('contentid','#local.productContent.get('contentId')#')
    .then(function(item){
      console.log(item.get('title'));
    });
	</script>
</cfoutput>

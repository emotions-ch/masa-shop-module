<cfoutput>
  <div class="main-wrapper">
    <article class="product ">

      <br>
      <div class="right">
        <button class="btn btn-primary mt-3"  onclick="window.location.href='/shop'">&##8592; Zurück zum Shop</button>
      </div>

      <div class="row">
        <picture id="product-image" style="background-image: url(#local.productContent.getImageUrl()#)"></picture>

        <div id="product-info">
          <h4>#local.productContent.get('title')#</h4>

          <cfif local.productContent.get("articleAmount").len()>
            <p id="amount" class="highlight">Menge: #local.productContent.get("articleAmount")#</p>
          </cfif>

            <p>#local.productContent.get('summary')#</p>
          <span id="price" class="highlight" >CHF #NumberFormat(local.productContent.get("articlePrice") ,'.00')#</span>
          
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
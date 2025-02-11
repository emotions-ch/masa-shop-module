<cfoutput>
  <!DOCTYPE html>
  <html lang="de" class="#(m.hasFETools() ? 'mura-edit-mode' : '')#">
    <!--- HTML Head --->
    <cfinclude template="inc/htmlHead.cfm">

    <cfhtmlhead>
      <script src="#m.siteConfig('themeAssetPath')#\assets\js\cart.js"></script>
      <link rel="stylesheet" href="#m.siteConfig('themeAssetPath')#\assets\css\shop.css">
    </cfhtmlhead>

    <body class="#m.createCSSHook(m.content('menuTitle'))#">
      <div class="scaffold">
        <!--- Header --->
        <header>
          <cfinclude template="inc/navbar.cfm">
        </header>

        <!--- Main --->
        <main>
          <div class="main-wrapper">
            <article class="product ">

              <br>
              <div class="right">
                <button class="btn btn-primary mt-3"  onclick="window.location.href='/shop'">&##8592; Zurück zum Shop</button>
              </div>

              <div class="row">
                <picture id="product-image" style="background-image: url(#m.content().getImageUrl('shop')#)"></picture>

                <div id="product-info">
                  <h4>#m.content('title')#</h4>

                  <cfif m.content("articleAmount").len()>
                    <p id="amount" class="highlight">Menge: #m.content("articleAmount")#</p>
                  </cfif>

                    <p>#m.content('summary')#</p>
                  <span id="price" class="highlight" >CHF #NumberFormat(m.content("articlePrice") ,'.00')#</span>
                  
                  <div class="product-action">
                    <div class="quantity">
                      <input type="number" class="form-control" value="1" min="1" max="99">
                    </div> <!-- quantity -->
                    <button href="##" class="article-to-cart form-control" article-id="#m.content('contentId')#">In den Warenkorb</button>
                  </div> <!-- product-action -->
                </div>
              </div>

              <div id="product-description" class="row">
                #m.content('body')#
              </div>
            </article>
          </div>
        </main>

        <!--- Footer --->
        <cfinclude template="inc/footer.cfm">
      </div>
    </body>
  </html>
</cfoutput>
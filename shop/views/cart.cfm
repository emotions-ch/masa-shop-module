<cfoutput>
  <div class="container">
    <h1>Warenkorb</h1>
    <cfif session.cart.getTotalQuantity() eq 0>
      <p>Ihr Warenkorb ist leer.</p>
      <p><a href="#local.cleanRequestUrl#">Zurück zum Shop</a></p>
    <cfelse>
      <p>In Ihrem Warenkorb befinden sich #session.cart.getTotalQuantity()# Artikel.</p>
      <p><a href="#local.cleanRequestUrl#?checkout=1">Zur Kasse</a></p>
      <p><a href="#local.cleanRequestUrl#?clear=1">Warenkorb leeren</a></p>
      
      <div class="cart-items">
        <cfloop array="#session.cart.getArticles()#" index="local.article">
          <div class="article">
            <img src="#local.article.getImageUrl()#" alt="#local.article.getTitle()#">
            <div class="item-details">
              <h2>#local.article.getTitle()#</h2>
              <p id="item-price">Preis: CHF #NumberFormat(local.article.getPrice(), '.00')#</p>
              <p id="total-item-price">Gesamt: CHF #NumberFormat(local.article.getTotalPrice(), '.00')#</p>
            </div>
            <div class="product-action">
              <button class="btn btn-danger remove-item" onclick="removeFromCart('#local.article.getId()#');">Entfernen</button>
              <div class="quantity">
                <input type="number" class="form-control" value="#local.article.getQuantity()#" min="1" max="99" article-id="#local.article.getId()#" onchange="updateQuantity(this, '#local.article.getPrice()#', '#local.article.getId()#'); ">
                <script>
                  function updateQuantity(input, price, articleId) {
                    const quantity = $(input).val();
                    const totalPrice = (parseFloat(price) * parseInt(quantity)).toFixed(2);
                    $(input).closest('.article').find('##total-item-price').text('Gesamt: CHF ' + totalPrice);
                    addToCart($(input));
                  }
                </script>
              </div> <!-- quantity -->
            </div>
          </div>
        </cfloop>
      </div>

      <p class="total-price">Gesamtpreis: CHF #NumberFormat(session.cart.getTotalPrice(), '.00')#</p>
      
      <!--- Add more actions or information as needed --->
      
      <p><a href="#local.cleanRequestUrl#?checkout=1">Zur Kasse gehen</a></p>
      <p><a href="#local.cleanRequestUrl#?clear=1">Warenkorb leeren</a></p>
      
    </cfif>
</cfoutput>
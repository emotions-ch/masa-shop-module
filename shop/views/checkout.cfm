<cfoutput>
  <cfset local.billing = new modules.shop.components.Billing()>

  <!--- TODO --->
  <cfset session.shippingCost = 10>

  <cfif !isEmpty(form)>
    <cfset local.recipitent = m.siteConfig('contactEmail')>
    <cfset local.sender = "no-reply@myemotions.cloud">

    <!--- mail to melanie --->
    <cfmail to="#local.recipitent#" from="#local.sender#" subject="Hundeschule-Bestellung vom #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#" type="html">
      <cfloop collection="#form#" item="key">
        <cfif key neq "fieldnames" and key neq "alternateShippingAddress" and not isEmpty(form[key])>
          <cfoutput>#key#: #form[key]#<br></cfoutput>
        </cfif>
      </cfloop>
      <br>
      #local.billing.generateBillingTable(session.cart, session.shippingCost)#
    </cfmail>

    <!--- mail to customer --->
    <cfmail to="#form.email#" from="#local.sender#" subject="Ihre Bestellung bei der Hundeschule Famcane" type="html">
      <p>Hallo #form.firstname#</p>
      <p>Vielen Dank für deine Bestellung und das Vertrauen in uns!</p>
      <p>Nachfolgend findest du deine Bestellbestätigung:</p>
      <p><b>Lieferadresse:</b><br>

      <cfif form.shippingAddress.len()>
        <cfif form.shippingAddresszusatz neq "">
          #form.shippingAddresszusatz#<br>
        </cfif>
        
        #form.shippingFirstname# #form.shippingLastname#<br>
        #form.shippingAddress#<br>
        #form.shippingZip# #form.shippingCity#<br></p>

        <p><b>Rechnungsadresse:</b><br>

        <cfif form.addresszusatz neq "">
          #form.addresszusatz#<br>
        </cfif>

        #form.firstname# #form.lastname#<br>
        #form.address#<br>
        #form.zip# #form.city#<br></p>

      <cfelse>
        <cfif form.addresszusatz neq "">
          #form.addresszusatz#<br>
        </cfif>

        #form.firstname# #form.lastname#<br>
        #form.address#<br>
        #form.zip# #form.city#<br></p>
      </cfif>

      <p><b>Artikel</b><br>
      #local.billing.generateBillingTable(session.cart, session.shippingCost)#</p>
      <p>Freundliche Grüsse<br>
      Hundeschule Famcane</p>
    </cfmail>
  </cfif>

  <div class="container">
    <h2 class="heading-line text-primary mt-4">KASSE</h2>

    <div class="form-box">
      <div class="form-wrap">
        <cfif isEmpty(form)>

          <h2 class="form-title">Ihr Warenkorb</h2>
          <div class="table-responsive">
            <!--- billing table --->
            #local.billing.generateBillingTable(session.cart, session.shippingCost)#
            <!--- billing table done --->

            <div class="spread">
              <button class="btn btn-primary mt-3" onclick="window.location.href='/shop'">Zurück zum Shop</button>
              <button class="btn btn-primary mt-3" onclick="window.location.href='/checkout?clear=1'">Warenkorb leeren</button>
            </div>
          </div>

          <h2 class="form-title">Warenkorb bestellen</h2>
          <form method="POST">
            <label for="firstname">Vorname*</label>
            <input type="text" class="form-control" id="firstname" name="firstname" required>

            <label for="lastname">Nachname*</label>
            <input type="text" class="form-control" id="lastname" name="lastname" required>

            <label for="email">E-Mail*</label>
            <input type="email" class="form-control" id="email" name="email" required>

            <label for="phone">Telefon</label>
            <input type="tel" class="form-control" id="phone" name="phone">

            <label for="address">Strasse &amp; Nr.*</label>
            <input type="text" class="form-control" id="address" name="address" required>

            <div class="form-row-2">
              <div>
                <label for="zip">PLZ*</label>
                <input type="text" class="form-control" id="zip" name="zip" required>
              </div>

              <div>
                <label for="city">Ort*</label>
                <input type="text" class="form-control" id="city" name="city" required>
              </div>
            </div>

            <label for="addresszusatz">Adresszusatz</label>
            <input type="text" class="form-control" id="addresszusatz" name="addresszusatz">

            <div class="form-row-2" style="margin-top: 1rem;">
              <label for="alternateShippingAddress">Abweichende Lieferadresse?</label>
              <input type="checkbox" id="alternateShippingAddress" name="alternateShippingAddress">
            </div>

            <div class="shipping-address">
              <h4>Lieferadresse</h4>
              <label for="shippingFirstname">Vorname*</label>
              <input type="text" class="form-control" id="shippingFirstname" name="shippingFirstname">

              <label for="shippingLastname">Nachname*</label>
              <input type="text" class="form-control" id="shippingLastname" name="shippingLastname">

              <label for="shippingAddress">Strasse &amp; Nr.*</label>
              <input type="text" class="form-control" id="shippingAddress" name="shippingAddress">
            
              <div class="form-row-2">
                <div>
                  <label for="shippingZip">PLZ*</label>
                  <input type="text" class="form-control" id="shippingZip" name="shippingZip">
                </div>
              
                <div>
                  <label for="shippingCity">Ort*</label>
                  <input type="text" class="form-control" id="shippingCity" name="shippingCity">
                </div>
              </div>

              <label for="shippingAddresszusatz">Adresszusatz</label>
              <input type="text" class="form-control" id="shippingAddresszusatz" name="shippingAddresszusatz">
            </div>

            <input type="submit" class="btn btn-primary mt-3" value="Bestellung abschicken">
          </form>
          <script>
            document.getElementById('alternateShippingAddress').addEventListener('change', function() {
              var billingAddressDiv = document.querySelector('.shipping-address');
              if (this.checked) {
                billingAddressDiv.style.display = 'block';
                document.getElementById('shippingFirstname').required = true;
                document.getElementById('shippingLastname').required = true;
                document.getElementById('shippingAddress').required = true;
                document.getElementById('shippingZip').required = true;
                document.getElementById('shippingCity').required = true;
              } else {
                billingAddressDiv.style.display = 'none';
                document.getElementById('shippingFirstname').required = false;
                document.getElementById('shippingLastname').required = false;
                document.getElementById('shippingAddress').required = false;
                document.getElementById('shippingZip').required = false;
                document.getElementById('shippingCity').required = false;
              }
            });

            // Initially hide the billing address div
            document.querySelector('.shipping-address').style.display = 'none';
          </script>
        <cfelse>
          <h2 class="form-title">Bestellbestätigung</h2>
          <p>Vielen Dank für Ihre Bestellung, #form.firstname# #form.lastname#!</p>
          <p>Ihre Bestellung wird an folgende Adresse geliefert:</p>
          <cfif form.shippingAddress.len()>
            <p>
              <b>Lieferadresse:</b><br>
              <cfif form.shippingAddresszusatz neq "">
                #form.shippingAddresszusatz#<br>
              </cfif>

              #form.shippingFirstname# #form.shippingLastname#<br>
              #form.shippingAddress#<br>
              #form.shippingZip# #form.shippingCity#<br>
            </p>

            <p>
              <b>Rechnungsadresse:</b><br>
              <cfif form.addresszusatz neq "">
                #form.addresszusatz#<br>
              </cfif>

              #form.firstname# #form.lastname#<br>
              #form.address#<br>
              #form.zip# #form.city#<br>
            </p>

          <cfelse>
            <p>
              <cfif form.addresszusatz neq "">
                #form.addresszusatz#<br>
              </cfif>

              #form.firstname# #form.lastname#<br>
              #form.address#<br>
              #form.zip# #form.city#<br>
            </p>
          </cfif>

          <cfset session.delete("cart")>

          <button class="btn btn-primary mt-3" onclick="window.location.href='/shop'">Zurück zum shop</button>
        </cfif>
      </div>
    </div>
  </div>
</cfoutput>
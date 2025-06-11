<cfoutput>
  <cfset local.billing = new modules.shop.components.Billing()>
  
  <cfif structKeyExists(session, "customer")>
    <!--- the empty string gets appended beacause ther default value of the values is NULL, which means I cannot instert them into a form --->
    <cfset local.storedCustomerValues = {
      email = session.customer.getEmail() & "",
      firstname = session.customer.getFirstname() & "",
      lastname = session.customer.getLastname() & "",
    }>
  <cfelse>
    <cfset local.storedCustomerValues = {
      email = "",
      firstname = "",
      lastname = "",
    }>
  </cfif>

  <div class="container">
    <h2 class="heading-line text-primary mt-4">KASSE</h2>

    <div class="form-box">
      <div class="form-wrap">
        <cfif session.cart.getTotalQuantity() eq 0 AND isEmpty(form)>
          <h2 class="form-title">Ihr Warenkorb ist leer</h2>
          <p>Gehen Sie doch zurück zu unserem Shop und füllen Sie Ihren Warenkorb :)</p>
          <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#'">Zurück zum Shop</button>
        <cfelseif isEmpty(form)>

          <h2 class="form-title">Ihr Warenkorb</h2>
          <div class="table-responsive">
            <!--- billing table --->
            #local.billing.generateBillingTable(session.cart, session.shippingCost)#
            <cfdump var="#session.cart.getCartJson()#" label="Session Cart Articles" abort="false">
            <!--- billing table done --->

            <div class="spread">
              <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#'">Zurück zum Shop</button>
              <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#?clear=1'">Warenkorb leeren</button>
            </div>
          </div>

          <h2 class="form-title">Warenkorb bestellen</h2>
          <form onsubmit="submitOrder(this); return false;" class="form" method="POST">
            <label for="firstname">Vorname*</label>
            <input type="text" class="form-control" id="firstname" name="firstname" required value="#local.storedCustomerValues.firstname#">

            <label for="lastname">Nachname*</label>
            <input type="text" class="form-control" id="lastname" name="lastname" required value="#local.storedCustomerValues.lastname#">

            <label for="email">E-Mail*</label>
            <input type="email" class="form-control" id="email" name="email" required value="#local.storedCustomerValues.email#">

            <label for="phone">Telefon</label>
            <input type="tel" class="form-control" id="phone" name="phone">

            <label for="address">Strasse &amp; Nr.*</label>
            <input type="text" class="form-control" id="address" name="address" required value="teststrasse 1">

            <div class="form-row-2">
              <div>
                <label for="zip">PLZ*</label>
                <input type="text" class="form-control" id="zip" name="zip" required value="1234">
              </div>

              <div>
                <label for="city">Ort*</label>
                <input type="text" class="form-control" id="city" name="city" required value="Testort">
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
              <input type="text" class="form-control" id="shippingFirstname" name="shippingFirstname" value="Shipping test">

              <label for="shippingLastname">Nachname*</label>
              <input type="text" class="form-control" id="shippingLastname" name="shippingLastname" value="Shipping lastname test">

              <label for="shippingAddress">Strasse &amp; Nr.*</label>
              <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" value="Shipping teststrasse 2" >

              <div class="form-row-2">
                <div>
                  <label for="shippingZip">PLZ*</label>
                  <input type="text" class="form-control" id="shippingZip" name="shippingZip" value="5678">
                </div>

                <div>
                  <label for="shippingCity">Ort*</label>
                  <input type="text" class="form-control" id="shippingCity" name="shippingCity" value="Shipping Testort">
                </div>
              </div>

              <label for="shippingAddresszusatz">Adresszusatz</label>
              <input type="text" class="form-control" id="shippingAddresszusatz" name="shippingAddresszusatz">
            </div>

            <input type="submit" class="btn btn-primary mt-3" value="Bestellung abschicken">
          </form>
          <script> <!--- form control --->
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
          <button class="btn btn-primary mt-3" onclick="window.location.href='/?clear=1'">Zurück zum shop</button>

          <cfsilent>
            <cfset local.recipitent = m.siteConfig('contactEmail')>
            <cfset local.sender = objectParams.emailSender>

            <!--- mail to melanie --->
            <cfmail to="#local.recipitent#" from="#local.sender#" subject="#m.siteconfig('contactname')# Order #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#" type="html" server="#m.siteConfig('mailServerIP')#" port="#m.siteConfig('MailServerSMTPPort')#" username="#m.siteConfig('mailServerUserName')#" password="#m.siteConfig('mailServerPassword')#" usetls="#m.siteConfig('mailServerTLS')#">
              <cfloop collection="#form#" item="key">
                <cfif key neq "fieldnames" and key neq "alternateShippingAddress" and not isEmpty(form[key])>
                  <cfoutput>#key#: #form[key]#<br></cfoutput>
                </cfif>
              </cfloop>
              <br>
              #local.billing.generateBillingTable(session.cart, session.shippingCost)#

              <cfmailparam filename="Rechnung.pdf" file="#expandPath("modules/shop/components/pdf-bill-export/tmp")#/#session.SessionID#.pdf" disposition="attachment" contentid="pdf"> 
            </cfmail>

            <!--- mail to customer --->
            <cfmail to="#form.email#" from="#local.sender#" subject="#objectParams.emailSubjectLine#" type="html" server="#m.siteConfig('mailServerIP')#" port="#m.siteConfig('MailServerSMTPPort')#" username="#m.siteConfig('mailServerUserName')#" password="#m.siteConfig('mailServerPassword')#" usetls="#m.siteConfig('mailServerTLS')#">
              <p>Hi #form.firstname#</p>
              <p>#objectParams.emailText#</p>
              <p><b>Shippingadress:</b><br>
        
              <cfif form.shippingAddress.len()>
                <cfif form.shippingAddresszusatz neq "">
                  #form.shippingAddresszusatz#<br>
                </cfif>
                
                #form.shippingFirstname# #form.shippingLastname#<br>
                #form.shippingAddress#<br>
                #form.shippingZip# #form.shippingCity#<br></p>
        
                <p><b>Billingadress:</b><br>
        
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
              <p>#m.siteconfig('contactname')#</p>

              <cfmailparam filename="Rechnung.pdf" file="#expandPath("modules/shop/components/pdf-bill-export/tmp")#/#session.SessionID#.pdf" disposition="attachment" contentid="pdf"> 
            </cfmail>
          </cfsilent>
          
          <!--- store customer in bean --->
          <cfscript>
            new modules.shop.components.Checkout().storeOrder(form, session);
          </cfscript>
          <!--- <cfdump var="#entityLoad('shopAddress')#" abort="false"> --->
        </cfif>
      </div>
    </div>
  </div>
</cfoutput>
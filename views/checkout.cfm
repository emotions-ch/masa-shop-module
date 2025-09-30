<cfoutput>
  <cfset local.billing = new modules.shop.components.Billing()>
  <cfset local.checkout = new modules.shop.components.Checkout()>
  <cfparam name="form.alternateShippingAddress" default="">

  <div class="container checkout">
    <h2 class="heading-line text-primary mt-4">KASSE</h2>

    <div class="form-box">
      <div class="form-wrap">
        <cfif session.cart.getTotalQuantity() eq 0 AND isEmpty(form)>
          <h2 class="form-title">Ihr Warenkorb ist leer</h2>
          <p>Gehen Sie doch zurück zu unserem Shop und füllen Sie Ihren Warenkorb :)</p>
          <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#'">Zurück zum Shop</button>
        <cfelseif !structKeyExists(form, "fieldnames")>
          <cfset local.storedCustomerData = local.checkout.retriveCustomerData(session)>

          <h2 class="form-title">Ihr Warenkorb</h2>
          <div class="table-responsive">
            <!--- billing table --->
            #local.billing.generateBillingTable(session.cart)#
            <!--- billing table done --->

            <div class="spread">
              <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#'">Zurück zum Shop</button>
              <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#?cart=1'">zum Warenkorb</button>
            </div>
          </div>

          <h2 class="form-title">Warenkorb bestellen</h2>
          <form onsubmit="submitOrder(this); return false;" class="form" method="POST">
            <label for="firstname">Vorname*</label>
            <input type="text" class="form-control" id="firstname" name="firstname" required value="#local.storedCustomerData.firstname#">

            <label for="lastname">Nachname*</label>
            <input type="text" class="form-control" id="lastname" name="lastname" required value="#local.storedCustomerData.lastname#">

            <label for="email">E-Mail*</label>
            <input type="email" class="form-control" id="email" name="email" required value="#local.storedCustomerData.email#">

            <label for="phone">Telefon</label>
            <input type="tel" class="form-control" id="phone" name="phone">

            <label for="address">Strasse &amp; Nr.*</label>
            <input type="text" class="form-control" id="address" name="address" required value="#local.storedCustomerData.billingAddress.street#">

            <div class="form-row-2">
              <div>
                <label for="zip">PLZ*</label>
                <input type="text" class="form-control" id="zip" name="zip" required value="#local.storedCustomerData.billingAddress.zip#">
              </div>

              <div>
                <label for="city">Ort*</label>
                <input type="text" class="form-control" id="city" name="city" required value="#local.storedCustomerData.billingAddress.city#">
              </div>
            </div>

            <label for="addresszusatz">Adresszusatz</label>
            <input type="text" class="form-control" id="addresszusatz" name="addresszusatz">

            <div class="form-row-2" style="margin-top: 1rem;">
              <label for="alternateShippingAddress">Abweichende Lieferadresse?</label>
              <input type="checkbox" id="alternateShippingAddress" name="alternateShippingAddress" #local.storedCustomerData.shippingAddress.active#>
            </div>

						<div class="form-row-2" style="margin-top: 1rem;">
							<label for="pickup">Abholung?</label>
							<input type="checkbox" class="" id="pickup" name="pickup">
						</div>

            <div class="shipping-address">
              <h4>Lieferadresse</h4>
              <label for="shippingFirstname">Vorname*</label>
              <input type="text" class="form-control" id="shippingFirstname" name="shippingFirstname" value="#local.storedCustomerData.shippingAddress.firstname#">

              <label for="shippingLastname">Nachname*</label>
              <input type="text" class="form-control" id="shippingLastname" name="shippingLastname" value="#local.storedCustomerData.shippingAddress.lastname#">

              <label for="shippingAddress">Strasse &amp; Nr.*</label>
              <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" value="#local.storedCustomerData.shippingAddress.street#">

              <div class="form-row-2">
                <div>
                  <label for="shippingZip">PLZ*</label>
                  <input type="text" class="form-control" id="shippingZip" name="shippingZip" value="#local.storedCustomerData.shippingAddress.zip#">
                </div>

                <div>
                  <label for="shippingCity">Ort*</label>
                  <input type="text" class="form-control" id="shippingCity" name="shippingCity" value="#local.storedCustomerData.shippingAddress.city#">
                </div>
              </div>

              <label for="shippingAddresszusatz">Adresszusatz</label>
              <input type="text" class="form-control" id="shippingAddresszusatz" name="shippingAddresszusatz">
            </div>

            <div class="form-row-2" style="margin-top: 1rem;">
              <label for="agb"><a href="#objectParams.agbUrl#">AGB</a>- Terms & Conditions*</label>
							<input type="checkbox" class="" id="agb" name="accept AGB" required> 
							<p id="agbText">#objectParams.agbText#</p>
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

            var shippingCheckbox = document.getElementById('alternateShippingAddress');
            var shippingAddressDiv = document.querySelector('.shipping-address');
            if (shippingCheckbox.checked) {
              shippingAddressDiv.style.display = 'block';
              document.getElementById('shippingFirstname').required = true;
              document.getElementById('shippingLastname').required = true;
              document.getElementById('shippingAddress').required = true;
              document.getElementById('shippingZip').required = true;
              document.getElementById('shippingCity').required = true;
            } else {
              shippingAddressDiv.style.display = 'none';
            }
          </script>
        <cfelse>
          <h2 class="form-title">Bestellbestätigung</h2>
          <p>Vielen Dank für Ihre Bestellung, #form.firstname# #form.lastname#!</p>
          <cfif structKeyExists(form, "pickup") AND form.pickup EQ "on">
            <p><strong>Ihre Bestellung wird zur Abholung bereitgestellt.</strong> Sie erhalten eine separate Benachrichtigung, wann die Bestellung abholbereit ist.</p>
            <p>Rechnungsadresse:</p>
          <cfelse>
            <p>Ihre Bestellung wird an folgende Adresse geliefert:</p>
          </cfif>
          <cfif structKeyExists(form, "alternateShippingAddress") AND form.alternateShippingAddress EQ "on">
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
          <button class="btn btn-primary mt-3" onclick="window.location.href='#local.cleanRequestUrl#?clear=1'">Zurück zum shop</button>

          <cfsilent>
            <cfset local.recipitent = m.siteConfig('contactEmail')>
            <cfset local.sender = objectParams.emailSender>

            <!--- mail to melanie --->
            <cfmail to="#local.recipitent#" from="#local.sender#" subject="#m.siteconfig('contactname')# Order #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#<cfif structKeyExists(form, 'pickup') AND form.pickup EQ 'on'> - ABHOLUNG</cfif>" type="html" server="#m.siteConfig('mailServerIP')#" port="#m.siteConfig('MailServerSMTPPort')#" username="#m.siteConfig('mailServerUserName')#" password="#m.siteConfig('mailServerPassword')#" usetls="#m.siteConfig('mailServerTLS')#">
              <cfif structKeyExists(form, "pickup") AND form.pickup EQ "on">
                <p><strong>*** ABHOLUNG - Keine Lieferung erforderlich ***</strong></p>
                <br>
              </cfif>
              <cfloop collection="#form#" item="key">
                <cfif key neq "fieldnames" and key neq "alternateShippingAddress" and not isEmpty(form[key])>
                  <cfif form.alternateShippingAddress EQ "on" AND reMatchNoCase("shipping[a-zA-Z]+", key).len() EQ 1>
                    <cfoutput>#key#: #form[key]#<br></cfoutput>
                  <cfelseif NOT reMatchNoCase("shipping[a-zA-Z]+", key).len() EQ 1>
                    <cfoutput>#key#: #form[key]#<br></cfoutput>
                  </cfif>
                </cfif>
              </cfloop>
              <br>
              #local.billing.generateBillingTable(session.cart)#

              <cfmailparam filename="Rechnung.pdf" file="#expandPath("modules/shop/components/pdf-bill-export/tmp")#/#session.SessionID#.pdf" disposition="attachment" contentid="pdf"> 
            </cfmail>

            <!--- mail to customer --->
            <cfmail to="#form.email#" from="#local.sender#" subject="#objectParams.emailSubjectLine#<cfif structKeyExists(form, 'pickup') AND form.pickup EQ 'on'> - Abholung</cfif>" type="html" server="#m.siteConfig('mailServerIP')#" port="#m.siteConfig('MailServerSMTPPort')#" username="#m.siteConfig('mailServerUserName')#" password="#m.siteConfig('mailServerPassword')#" usetls="#m.siteConfig('mailServerTLS')#">
              <p>Hi #form.firstname#</p>
              <p>#objectParams.emailText#</p>
              <cfif structKeyExists(form, "pickup") AND form.pickup EQ "on">
                <p><b>ABHOLUNG:</b> Ihre Bestellung wird zur Abholung bereitgestellt. Sie erhalten eine separate Benachrichtigung, wann die Bestellung abholbereit ist.</p>
                
                <p><b>Rechnungsadresse:</b><br>
                <cfif form.addresszusatz neq "">
                  #form.addresszusatz#<br>
                </cfif>
                #form.firstname# #form.lastname#<br>
                #form.address#<br>
                #form.zip# #form.city#<br></p>
              <cfelse>
                <p><b>Lieferadresse:</b><br>

                <cfif structKeyExists(form, "alternateShippingAddress") AND form.alternateShippingAddress EQ "on">
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
              </cfif>
        
              <p><b>Artikel</b><br>
              #local.billing.generateBillingTable(session.cart)#</p>
              <p>#m.siteconfig('contactname')#</p>

              <cfmailparam filename="Rechnung.pdf" file="#expandPath("modules/shop/components/pdf-bill-export/tmp")#/#session.SessionID#.pdf" disposition="attachment" contentid="pdf"> 
            </cfmail>
          </cfsilent>
          
          <!--- store customer in bean --->
          <cfscript>
            local.checkout.storeOrder(form, session);
            session.customer = entityLoad("customer", {email=form.email})[1];
          </cfscript>
        </cfif>
      </div>
    </div>
  </div>
</cfoutput>

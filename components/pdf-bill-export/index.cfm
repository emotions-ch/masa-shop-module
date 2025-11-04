<cfset local.illegalCall = false>

<cfif !isDefined("session.cart")>
  <cfset local.illegalCall = true>
</cfif>

<cfif local.illegalCall>
  <cflocation url="/" addtoken="false">
</cfif>

<cfset local.billId = session.SessionID>
<cfset local.billing = new modules.shop.components.Billing()>
<cfset local.qrBill = new modules.shop.components.qrBill()>
<cfset variables.m = application.serviceFactory.getBean('m')>

<cfset local.creditor = local.qrBill.createAddress(
  name=session.creditor.name,
  street=session.creditor.street,
  houseNo=session.creditor.houseNo,
  postalCode=session.creditor.postalCode,
  town=session.creditor.town,
  countryCode=session.creditor.countryCode
)>
<cfset local.qrInvoice = local.billing.getQrInvoice(
  cart=session.cart,
  unstructuredMessage="Bestellung vom #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#",
  shippingCost=session.cart.getMaxShippingPrice(),
  iban=session.creditor.iban,
  creditor=local.creditor
)>

<cfif NOT directoryExists("./tmp")>
  <cfdirectory action="create" directory="./tmp">
</cfif>
<cffile action="write" file="./tmp/#local.billId#.png" output="#local.qrInvoice#" nameconflict="overwrite">

<cfsavecontent variable="local.bill">
  <cfoutput>
    <html>
      <main>
				<div id="pdf-head">
					<img class="logo" src="/modules/shop/assets/images/logo.png">
					<div id="header-pad"></div>
				</div>
        <p class="small">#session.creditor.name# / #session.creditor.street# #session.creditor.houseNo# / #session.creditor.postalCode# #session.creditor.town#</p>
        <p class="right">#session.creditor.town#, #lsDateFormat(now(), "d.m.yyyy")#</p>

        <h1>Rechnung</h1>
        <div id="payment">
          #local.billing.generateBillingTable(session.cart)#
        </div>
        
      </main>

			<div class="page-break">
				<img id="invoice" src="./tmp/#local.billId#.png" alt="QR Rechnung">
			</div>

      <style>
				<cfinclude template="./styles.css">
      </style>
    </html>
  </cfoutput>
</cfsavecontent>



<!--- DEV SHIT --->
<cfif !isDefined("url.o")>
  <cfset url.o = false>
</cfif>

<cfif url.o>
  <cfoutput>
    #local.bill#
  </cfoutput>
  <cfabort>
</cfif>
<!--- END DEV SHIT --->

<cfdocument format="PDF" pagetype="A4" filename="#ExpandPath('./tmp/#local.billId#.pdf')#" overwrite="yes" unit="cm" margin="#{top:0.5,bottom:0.5,left:0.5,right:0.5}#">
  <cfoutput>#local.bill#</cfoutput>
</cfdocument>

<cfset local.illegalCall = false>

<cfif !isDefined("session.cart")>
  <cfset local.illegalCall = true>
</cfif>

<cfif !isDefined("session.shippingCost")>
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
  name="Hundeschule FAMCANE GmbH",
  street="Dorfstrasse",
  houseNo="34",
  postalCode="6340",
  town="Baar",
  countryCode="CH"
)>
<cfset local.qrInvoice = local.billing.getQrInvoice(
  cart=session.cart,
  unstructuredMessage="Bestellung vom #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#",
  shippingCost=session.shippingCost,
  iban="CH8230787786229140905",
  creditor=local.creditor
)>

<cffile action="write" file="./tmp/#local.billId#.png" output="#local.qrInvoice#" nameconflict="overwrite">

<cfsavecontent variable="local.bill">
  <cfoutput>
    <div id="pdf-head">
      <img class="logo" src="modules/shop/assets/images/logo.png">
      <div id="header-pad"></div>
    </div>

    <main>
      <p class="small">#m.siteConfig('contactName')# / #m.siteConfig('contactAddress')# / #m.siteConfig('contactzip')# #m.siteConfig('contactCity')#</p>

      <!--- customer address --->

      <p class="right">#m.siteConfig('contactCity')#, #lsDateFormat(now(), "d.m.yyyy")#</p>

      <h1>Rechnung</h1>
      <div id="payment">
        #local.billing.generateBillingTable(session.cart, session.shippingCost)#
        <img id="invoice" src="./tmp/#local.billId#.png" alt="QR Rechnung">
      </div>
    </main>
  </cfoutput>

  <style>
    @import url('styles.css');
  </style>
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

<cfdocument format="PDF" filename="#ExpandPath('./tmp/#local.billId#.pdf')#" overwrite="yes">
  <cfoutput>#local.bill#</cfoutput>
</cfdocument>

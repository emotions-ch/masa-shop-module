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

<cfdirectory action="delete" directory="#expandPath('./tmp')#" recurse="true">
<cfdirectory action="create" directory="#expandPath('./tmp')#">

<cfset local.imgId = createUUID()>
<cfset local.billing = new modules.shop.components.Billing()>
<cfset variables.m = application.serviceFactory.getBean('m')>
<cfset local.qrInvoice = local.billing.getQrInvoice(session.cart, "Bestellung vom #lsDateTimeFormat(now(), 'dd.M.yyyy HH:nn:ss')#", session.shippingCost)>

<cffile action="write" file="./tmp/#local.imgId#.png" output="#local.qrInvoice#" nameconflict="overwrite">

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
        <img id="invoice" src="./tmp/#local.imgId#.png" alt="QR Rechnung">
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

<cfcontent type="application/pdf">
<cfdocument format="pdf" backgroundvisible="true">
  <cfoutput>#local.bill#</cfoutput>
</cfdocument>

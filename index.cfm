<cfsilent>
	<cfinclude template="objectParams.cfm">

	<!--- Url params --->
	<cfparam name="url.product" default="00000000000000000000000000000000001">
	<cfparam name="url.checkout" default="0">
	<cfparam name="url.clear" default="0">
	<cfparam name="url.login" default="0">
	<cfparam name="url.logout" default="0">
	<cfparam name="url.cart" default="0">
	<cfparam name="url.pickup" default="">
	<cfparam name="url.category" default="">

	<cfset local.contentBean = m.getBean('content').loadBy(filename=cgi.path_info.left(-1).right(-1))>
	<cfset local.cleanRequestUrl = local.contentBean.get('url')>

	<cfif url.logout eq "1">
		<cfset session.clear()>
	</cfif>

	<cfset local.modulePath = "/modules/shop">
	<cfset local.cartHandler = new components.CartHandler()>

	<cfif url.clear eq "1">
		<cfdirectory action="list" directory="#expandPath('#local.modulePath#/components/pdf-bill-export/tmp/')#" name="fileList">
		<cfloop query="fileList">
			<cfif fileList.name contains "#session.SessionID#">
				<cfset fileDelete = expandPath('#local.modulePath#/components/pdf-bill-export/tmp/' & fileList.name)>
				<cffile action="delete" file="#fileDelete#">
			</cfif>
		</cfloop>
	
		<cfset session.delete("cart")>
	</cfif>

	<cfif url.pickup neq "">
		<cfset session.cart.setIsPickup(url.pickup)>
	</cfif>

	<!--- Create creditor struct with all creditor parameters --->
	<cfset session.creditor = {
		name = objectParams.creditorName,
		street = objectParams.creditorStreet,
		houseNo = objectParams.creditorHouseNo,
		postalCode = objectParams.creditorPostalCode,
		town = objectParams.creditorTown,
		countryCode = objectParams.creditorCountryCode,
		iban = objectParams.iban
	}>
</cfsilent>

<cfoutput>
	<div id="shop-modul-object">

		<cfset local.productContent = m.getBean('content').loadBy(contentid=url.product)>

		<cfif url.product neq "" && local.productContent.get('contentid') neq "00000000000000000000000000000000001">
			<cfinclude template="views/product.cfm">
			<script src="#local.modulePath#/assets/js/product.js" defer></script>
		<cfelseif url.checkout eq "1" && arrayLen(session.cart.getArticles())>
			<cfinclude template="views/checkout.cfm">
		<cfelseif url.login eq "1">
			<cfinclude template="views/login.cfm">
		<cfelseif url.cart eq "1">
			<cfinclude template="views/cart.cfm">
		<cfelse>
			<cfinclude template="views/shop.cfm">
		</cfif> 

		<link rel="stylesheet" href="#local.modulePath#/assets/css/shop.css">
		<script src="#local.modulePath#/assets/js/jquery-3.7.1.min.js"></script>
		<script src="#local.modulePath#/assets/js/shop.js" defer></script>

		<cfif objectParams.fontawsomeKitId.len()>
			<script src="https://kit.fontawesome.com/#objectParams.fontawsomeKitId#.js" crossorigin="anonymous" defer></script>
		</cfif>

		<script>
			document.addEventListener('DOMContentLoaded', function() {
				if (typeof window.siteId === 'undefined') {
					window.siteId = '#m.content().get('siteId')#';
				}

				if (typeof Mura === 'undefined') {
					fetch('#cgi.request_url.listFirst(":")#://#cgi.http_host#/core/modules/v1/core_assets/js/mura.min.js')
						.then(response => response.text())
						.then(code => eval(code))
						.then(() => {
							Mura.init({
								siteid:window.siteId,
								rootpath:'#cgi.request_url.listFirst(":")#://#cgi.http_host#'
							});
						});
				}
			});
		</script>
	</div>
</cfoutput>

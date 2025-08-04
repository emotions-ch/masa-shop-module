<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
	<cfparam name="objectParams.creditorName" default="">
	<cfparam name="objectParams.creditorStreet" default="">
	<cfparam name="objectParams.creditorHouseNo" default="">
	<cfparam name="objectParams.creditorPostalCode" default="">
	<cfparam name="objectParams.creditorTown" default="">
	<cfparam name="objectParams.creditorCountryCode" default="CH">
	<cfparam name="objectParams.iban" default="">

	<!--- Url params --->
	<cfparam name="url.product" default="00000000000000000000000000000000001">
	<cfparam name="url.checkout" default="0">
	<cfparam name="url.clear" default="0">
	<cfparam name="url.login" default="0">
	<cfparam name="url.logout" default="0">
	<cfparam name="url.cart" default="0">

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

		<cfset local.productContent = m.content().loadBy(contentid=url.product)>

		<cfif url.product neq "" && local.productContent.get('contentid') neq "00000000000000000000000000000000001">
			<cfinclude template="views/product.cfm">
		<cfelseif url.checkout eq "1">
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
	</div>
</cfoutput>

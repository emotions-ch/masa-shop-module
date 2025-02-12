<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
	<cfset objectParams.render="server">

	<!--- Url params --->
	<cfparam name="url.product" default="00000000000000000000000000000000001">

	<cfif cgi.query_string.len()>
		<cfset local.cleanRequestUrl = left(cgi.request_url, "-" & "#cgi.query_string.len()+1#")>
	<cfelse>
		<cfset local.cleanRequestUrl = cgi.request_url>
	</cfif>

	<cfset local.modulePath = "/modules/shop">
	<cfset local.cartHandler = new components.CartHandler()>
</cfsilent>

<cfoutput>
	<cfhtmlhead>
		<script src="#local.modulePath#/assets/js/shop.js" defer></script>
		<link rel="stylesheet" href="#local.modulePath#/assets/css/shop.css">
	</cfhtmlhead>

	<div id="shop-modul-object">

		<cfset local.productContent = m.content().loadBy(contentid=url.product)>

		<cfif url.product neq "" && local.productContent.get('contentid') neq "00000000000000000000000000000000001">
			<cfinclude template="views/product.cfm">
		<cfelse>
			<cfinclude template="views/#objectParams.view#.cfm">
		</cfif> 
	</div>
</cfoutput>
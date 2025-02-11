<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
	<cfset objectParams.render="server">

	<cfset local.modulePath = "/modules/shop">
</cfsilent>

<cfoutput>
<cfhtmlhead>
	<script src="#local.modulePath#/assets/js/shop.js" defer></script>
	<link rel="stylesheet" href="#local.modulePath#/assets/css/shop.css">
</cfhtmlhead>
	
	<cfset local.cartHandler = new components.CartHandler()>
	<div>

		<!--- <cfdump var="#m.siteConfig().getAllValues()#"> --->

		<cfinclude template="views/#objectParams.view#.cfm">
	</div>
</cfoutput>
<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
	<cfset objectParams.render="server">
</cfsilent>

<cfoutput>
<cfhtmlhead><script src="/modules/shop/assets/js/cart.js" defer></script></cfhtmlhead>
	
	<cfset local.cartHandler = new components.CartHandler()>
	<div>

		<!--- <cfdump var="#m.siteConfig().getAllValues()#"> --->

		<cfinclude template="views/#objectParams.view#.cfm">
	</div>
</cfoutput>
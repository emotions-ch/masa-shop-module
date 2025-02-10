<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfset objectParams.render="server">
</cfsilent>

<cfoutput>
<cfhtmlhead><script src="/modules/shop/assets/js/cart.js" defer></script></cfhtmlhead>
	
	<cfset local.cartHandler = new components.CartHandler()>
	<div>
		<!--- <cfdump var="#objectParams#" expand="false">
		<cfdump var="#session.cart.getTotalQuantity()#">
		<cfdump var="#session.cart.getArticles()#"> --->

		<cfinclude template="views/#objectParams.view#.cfm">
	</div>
</cfoutput>
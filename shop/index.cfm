<cfsilent>
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.buttonsize" default="">
	<cfparam name="objectParams.target" default="">
	<cfparam name="objectParams.url" default="">
	<cfset objectParams.render="server">
</cfsilent>
<cfoutput>
	<cfset local.cartHandler = new components.CartHandler()>
	<div>
		<cfdump var="#objectParams#" expand="false">
		<cfdump var="#session.cart.getTotalQuantity()#">
		<cfdump var="#session.cart.getArticles()#">
	</div>
</cfoutput>
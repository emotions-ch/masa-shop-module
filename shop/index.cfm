<cfsilent>
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.buttonsize" default="">
	<cfparam name="objectParams.target" default="">
	<cfparam name="objectParams.url" default="">
	<cfset objectParams.render="server">
</cfsilent>
<cfoutput>
	<cfset local.cartHandler = new components.CartHandler()>
	<div class="masa-module-buttonUwU">
		<cfdump var="#objectParams#">
		<cfdump var="#session.cart.getArticles()#">
	</div>
</cfoutput>
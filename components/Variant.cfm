<cfscript>
	cfheader( name="Content-Type", value="application/json" );
	local.variantContent = application.serviceFactory.getBean('m').getBean('content').loadBy(contentid=url.variant,siteId=url.site)

	local.variationInfo = {
		"price":local.variantContent.get("articlePrice"),
		"amount":local.variantContent.get("articleAmount"),
		"articleNumber":local.variantContent.get("ArticleNumber"),
		"body":local.variantContent.get("body")
	};

	writeOutput( local.variationInfo.toJSON() );	
</cfscript>


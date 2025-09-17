<cfscript>
	local.variantContent = application.serviceFactory.getBean('m').getBean('content').loadBy(contentid=url.variant,siteId=url.site)

	local.variationInfo = {
		"price":local.variantContent.get("articlePrice"),
		"amount":local.variantContent.get("articleAmount"),
		"articleNumber":local.variantContent.get("ArticleNumber")
	};

	writeOutput( local.variationInfo.toJSON() );	
</cfscript>


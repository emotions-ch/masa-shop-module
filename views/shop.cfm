<cfoutput>
	<div class="container">
		<nav aria-label="breadcrumb">
			<div class="filters">
				<div class="search-filter mb-3 d-flex">
					<input type="text" id="search-input" class="form-control" placeholder="Produkte suchen..." value="#StructKeyExists(url, "search") ? HTMLEditFormat(decodeFromURL(url.search)) : ""#" onkeypress="handleSearchKeypress(event)">
					<button type="button" id="search-button" class="btn btn-primary ml-2" onclick="handleSearchClick()"><i class="fas fa-search"></i> Suchen</button>
				</div>

				<div>
					<div class="sort-filter ml-sm-auto">
						<cfset local.filterQuery = m.getBean('category').loadBy(name='shopArticleCategorys').getKidsQuery()>

						<select id="sort-select" class="form-select" onchange="handleCategoryChange(this.value)">
							<option value="" #((decodeFromURL(url.category) == "") ? "selected" : "")#>Alle Kategorien</option>
							<cfloop query="#local.filterQuery#">
								<option value="#local.filterQuery['categoryID']#" #((decodeFromURL(url.category) == local.filterQuery['categoryID']) ? "selected" : "")#>#local.filterQuery['name']#</option>
							</cfloop>
						</select>
					</div>

					<div class="sort-filter ml-sm-auto">
						<cfif CGI.query_string.length() AND !FindNoCase("sort", CGI.query_string)>
							<cfset local.paramPrefix = "?#CGI.query_string#&">
						<cfelse>
							<cfset local.paramPrefix = "?">
						</cfif>

						<cfset local.sortingArray = [
							{"direction":"","attribute":"","name":"Sortierung wählen"},
							{"direction":"asc","attribute":"name","name":"Produktname (A - Z)"},
							{"direction":"desc","attribute":"name","name":"Produktname (Z - A)"},
							{"direction":"asc","attribute":"price","name":"Produkt Preis (Niedrig → Hoch)"},
							{"direction":"desc","attribute":"price","name":"Produkt Preis (Hoch → Niedrig)"}
						]>
						
						<label for="sort-select" class="sr-only">Sortierung wählen</label>
						<select id="sort-select" class="form-select" onchange="handleSortChange(this.value, '#local.paramPrefix#')">
							<cfloop array="#local.sortingArray#" index="local.sorting">
								<cfset local.sortValue = (local.sorting.direction NEQ "" AND local.sorting.attribute NEQ "") ? encodeForURL(serializeJSON({"direction":local.sorting.direction, "attribute":local.sorting.attribute})) : "">
								<cfset local.isSelected = false>
								<cfif StructKeyExists(url, "sort")>
									<cfset local.currentSort = deserializeJSON(decodeFromURL(url.sort))>
									<cfif local.currentSort.direction EQ local.sorting.direction AND local.currentSort.attribute EQ local.sorting.attribute>
										<cfset local.isSelected = true>
									</cfif>
								<cfelseif local.sorting.direction EQ "" AND local.sorting.attribute EQ "">
									<cfset local.isSelected = true>
								</cfif>
								<option value="#local.sortValue#" <cfif local.isSelected>selected</cfif>>#local.sorting.name#</option>
							</cfloop>
						</select>
					</div>
				</div>

			</div>
			
			<div class="breadcrumb mt-3 flex-column flex-sm-row">
				<cfif StructKeyExists(session, "customer")>
					<div class="mr-sm-auto">
						<a class="btn btn-primary" href="#local.cleanRequestUrl#?logout=1">Logout</a>
					</div>
				<cfelse>
					<div class="mr-sm-auto">
						<a class="btn btn-primary" href="#local.cleanRequestUrl#?login=1">Login</a>
					</div>
				</cfif>
				
				<div class="ml-sm-auto">
					<a class="btn btn-primary" href="#local.cleanRequestUrl#?cart=1">Zum Warenkorb</a>
				</div>
			</div> <!--- breadcrumb --->
		</nav> <!--- breadcrumb --->

		<cfif url.category NEQ "" AND StructKeyExists(url, "search") AND url.search NEQ "">
			<!--- category filter & search --->
			<cfset local.articleIterator = m.getFeed("content")
				.where()
				.prop("tContent.parentId")
				.isEQ(m.content().get("contentId"))
				.addJoin(
					jointype="inner",
					table="tContentCategoryAssign",
					clause="tContent.contentHistId=tContentCategoryAssign.contentHistId")
				.prop("tContentCategoryAssign.categoryId")
				.isEQ(url.category)
				.andOpenGrouping()
				.prop("tContent.title")
				.containsValue(decodeFromURL(url.search))
				.orProp("tContent.summary")
				.containsValue(decodeFromURL(url.search))
				.closeGrouping()
				.getIterator(liveonly=false)
			>
		<cfelseif url.category NEQ "">
			<!--- just category filter --->
			<cfset local.articleIterator = m.getFeed("content")
				.where()
				.prop("tContent.parentId")
				.isEQ(m.content().get("contentId"))
				.addJoin(
					jointype="inner",
					table="tContentCategoryAssign",
					clause="tContent.contentHistId=tContentCategoryAssign.contentHistId")
				.prop("tContentCategoryAssign.categoryId")
				.isEQ(url.category)
				.getIterator(liveonly=false)
			>
		<cfelseif StructKeyExists(url, "search") AND url.search NEQ "">
			<!--- just a search --->
			<cfset local.articleIterator = m.getFeed("content")
				.where()
				.prop("tContent.parentId")
				.isEQ(m.content().get("contentId"))
				.andOpenGrouping()
				.prop("tContent.title")
				.containsValue(decodeFromURL(url.search))
				.orProp("tContent.summary")
				.containsValue(decodeFromURL(url.search))
				.closeGrouping()
				.getIterator(liveonly=false)
			>
		<cfelse>
			<cfset local.articleIterator = local.contentBean.getKidsIterator(liveonly=false)>
		</cfif>
		<cfset local.articleIterator.setNextN(0)>

		<cfset local.columns = "contentid,name,summary,price,amount,image,url,hasVariants,hasVariantPricing">
		<cfset local.articles = QueryNew(local.columns)>
		<cfloop condition="local.articleIterator.hasNext()">
			<cfset local.article = local.articleIterator.next()>
			<cfset local.article.hasVariants = false>
			<cfset local.article.hasVariantPricing = false>

			<cfset local.article.kidsIterator = local.article.getKidsIterator()>
			<cfif local.article.kidsIterator.hasNext()>
				<cfloop condition=local.article.kidsIterator.hasNext()>
					<cfset local.variationContent = local.article.kidsIterator.next()>
					<cfset local.variantsContentKidsIterator = local.variationContent.getKidsIterator()>
					<cfif local.variantsContentKidsIterator.hasNext()>
						<cfset local.article.hasVariants = true>
						<cfset local.price = local.article.get('articlePrice')>

						<cfloop condition="#local.variantsContentKidsIterator.hasNext() AND (local.variationContent.get('subtype') EQ 'Variations')#">
							<cfset local.variantsContentKid = local.variantsContentKidsIterator.next()>
							<cfif local.variantsContentKid.get('articlePrice') NEQ local.price>
								<cfset local.article.hasVariantPricing = true>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>

			<cfif local.article.get("display")>
				<cfset queryAddRow(local.articles, {
					"contentid":local.article.get("contentid"),
					"name":local.article.get("title"),
					"summary":local.article.get("summary"),
					"price":local.article.get("articlePrice"),
					"amount":local.article.get("articleAmount"),
					"image":local.article.getImageUrl("shop"),
					"url":"?product=#local.article.get("contentid")#",
					"hasVariants":local.article.hasVariants,
					"hasVariantPricing":local.article.hasVariantPricing
				})>
			</cfif>
		</cfloop>

		<cfif StructKeyExists(url, "sort")>
			<cfset local.filter = deserializeJSON(decodeFromURL(url.sort))>
			<cfif ListFind(local.columns, local.filter.attribute) AND (local.filter.direction EQ "asc" OR local.filter.direction EQ "desc")>
				<cfset local.articles.sort("#local.filter["attribute"]#","#local.filter["direction"]#")>
			</cfif>
		</cfif>

		<div class="product-list grid-container" style="--grid-column-count: 3; --grid-item--min-width: 280px;">
			<cfloop query="local.articles">
				<!--- Product start --->
				<div class="product" id="#local.articles["contentid"]#">
					<div class="product-image">
						<a href="#local.articles["url"]#">
							<img class="img-fluid d-block mx-auto" src="#local.articles['image']#" alt=""></img>
						</a>
					</div>

					<div class="product-info">
						<div>
							<h4 class="product-name text-uppercase">
								<a href="#local.articles["url"]#">#local.articles["name"]#</a>
							</h4>
							<cfif local.articles["amount"].len()>
								<p class="product-size">
									<small>Menge: #local.articles["amount"]#</small>
								</p>
							</cfif>
							<p class="product-description">
								<small>
									#local.articles["summary"]#
								</small>
							</p>
						</div>
						<p class="product-price">
							<cfif condition=isNumeric(local.articles["price"])>
								<span>#((local.articles["hasVariantPricing"]) ? "Ab ":"")#CHF #NumberFormat(local.articles["price"] ,'.00')#</span>
							<cfelse>
								<span>CHF #local.articles["price"]#</span>
							</cfif>	
						</p>
					</div>

					<div class="product-action d-flex align-items-center mt-auto">
						<cfif NOT local.articles["hasVariants"]>
							<div class="quantity">
								<input type="number" class="form-control" value="1" min="1" max="99">
							</div> <!-- quantity -->
							<button type="button" class="article-to-cart form-control" article-id="#local.articles['contentId']#">In den Warenkorb</button>
						<cfelse>
							<button type="button" class="form-control" onclick="window.location.href='?product=#local.articles["contentid"]#'">Variante ausw&auml;hlen</button>
						</cfif>
					</div> <!-- product-action -->
				</div> <!-- product -->
				<!--- product end --->
			</cfloop>
		</div> <!-- product-list -->
	</div>
</cfoutput>

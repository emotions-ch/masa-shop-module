<cfoutput>
	<div class="container">
		<nav aria-label="breadcrumb">
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

				<!--- <div class="dropdown">
					<button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
						Kategorie
					</button>

					<!--- the ID's used in this array to define categorys, are masa category ID's that product's can be assigned to--->
					<cfset local.filterArray = [
						{"category":"C1D25879-9502-4F30-9100D3B85202E46E", "name":"Bekleidung Mensch"},
						{"category":"4AABA5AB-303A-4EAA-97D83CA750E571BC", "name":"Geschirr"},
						{"category":"97E9C0C6-9F94-449E-AC6B9EB261E71645", "name":"Hundefutter"},
						{"category":"721AE871-B6E9-481A-B24E146168EE389B", "name":"Leinen"},
						{"category":"DACF4173-9E34-407E-9DAE2A53CDA8B326", "name":"Snacks/belohnung"},
						{"category":"04BE8F1A-A051-4C4E-A859B222B5CB0049", "name":"Spielzeug"}
					]>

					<div class="dropdown-menu">
						<cfloop array="#local.filterArray#" index="local.filter">
							<a class="dropdown-item" href="?category=#local.filter.category#">#local.filter.name#</a>
						</cfloop>
					</div>
				</div> <!-- dropdown -->

				<div class="dropdown ml-sm-auto">
					<button class="btn btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
						Sort
					</button>
					<cfif CGI.query_string.length() AND !FindNoCase("sort", CGI.query_string)>
						<cfset local.paramPrefix = "?#CGI.query_string#&">
					<cfelse>
						<cfset local.paramPrefix = "?">
					</cfif>

					<cfset local.sortingArray = [
						{"direction":"asc","attribute":"name","name":"Produktname (A - Z)"},
						{"direction":"desc","attribute":"name","name":"Produktname (Z - A)"},
						{"direction":"asc","attribute":"price","name":"Produkt Preis (Niedrig  Hoch)"},
						{"direction":"desc","attribute":"price","name":"Produkt Preis (Hoch  Niedrig)"}
					]>
					<div class="dropdown-menu">
						<cfloop array="#local.sortingArray#" index="local.sorting">
							<a class="dropdown-item" href="#local.paramPrefix#sort=#encodeForURL(serializeJSON(local.sorting))#">#local.sorting.name#</a>
						</cfloop>
					</div>

				</div> <!-- dropdown --> --->
				
				<div class="ml-sm-auto">
					<a class="btn btn-primary" href="#local.cleanRequestUrl#?cart=1">Zum Warenkorb</a>
				</div>
			</div> <!-- breadcrumb -->
		</nav> <!-- breadcrumb -->

		<cfif StructKeyExists(url, "category")>
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
		<cfelse>
			<cfset local.articleIterator = local.contentBean.getKidsIterator(liveonly=false)>
		</cfif>
		<cfset local.articleIterator.setNextN(0)>

		<cfset local.columns = "contentid,name,summary,price,amount,image,url,hasVariants">
		<cfset local.articles = QueryNew(local.columns)>
		<cfloop condition="local.articleIterator.hasNext()">
			<cfset local.article = local.articleIterator.next()>
			<cfset local.article.hasVariants = false>

			<cfset local.article.kidsIterator = local.article.getKidsIterator()>
			<cfif local.article.kidsIterator.hasNext()>
				<cfloop condition=local.article.kidsIterator.hasNext()>
					<cfset local.variationContent = local.article.kidsIterator.next()>
					<cfset local.variantsContentKidsIterator = local.variationContent.getKidsIterator()>
					<cfif local.variantsContentKidsIterator.hasNext()>
						<cfset local.article.hasVariants = true>
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
					"url":local.article.get("url"),
					"hasVariants":local.article.hasVariants
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
			<cfloop query = "local.articles">
				<!--- Product start --->
				<div class="product" id="#local.articles["contentid"]#">
					<div class="product-image">
						<a href="?product=#local.articles["contentid"]#">
							<img class="img-fluid d-block mx-auto" src="#local.articles['image']#" alt=""></img>
						</a>
					</div>

					<div class="product-info">
						<div>
							<h4 class="product-name text-uppercase">
								<a href="?product=#local.articles["contentid"]#">#local.articles["name"]#</a>
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
								<span>CHF #NumberFormat(local.articles["price"] ,'.00')#</span>
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

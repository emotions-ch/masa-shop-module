<!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.view" default="">
</cfsilent>

<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label class="mura-control-label">View</label>
				<select id="view" name="view" class="objectParam" value="#esapiEncode('html_attr',objectparams.view)#">
					<option value="shop">Shop</option>
					<option value="checkout">Checkout</option>
					<!--- <option value="_new">New Page</option> --->
				</select>
			</div>
		</div>
	</div>
</cfoutput>
</cf_objectconfigurator>

<!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
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

			<div class="mura-control-group">
				<label class="mura-control-label">Email Sender</label>
				<input type="text" id="emailSender" name="emailSender" class="objectParam" value="#esapiEncode('html_attr',objectparams.emailSender)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Subject Line</label>
				<input type="text" id="emailSubjectLine" name="emailSubjectLine" class="objectParam" value="#esapiEncode('html_attr',objectparams.emailSubjectLine)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Email Text</label>
				<textarea id="emailText" name="emailText" class="objectParam" required>#esapiEncode('html',objectparams.emailText)#</textarea>
			</div>
		</div>
	</div>
</cfoutput>
</cf_objectconfigurator>

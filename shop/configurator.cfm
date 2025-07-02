<!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.view" default="shop">
	<cfparam name="objectParams.emailSender" default="">
	<cfparam name="objectParams.emailSubjectLine" default="Order confirmation">
	<cfparam name="objectParams.emailText" default="">
	<cfparam name="objectParams.creditorName" default="">
	<cfparam name="objectParams.creditorStreet" default="">
	<cfparam name="objectParams.creditorHouseNo" default="">
	<cfparam name="objectParams.creditorPostalCode" default="">
	<cfparam name="objectParams.creditorTown" default="">
	<cfparam name="objectParams.creditorCountryCode" default="CH">
	<cfparam name="objectParams.iban" default="">
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

			<p>Payment info</p>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor Name</label>
				<input type="text" id="creditorName" name="creditorName" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorName)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor Street</label>
				<input type="text" id="creditorStreet" name="creditorStreet" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorStreet)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor House No</label>
				<input type="text" id="creditorHouseNo" name="creditorHouseNo" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorHouseNo)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor Postal Code</label>
				<input type="text" id="creditorPostalCode" name="creditorPostalCode" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorPostalCode)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor Town</label>
				<input type="text" id="creditorTown" name="creditorTown" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorTown)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">Creditor Country Code</label>
				<input type="text" id="creditorCountryCode" name="creditorCountryCode" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorCountryCode)#" required></input>
			</div>

			<div class="mura-control-group">
				<label class="mura-control-label">IBAN</label>
				<input type="text" id="iban" name="iban" class="objectParam" value="#esapiEncode('html_attr',objectparams.iban)#" required></input>
			</div>
		</div>
	</div>
</cfoutput>
</cf_objectconfigurator>

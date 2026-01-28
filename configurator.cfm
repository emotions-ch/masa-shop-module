<!--- license goes here --->
<cfsilent>
	<cfinclude template="objectParams.cfm">
</cfsilent>


<cf_objectconfigurator params="#objectParams#">
	<cfoutput>
		<div>
			<div class="mura-layout-row">
				<div class="mura-control-group">
					<label class="mura-control-label">Email Sender</label>
					<input type="text" id="emailSender" name="emailSender" class="objectParam" value="#esapiEncode('html_attr',objectparams.emailSender)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Betreff</label>
					<input type="text" id="emailSubjectLine" name="emailSubjectLine" class="objectParam" value="#esapiEncode('html_attr',objectparams.emailSubjectLine)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Email Text</label>
					<textarea id="emailText" name="emailText" class="objectParam" required>#esapiEncode('html',objectparams.emailText)#</textarea>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">AGB link</label>
					<input type="text"id="agbUrl" name="agbUrl" class="objectParam" required value="#esapiEncode('html',objectparams.agbUrl)#"></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">AGB Text</label>
					<textarea id="agbText" name="agbText" class="objectParam" required>#esapiEncode('html',objectparams.agbText)#</textarea>
				</div>

				<h2>Payment info</h2>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor Name</label>
					<input type="text" id="creditorName" name="creditorName" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorName)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor Strasse</label>
					<input type="text" id="creditorStreet" name="creditorStreet" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorStreet)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor Hausnummer</label>
					<input type="text" id="creditorHouseNo" name="creditorHouseNo" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorHouseNo)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor Postleitzahl</label>
					<input type="text" id="creditorPostalCode" name="creditorPostalCode" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorPostalCode)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor Stadt</label>
					<input type="text" id="creditorTown" name="creditorTown" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorTown)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">Kreditor lämdercode (CH)</label>
					<input type="text" id="creditorCountryCode" name="creditorCountryCode" class="objectParam" value="#esapiEncode('html_attr',objectparams.creditorCountryCode)#" required></input>
				</div>

				<div class="mura-control-group">
					<label class="mura-control-label">IBAN</label>
					<input type="text" id="iban" name="iban" class="objectParam" value="#esapiEncode('html_attr',objectparams.iban)#" required></input>
				</div>

				<h2>Advanced </h2>
				<p>(don`t touch if you don`t know what your`re doing!)</p>

				<div class="mura-control-group">
					<label class="mura-control-label">FontAwesome Kit Id</label>
					<input type="text" id="fontawsomeKitId" name="fontawsomeKitId" class="objectParam" value="#esapiEncode('html_attr',objectparams.fontawsomeKitId)#" required></input>
				</div>

				<a href="/modules/shop/docs/userDocumentation.html" target="_blank">Dokumentation</a>
			</div>
		</div>
	</cfoutput>
</cf_objectconfigurator>


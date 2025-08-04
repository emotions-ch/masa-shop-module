component extends='core.mura.cfobject' {


	public void function onApplicationLoad() {
		//  ==================== START PAGE / default ====================
		// WriteDump(var=variables, abort=true);
		local.subType = application.configBean.getClassExtensionManager().getSubTypeBean();
		local.subType.setType('Page');
		local.subType.setSubtype('Shop');
		local.subType.setSiteId('#m.siteConfig("siteId")#');
		local.subType.load();

		local.subType.setIconClass('mi-cart-plus');
		local.subType.setAvailableSubtypes('Page/Article');
		local.subType.setHasAssocFile(0);
		local.subType.setHasSummary(1);
		local.subType.setHasBody(0);
		local.subType.setBaseTable('tcontent');
		local.subType.setBaseKeyField('contentHistId');
		local.subType.save();
	}
}

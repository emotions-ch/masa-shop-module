component extends='core.mura.cfobject' {


	public void function onApplicationLoad() {
		//  ==================== START PAGE / default ====================
		local.subType = application.configBean.getClassExtensionManager().getSubTypeBean();
		local.subType.setType('Page');
		local.subType.setSubtype('ArticleVariation');
		local.subType.setSiteId('#m.siteConfig("siteId")#');
		local.subType.load();

		local.subType.setIconClass('mi-dropbox');
		local.subType.setHasAssocFile(1);
		local.subType.setHasSummary(1);
		local.subType.setHasBody(1);
		local.subType.setAvailableSubtypes('Page/FiggDiniMuetter');
		local.subType.setBaseTable('tcontent');
		local.subType.setBaseKeyField('contentHistId');
		local.subType.save();

		//  EXTENDED ATTRIBUTES SET 1
		local.extendSet = local.subType.getExtendSetByName('ArticleVariation');
		local.extendSet.setContainer('Basic');
		local.extendSet.setOrderNo(1);
		local.extendSet.save()

			local.orderNo = 1;
			local.attribute = local.extendSet.getAttributeByName('articleAmount');
			local.attribute.setLabel('Menge');
			local.attribute.setType('textbox');
			local.attribute.setRequired(false);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();

			local.orderNo += 1;
			local.attribute = local.extendSet.getAttributeByName('articlePrice');
			local.attribute.setLabel('Preis');
			local.attribute.setType('textbox');
			local.attribute.setRequired(false);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();

			local.orderNo += 1;
			local.attribute = local.extendSet.getAttributeByName('articleNumber');
			local.attribute.setLabel('Arikelnummer');
			local.attribute.setType('textbox');
			local.attribute.setRequired(false);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();
	}
}

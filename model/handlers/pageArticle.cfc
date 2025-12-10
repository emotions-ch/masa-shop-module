component extends='core.mura.cfobject' {


	public void function onApplicationLoad() {
		//  ==================== START PAGE / default ====================
		local.subType = application.configBean.getClassExtensionManager().getSubTypeBean();
		local.subType.setType('Page');
		local.subType.setSubtype('Article');
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
		local.extendSet = local.subType.getExtendSetByName('Article');
		local.extendSet.setContainer('Basic');
		local.extendSet.setOrderNo(1);
		local.extendSet.save();

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
			local.attribute.setRequired(true);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();

			local.orderNo += 1;
			local.attribute = local.extendSet.getAttributeByName('articleNumber');
			local.attribute.setLabel('Arikelnummer');
			local.attribute.setType('textbox');
			local.attribute.setRequired(true);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();

			local.orderNo += 1;
			local.attribute = local.extendSet.getAttributeByName('shippingCostCategory');
			local.attribute.setLabel('Versandkosten Kategorie');
			local.attribute.setType('RadioGroup');
			local.attribute.setOptionList("2^8.5^11.5^20.5");
			local.attribute.setOptionLabelList("Grossbrief (B4, <1000g)^Standardpaket (<2kg)^Standardpaket (<10kg)^Standardpaket (<30kg)");
			local.attribute.setRequired(true);
			local.attribute.setOrderNo(local.orderNo);
			local.attribute.save();
	}

	public void function onBeforePageArticleSave(m) {
		arguments.m.content().setValue("isNav", 0);
		request.pageArticleIsNew = arguments.m.content().getIsNew();
	}

	public void function onAfterPageArticleSave() {
		cfparam(name="request.pageArticleIsNew", default="false");
		if (StructKeyExists(form, 'contentId') && request.pageArticleIsNew) {
			local.content = m.getBean('content').loadBy(siteid=m.event('siteid'));
			local.content.setTitle('Variationen');
			local.content.setSiteId(m.event('siteid'));
			local.content.setType('Folder');
			local.content.setSubtype('Variations');
			local.content.setParentId(form.contentId);
			local.content.setDisplay(1);
			local.content.setApproved(1);

			local.content.save();

			local.content = m.getBean('content').loadBy(siteid=m.event('siteid'));
			local.content.setTitle('Farben');
			local.content.setSiteId(m.event('siteid'));
			local.content.setType('Folder');
			local.content.setSubtype('Images');
			local.content.setParentId(form.contentId);
			local.content.setDisplay(1);
			local.content.setApproved(1);

			local.content.save();
		}
	}
}

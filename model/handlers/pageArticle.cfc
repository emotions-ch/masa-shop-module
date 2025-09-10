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
	}

	public void function onBeforePageArticleSave() {
		request.isNew = m.getBean('content').loadBy(contentId = form.contentId).getIsNew();
	}

	public void function onAfterPageArticleSave() {
		cfparam(name="request.isNew", default="false");
		cfparam(name="request.onAfterPageArticleSave", default="true");
		if (request.onAfterPageArticleSave && StructKeyExists(form, 'contentId') && request.isNew) {
			request.onAfterPageArticleSave = "false";
			local.content = m.getBean('content').loadBy(siteid=m.event('siteid'));
			local.content.setTitle('Variationen');
			local.content.setSiteId(m.event('siteid'));
			local.content.setType('Folder');
			local.content.setSubtype('Variations');
			local.content.setParentId(form.contentId);

			local.content.save();

			local.content = m.getBean('content').loadBy(siteid=m.event('siteid'));
			local.content.setSiteId(m.event('siteid'));
			local.content.setTitle('Farben');
			local.content.setType('Folder');
			local.content.setSubtype('Images');
			local.content.setParentId(form.contentId);

			local.content.save();
		}
	}
}

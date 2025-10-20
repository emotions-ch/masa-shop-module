component extends='core.mura.cfobject' {

	public void function onApplicationLoad() {
		local.categoryBean = m.getBean('category').loadBy(name='shopArticleCategorys', siteID=m.siteConfig().getSiteId());
		if (local.categoryBean.get('isnew')) {
			local.categoryBean.setName('shopArticleCategorys');
			local.categoryBean.set('isfeatureable', false);
			local.categoryBean.set('isinterestgroup', false);
			local.categoryBean.set('isopen', false);
			local.categoryBean.save();
		}
	}
}

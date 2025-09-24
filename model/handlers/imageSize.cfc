component extends='core.mura.cfobject' {

	public void function onApplicationLoad() {
		var local.image = m.getBean('imageSize').loadBy(name="shop", siteID=m.siteConfig().getSiteId());
		if (!local.image.exists()) {
			local.image.setHeight(270);
			local.image.setName("shop");
			local.image.save();
		}
	}
}

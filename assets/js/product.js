document.addEventListener('DOMContentLoaded', function() {

	document.querySelectorAll('select[id^="productVariation-"]').forEach(function(select) {
		select.addEventListener('change', function(event) {
			let selectedOption = event.target.selectedOptions[0];
			let cType = selectedOption.getAttribute('cType');

			if (cType === "File/Default") {
				// Async image loader
				Mura.getEntity('content').loadBy('contentid', event.target.value)
					.then(function(item){
						let image = item.get('images').source;
						document.getElementById('product-image').style.backgroundImage = 'url(' + image + ')';
				});
			} else if (cType === "Page/ArticleVariation") {
				// async info
				let url = `/modules/shop/components/Variant.cfm?variant=${event.target.value}&site=${siteId}`
				fetch(url)
					.then(response => response.json())
					.then(data => {

						if (data.price !== "") {
							document.getElementById('price').innerHTML = `CHF ${data.price}`;
						}
						if (data.amount !== "") {
							document.getElementById('amount').innerHTML = `Menge: ${data.amount}`;
						}
					})
					.catch(error => {
						console.error('Error fetching variation info:', error);
					});
			}
		});
	});
});


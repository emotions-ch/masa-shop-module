document.addEventListener('DOMContentLoaded', function() {

	document.querySelectorAll('select[id^="productVariation-"]').forEach(function(select) {
		select.addEventListener('change', function(event) {
			let selectedOption = event.target.selectedOptions[0];
			let cType = selectedOption.getAttribute('cType');

			// Async image loader
			if (cType === "File/Default") {
				Mura.getEntity('content').loadBy('contentid', event.target.value)
					.then(function(item){
						let image = item.get('images').source;
						document.getElementById('product-image').style.backgroundImage = 'url(' + image + ')';
				});	
			}
		});
	});
});


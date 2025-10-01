// jquery ready
$(function () {

  console.log('cart.js loaded');

  /**
   * add article to cart
   */
  $('.product-action .article-to-cart').on('click', function (e) {
    e.preventDefault();
    let locked;

    if (!locked) {
      locked = true; // Lock to prevent multiple clicks
      let variations = document.querySelectorAll('select[id^="productVariation-"]');
      let variationValues = {};
      Array.from(variations).forEach(v => {
				let selectedOption = v.selectedOptions[0];
				let cType = selectedOption.getAttribute('cType');
        variationValues[cType] = v.value;
      });
			variationValues = JSON.stringify(variationValues);

      addToCart($(this), variationValues);

      var originalText = $(this).html();
      var originalWidth = $(this).outerWidth();

      $(this).html('<span class="checkmark">&#10004;</span>').css({'background-color':'green','color':'white', 'width': originalWidth + "px"});
      setTimeout(() => {
      $(this).html(originalText).css({'background-color':'','color':'', 'width': ''});
      }, 2000);
      locked = false; // Unlock after the operation
    }
  });

  // vietnam template
  //=== SHOP ===//
  var quantity = $('.quantity');
  quantity.each(function () {
    var spinner = $(this),
      input = spinner.find('input[type="text"]'),
      btnUp = spinner.find('.plus'),
      btnDown = spinner.find('.minus'),
      min = input.attr('min'),
      max = input.attr('max');

    btnUp.click(function () {
      var oldValue = parseFloat(input.val());
      if (oldValue >= max) {
        var newVal = oldValue;
      } else {
        var newVal = oldValue + 1;
      }
      spinner.find("input").val(newVal);
      spinner.find("input").trigger("change");
    });

    btnDown.click(function () {
      var oldValue = parseFloat(input.val());
      if (oldValue <= min) {
        var newVal = oldValue;
      } else {
        var newVal = oldValue - 1;
      }
      spinner.find("input").val(newVal);
      spinner.find("input").trigger("change");
    });

    // Allow only number in range min - max
    // if invalid, set value = min
    input.on('change', function () {
      var val = $(this).val();

      if (val > max) {
        $(this).val(max);
      } else
      if (val < min) {
        $(this).val(min);
      } else

      if (val == '' || isNaN(val)) {
        $(this).val(min);
      }
    });
  });

  // Scroll breadcrumb to item active
  var breadcrumb_scroll = $('.breadcrumb-scroll');
  var breadcrumb = breadcrumb_scroll.find('.breadcrumb');
  if (breadcrumb.length) {
    breadcrumb_scroll.animate({
      scrollLeft: breadcrumb.find('.active').offset().left
    }, 0);
  }

  // Handle pickup checkbox changes
  $('#pickup').on('change', function() {
    saveFormDataToLocalStorage();

    var url = new URL(window.location);
    if ($(this).is(':checked')) {
      url.searchParams.set('pickup', '1');
    } else {
      url.searchParams.set('pickup', '0');
    }
    window.location.href = url.toString();
  });

  // Set pickup checkbox based on URL parameter (after event handler is bound)
  var urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('pickup') === '1') {
    $('#pickup').prop('checked', true);
  }

  restoreFormDataFromLocalStorage();
  setupCheckboxMutualExclusion();
});

function addToCart(article, variations) {
  let quantity = article.closest('.product-action').find('.quantity input').val();
  let articleId = article.attr('article-id');
  let set = article.attr('setter') || '0';
	let variationParam = encodeURIComponent(variations);

  let url = `?ajax=updateCart&articleId=${articleId}&quantity=${quantity}&set=${set}&variants=${variationParam}`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function () {
      console.log("Article added to cart: " + articleId);
    },
  });
}

/**
 * @function updateCart
 * Updates the cart viw & object total price and item total price when quantity changes.
 * @param {*} input 
 * @param {*} price 
 */
function updateCart(input, price, variant) {
  const quantity = $(input).val();
  const totalPrice = (parseFloat(price) * parseInt(quantity)).toFixed(2);
  $(input).closest('.article').find('#total-item-price').text('CHF ' + totalPrice);

  const articles = document.querySelectorAll('.article');
  let cartTotal = 0;

  articles.forEach(article => {
    const itemTotalText = article.querySelector('#total-item-price').textContent;
    const itemTotal = parseFloat(itemTotalText.replace('CHF ', ''));
    cartTotal += itemTotal;
  });
  document.querySelector('.total-price').textContent = 'Gesamtpreis: CHF ' + cartTotal.toFixed(2);

  addToCart($(input), variant);
}

function removeFromCart(articleId, variant) {
  if (!confirm('Are you sure you want to remove this item from your cart?')) {
    return;
  }

	let variationParam = encodeURIComponent(variant);
  
  var url = `?ajax=updateCart&articleId=${articleId}&quantity=0&variants=${variationParam}`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function () {
      document.querySelector('.article[article-id="' + articleId + '"][variant="' + variant + '"]').remove();
    },
  });
}

function getJsonFromBody(data) {
  var parser = new DOMParser();
  var doc = parser.parseFromString(data, 'text/html');
  data = doc.getElementsByTagName("body")[0].innerHTML;

  return data;
}

async function submitOrder(f) {
  await fetch('/modules/shop/components/pdf-bill-export/index.cfm', {
    method: 'POST',
    body: new FormData(f),
  })
  .then(data => {
    console.log('Success:', data);
    // Clear localStorage on successful submission
    clearCheckoutFormData();
    f.submit();
  })
  .catch((error) => {
    console.error('Error:', error);
    alert('Es ist ein Fehler aufgetreten. Bitte überprüfen Sie ihre Angaben versuchen Sie es erneut.');
  });
}

/**
 * Save checkout form data to localStorage
 */
function saveFormDataToLocalStorage() {
  const form = document.querySelector('.checkout form');
  if (!form) return;

  const formData = {};
  const inputs = form.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"], input[type="checkbox"]');

  inputs.forEach(input => {
    if (input.type === 'checkbox') {
      formData[input.name] = input.checked;
    } else {
      formData[input.name] = input.value;
    }
  });

  localStorage.setItem('checkoutFormData', JSON.stringify(formData));
  console.log('Form data saved to localStorage');
}

/**
 * Restore checkout form data from localStorage
 */
function restoreFormDataFromLocalStorage() {
  const savedData = localStorage.getItem('checkoutFormData');
  if (!savedData) return;

  try {
    const formData = JSON.parse(savedData);
    const form = document.querySelector('.checkout form');
    if (!form) return;

    Object.keys(formData).forEach(fieldName => {
      const field = form.querySelector(`[name="${fieldName}"]`);
      if (field) {
        if (field.type === 'checkbox') {
          field.checked = formData[fieldName];
          // Don't trigger change event for pickup checkbox to avoid reload loop
          // Only trigger change event for other checkboxes that need UI updates
          if (fieldName !== 'pickup') {
            field.dispatchEvent(new Event('change'));
          }
        } else {
          field.value = formData[fieldName];
        }
      }
    });

    console.log('Form data restored from localStorage');
  } catch (error) {
    console.error('Error restoring form data:', error);
    clearCheckoutFormData();
  }
}

/**
 * Clear checkout form data from localStorage
 */
function clearCheckoutFormData() {
  localStorage.removeItem('checkoutFormData');
  console.log('Checkout form data cleared from localStorage');
}

/**
 * Setup mutual exclusion between pickup and alternate shipping address checkboxes
 */
function setupCheckboxMutualExclusion() {
  const pickupCheckbox = $('#pickup');
  const alternateShippingCheckbox = $('#alternateShippingAddress');
  const pickupRow = pickupCheckbox.closest('.form-row-2');
  const alternateShippingRow = alternateShippingCheckbox.closest('.form-row-2');

  // Initial state check
  updateCheckboxVisibility();

  // Handle alternate shipping address changes
  alternateShippingCheckbox.on('change', function() {
    if ($(this).is(':checked')) {
      pickupRow.hide();
      pickupCheckbox.prop('checked', false);
    } else {
      pickupRow.show();
    }
  });

  // Handle pickup changes (but don't trigger reload for visibility changes)
  pickupCheckbox.on('change', function() {
    if ($(this).is(':checked')) {
      alternateShippingRow.hide();
      alternateShippingCheckbox.prop('checked', false);
      alternateShippingCheckbox.trigger('change');
    } else {
      alternateShippingRow.show();
    }
  });

  function updateCheckboxVisibility() {
    if (pickupCheckbox.is(':checked')) {
      alternateShippingRow.hide();
    } else if (alternateShippingCheckbox.is(':checked')) {
      pickupRow.hide();
    }
  }
}

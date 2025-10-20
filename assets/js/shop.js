
/**
 * Handles sort dropdown changes and redirects to sorted page
 * @param {string} sortValue - The encoded sort parameters
 * @param {string} paramPrefix - URL prefix with existing parameters
 */
function handleSortChange(sortValue, paramPrefix) {
  if (sortValue === "") {
    // Remove sort parameter if "default" is selected
    let url = new URL(window.location);
    url.searchParams.delete('sort');
    window.location.href = url.toString();
  } else {
    window.location.href = paramPrefix + 'sort=' + sortValue;
  }
}

/**
 * Validates variation selections and updates UI accordingly
 */
function validateVariations() {
  let variations = document.querySelectorAll('select[id^="productVariation-"]');
  let addToCartButton = document.querySelector('.product-action .article-to-cart');
  
  if (variations.length === 0) {
    // No variations, button should be enabled
    if (addToCartButton) {
      addToCartButton.classList.remove('disabled');
    }
    return true;
  }
  
  let hasEmptyVariation = false;
  Array.from(variations).forEach(v => {
    if (v.value === "" || v.value === null) {
      hasEmptyVariation = true;
      v.classList.add('is-invalid');
    } else {
      v.classList.remove('is-invalid');
    }
  });
  
  if (addToCartButton) {
    if (hasEmptyVariation) {
      addToCartButton.classList.add('disabled');
    } else {
      addToCartButton.classList.remove('disabled');
    }
  }
  
  return !hasEmptyVariation;
}

// jquery ready
$(function () {

  console.log('cart.js loaded');

  // Initial validation on page load
  validateVariations();

  // Add change event listeners to all variation dropdowns
  document.querySelectorAll('select[id^="productVariation-"]').forEach(function(select) {
    select.addEventListener('change', validateVariations);
  });

  /**
   * add article to cart
   */
  $('.product-action .article-to-cart').on('click', function (e) {
    e.preventDefault();
    let locked;

    // Check if button is disabled
    if ($(this).hasClass('disabled')) {
      return;
    }

    if (!locked) {
      locked = true; // Lock to prevent multiple clicks
      
      // Final validation check
      if (!validateVariations()) {
        alert('Bitte wählen Sie alle Produktvariationen aus, bevor Sie das Produkt in den Warenkorb legen.');
        locked = false;
        return;
      }
      
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

/**
 * Adds an article to the cart via AJAX request
 * @param {jQuery} article - The article element containing cart information
 * @param {string} variations - JSON string of product variations
 */
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

  updateCartPrice();
  addToCart($(input), variant);
}

function updateCartPrice() {
	const articles = document.querySelectorAll('.article');
  let cartTotal = 0;

  articles.forEach(article => {
    const itemTotalText = article.querySelector('#total-item-price').textContent;
    const itemTotal = parseFloat(itemTotalText.replace('CHF ', ''));
    cartTotal += itemTotal;
  });
  document.querySelector('.total-price').textContent = 'Gesamtpreis: CHF ' + cartTotal.toFixed(2);
}

/**
 * Removes an article from the cart after user confirmation
 * @param {string} articleId - The ID of the article to remove
 * @param {string} variant - The variant specification of the article
 */
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
      // Find element by iterating through articles since variant contains JSON with quotes
      const articles = document.querySelectorAll('.article[article-id="' + articleId + '"]');
      articles.forEach(article => {
        if (article.getAttribute('variant') === variant) {
          article.remove();
        }
      });
			updateCartPrice();
    },
  });
}

/**
 * Extracts and returns the body content from HTML string data
 * @param {string} data - HTML string to parse
 * @returns {string} The innerHTML content of the body element
 */
function getJsonFromBody(data) {
  var parser = new DOMParser();
  var doc = parser.parseFromString(data, 'text/html');
  data = doc.getElementsByTagName("body")[0].innerHTML;

  return data;
}

/**
 * Submits the order form asynchronously and handles the response
 * @param {HTMLFormElement} f - The form element to submit
 */
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
 * Sets up mutual exclusion between pickup and alternate shipping address checkboxes
 * Ensures only one option can be selected at a time and manages visibility
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

  /**
   * Updates the visibility of checkboxes based on current state
   */
  function updateCheckboxVisibility() {
    if (pickupCheckbox.is(':checked')) {
      alternateShippingRow.hide();
    } else if (alternateShippingCheckbox.is(':checked')) {
      pickupRow.hide();
    }
  }
}

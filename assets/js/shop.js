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
      let variation = document.querySelector("#productVariations");
      addToCart($(this), variation);

      var originalText = $(this).html();
      var originalWidth = $(this).outerWidth();

      $(this).html('<span class="checkmark">&#10004;</span>').css({'background-color':'green','color':'white', 'width': originalWidth + "px"});
      setTimeout(() => {
      $(this).html(originalText).css({'background-color':'','color':'', 'width': ''});
      }, 2000);
      locked = false; // Unlock after the operation
    }
  });

  // todo: other cart functions


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
});

function addToCart(article, variation) {
  let quantity = article.closest('.product-action').find('.quantity input').val();
  let articleId = article.attr('article-id');
  let set = article.attr('setter') || '0';
  if (variation === null || variation === undefined) {
    variation = '';
  } else {
    variation = variation.value
  }

  let url = `?ajax=updateCart&articleId=${articleId}&quantity=${quantity}&set=${set}&variant=${variation}`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function (data) {
      console.log("Article added to cart: " + articleId);
    },
  });
}

/**
 * @function updateCart
 * Updates the cart viw & object total price and item total price when quantity changes.
 * @param {*} input 
 * @param {*} price 
 * @param {*} articleId 
 */
function updateCart(input, price, articleId) {
  const quantity = $(input).val();
  const totalPrice = (parseFloat(price) * parseInt(quantity)).toFixed(2);
  $(input).closest('.article').find('#total-item-price').text('Gesamt: CHF ' + totalPrice);
  // Update total cart price
  const articles = document.querySelectorAll('.article');
  let cartTotal = 0;

  let variation = document.querySelector("#productVariations");
  
  articles.forEach(article => {
    const itemTotalText = article.querySelector('#total-item-price').textContent;
    const itemTotal = parseFloat(itemTotalText.replace('Gesamt: CHF ', ''));
    cartTotal += itemTotal;
  });
  document.querySelector('.total-price').textContent = 'Gesamtpreis: CHF ' + cartTotal.toFixed(2);
  if (input) {
  }

  addToCart($(input), variation);
}

function removeFromCart(articleId, variant) {
  // Ask for confirmation before removing the item
  if (!confirm('Are you sure you want to remove this item from your cart?')) {
    return; // User canceled the operation
  }

	if (variant === null || variant === undefined) {
    variant = '';
  }
  
  var url = `?ajax=updateCart&articleId=${articleId}&quantity=0&variant=${variant}`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function (data) {
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
    f.submit();
  })
  .catch((error) => {
    console.error('Error:', error);
    alert('Es ist ein Fehler aufgetreten. Bitte überprüfen Sie ihre Angaben versuchen Sie es erneut.');
  });
}

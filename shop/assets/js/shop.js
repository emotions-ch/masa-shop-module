// jquery ready
$(function () {

  console.log('cart.js loaded');

  /**
   * add article to cart
   */
  $('.product-action .article-to-cart').on('click', function (e) {
    e.preventDefault();
    addToCart($(this));

    var originalText = $(this).html();
    $(this).html('<span class="checkmark">&#10004;</span>').css({'background-color':'green','color':'white'});
    setTimeout(() => {
      $(this).html(originalText).css({'background-color':'','color':''});
    }, 2000);
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

function addToCart(article) {
  var quantity = article.closest('.product-action').find('.quantity input').val();
  var articleId = article.attr('article-id');
  var url = `?ajax=updateCart&articleId=${articleId}&quantity=${quantity}`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function (data) {
      console.log("Article added to cart: " + articleId);
    },
  });
}

function removeFromCart(articleId) {
  // Ask for confirmation before removing the item
  if (!confirm('Are you sure you want to remove this item from your cart?')) {
    return; // User canceled the operation
  }
  
  var url = `?ajax=updateCart&articleId=${articleId}&quantity=0`;

  $.ajax({
    type: "GET",
    url: url,
    data: {},
    success: function (data) {
      data = getJsonFromBody(data);

      // console.log(data.trim());
      location.reload();
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
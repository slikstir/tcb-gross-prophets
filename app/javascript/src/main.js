document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".quantity-selector").forEach(function (selector) {
      const decreaseBtn = selector.querySelector(".decreaseBtn");
      const increaseBtn = selector.querySelector(".increaseBtn");
      const lineItemQuantity = selector.querySelector(".line_item_quantity");
  
      if (decreaseBtn && increaseBtn && lineItemQuantity) {
        decreaseBtn.addEventListener("click", function () {
          let quantity = parseInt(lineItemQuantity.value, 10);
          if (quantity > 1) {
            lineItemQuantity.value = quantity - 1;
          }
        });
  
        increaseBtn.addEventListener("click", function () {
          let quantity = parseInt(lineItemQuantity.value, 10);
          lineItemQuantity.value = quantity + 1;
        });
      }
    });
  });
  
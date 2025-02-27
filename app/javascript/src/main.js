document.addEventListener("DOMContentLoaded", function () {
  const decreaseBtn = document.getElementById("decreaseBtn");
  const increaseBtn = document.getElementById("increaseBtn");
  const line_item_quantity = document.getElementById("line_item_quantity");

  if (decreaseBtn && increaseBtn && line_item_quantity) {
      decreaseBtn.addEventListener("click", function () {
          let quantity = parseInt(line_item_quantity.value, 10);
          if (quantity > 1) {
              line_item_quantity.value = quantity - 1;
          }
      });

      increaseBtn.addEventListener("click", function () {
          let quantity = parseInt(line_item_quantity.value, 10);
          line_item_quantity.value = quantity + 1;
      });
  }
});

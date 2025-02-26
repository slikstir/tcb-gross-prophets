document.addEventListener("DOMContentLoaded", function () {
  const decreaseBtn = document.getElementById("decreaseBtn");
  const increaseBtn = document.getElementById("increaseBtn");
  const quantityInput = document.getElementById("quantityInput");

  if (decreaseBtn && increaseBtn && quantityInput) {
      decreaseBtn.addEventListener("click", function () {
          let quantity = parseInt(quantityInput.value, 10);
          if (quantity > 1) {
              quantityInput.value = quantity - 1;
          }
      });

      increaseBtn.addEventListener("click", function () {
          let quantity = parseInt(quantityInput.value, 10);
          quantityInput.value = quantity + 1;
      });
  }
});

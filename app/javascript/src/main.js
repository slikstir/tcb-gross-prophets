function setupQuantitySelectors() {
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
}

function attachDatetimeFormHandler() {
  const form = document.getElementById("order-report-form");

  if (form) {
    form.addEventListener("submit", function () {
      const startInput = document.querySelector("input[name='start_datetime_local']");
      const endInput = document.querySelector("input[name='end_datetime_local']");
      const startHidden = document.getElementById("start_datetime");
      const endHidden = document.getElementById("end_datetime");
      const timeZoneHidden = document.getElementById("time_zone");

      if (startInput && endInput && startHidden && endHidden) {
        startHidden.value = new Date(startInput.value).toISOString();
        endHidden.value = new Date(endInput.value).toISOString();
      }

      if (timeZoneHidden) {
        timeZoneHidden.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
      }
    });
  }
}

document.addEventListener("DOMContentLoaded", setupQuantitySelectors);
document.addEventListener("turbo:render", setupQuantitySelectors);

document.addEventListener("DOMContentLoaded", attachDatetimeFormHandler);
document.addEventListener("turbo:load", attachDatetimeFormHandler);
document.addEventListener("turbo:render", attachDatetimeFormHandler);
  
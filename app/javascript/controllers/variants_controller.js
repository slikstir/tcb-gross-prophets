import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["variant"]

  add(event) {
    event.preventDefault();
    
    const variantsContainer = this.element.querySelector("#variants");
    const index = new Date().getTime();
    const template = document.createElement("template");

    template.innerHTML = this.variantTemplate(index);
    variantsContainer.insertAdjacentHTML("beforeend", template.innerHTML);
  }

  remove(event) {
    event.preventDefault();
    event.target.closest(".variant").remove();
  }

  variantTemplate(index) {
    return `
      <div class="variant row">
        <input type="hidden" name="product[children_attributes][${index}][id]" id="product_children_attributes_${index}_id">

        <div class="col">
          <div class="mb-3">
            <label class="form-label" for="product_children_attributes_${index}_sku">SKU</label>
            <input class="form-control" type="text" name="product[children_attributes][${index}][sku]" id="product_children_attributes_${index}_sku">
          </div>
        </div>

        <div class="col">
          <div class="mb-3">
            <label class="form-label" for="product_children_attributes_${index}_option_1">Option 1</label>
            <input class="form-control" type="text" name="product[children_attributes][${index}][option_1]" id="product_children_attributes_${index}_option_1">
          </div>
        </div>

        <!--
        <div class="col">
          <div class="mb-3">
          <label class="form-label"  for="product_children_attributes_${index}_option_2">Option 2</label>
          <input class="form-control"  type="text" name="product[children_attributes][${index}][option_2]" id="product_children_attributes_${index}_option_2">
          </div>
        </div>

        <div class="col">
          <div class="mb-3">
          <label class="form-label" for="product_children_attributes_${index}_option_3">Option 3</label>
          <input class="form-control"  type="text" name="product[children_attributes][${index}][option_3]" id="product_children_attributes_${index}_option_3">
          </div>
        </div>
        -->
        
        <div class="col">
          <div class="mb-3">
            <label class="form-label" for="product_children_attributes_${index}_stock_level">Stock level</label>
            <input class="form-control" type="text" name="product[children_attributes][${index}][stock_level]" id="product_children_attributes_${index}_stock_level">
          </div>
        </div>


        <input type="hidden" name="product[children_attributes][${index}][parent]" value="false">

        <div class="col d-flex align-items-center justify-content-center">
          <button type="button" class="btn btn-danger" data-action="click->variants#remove" data-variant-target="variant">
            Remove
          </button>
        </div>      
  </div>
    `;
  }
}

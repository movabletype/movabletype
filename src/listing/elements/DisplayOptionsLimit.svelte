<script>
  import { ListingStore } from "../ListingStore.ts";

  function changeLimit(e) {
    //this.store.trigger('update_limit', this.refs.limit.value)
    console.log("Run update_limit for " + e.currentTarget.id);
  }
  let selected = $ListingStore.limit.toString();
</script>

<div class="field-header">
  <!-- svelte-ignore a11y-label-has-associated-control -->
  <label class="form-label">{window.trans("Show")}</label>
</div>
<div class="field-content">
  <select
    id="row"
    class="custom-select form-control form-select"
    style="width: 100px;"
    ref="limit"
    bind:value={selected}
    on:change={changeLimit}
  >
    <option value="10">{window.trans("[_1] rows", 10)}</option>
    <option value="25">{window.trans("[_1] rows", 25)}</option>
    <option value="50">{window.trans("[_1] rows", 50)}</option>
    <option value="100">{window.trans("[_1] rows", 100)}</option>
    <option value="200">{window.trans("[_1] rows", 200)}</option>
  </select>
</div>

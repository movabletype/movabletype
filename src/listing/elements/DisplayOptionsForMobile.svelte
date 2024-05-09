<script>
  //import DisplayOptionsLimit, { changeLimit } from "./DisplayOptionsLimit.svelte";
  import { ListingStore, ListingOpts } from "../ListingStore.ts";

  function changeLimit(e) {
    //this.store.trigger('update_limit', this.refs.limit.value)
    console.log("Run update_limit for " + e.currentTarget.id);
  }
  let selected = $ListingStore.limit.toString();
</script>

<div class="row d-md-none">
  <div class="col-auto mx-auto">
    <div class="form-inline">
      <label for="row-for-mobile" class="form-label"
        >{trans("Show") + ":"}</label
      >
      <select
        id="row-for-mobile"
        class="custom-select form-control form-select"
        ref="limit"
        bind:value={selected}
        on:change={changeLimit}
      >
        <option value="10">{trans("[_1] rows", 10)}</option>
        <option value="25">{trans("[_1] rows", 25)}</option>
        <option value="50">{trans("[_1] rows", 50)}</option>
        <option value="100">{trans("[_1] rows", 100)}</option>
        <option value="200">{trans("[_1] rows", 200)}</option>
      </select>
    </div>
  </div>
</div>

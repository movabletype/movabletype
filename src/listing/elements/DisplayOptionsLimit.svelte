<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let changeLimit: (e: Event) => void;
  export let store: Listing.ListStore;

  $: limit = store.limit || 0;
  $: limitToString = limit.toString();
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
    {...{ ref: "limit" }}
    bind:value={limitToString}
    on:change={changeLimit}
  >
    <option value="10">{window.trans("[_1] rows", "10")}</option>
    <option value="25">{window.trans("[_1] rows", "25")}</option>
    <option value="50">{window.trans("[_1] rows", "50")}</option>
    <option value="100">{window.trans("[_1] rows", "100")}</option>
    <option value="200">{window.trans("[_1] rows", "200")}</option>
  </select>
</div>

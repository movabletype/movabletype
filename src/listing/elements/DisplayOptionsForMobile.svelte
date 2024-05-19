<script lang="ts">
  import { ChangeEventHandler } from "svelte/elements";

  export let changeLimit: ChangeEventHandler<HTMLSelectElement>;
  /* eslint @typescript-eslint/no-explicit-any: 0 */
  export let store: any;

  $: limit = store.limit;
  $: limitToString = limit.toString();
</script>

<div class="row d-md-none">
  <div class="col-auto mx-auto">
    <div class="form-inline">
      <label for="row-for-mobile" class="form-label"
        >{window.trans("Show") + ":"}</label
      >
      <select
        id="row-for-mobile"
        class="custom-select form-control form-select"
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
  </div>
</div>

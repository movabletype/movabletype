<script lang="ts">
  import { getContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    changeLimit: (e: Event) => void;
  };
  let { changeLimit }: Props = $props();

  const { reactiveStore } = getContext<ListStoreContext>("listStore");

  let limit = $derived($reactiveStore.limit || 0);
  let limitToString = $derived(limit.toString());
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
        {...{ ref: "limit" }}
        bind:value={limitToString}
        onchange={changeLimit}
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

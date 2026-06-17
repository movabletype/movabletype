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

<div class="field-header">
  <!-- svelte-ignore a11y_label_has_associated_control -->
  <label class="form-label">{window.trans("Show")}</label>
</div>
<div class="field-content">
  <select
    id="row"
    class="custom-select form-control form-select"
    style="width: 100px;"
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

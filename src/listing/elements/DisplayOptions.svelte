<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import DisplayOptionsDetail from "./DisplayOptionsDetail.svelte";

  type Props = {
    changeLimit: (e: Event) => void;
    disableUserDispOption: boolean;
    store: Listing.ListStore;
  };
  let { changeLimit, disableUserDispOption, store }: Props = $props();
</script>

<div class="row">
  <div class="col-12">
    <button
      class="btn btn-default dropdown-toggle float-end"
      data-bs-toggle="collapse"
      data-bs-target="#display-options-detail"
      aria-expanded="false"
      aria-controls="display-options-detail"
    >
      {window.trans("Display Options")}
    </button>
  </div>
</div>
<div class="row">
  <div data-is="display-options-detail" class="col-12">
    <DisplayOptionsDetail {changeLimit} {disableUserDispOption} {store} />
  </div>
</div>

<script>
  import DisplayOptionsDetail from "./DisplayOptionsDetail.svelte";
</script>

<div class="row">
  <div class="col-12">
    <button
      class="btn btn-default dropdown-toggle float-end"
      data-bs-toggle="collapse"
      data-bs-target="#display-options-detail2"
      aria-expanded="false"
      aria-controls="display-options-detail2"
    >
      {window.trans("Display Options")}
    </button>
  </div>
</div>
<div class="row">
  <div data-is="display-options-detail2" class="col-12">
    <DisplayOptionsDetail />
  </div>
</div>

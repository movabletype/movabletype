<script>
import ListFilterHeader from "./ListFilterHeader.svelte";
import ListFilterDetail from "./ListFilterDetail.svelte";
</script>

<div class="card-header">
  <ListFilterHeader />
</div>
<div id="list-filter-collapse" class="collapse">
  <div id="filter-detail" class="card-block p-3">
    <ListFilterDetail />
  </div>
</div>

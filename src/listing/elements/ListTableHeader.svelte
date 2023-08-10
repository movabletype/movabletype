<script>
import ListTableHeaderForPc from "./ListTableHeaderForPc.svelte";
import ListTableHeaderForMobile from "./ListTableHeaderForMobile.svelte";

function toggleAllRowsOnPage(e) {
  //this.store.trigger('toggle_all_rows_on_page');
}

function toggleSortColumn(e) {
//  var columnId = e.currentTarget.parentElement.dataset.id
//  this.store.trigger('toggle_sort_column', columnId)
}

</script>

<ListTableHeaderForPc />
<ListTableHeaderForMobile />

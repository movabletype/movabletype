<script>
import { ListingStore, ListingOpts } from "../ListingStore.ts";

function classes(index) {
  var nameClass = this.store.showColumns[index].id
  var classes
  if (this.store.hasMobileColumn()) {
    if (this.store.getMobileColumnIndex() == index) {
      classes = 'd-md-none'
    } else {
      classes = 'd-none d-md-table-cell'
    }
  } else {
    if (this.store.showColumns[index].primary) {
      classes = ''
    } else {
      classes = 'd-none d-md-table-cell'
    }
  }
  if (classes.length > 0) {
    return nameClass + ' ' + classes
  } else {
    return nameClass
  }
}
</script>

{#if $ListingOpts.hasListActions}
<td>
  {#if opts.object[0]}
  <div class="form-check">
    <input type="checkbox"
      name="id"
      class="form-check-input"
      id={ 'select_' + opts.object[0] }
      value={ opts.object[0] }
      checked={ opts.checked }>
    <span class="custom-control-indicator"></span>
    <label class="form-check-label" for={ 'select_' + opts.object[0] }><span class="visually-hidden">{ trans('Select') }</span></label>
  </div>
  {/if}
</td>
{/if}
{#each opts.object as content, index}
<td class={classes(index)}>
  {@html content}
</td>
{/each}

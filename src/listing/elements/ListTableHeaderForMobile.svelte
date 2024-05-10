<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  export let toggleAllRowsOnPage;
</script>

{#if $ListingStore.count}
  <tr class="d-md-none">
    {#if $ListingOpts.hasMobilePulldownActions}
      <th class="mt-table__control">
        <div class="form-check">
          <input
            type="checkbox"
            class="form-check-input"
            id="select-all"
            checked={$ListingOpts.checkedAllRowsOnPage}
            on:change={toggleAllRowsOnPage}
          />
          <label class="form-check-label" for="select-all"
            ><span class="visually-hidden">{window.trans("Select All")}</span
            ></label
          >
        </div>
      </th>
    {/if}
    <th scope="col">
      {#if $ListingOpts.hasMobilePulldownActions}
        <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
        <span on:click={toggleAllRowsOnPage}>
          {window.trans("All")}
        </span>
        <span class="float-end">
          {window.trans(
            "[_1] &ndash; [_2] of [_3]",
            $ListingStore.getListStart(),
            $ListingStore.getListEnd(),
            $ListingStore.count
          )}
        </span>
      {/if}
    </th>
  </tr>
{/if}

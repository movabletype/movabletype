<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let hasMobilePulldownActions: boolean;
  export let store: Listing.ListStore;
  export let toggleAllRowsOnPage: () => void;
</script>

{#if store.count}
  <tr class="d-md-none">
    {#if hasMobilePulldownActions}
      <th class="mt-table__control">
        <div class="form-check">
          <!-- checked="checked" is not added to input tag after click checkbox,
            but check parameter of input element returns true. So, do not fix this. -->
          <input
            type="checkbox"
            class="form-check-input"
            id="select-all"
            checked={store.checkedAllRowsOnPage}
            on:change={toggleAllRowsOnPage}
          />
          <label class="form-check-label" for="select-all">
            <span class="visually-hidden">
              {window.trans("Select All")}
            </span>
          </label>
        </div>
      </th>
    {/if}
    <th scope="col">
      {#if hasMobilePulldownActions}
        <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
        <span on:click={toggleAllRowsOnPage}>
          {window.trans("All")}
        </span>
      {/if}
      <span class="float-end">
        {window.trans(
          "[_1] - [_2] of [_3]",
          store.getListStart().toString(),
          store.getListEnd().toString(),
          store.count.toString(),
        )}
      </span>
    </th>
  </tr>
{/if}

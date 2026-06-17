<script lang="ts">
  import { getContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    hasMobilePulldownActions: boolean;
    toggleAllRowsOnPage: () => void;
  };
  let { hasMobilePulldownActions, toggleAllRowsOnPage }: Props = $props();
  const { store, reactiveStore } = getContext<ListStoreContext>("listStore");
</script>

{#if $reactiveStore.count}
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
            checked={$reactiveStore.checkedAllRowsOnPage}
            onchange={toggleAllRowsOnPage}
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
        <!-- svelte-ignore a11y_click_events_have_key_events -->
        <!-- svelte-ignore a11y_no_static_element_interactions -->
        <span onclick={toggleAllRowsOnPage}>
          {window.trans("All")}
        </span>
      {/if}
      <span class="float-end">
        {window.trans(
          "[_1] - [_2] of [_3]",
          store.getListStart().toString(),
          store.getListEnd().toString(),
          $reactiveStore.count.toString(),
        )}
      </span>
    </th>
  </tr>
{/if}

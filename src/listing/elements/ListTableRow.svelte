<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let checked: boolean;
  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let object: Array<string | number>;
  export let store: Listing.ListStore;

  const classes = (index: string): string => {
    const nameClass = store.showColumns[index].id;
    let classes: string;
    if (store.hasMobileColumn()) {
      if (store.getMobileColumnIndex().toString() === index) {
        classes = "d-md-none";
      } else {
        classes = "d-none d-md-table-cell";
      }
    } else {
      if (store.showColumns[index].primary) {
        classes = "";
      } else {
        classes = "d-none d-md-table-cell";
      }
    }
    if (classes.length > 0) {
      return nameClass + " " + classes;
    } else {
      return nameClass;
    }
  };
</script>

{#if hasListActions}
  <td
    class:d-none={!hasMobilePulldownActions}
    class:d-md-table-cell={!hasMobilePulldownActions}
  >
    {#if object[0]}
      <div class="form-check">
        <!-- checked="checked" is not added to input tag after click checkbox,
          but check parameter of input element returns true. So, do not fix this. -->
        <input
          type="checkbox"
          name="id"
          class="form-check-input"
          id={"select_" + object[0]}
          value={object[0]}
          {checked}
        />
        <span class="custom-control-indicator" />
        <label class="form-check-label" for={"select_" + object[0]}
          ><span class="visually-hidden">{window.trans("Select")}</span></label
        >
      </div>
    {/if}
  </td>
{/if}
{#each object as content, index}
  {#if index > 0}
    <!-- index is shifted compared to Riot.js -->
    <td data-is="list-table-column" class={classes((index - 1).toString())}>
      {@html content}
    </td>
  {/if}
{/each}

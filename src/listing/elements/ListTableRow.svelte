<script lang="ts">
  import { ListStore } from "types/listing";

  export let checked: number;
  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let object: Array<object>;
  export let store: ListStore;

  const classes = (index: string): string => {
    const nameClass = store.showColumns[index].id;
    let classes;
    if (store.hasMobileColumn()) {
      if (store.getMobileColumnIndex().toString() == index) {
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
        <input
          type="checkbox"
          name="id"
          class="form-check-input"
          id={"select_" + object[0]}
          value={object[0]}
          checked={checked != 0}
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
    <td data-is="list-table-column" class={classes((index - 1).toString())}>
      {@html content}
    </td>
  {/if}
{/each}

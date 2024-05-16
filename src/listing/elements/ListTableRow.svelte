<script>
  export let checked;
  export let listStore;
  export let object;
  export let opts;

  function classes(index) {
    const nameClass = listStore.showColumns[index].id;
    let classes;
    if (listStore.hasMobileColumn()) {
      if (listStore.getMobileColumnIndex() == index) {
        classes = "d-md-none";
      } else {
        classes = "d-none d-md-table-cell";
      }
    } else {
      if (listStore.showColumns[index].primary) {
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
  }
</script>

{#if opts.hasListActions}
  <td
    class:d-none={!opts.hasMobilePulldownActions}
    class:d-md-table-cell={!opts.hasMobilePulldownActions}
  >
    {#if object[0]}
      <div class="form-check">
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
    <td class={classes(index - 1)}>
      {@html content}
    </td>
  {/if}
{/each}

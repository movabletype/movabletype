<script lang="ts">
  export let id: string;

  export let attr = "";
  export let hint = "";
  export let label = "";
  export let required = 0;
  export let showHint = 0;
  export let showLabel = 1;

  if (!id) {
    alert("ConetntFieldOption: 'id' attribute missing");
  }
</script>

<div id="{id}-field" class="form-group" class:required {...{ attr: attr }}>
  {#if label && showLabel}
    <label for={id}>
      {label}

      {#if required}
        <span class="badge badge-danger">
          {window.trans("Required")}
        </span>
      {/if}
    </label>
  {/if}

  <slot />

  {#if hint && showHint}
    <small id="{id}-field-help" class="form-text text-muted">
      {hint}
    </small>
  {/if}
</div>

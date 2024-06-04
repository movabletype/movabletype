<script>
  export let id;
  export let label;
  export let showLabel;
  export let required;
  export let hint;
  export let showHint;
  export let attr;

  if (!id) {
    alert("ConetntFieldOption: id not found");
  }
  let classValue = "form-group";
  if (required) {
    classValue += " required";
  }
</script>

<div id="{id}-field" class={classValue} {attr}>
  {#if label && showLabel}
    <label for={id}>
      {label}
      {#if required}
        <span class="badge badge-danger">{window.trans("Required")}</span>
      {/if}
    </label>
  {/if}
  <slot name="inside" />
  {#if hint && showHint}
    <small id="{id}-field-help" class="form-text text-muted">{hint}</small>
  {/if}
</div>

<script lang="ts">
  // copied from lib/MT/Template/ContextHandlers.pm

  export let id: string;

  export let attr = "";
  export let attrShow: boolean | null = null;
  export let hint = "";
  export let label = "";
  export let required = 0;
  export let showHint = 0;
  export let showLabel = 1;

  if (!id) {
    console.error("ConetntFieldOption: 'id' attribute missing");
  }

  $: attrProp = attr ? { attr: attr } : {};

  let attrShowProps = {};
  $: {
    if (attrShow !== null) {
      if (attrShow) {
        attrShowProps = {
          style: "",
        };
      } else {
        attrShowProps = {
          hidden: "",
          style: "display: none;",
        };
      }
    }
  }
</script>

<div
  id="{id}-field"
  class="form-group"
  class:required
  {...attrProp}
  {...attrShowProps}
>
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

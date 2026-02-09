<script lang="ts">
  import { onMount } from "svelte";

  // copied from lib/MT/Template/ContextHandlers.pm
  type Props = {
    id: string;
    attr?: string;
    attrShow?: boolean | null;
    hint?: string;
    label?: string;
    required?: number;
    showHint?: number;
    showLabel?: number;
  };
  let {
    id,
    attr = "",
    attrShow = null,
    hint = "",
    label = "",
    required = 0,
    showHint = 0,
    showLabel = 1,
  }: Props = $props();

  onMount(() => {
    if (!id) {
      console.error("ConetntFieldOption 'id' attribute missing");
    }
  });

  let attrProp = $derived(attr ? { attr: attr } : {});

  let attrShowProps = $state({});
  $effect(() => {
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
  });
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

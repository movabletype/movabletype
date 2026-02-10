<script lang="ts">
  import ComponentList from "./ComponentList.svelte";

  let {
    namespace = "test-namespace",
    detail = {},
    hasPrepend = false,
    hasAppend = false,
    prependText = "Prepend Content",
    appendText = "Append Content",
    onmessage,
  }: {
    namespace?: string;
    detail?: Record<string, unknown>;
    hasPrepend?: boolean;
    hasAppend?: boolean;
    prependText?: string;
    appendText?: string;
    onmessage?: (e: MessageEvent) => void;
  } = $props();
</script>

{#if hasPrepend && hasAppend}
  <ComponentList {namespace} {detail} {onmessage}>
    {#snippet prepend()}
      <div class="prepend-content">{prependText}</div>
    {/snippet}
    {#snippet append()}
      <div class="append-content">{appendText}</div>
    {/snippet}
  </ComponentList>
{:else if hasPrepend}
  <ComponentList {namespace} {detail} {onmessage}>
    {#snippet prepend()}
      <div class="prepend-content">{prependText}</div>
    {/snippet}
  </ComponentList>
{:else if hasAppend}
  <ComponentList {namespace} {detail} {onmessage}>
    {#snippet append()}
      <div class="append-content">{appendText}</div>
    {/snippet}
  </ComponentList>
{:else}
  <ComponentList {namespace} {detail} {onmessage} />
{/if}

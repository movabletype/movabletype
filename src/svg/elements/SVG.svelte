<script lang="ts">
  let className: string;
  export { className as class };
  export let href: string;
  export let title: string;
  export let style: string | undefined = undefined;
</script>

<svg role="img" class={className} {style}>
  {#if title}
    <title>{title}</title>
  {/if}
  <use xlink:href={href} />
</svg>

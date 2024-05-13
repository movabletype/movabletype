<script lang="ts">
  let className: string;
  export { className as class };
  export let href: string;
  export let title: string;
</script>

<svg role="img" class={className}>
  {#if title}
    <title>{title}</title>
  {/if}
  <use xlink:href={href} />
</svg>

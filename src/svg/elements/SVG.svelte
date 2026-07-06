<script lang="ts">
  type Props = {
    class: string;
    href: string;
    title: string;
    style?: string;
  };
  let { class: className, href, title, style = undefined }: Props = $props();
</script>

<svg role="img" class={className} {style}>
  {#if title}
    <title>{title}</title>
  {/if}
  <use xlink:href={href} />
</svg>

<script lang="ts">
  // copied from lib/MT/Template/ContextHandlers.pm

  import StatusMsgTmpl from "./StatusMsgTmpl.svelte";

  export let blogId = "";
  export let canClose: number | undefined;
  let className = "info";
  export { className as class };
  export let id = "";
  export let hidden = "";
  export let noLink = "";
  export let rebuild = "";

  $: {
    if (!className) {
      className = "info";
    }
    className = className.replace(/\balert\b/, "warning");
    className = className.replace(/\berror\b/, "danger");
  }

  $: {
    if (id && (canClose || canClose === null)) {
      canClose = 1;
    }
  }
</script>

<StatusMsgTmpl
  {blogId}
  {canClose}
  canRebuild={0}
  class={className}
  didReplace={0}
  dynamicAll={0}
  hidden={hidden ?? ""}
  {id}
  noLink={noLink ?? ""}
  {rebuild}
>
  <svelte:fragment slot="msg">
    <slot name="msg" />
  </svelte:fragment>
</StatusMsgTmpl>

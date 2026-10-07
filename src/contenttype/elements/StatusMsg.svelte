<script lang="ts">
  import type { Snippet } from "svelte";

  // copied from lib/MT/Template/ContextHandlers.pm

  import StatusMsgTmpl from "./StatusMsgTmpl.svelte";

  type Props = {
    blogId?: string;
    canClose?: number;
    class?: string;
    id?: string;
    hidden?: string;
    msg?: Snippet;
    noLink?: string;
    rebuild?: string;
  };

  let {
    blogId = "",
    canClose,
    class: className = "info",
    id = "",
    hidden = "",
    msg,
    noLink = "",
    rebuild = "",
  }: Props = $props();

  $effect(() => {
    if (!className) {
      className = "info";
    }
    className = className.replace(/\balert\b/, "warning");
    className = className.replace(/\berror\b/, "danger");
  });

  $effect(() => {
    if (id && (canClose || canClose === null)) {
      canClose = 1;
    }
  });
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
  {msg}
  noLink={noLink ?? ""}
  {rebuild}
></StatusMsgTmpl>

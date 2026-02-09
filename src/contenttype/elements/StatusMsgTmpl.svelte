<script lang="ts">
  import type { Snippet } from "svelte";

  // copied from mtapp_statusmsg.tmpl

  type Props = {
    blogId: string;
    canClose?: number;
    canRebuild: number;
    class?: string;
    didReplace: number;
    dynamicAll: number;
    hidden: string;
    id: string;
    msg?: Snippet;
    noLink: string;
    rebuild: string;
  };

  let {
    blogId = "",
    canClose,
    canRebuild,
    class: className = "",
    didReplace = 0,
    dynamicAll = 0,
    hidden = "",
    id = "",
    msg,
    noLink = "",
    rebuild = "",
  }: Props = $props();

  let divProps: Record<string, string> = $derived.by(() => {
    const props: Record<string, string> = {};

    if (id) {
      props["id"] = id;
    }

    if (className) {
      props["class"] = "alert alert-" + className;
    } else {
      props["class"] = "alert alert-info";
    }

    if (canClose) {
      props["alert-dismissible"] = "";
    }

    if (hidden) {
      props["style"] = "display: none;";
    }

    if (className.match(/\bwarning|\bdanger/)) {
      props["role"] = "alert";
    }

    return props;
  });
</script>

<div {...divProps}>
  {#if canClose}
    <button
      type="button"
      class="btn-close"
      data-bs-dismiss="alert"
      aria-label="Close"
    >
      <span aria-hidden="true">&times;</span>
    </button>
  {/if}

  {#if msg}
    {@render msg()}
  {/if}

  {#if didReplace}
    {#if !noLink}
      {@html window.trans(
        "[_1]Publish[_2] your [_3] to see these changes take effect.",
        `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId}&prompt=index" class="mt-rebuild alert-link">`,
        "</a>",
        rebuild === "blog"
          ? window.trans("blog(s)")
          : window.trans("website(s)"),
      )}
    {/if}
  {:else if canRebuild}
    {#if rebuild === "cfg_prefs"}
      {@html window.trans(
        "[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.",
        `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId}" class="mt-rebuild alert-link">`,
        "</a>",
      )}
    {:else if rebuild === "all"}
      {#if !dynamicAll}
        {@html window.trans(
          "[_1]Publish[_2] your site to see these changes take effect.",
          `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId}" class="mt-rebuild alert-link">`,
          "</a>",
        )}
      {/if}
    {:else if rebuild === "index"}
      {#if !dynamicAll}
        {@html window.trans(
          "[_1]Publish[_2] your site to see these changes take effect.",
          `<a href="${window.CMSScriptURI}?__mode=rebuild_confirm&blog_id=${blogId}&prompt=index" class="mt-rebuild alert-link">`,
          "</a>",
        )}
      {/if}
    {:else}
      {@html rebuild}
    {/if}
  {/if}
</div>

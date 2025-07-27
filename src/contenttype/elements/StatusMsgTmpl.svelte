<script lang="ts">
  // copied from mtapp_statusmsg.tmpl

  export let blogId: string = "";
  export let canClose: number | undefined;
  export let canRebuild: number;
  let className: string;
  export { className as class };
  export let didReplace: number;
  export let dynamicAll: number;
  export let hidden: string;
  export let id: string;
  export let noLink: string;
  export let rebuild: string;

  let divProps = {};
  $: {
    divProps = {};

    if (id) {
      divProps["id"] = id;
    }

    if (className) {
      divProps["class"] = "alert alert-" + className;
    } else {
      divProps["class"] = "alert alert-info";
    }

    if (canClose) {
      divProps["alert-dismissible"] = "";
    }

    if (hidden) {
      divProps["style"] = "display: none;";
    }

    if (className.match(/\bwarning|\bdanger/)) {
      divProps["role"] = "alert";
    }
  }
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

  <slot name="msg" />

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

<script lang="ts">
  import { Breadcrumb } from "../../@types/breadcrumbs";
  import { portal } from "svelte-portal";
  import SVG from "../../svg/elements/SVG.svelte";

  export let breadcrumbs: Breadcrumb[] = [];
  export let scopeType: string = "";
  export let canAccessToSystemDashboard: boolean = false;
  export let canCurrentWebSiteLink: boolean = false;
  export let currentWebsiteID: string = "";
  export let currentWebsiteName: string = "";
  export let blogID: string = "";
  export let blogName: string = "";

  let open = false;
  const handleClick = (): void => {
    open = true;
  };
  const handleClose = (): void => {
    open = false;
  };

  let buttonRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;

  let modalLeft = 0;
  $: if (buttonRef && modalRef) {
    const buttonRect = buttonRef.getBoundingClientRect();
    modalLeft = buttonRect.left + (buttonRect.width - modalRef.offsetWidth) / 2;
  }
</script>

<span class="mt-breadcrumb-button-wrapper">
  <button
    type="button"
    on:click={handleClick}
    class="mt-breadcrumb-button"
    bind:this={buttonRef}
  >
    <SVG
      class="mt-icon"
      href={`${window.StaticURI}images/admin2025/sprite.svg#ic_menu`}
      title={window.trans("menu")}
    />
  </button>
</span>

{#if open}
  <div
    class="modal breadcrumbs-modal"
    use:portal={"body"}
    bind:this={modalRef}
    style="--modal-left: {modalLeft}px;"
  >
    <div class="modal-header">
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-label="Close"
        on:click={handleClose}
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <ul class="breadcrumb-list">
        <li class="breadcrumb-list-item">
          <span class="mt-icon">
            <SVG
              class="mt-icon"
              href={`${window.StaticURI}images/admin2025/sprite.svg#ic_home`}
              title={window.trans("Dashboard")}
            />
          </span>
          <a
            href="{window.ScriptURI}?__mode=dashboard"
            title={window.trans("Dashboard")}
          >
            {window.trans("Dashboard")}
          </a>
        </li>
        {#if scopeType === "system"}
          <li class="breadcrumb-list-item">
            <span class="mt-icon icon-circle">&nbsp;</span>
            {#if canAccessToSystemDashboard}
              <a href="{window.ScriptURI}?__mode=dashboard&blog_id=0">
                {window.trans("System")}
              </a>
            {:else}
              {window.trans("System")}
            {/if}
          </li>
        {:else}
          {#if scopeType === "blog"}
            <li class="breadcrumb-list-item">
              <span class="mt-icon icon-circle">&nbsp;</span>
              {#if canCurrentWebSiteLink}
                <a
                  href="{window.ScriptURI}?__mode=dashboard&blog_id={currentWebsiteID}"
                >
                  {currentWebsiteName}
                </a>
              {:else}
                {currentWebsiteName}
              {/if}
            </li>
          {/if}
          <li class="breadcrumb-list-item">
            <span class="mt-icon icon-circle">&nbsp;</span>
            <a href="{window.ScriptURI}?__mode=dashboard&blog_id={blogID}">
              {blogName}
            </a>
          </li>
        {/if}

        {#if breadcrumbs.length > 0}
          {#each breadcrumbs as breadcrumb}
            {@debug breadcrumb}
            <li class="breadcrumb-list-item">
              <span class="mt-icon icon-circle">&nbsp;</span>
              {#if breadcrumb.bc_uri !== null}
                <a href={breadcrumb.bc_uri} class="mt-breadcrumb__item">
                  {breadcrumb.bc_name}
                </a>
              {/if}
              {#if breadcrumb.is_last}
                <span class="current">{breadcrumb.bc_name}</span>
              {/if}
            </li>
          {/each}
        {/if}
      </ul>
    </div>
  </div>
{/if}

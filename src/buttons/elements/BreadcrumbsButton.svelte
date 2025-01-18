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
  const handleClick = () => {
    open = true;
  };
  const handleClose = () => {
    open = false;
  };

  let buttonRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;

  let modalLeft = 0;
  $: if (buttonRef && modalRef) {
    const buttonRect = buttonRef.getBoundingClientRect();
    modalLeft = buttonRect.left + (buttonRect.width - modalRef.offsetWidth) / 2;
  }

  console.table(breadcrumbs);
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

<style>
  .mt-breadcrumb-button {
    background-color: #f4f4f4;
    border: none;
    outline: none;
    border-radius: 4px;
    display: inline-block;
    width: 26px;
    height: 26px;
    padding: 0;
    margin: 0;
    transform: rotate(90deg);
  }
  .breadcrumbs-modal {
    position: fixed;
    top: 45px;
    left: var(--modal-left);
    width: 400px;
    height: auto;
    background-color: #ffffff;
    z-index: 1002;
    display: block;
    overflow: visible;
    border-width: 1px 1px 1px 0px;
    border-style: solid;
    border-color: #e0e0e0;
    box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.25);
    border-radius: 0px 4px 4px 0px;
  }
  .breadcrumbs-modal::before {
    content: "";
    position: absolute;
    top: -9px;
    left: 50%;
    width: 16px;
    height: 16px;
    border-top: 1px solid #e0e0e0;
    transform: translateX(-50%) rotate(45deg);
    background: #fff;
    z-index: 0;
  }
  .modal-header {
    justify-content: flex-end;
    background-color: #ffffff;
    padding: 0;
  }

  .modal-header .close {
    color: #000000;
    padding: 12px;
  }
  .modal-header .close span {
    font-size: 30px;
    line-height: 0;
  }
  .modal-body {
    padding: 0 24px 28px 24px;
  }

  .breadcrumb-list {
    list-style: none;
    padding: 0;
  }

  .breadcrumb-list .breadcrumb-list-item {
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    position: relative;
    margin-bottom: 24px;
  }
  .breadcrumb-list .breadcrumb-list-item::after {
    position: absolute;
    content: "";
    display: block;
    background-color: #999999;
    mask: url('data:image/svg+xml;charset=UTF-8,<svg width="12" height="8" viewBox="0 0 12 8" xmlns="http://www.w3.org/2000/svg"><path d="M6 4.5999L1.4 -9.77516e-05L0 1.3999L6 7.3999L12 1.3999L10.6 -9.77516e-05L6 4.5999Z" /></svg>')
      no-repeat center center;
    height: 8px;
    width: 18px;
    bottom: -16px;
    left: 2px;
  }
  .breadcrumb-list .breadcrumb-list-item:last-of-type::after {
    display: none;
  }

  .icon-circle {
    margin-right: 8px;
    font-size: 12px;
    background-color: #f4f4f4;
    border-radius: 50%;
  }

  .breadcrumb-list a {
    text-decoration: underline;
    color: #007bff;
    display: block;
    width: 100%;
  }

  .breadcrumb-list .current {
    font-weight: bold;
    color: #333;
  }
</style>

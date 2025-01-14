<script lang="ts">
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { type ContentType } from "../../@types/contenttype";
  import SVG from "../../svg/elements/SVG.svelte";

  export let contentTypes: ContentType[] = [];
  export let blog_id: string;

  let open = false;
  const handleClick = () => {
    open = true;
  };
  const handleClose = () => {
    open = false;
  };

  let buttonRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;
  const clickEvent = (e: MouseEvent) => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([buttonRef, modalRef], eventTarget)) {
      handleClose();
    }
  };
</script>

<svelte:body on:click={clickEvent} />
<!-- svelte-ignore a11y-invalid-attribute -->
<a
  href="#"
  class="menu_actions__button create"
  on:click={handleClick}
  bind:this={buttonRef}
>
  <SVG
    title={window.trans("Create New")}
    class="mt-icon"
    href={`${window.StaticURI}images/admin2025/sprite.svg#ic_create`}
  />
  {window.trans("Create New")}
</a>

{#if open}
  <div
    class="modal create-button-modal"
    use:portal={"body"}
    bind:this={modalRef}
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
      <p class="block-title">{window.trans("Content Data")}</p>
      {#if contentTypes.length > 0}
        <ul class="create-button-list">
          {#each contentTypes as contentType}
            <li>
              <a
                href={`${window.CMSScriptURI}?__mode=edit&_type=content_data&content_type_id=${contentType.id}&type=content_data_${contentType.id}&blog_id=${blog_id}`}
              >
                {window.trans("New [_1] creation", contentType.name)}
              </a>
            </li>
          {/each}
        </ul>
      {:else}
        <p>{window.trans("No Content Type could be found.")}</p>
      {/if}
      <p class="block-title">
        {`${window.trans("Entry")}・${window.trans("Page")}`}
      </p>
      <ul class="create-button-list">
        <li>
          <a href={`${window.CMSScriptURI}?__mode=edit&_type=entry&blog_id=2`}>
            {window.trans("New [_1] creation", window.trans("Entry"))}
          </a>
        </li>
        <li>
          <a href={`${window.CMSScriptURI}?__mode=edit&_type=page&blog_id=2`}>
            {window.trans("New [_1] creation", window.trans("Page"))}
          </a>
        </li>
      </ul>
    </div>
  </div>
{/if}

<style>
  .create-button-modal {
    position: fixed;
    top: 50px;
    left: 0;
    width: 313px;
    height: 500px;
    background-color: #ffffff;
    z-index: 1001;
    display: block;
    overflow: auto;
    border-width: 1px 1px 1px 0px;
    border-style: solid;
    border-color: #e0e0e0;
    box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.25);
    border-radius: 0px 4px 4px 0px;
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
  .block-title {
    font-family: "Hiragino Sans";
    font-style: normal;
    font-weight: 700;
    font-size: 14px;
    line-height: 125%;
    margin-bottom: 8px;
  }
  .create-button-list {
    list-style: none;
    margin: 0 0 34px 0;
    padding: 0;
  }
  .create-button-list li {
    line-height: 100%;
    border-top: 1px solid #e0e0e0;
    display: flex;
    align-items: baseline;
    margin: 0;
    padding: 0 0 0 10px;
  }
  .create-button-list li:hover {
    background: #f4f4f4;
  }
  .create-button-list li:last-of-type {
    border-bottom: 1px solid #e0e0e0;
  }

  .create-button-list li a {
    display: block;
    color: #212529;
    text-decoration: none;
    padding: 16px 8px 16px 12px;
    font-weight: 400;
    font-size: 16px;
    line-height: 100%;
    width: 100%;
  }
  .create-button-list li:before {
    display: inline-block;
    content: "+";
    color: #000000;
    font-size: 24px;
    line-height: 100%;
  }
</style>

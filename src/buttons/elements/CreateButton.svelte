<script lang="ts">
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { type ContentType } from "../../@types/contenttype";
  import SVG from "../../svg/elements/SVG.svelte";

  export let contentTypes: ContentType[] = [];
  export let blog_id: string;

  let open = false;
  const handleClick = (): void => {
    open = true;
  };
  const handleClose = (): void => {
    open = false;
  };

  let buttonRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;
  const clickEvent = (e: MouseEvent): void => {
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
      {#if contentTypes.length > 0}
        <p class="block-title">{window.trans("Content Data")}</p>
        <ul class="create-button-list">
          {#each contentTypes as contentType}
            <li>
              <a
                href={`${window.CMSScriptURI}?__mode=view&_type=content_data&content_type_id=${contentType.id}&type=content_data_${contentType.id}&blog_id=${blog_id}`}
              >
                {window.trans("New [_1] creation", contentType.name)}
              </a>
            </li>
          {/each}
        </ul>
      {/if}
      <p class="block-title">
        {`${window.trans("Entry")}・${window.trans("Page")}`}
      </p>
      <ul class="create-button-list">
        <li>
          <a href={`${window.CMSScriptURI}?__mode=view&_type=entry&blog_id=2`}>
            {window.trans("New [_1] creation", window.trans("Entry"))}
          </a>
        </li>
        <li>
          <a href={`${window.CMSScriptURI}?__mode=view&_type=page&blog_id=2`}>
            {window.trans("New [_1] creation", window.trans("Page"))}
          </a>
        </li>
      </ul>
    </div>
  </div>
{/if}

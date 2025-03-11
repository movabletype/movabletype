<script lang="ts">
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { type ContentType } from "../../@types/contenttype";

  export let contentTypes: ContentType[] = [];
  export let blog_id: string;
  export let open: boolean = false;
  export let buttonRef: HTMLElement | null = null;
  export let anchorRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;

  $: {
    if (anchorRef) {
      // Adjust the top position of the modal
      if (modalRef) {
        const rect = anchorRef.getBoundingClientRect();
        const styleTop = `calc(${rect.bottom}px + 10px)`;
        modalRef.style.top = styleTop;
      }

      if (open) {
        anchorRef.classList.add("open");
      } else {
        anchorRef.classList.remove("open");
      }
    }
  }
  const handleClose = (): void => {
    open = false;
  };

  const clickEvent = (e: MouseEvent): void => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([buttonRef, modalRef], eventTarget)) {
      handleClose();
    }
  };
</script>

<svelte:body on:click={clickEvent} />

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
          <a
            href={`${window.CMSScriptURI}?__mode=view&_type=entry&blog_id=${blog_id}`}
          >
            {window.trans("New [_1] creation", window.trans("Entry"))}
          </a>
        </li>
        <li>
          <a
            href={`${window.CMSScriptURI}?__mode=view&_type=page&blog_id=${blog_id}`}
          >
            {window.trans("New [_1] creation", window.trans("Page"))}
          </a>
        </li>
      </ul>
    </div>
  </div>
{/if}

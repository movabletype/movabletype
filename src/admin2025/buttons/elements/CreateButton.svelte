<script lang="ts">
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { type ContentType } from "src/@types/contenttype";
  import { fetchContentTypes } from "src/utils/fetch-content-types";

  export let blog_id: string;
  export let magicToken: string;
  export let open: boolean = false;
  export let anchorRef: HTMLElement | null = null;
  export let containerRef: HTMLElement | null = null;
  let modalRef: HTMLElement | null = null;
  let contentTypesFetched = false;
  let isLoading = false;
  let contentTypes: ContentType[] = [];

  $: {
    if (anchorRef) {
      // Adjust the top position of the modal
      if (modalRef) {
        const rect = anchorRef.getBoundingClientRect();
        const styleTop = `calc(${rect.bottom}px + 10px)`;
        modalRef.style.top = styleTop;
        const styleMaxHeight = `calc(100vh - ${rect.bottom}px - 10px - 20px)`;
        modalRef.style.maxHeight = styleMaxHeight;
      }

      if (open) {
        anchorRef.classList.add("open");

        if (!contentTypesFetched && !isLoading) {
          isLoading = true;
          fetchContentTypes({
            blogId: blog_id,
            magicToken: magicToken,
          })
            .then((data) => {
              contentTypes = data.contentTypes.filter(
                (contentType) => contentType.can_create === 1,
              );
              contentTypesFetched = true;
              isLoading = false;
            })
            .catch((error) => {
              console.error("Failed to fetch content types:", error);
              isLoading = false;
            });
        }
      } else {
        anchorRef.classList.remove("open");
      }
    }
  }
  const handleClose = (): void => {
    open = false;
  };

  const clickEvent = (e: MouseEvent): void => {
    if (containerRef && containerRef.classList.contains("show")) {
      return;
    }

    const eventTarget = e.target as Node;
    if (open && isOuterClick([anchorRef, modalRef], eventTarget)) {
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
      {#if isLoading}
        <p>{window.trans("Loading...")}</p>
      {:else if contentTypes.length > 0}
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

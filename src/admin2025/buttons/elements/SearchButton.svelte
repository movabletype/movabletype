<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { modalOverlay } from "../../svelte/action";
  import type { ContentType } from "src/@types/contenttype";
  import type { SearchTab } from "../search-button";
  import SearchForm from "../../forms/search/SearchForm.svelte";
  import { fetchContentTypes } from "src/utils/fetch-content-types";

  type Props = {
    blogId: string;
    magicToken: string;
    open: boolean;
    anchorRef: HTMLElement;
    searchTabs: SearchTab[];
    objectType: string;
  };
  let {
    blogId,
    magicToken,
    open = false,
    anchorRef,
    searchTabs,
    objectType,
  }: Props = $props();
  export { blogId, magicToken, open, anchorRef, searchTabs, objectType };

  let contentTypes: ContentType[] = $state([]);
  let contentTypesFetched = false;
  let isLoading = $state(false);

  $effect(() => {
    if (anchorRef) {
      if (open) {
        anchorRef.classList.add("open");

        if (!contentTypesFetched && !isLoading) {
          isLoading = true;
          fetchContentTypes({
            blogId: blogId,
            magicToken: magicToken,
          })
            .then((data) => {
              contentTypes = data.contentTypes.filter(
                (contentType) => contentType.can_search === 1,
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
  });

  const handleClose = (): void => {
    open = false;
  };

  let modalRef: HTMLElement | null = $state(null);
  const clickEvent = (e: MouseEvent): void => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([anchorRef, modalRef], eventTarget)) {
      handleClose();
    }
  };

  let searchTextRef: HTMLInputElement | null = null;
  $effect(() => {
    if (open && searchTextRef) {
      // searchTextRef.focus();
    }
  });

  onMount(async () => {
    if (objectType) {
      // If objectType is set and does not exist in searchTabs, select the first one
      if (!searchTabs.find((tab) => tab.key === objectType)) {
        objectType = searchTabs[0].key;
      }
    } else {
      // If objectType is not set, select the first one
      objectType = searchTabs[0].key;
    }
  });
</script>

<svelte:body onclick={clickEvent} />

{#if open}
  <!-- svelte-ignore a11y_click_events_have_key_events -->
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div
    class="search-button-modal-overlay"
    onclick={handleClose}
    use:portal={"body"}
    use:modalOverlay
  ></div>
  <div
    class="modal search-button-modal"
    bind:this={modalRef}
    use:portal={"body"}
  >
    <div class="modal-header">
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-label="Close"
        onclick={handleClose}
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <SearchForm
        {blogId}
        {magicToken}
        {contentTypes}
        {objectType}
        {searchTabs}
        {isLoading}
      />
    </div>
  </div>
{/if}

<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { ContentType } from "src/@types/contenttype";
  import { SearchTab } from "../search-button";
  import SearchForm from "../../forms/search/SearchForm.svelte";

  export let blogId: string;
  export let magicToken: string;
  export let contentTypes: ContentType[] = [];
  export let open: boolean = false;
  export let buttonRef: HTMLElement;
  export let anchorRef: HTMLElement;
  export let searchTabs: SearchTab[];
  export let objectType;

  $: {
    if (anchorRef) {
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

  let modalRef: HTMLElement | null = null;
  const clickEvent = (e: MouseEvent): void => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([buttonRef, modalRef], eventTarget)) {
      handleClose();
    }
  };

  let searchTextRef: HTMLInputElement | null = null;
  $: {
    if (open && searchTextRef) {
      searchTextRef.focus();
    }
  }

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

<svelte:body on:click={clickEvent} />

{#if open}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-static-element-interactions -->
  <div
    class="search-button-modal-overlay"
    on:click={handleClose}
    use:portal={"body"}
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
        on:click={handleClose}
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <SearchForm
        blogId={blogId}
        magicToken={magicToken}
        contentTypes={contentTypes}
        objectType={objectType}
        searchTabs={searchTabs}
      />
    </div>
  </div>
{/if}

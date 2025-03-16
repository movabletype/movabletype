<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { ContentType } from "src/@types/contenttype";
  import SVG from "../../svg/elements/SVG.svelte";
  import { SearchTab } from "../search-button";

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
      <form class="search-form" method="post" action={window.ScriptURI}>
        <input type="hidden" name="__mode" value="search_replace" />
        <input type="hidden" name="blog_id" value={blogId} />
        <input type="hidden" name="_type" bind:value={objectType} />
        <input type="hidden" name="do_search" value="1" />
        <input type="hidden" name="magic_token" value={magicToken} />

        <div class="search-type">
          {#each searchTabs as type}
            <label>
              <input
                type="radio"
                name="type"
                value={type.key}
                id={type.key}
                bind:group={objectType}
              />
              {type.label}
            </label>
          {/each}
        </div>
        <div class="search-content-type">
          <select
            class="custom-select form-control form-select"
            class:disabled={objectType !== "content_data"}
            name="content_type_id"
            disabled={objectType !== "content_data" ||
              contentTypes.length === 0}
          >
            {#if contentTypes.length > 0}
              {#each contentTypes as contentType}
                <option value={contentType.id}>{contentType.name}</option>
              {/each}
            {:else}
              <option value=""
                >{window.trans("No Content Type could be found.")}</option
              >
            {/if}
          </select>
        </div>
        <div class="search-text-box">
          <input
            type="text"
            placeholder={window.trans("Select target and search text...")}
            name="search"
            bind:this={searchTextRef}
          />
        </div>
        <div class="submit-button">
          <button type="submit" class="btn btn-primary">
            <SVG
              title={window.trans("Search")}
              class="mt-icon mt-icon--sm"
              href={`${window.StaticURI}images/admin2025/sprite.svg#ic_search`}
            />
            <span>{window.trans("Search")}</span>
          </button>
        </div>
      </form>
    </div>
  </div>
{/if}

<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { ContentType } from "src/@types/contenttype";
  import SVG from "../../svg/elements/SVG.svelte";

  export let blogId: string;
  export let magicToken: string;
  export let contentTypes: ContentType[] = [];

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

  const objectTypes: Array<{ value: string; label: string }> = [
    {
      value: "content_data",
      label: window.trans("Content Data"),
    },
    {
      value: "entry",
      label: window.trans("Entry"),
    },
    {
      value: "comment",
      label: window.trans("Comment"),
    },
    {
      value: "page",
      label: window.trans("Page"),
    },
    {
      value: "template",
      label: window.trans("Template"),
    },
    {
      value: "asset",
      label: window.trans("Asset"),
    },
    {
      value: "log",
      label: window.trans("Log"),
    },
    {
      value: "blog",
      label: window.trans("Child Site"),
    },
  ];

  let searchTextRef: HTMLInputElement | null = null;
  let objectType = "entry";
  onMount(async () => {
    if (contentTypes.length > 0) {
      objectType = "content_data";
    }
  });

  $: {
    if (open && searchTextRef) {
      searchTextRef.focus();
    }
  }
</script>

<svelte:body on:click={clickEvent} />
<!-- svelte-ignore a11y-invalid-attribute -->
<a
  href="#"
  class="action mt-actionSearch"
  class:open
  on:click={handleClick}
  bind:this={buttonRef}
>
  <SVG
    title={window.trans("Search")}
    class="mt-icon"
    href={`${window.StaticURI}images/sprite.svg#ic_search`}
  />

  {window.trans("Search")}
</a>

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
        <input
          type="hidden"
          name="blog_id"
          value={objectType !== "blog" ? blogId : "0"}
        />
        <input type="hidden" name="_type" bind:value={objectType} />
        <input type="hidden" name="do_search" value="1" />
        <input type="hidden" name="magic_token" value={magicToken} />

        <div class="search-type">
          <label>
            <input
              type="radio"
              name="type"
              value="content_data"
              id="content_data"
              bind:group={objectType}
              disabled={contentTypes.length === 0}
            />
            {window.trans("Content Data")}
          </label>
          {#each objectTypes.slice(1) as type}
            <label>
              <input
                type="radio"
                name="type"
                value={type.value}
                id={type.value}
                bind:group={objectType}
              />
              {type.label}
            </label>
          {/each}
        </div>
        <div class="search-content-type">
          <select
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
              href={`${window.StaticURI}images/sprite.svg#ic_search`}
            />
            <span>{window.trans("Search")}</span>
          </button>
        </div>
      </form>
    </div>
  </div>
{/if}

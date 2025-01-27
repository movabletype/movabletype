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
  let objectType = "entry";
  onMount(async () => {
    if (contentTypes.length > 0) {
      objectType = "content_data";
    }
  });
</script>

<svelte:body on:click={clickEvent} />
<!-- svelte-ignore a11y-invalid-attribute -->
<a
  href="#"
  class="action mt-actionSearch"
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

        <div class="search-text-box">
          <input
            type="text"
            placeholder={window.trans("Select target and search text")}
            name="search"
          />
          <button type="submit">
            <SVG
              title={window.trans("Search")}
              class="mt-icon"
              href={`${window.StaticURI}images/sprite.svg#ic_search`}
            />
          </button>
        </div>
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
          </label>
        </div>
        <div class="search-type">
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
      </form>
    </div>
  </div>
{/if}

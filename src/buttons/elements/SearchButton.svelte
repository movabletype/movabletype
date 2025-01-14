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

<style>
  .search-button-modal-overlay {
    position: fixed;
    top: 45px;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1001;
  }
  .search-button-modal {
    position: fixed;
    top: 45px;
    left: 0;
    width: 100vw;
    height: 164px;
    background-color: #ffffff;
    z-index: 1002;
    display: block;
    overflow: auto;
    border-width: 1px 1px 1px 0px;
    border-style: solid;
    border-color: #e0e0e0;
    box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.25);
    border-radius: 0px 4px 4px 0px;
  }
  .modal-body {
    padding: 12px 24px 28px 24px;
  }
  .search-form {
    display: flex;
    flex-direction: column;
  }
  .search-form .search-type {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
  }
  .search-form input[type="text"] {
    margin-bottom: 16px;
    padding: 8px;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
  }
  .search-form input[type="radio"] {
    margin: 0 8px;
  }
  .search-form label {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    align-items: center;
    margin: 0 8px 8px;
  }
  .search-form select {
    margin: 0 8px 8px;
    min-width: 336px;
    height: 32px;
    border: 1px solid #cbcbcb;
    border-radius: 7px;
  }
  .search-form select.disabled {
    background: #e0e0e0;
  }
  .search-text-box {
    position: relative;
    display: flex;
    width: 100%;
  }

  .search-text-box input[type="text"] {
    flex-grow: 1;
    padding: 8px;
    background: #ffffff;
    border: 1px solid #cbcbcb;
    border-radius: 7px;
  }

  .search-text-box button {
    position: absolute;
    top: -0.05rem;
    right: 0;
    cursor: pointer;
    padding: 0.8rem 0.9rem 0.8rem 0.8rem;
    border-radius: 0 1.5rem 1.5rem 0;
    border: none;
    background: none;
    color: #333;
    font-size: 1rem;
    transition: 0.5s;
    background-image: url();
  }
</style>

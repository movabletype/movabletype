<script lang="ts">
  import SVG from "../../../svg/elements/SVG.svelte";
  import type { ContentType } from "src/@types/contenttype";
  import type { SearchTab } from "src/admin2025/buttons/search-button";

  export let blogId: string;
  export let magicToken: string;
  export let contentTypes: ContentType[] = [];
  export let searchTabs: SearchTab[] = [];
  export let objectType: string;
  export let isLoading: boolean = false;
  let searchContentTypeId: string = "";
  let searchTextRef: HTMLInputElement | null = null;

  $: {
    if (searchTextRef) {
      searchTextRef.focus();
    }
    if (!searchContentTypeId && contentTypes.length > 0) {
      searchContentTypeId = contentTypes[0].id;
    }
  }

  const submit = (event: Event): void => {
    event.preventDefault();

    const form = document.createElement("form");
    form.method = "POST";
    form.action = window.ScriptURI;

    const hiddenInput = (name: string, value: string): HTMLInputElement => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = name;
      input.value = value;
      return input;
    };

    const searchText = searchTextRef?.value.trim() || "";
    form.appendChild(hiddenInput("__mode", "search_replace"));
    form.appendChild(hiddenInput("blog_id", blogId));
    form.appendChild(hiddenInput("_type", objectType));
    form.appendChild(hiddenInput("do_search", "1"));
    form.appendChild(hiddenInput("magic_token", magicToken));
    form.appendChild(hiddenInput("search", searchText));
    form.appendChild(hiddenInput("content_type_id", searchContentTypeId || ""));
    form.appendChild(hiddenInput("object_type", objectType));

    document.body.appendChild(form);
    form.submit();
  };
</script>

<div class="mt-search-form">
  <div class="search-type">
    {#each searchTabs as type}
      <label>
        <input
          type="radio"
          value={type.key}
          checked={objectType === type.key}
          bind:group={objectType}
        />
        {type.label}
      </label>
    {/each}
  </div>

  <div class="search-content-type">
    {#if isLoading}
      <p>{window.trans("Loading...")}</p>
    {:else}
      <select
        class="custom-select form-control form-select"
        class:disabled={objectType !== "content_data"}
        disabled={objectType !== "content_data" || contentTypes.length === 0}
        bind:value={searchContentTypeId}
      >
        {#if contentTypes.length > 0}
          {#each contentTypes as contentType}
            <option value={contentType.id}>{contentType.name}</option>
          {/each}
        {:else}
          <option value="">
            {window.trans("No Content Type could be found.")}
          </option>
        {/if}
      </select>
    {/if}
  </div>

  <div class="search-input-group">
    <div class="search-text-box">
      <input
        type="text"
        placeholder={window.trans("Select target and search text...")}
        bind:this={searchTextRef}
        on:keydown={(event) => {
          if (event.key === "Enter" && !event.isComposing) {
            submit(event);
          }
        }}
      />
    </div>

    <div class="submit-button">
      <button type="button" class="btn btn-primary" on:click={submit}>
        <SVG
          title={window.trans("Search")}
          class="mt-icon mt-icon--sm"
          href={`${window.StaticURI}images/admin2025/sprite.svg#ic_search`}
        />
        <span>{window.trans("Search")}</span>
      </button>
    </div>
  </div>
</div>

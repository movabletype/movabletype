<script lang="ts">
  import SVG from "../../../svg/elements/SVG.svelte";
  import type { ContentType } from "src/@types/contenttype";
  import type { SearchTab } from "src/admin2025/buttons/search-button";

  export let blogId: string;
  export let magicToken: string;
  export let contentTypes: ContentType[] = [];
  export let searchTabs: SearchTab[] = [];
  export let objectType: string;

  let searchTextRef: HTMLInputElement | null = null;

  $: {
    if (searchTextRef) {
      searchTextRef.focus();
    }
  }
</script>

<form class="mt-search-form" method="post" action={window.ScriptURI}>
  <input type="hidden" name="__mode" value="search_replace" />
  <input type="hidden" name="blog_id" value={blogId} />
  <input type="hidden" name="_type" value={objectType} />
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
          checked={objectType === type.key}
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
      disabled={objectType !== "content_data" || contentTypes.length === 0}
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
  </div>

  <div class="search-input-group">
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
  </div>
</form>

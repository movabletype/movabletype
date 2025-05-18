<script lang="ts">
  import { onMount } from "svelte";
  import SVG from "../../svg/elements/SVG.svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { fetchSites } from "src/utils/fetch-sites";
  import { Site } from "src/@types/site";

  export let magicToken: string;
  export let limit: number = 50;
  export let open: boolean = false;
  export let buttonRef: HTMLElement;
  export let anchorRef: HTMLElement;
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

  let sites: Site[] = [];
  let totalCount = 0;
  let page = 1;
  let pageMax = 1;
  let siteType = "parent_sites";
  let filterSiteName = "";
  let items: Array<{
    type: string;
    args: {
      string?: string;
      option?: string;
      value?: string;
    };
  }> = [];
  let loading = false;
  let modalRef: HTMLElement | null = null;

  const nextPage = (): void => {
    page++;
    _fetchSites();
  };
  const lastPage = (): void => {
    page = pageMax;
    _fetchSites();
  };
  const prevPage = (): void => {
    page--;
    _fetchSites();
  };
  const firstPage = (): void => {
    page = 1;
    _fetchSites();
  };
  const filterApply = (): void => {
    items = [];
    if (siteType === "child_sites_only") {
      items = [{ type: "parent_website", args: { value: "" } }];
    } else if (siteType === "parent_sites") {
      items = [{ type: "parent_website", args: { value: "1" } }];
    }
    filterSiteName = filterSiteName.trim();
    if (filterSiteName !== "") {
      items.push({
        type: "name",
        args: { string: filterSiteName, option: "contains" },
      });
    }
    page = 1;
    _fetchSites();
  };

  const _fetchSites = async (): Promise<void> => {
    loading = true;

    // data loading
    const result = await fetchSites({
      magicToken: magicToken,
      items: items,
      page: page,
      limit: limit,
    });

    // data setting
    totalCount = result.count;
    pageMax = result.pageMax;
    page = pageMax !== 0 ? result.page : 0;
    sites = result.sites;

    loading = false;
  };

  const clickEvent = (e: MouseEvent): void => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([buttonRef, modalRef], eventTarget)) {
      handleClose();
    }
  };
  onMount(async () => {
    filterApply();
  });
</script>

<svelte:body on:click={clickEvent} />

{#if open}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-static-element-interactions -->
  <div
    class="site-list-button-modal-overlay"
    on:click={handleClose}
    use:portal={"body"}
  ></div>
  <div
    class="modal site-list-button-modal"
    use:portal={"body"}
    bind:this={modalRef}
  >
    <div class="modal-body">
      <div class="site-list-container">
        <div class="site-list-header">
          <div class="site-list-title">
            <span>({window.trans("[_1]Site", totalCount.toString())})</span>
            <p>{window.trans("Site List")}</p>
          </div>

          <div class="site-list-actions">
            <div class="prev-next">
              <button
                type="button"
                on:click={firstPage}
                on:keydown={(e) => e.key === "Enter" && firstPage()}
                disabled={page <= 1}>&lt;&lt;</button
              >
              <button
                type="button"
                on:click={prevPage}
                on:keydown={(e) => e.key === "Enter" && prevPage()}
                disabled={page <= 1}>&lt;</button
              >
              <span class="page-num"
                ><span class="current">{page}</span>/{pageMax}</span
              >
              <button
                type="button"
                on:click={nextPage}
                on:keydown={(e) => e.key === "Enter" && nextPage()}
                disabled={page === pageMax}>&gt;</button
              >
              <button
                type="button"
                on:click={lastPage}
                on:keydown={(e) => e.key === "Enter" && lastPage()}
                disabled={page === pageMax}>&gt;&gt;</button
              >
            </div>
            <div class="site-type-filter">
              <select
                bind:value={siteType}
                on:change={filterApply}
                class="custom-select form-control form-select"
              >
                <option value="parent_sites">{window.trans("Parent Sites")}</option>
                <option value="parent_and_child_sites">{window.trans("Parent and child sites")}</option>
                <option value="child_sites_only">{window.trans("Only to child sites within this system")}</option>
              </select>
            </div>
            <div class="site-name-filter">
              <input
                type="text"
                placeholder={window.trans("Filter by site name")}
                bind:value={filterSiteName}
                on:keydown={(e) => e.key === "Enter" && filterApply()}
              />
              <button on:click={filterApply}>
                <SVG
                  title={window.trans("Search")}
                  class="mt-icon"
                  href={`${window.StaticURI}images/admin2025/sprite.svg#ic_search`}
                />
              </button>
            </div>
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
        </div>
        <div class="site-list-table-header">
          <span class="table-header-col site-list-header-name">
            {window.trans("Site Name")}
          </span>
          <span class="table-header-col site-list-header-parent">
            {window.trans("Parent Site")}
          </span>
        </div>
        <div class="site-list-table-wrapper">
          <table>
            <tbody>
              {#if loading}
                <tr>
                  <td colspan="2" class="loading"
                    >{window.trans("Loading...")}</td
                  >
                </tr>
              {:else}
                {#each sites as site}
                  <tr>
                    <td>
                      <a
                        href={`${window.ScriptURI}?__mode=dashboard&blog_id=${site.id}`}
                        class="dashboard-link"
                      >
                        <SVG
                          title={window.trans("Site")}
                          class="mt-icon mt-icon--sm"
                          href={`${window.StaticURI}images/admin2025/sprite.svg#${site.parentSiteName !== "-" ? "ic_subsites" : "ic_sites"}`}
                        />
                        {site.name}
                      </a>
                      <a href={site.siteUrl} class="site-link" target="_blank">
                        <SVG
                          title={window.trans("View your site.")}
                          class="mt-icon mt-icon--sm"
                          href={`${window.StaticURI}images/admin2025/sprite.svg#ic_permalink`}
                        />
                      </a>
                    </td>
                    <td>
                      {site.parentSiteName}
                    </td>
                  </tr>
                {/each}
              {/if}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
{/if}

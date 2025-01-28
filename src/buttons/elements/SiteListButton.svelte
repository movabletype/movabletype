<script lang="ts">
  import { onMount } from "svelte";
  import SVG from "../../svg/elements/SVG.svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { fetchSites } from "src/utils/fetch-sites";
  import { Site } from "src/@types/site";

  export let magicToken: string;
  export let limit: number = 50;

  let open = false;
  let oldOverflow: string;
  const handleClick = (): void => {
    open = true;
    oldOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
  };
  const handleClose = (): void => {
    open = false;
    document.body.style.overflow = oldOverflow;
  };

  let sites: Site[] = [];
  let totalCount = 0;
  let page = 1;
  let pageMax = 1;
  let siteType = "";
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
  let buttonRef: HTMLElement | null = null;
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
    if (siteType === "blog") {
      items = [{ type: "parent_website", args: { value: "" } }];
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
    _fetchSites();
  });
</script>

<svelte:body on:click={clickEvent} />
<!-- svelte-ignore a11y-invalid-attribute -->
<a
  href="#"
  class="action mt-actionSite"
  on:click={handleClick}
  bind:this={buttonRef}
>
  <svg
    width="20"
    height="19"
    viewBox="0 0 20 19"
    xmlns="http://www.w3.org/2000/svg"
    role="img"
    class="mt-icon"
  >
    <path
      d="M11.75 16.25V14H8.75V6.5H7.25V8.75H2V2.75H7.25V5H11.75V2.75H17V8.75H11.75V6.5H10.25V12.5H11.75V10.25H17V16.25H11.75Z"
      fill="#212529"
    />
  </svg>
  {window.trans("Site")}
</a>

{#if open}
  <div
    class="modal site-list-button-modal"
    use:portal={"body"}
    bind:this={modalRef}
  >
    <div class="modal-body">
      <div class="site-list-table">
        <div class="site-list-table-header">
          <div class="table-title">
            <span>({window.trans("[_1]Site", totalCount.toString())})</span>
            <p>{window.trans("Site List")}</p>
          </div>

          <div class="table-control">
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
              <select bind:value={siteType} on:change={filterApply}>
                <option value="">{window.trans("All Sites")}</option>
                <option value="blog">
                  {window.trans("Only to child sites within this system")}
                </option>
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
                  href={`${window.StaticURI}images/sprite.svg#ic_search`}
                />
              </button>
            </div>
            <div class="close">
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
        </div>
        <table>
          <thead>
            <tr>
              <th>
                {window.trans("Site Name")}
              </th>
              <th>
                {window.trans("Parent Site")}
              </th>
            </tr>
          </thead>
          <tbody>
            {#if loading}
              <tr>
                <td colspan="2" class="loading">{window.trans("Loading...")}</td
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
                        href={`${window.StaticURI}images/sprite.svg#ic_sites`}
                      />{site.name}</a
                    >
                    <a href={site.siteUrl} class="site-link" target="_blank">
                      <SVG
                        title={window.trans("View your site.")}
                        class="mt-icon mt-icon--sm"
                        href={`${window.StaticURI}images/sprite.svg#ic_permalink`}
                      />
                    </a>
                  </td>
                  <td>
                    {#if site.parentSiteName}
                      {site.parentSiteName}
                    {:else}
                      <span class="text-center">-</span>
                    {/if}
                  </td>
                </tr>
              {/each}
            {/if}
          </tbody>
        </table>
      </div>
    </div>
  </div>
{/if}

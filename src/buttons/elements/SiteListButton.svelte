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
  const handleClick = () => {
    open = true;
    oldOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
  };
  const handleClose = () => {
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

  const nextPage = () => {
    page++;
    _fetchSites();
  };
  const lastPage = () => {
    page = pageMax;
    _fetchSites();
  };
  const prevPage = () => {
    page--;
    _fetchSites();
  };
  const firstPage = () => {
    page = 1;
    _fetchSites();
  };
  const filterApply = () => {
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

  const _fetchSites = async () => {
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
    page = result.page;
    sites = result.sites;

    loading = false;
  };

  const clickEvent = (e: MouseEvent) => {
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
                disabled={page === 1}>&lt;&lt;</button
              >
              <button
                type="button"
                on:click={prevPage}
                on:keydown={(e) => e.key === "Enter" && prevPage()}
                disabled={page === 1}>&lt;</button
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

<style>
  .site-list-button-modal {
    position: absolute;
    top: 50px;
    left: 0;
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    background-color: #ffffff;
    z-index: 1001;
    display: block;
    overflow: auto;
    border-width: 1px 1px 1px 0px;
    border-style: solid;
    border-color: #e0e0e0;
    box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.25);
    border-radius: 0px 4px 4px 0px;
  }
  .modal-body {
    padding: 0;
    max-height: none;
  }
  .close {
    color: #000000;
    padding: 12px;
  }
  .close span {
    font-size: 30px;
    line-height: 0;
  }
  .site-list-table-header {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    background-color: #f4f4f4;
    position: fixed;
    z-index: 1;
    top: 50px;
    left: 0;
    right: 0;
    padding: 12px 16px;
    border-bottom: 1px solid #cbcbcb;
  }
  .table-title span {
    font-family: "Inter";
    font-style: normal;
    font-weight: 400;
    font-size: 12px;
    line-height: 125%;
  }
  .table-title p {
    font-family: "Hiragino Sans";
    font-style: normal;
    font-weight: 400;
    font-size: 21px;
    line-height: 125%;
  }
  .table-control {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    align-items: center;
  }
  .prev-next {
    margin-right: 21px;
  }
  .prev-next button {
    width: 32px;
    height: 32px;

    background: #ffffff;
    border: 1px solid #cbcbcb;
    border-radius: 4px;
  }
  .prev-next button:disabled {
    background: #f4f4f4;
  }
  .page-num {
    font-family: "Inter";
    font-style: normal;
    font-weight: 500;
    font-size: 16px;
    line-height: 125%;
    color: #000000;
    margin: 0 12px;
  }
  .page-num .current {
    font-size: 22px;
  }
  .site-type-filter {
    height: 40px;
    background: #ffffff;
    margin-right: 7px;
  }
  .site-type-filter select {
    height: 100%;
    border: 1px solid #cbcbcb;
    border-radius: 7px;
  }
  .site-name-filter {
    position: relative;
    min-width: 240px;
    max-width: 320px;
    height: 40px;

    background: #ffffff;
    border: 1px solid #cbcbcb;
    border-radius: 7px;
  }
  .site-name-filter input[type="text"] {
    flex-grow: 1;
    padding: 8px 34px 8px 8px;
    background: #ffffff;
    border: none;
    outline: none;
    width: 100%;
    border-radius: 7px;
  }

  .site-name-filter button {
    position: absolute;
    top: 0;
    right: 0;
    cursor: pointer;
    padding: 8px;
    border: none;
    background: none;
    color: #7a7a7a;
    font-size: 14px;
  }

  .site-list-table {
    padding-bottom: 30px;
    overflow: auto;
  }
  .site-list-table table {
    width: 100%;
    table-layout: fixed;
    border-spacing: 0;
    border-collapse: separate;
    position: relative;
    margin-top: 88px;
    margin-bottom: 30px;
  }
  .site-list-table tr {
    text-align: left;
    background: #ffffff;
  }
  .site-list-table th {
    text-align: left;
    background: #f4f4f4;
    border-bottom: 1px solid #cbcbcb;
    padding: 14px 16px;
    width: 70%;
  }
  .site-list-table th:last-child {
    width: 30%;
  }
  .site-list-table tbody {
    overflow-y: scroll;
  }
  .site-list-table td {
    font-size: 14px;
    line-height: 125%;
    color: #212529;
    vertical-align: middle;
    padding: 14px 16px;
  }
  .site-list-table tbody tr {
    position: relative;
  }
  .site-list-table tbody tr:after {
    content: "";
    display: block;
    width: calc(100% - 16px * 2);
    border-bottom: 1px solid #cbcbcb;
    position: absolute;
    bottom: 0;
    left: 16px;
    right: 0;
  }
  .site-list-table td.loading {
    text-align: center;
  }
  .site-list-table td a {
    display: inline-block;
  }
  .dashboard-link {
    margin-right: 10px;
  }

  :global(.dashboard-link .mt-icon) {
    margin-right: 7px;
  }
</style>

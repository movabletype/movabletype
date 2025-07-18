<script lang="ts">
  import { tick } from "svelte";
  import SVG from "../../../svg/elements/SVG.svelte";
  import { portal } from "svelte-portal";
  import { isOuterClick } from "../outerClick";
  import { fetchSites } from "src/utils/fetch-sites";
  import { Site } from "src/@types/site";

  export let magicToken: string;
  export let limit: number = 50;
  export let open: boolean = false;
  export let anchorRef: HTMLElement;
  export let initialStarredSites: number[];

  let sitesFetched = false;

  $: {
    if (anchorRef) {
      if (open) {
        anchorRef.classList.add("open");
        if (!sitesFetched) {
          sitesFetched = true;
          filterApply();
        }
      } else {
        anchorRef.classList.remove("open");
      }
    }
  }

  const handleClose = (): void => {
    open = false;
  };

  let starredSiteStore: Record<number, Site> = {};
  let siteStore: Site[] = [];
  let activeStarredSites: number[] = [];

  let sites: Site[] = [];
  let starredSites: number[] = initialStarredSites; // copy to local variable
  let totalCount = 0;
  let page = 1;
  let pageMax = 1;
  let siteType: "parent_sites" | "parent_and_child_sites" | "child_sites_only" =
    "parent_and_child_sites";
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
    siteStore = [];
    activeStarredSites = starredSites; // save current starred sites for this filter session

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

    sites = [];

    if (siteStore.length === 0) {
      // initial data loading
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

      const notFoundStarredSites: number[] = [];
      activeStarredSites.forEach((id) => {
        const index = result.sites.findIndex((site) => Number(site.id) === id);
        if (index !== -1) {
          starredSiteStore[id] = result.sites[index];
          result.sites.splice(index, 1);
        } else {
          const site = starredSiteStore[id];
          if (!site) {
            notFoundStarredSites.push(id);
          } else {
            const isChildSite = site.parentSiteName.match(/^<a/);
            if (
              (siteType === "child_sites_only" && !isChildSite) ||
              (siteType === "parent_sites" && isChildSite)
            ) {
              activeStarredSites = activeStarredSites.filter(
                (_id) => _id !== id,
              );
            }
          }
        }
      });
      siteStore = [...result.sites];

      if (notFoundStarredSites.length > 0) {
        const result = await fetchSites({
          magicToken: magicToken,
          items: [
            ...items,
            {
              type: "pack",
              args: {
                op: "or",
                items: notFoundStarredSites.map((id) => ({
                  type: "id",
                  args: { value: id, option: "equal" },
                })),
              },
            },
          ],
          page: 0,
          limit: 200, // FIXME: 200 is a magic number
        });
        notFoundStarredSites.forEach((id) => {
          const index = result.sites.findIndex(
            (site) => Number(site.id) === id,
          );
          if (index !== -1) {
            starredSiteStore[id] = result.sites[index];
          } else {
            activeStarredSites = activeStarredSites.filter((_id) => _id !== id);
            // this siteId is not longer available
            starredSites = starredSites.filter((_id) => _id !== id);
          }
        });
      }

      for (let i = 0; i < limit && i < activeStarredSites.length; i++) {
        sites.push(starredSiteStore[activeStarredSites[i]]);
      }
      for (let i = 0; i < siteStore.length && sites.length < limit; i++) {
        sites.push(siteStore[i]);
      }
    } else {
      const favSiteCount = activeStarredSites.length;
      const offset = (page - 1) * limit;
      for (let i = offset; i < favSiteCount && sites.length < limit; i++) {
        sites.push(starredSiteStore[activeStarredSites[i]]);
      }
      for (
        let i = Math.max(offset - favSiteCount, 0);
        i < totalCount - favSiteCount && sites.length < limit;
        i++
      ) {
        if (!siteStore[i]) {
          const page = Math.floor(i / limit);
          const result = await fetchSites({
            magicToken,
            items: [
              ...items,
              ...activeStarredSites.map((id) => ({
                type: "id",
                args: { value: id, option: "not_equal" },
              })),
            ],
            page: page + 1, // listing framework's page parameter is 1-indexed
            limit,
          });
          const storeOffset = page * limit;
          for (let j = 0; j < result.sites.length; j++) {
            siteStore[storeOffset + j] = result.sites[j];
          }
        }
        sites.push(siteStore[i]);
      }
    }

    loading = false;
  };

  const _saveStarredSites = async (starredSites: number[]): Promise<void> => {
    const body = new FormData();
    body.append("__mode", "save_starred_sites");
    body.append("magic_token", magicToken);
    starredSites.forEach((id) => {
      body.append("id", String(id));
    });
    return fetch(window.ScriptURI, {
      method: "POST",
      body,
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.error) {
          throw new Error(data.error);
        }
      });
  };

  const updateStarredSites = (newStarredSites: number[]): void => {
    const oldStarredSites = [...starredSites];
    starredSites = newStarredSites;
    _saveStarredSites(starredSites).catch((err) => {
      alert(err.message);
      starredSites = oldStarredSites;
    });
  };

  const addStarredSite = (e: MouseEvent, site: Site): void => {
    e.stopPropagation();
    updateStarredSites([...new Set([...starredSites, Number(site.id)])]);
  };

  const removeStarredSite = (e: MouseEvent, site: Site): void => {
    e.stopPropagation();
    const siteId = Number(site.id);
    updateStarredSites(starredSites.filter((id) => id !== siteId));
  };

  const clickEvent = (e: MouseEvent): void => {
    const eventTarget = e.target as Node;
    if (open && isOuterClick([anchorRef, modalRef], eventTarget)) {
      handleClose();
    }
  };

  let tableBodyRef: HTMLElement | null = null;
  const initSortable = async (): Promise<void> => {
    await tick();
    if (!tableBodyRef) {
      return;
    }
    jQuery(tableBodyRef).sortable({
      delay: 100,
      distance: 3,
      items: "tr[data-is-starred]",
      handle: ".site-list-table-sortable-handle",
      opacity: 0.8,
      start: function (_, ui) {
        if (!tableBodyRef) {
          return;
        }
        const columnSizePlaceholder = document.createElement("tr");
        columnSizePlaceholder.classList.add("site-list-table-placeholder");
        columnSizePlaceholder.innerHTML =
          "<td></td><td class='site-list-table-parent-site'></td><td class='site-list-table-action'></td>";
        tableBodyRef.insertBefore(
          columnSizePlaceholder,
          tableBodyRef.firstChild,
        );
        ui.placeholder.height(ui.item.height() as number);
      },
      stop: function () {
        tableBodyRef?.querySelector(".site-list-table-placeholder")?.remove();
      },
      update: () => {
        if (!tableBodyRef) {
          return;
        }

        const updatedSites: Site[] = [];
        const updatedStarredSites: number[] = [];
        tableBodyRef
          .querySelectorAll<HTMLTableRowElement>("tr[data-site-id]")
          .forEach((elm) => {
            const siteId = Number(elm.dataset.siteId);
            if (elm.dataset.isStarred) {
              updatedStarredSites.push(Number(siteId));
            }
            updatedSites.push(
              sites.find((site) => Number(site.id) === siteId) as Site,
            );
          });
        sites = updatedSites;

        // Find the index of the first siteId to replace if paginated
        const index = starredSites.findIndex((id) =>
          updatedStarredSites.includes(id),
        );
        starredSites = [...starredSites]; // clone
        starredSites.splice(
          index,
          updatedStarredSites.length,
          ...updatedStarredSites,
        );
        updateStarredSites(starredSites);
      },
    });
  };

  $: {
    if (sites && sites.length > 0 && open && !loading) {
      initSortable();
    }
  }
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
            <div class="d-block d-md-none">
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
            <div class="site-filter-actions">
              <div class="site-type-filter">
                <select
                  bind:value={siteType}
                  on:change={filterApply}
                  class="custom-select form-control form-select"
                >
                  <option value="parent_sites"
                    >{window.trans("Parent Sites")}</option
                  >
                  <option value="parent_and_child_sites"
                    >{window.trans("Parent and child sites")}</option
                  >
                  <option value="child_sites_only"
                    >{window.trans("Only child sites")}</option
                  >
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
            </div>
            <div class="d-none d-md-block">
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
            <tbody bind:this={tableBodyRef}>
              {#if loading}
                <tr>
                  <td colspan="2" class="loading"
                    >{window.trans("Loading...")}</td
                  >
                </tr>
              {:else}
                {#each sites as site (site.id)}
                  <tr
                    data-site-id={site.id}
                    data-is-starred={starredSites.includes(Number(site.id)) ||
                      undefined}
                  >
                    <td>
                      <span class="site-list-table-bagde-container">
                        {#if site.parentSiteName === "-"}
                          <span class="badge badge-site"
                            >{window.trans("Site")}</span
                          >
                        {:else}
                          <span class="badge badge-child-site"
                            >{window.trans("Child Site")}</span
                          >
                        {/if}
                        <span class="site-list-table-action-buttons-mobile">
                          {#if starredSites.includes(Number(site.id))}
                            <button
                              on:click={(ev) => removeStarredSite(ev, site)}
                              aria-label={window.trans(
                                "Remove from starred sites",
                              )}
                              aria-pressed="true"
                              title={window.trans("Remove from starred sites")}
                              ><span>★</span></button
                            >
                          {:else}
                            <button
                              on:click={(ev) => addStarredSite(ev, site)}
                              aria-label={window.trans("Add to starred sites")}
                              aria-pressed="false"
                              title={window.trans("Add to starred sites")}
                              ><span>☆</span></button
                            >
                          {/if}
                          <span
                            class="site-list-table-sortable-handle"
                            style={starredSites.includes(Number(site.id))
                              ? "cursor: move"
                              : "visibility: hidden;"}
                          >
                            <SVG
                              title={window.trans("Move")}
                              class="mt-icon"
                              href={`${window.StaticURI}images/admin2025/sprite.svg#ic_move`}
                              style="height: 15px;"
                            />
                          </span>
                        </span>
                      </span>
                      <a
                        href={`${window.ScriptURI}?__mode=dashboard&blog_id=${site.id}`}
                        class="dashboard-link"
                      >
                        {site.name}
                      </a>
                      {#if site.parentSiteName !== "-"}
                        <span class="d-block d-md-none parent-site"
                          >{@html site.parentSiteName}</span
                        >
                      {/if}
                      <a href={site.siteUrl} class="site-link" target="_blank">
                        <span class="d-inline-block d-md-none"
                          >{window.trans("View your site.")}</span
                        >
                        <SVG
                          title={window.trans("View your site.")}
                          class="mt-icon mt-icon--sm"
                          href={`${window.StaticURI}images/admin2025/sprite.svg#ic_permalink`}
                        />
                      </a>
                    </td>
                    <td class="site-list-table-parent-site">
                      {@html site.parentSiteName}
                    </td>
                    <td class="site-list-table-action">
                      <span class="site-list-table-action-buttons">
                        {#if starredSites.includes(Number(site.id))}
                          <button
                            on:click={(ev) => removeStarredSite(ev, site)}
                            aria-label={window.trans(
                              "Remove from starred sites",
                            )}
                            aria-pressed="true"
                            title={window.trans("Remove from starred sites")}
                            ><span>★</span></button
                          >
                        {:else}
                          <button
                            on:click={(ev) => addStarredSite(ev, site)}
                            aria-label={window.trans("Add to starred sites")}
                            aria-pressed="false"
                            title={window.trans("Add to starred sites")}
                            ><span>☆</span></button
                          >
                        {/if}
                        <span
                          class="site-list-table-sortable-handle"
                          style={starredSites.includes(Number(site.id))
                            ? "cursor: move"
                            : "visibility: hidden;"}
                        >
                          <SVG
                            title={window.trans("Move")}
                            class="mt-icon"
                            href={`${window.StaticURI}images/admin2025/sprite.svg#ic_move`}
                            style="height: 15px;"
                          />
                        </span>
                      </span>
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

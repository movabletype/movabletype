<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  import ListFilterItemField from "./ListFilterItemField.svelte";
</script>

<div class="filteritem">
  <button class="close" aria-label="Close" on:click={removeFilterItem}>
    <span aria-hidden="true">&times;</span>
  </button>
  {#if opts.item.type == "pack"}
    <div>
      {#each opts.item.args.items as item, index}
        {#if filterTypeHash[item.type]}
          <div
            data-mt-list-item-content-index={index}
            class={"filtertype type-" + item.type}
          >
            <div class="item-content form-inline">
              <ListFilterItemField />
              <a
                href="javascript:void(0);"
                class="d-inline-block"
                if={!filterTypeHash[item.type].singleton}
                on:click={addFilterItemContent}
              >
                <svg class="mt-icon mt-icon--sm">
                  <use xlink:href={StaticURI + "images/sprite.svg#ic_add"} />
                </svg>
              </a>
              {#if !filterTypeHash[item.type].singleton && opts.item.args.items.length > 1}
                <a
                  href="javascript:void(0);"
                  on:click={removeFilterItemContent}
                >
                  <svg class="mt-icon mt-icon--sm">
                    <use
                      xlink:href={StaticURI + "images/sprite.svg#ic_remove"}
                    />
                  </svg>
                </a>
              {/if}
            </div>
          </div>
        {/if}
      {/each}
    </div>
  {/if}
  {#if opts.item.type != "pack" && filterTypeHash[opts.item.type]}
    <div
      data-mt-list-item-content-index="0"
      class={"filtertype type-" + opts.item.type}
    >
      <div class="item-content form-inline">
        <virtual
          data-is="list-filter-item-field"
          field={filterTypeHash[opts.item.type].field}
          item={opts.item}
        />
        <a
          href="javascript:void(0);"
          class="d-inline-block"
          if={!filterTypeHash[opts.item.type].singleton}
          on:click={addFilterItemContent}
        >
          <svg class="mt-icon mt-icon--sm">
            <use xlink:href={StaticURI + "images/sprite.svg#ic_add"} />
          </svg>
        </a>
      </div>
    </div>
  {/if}
</div>

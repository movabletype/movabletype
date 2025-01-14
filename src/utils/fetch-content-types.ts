import { type ContentTypes, type ContentType } from "../@types/contenttype";
import { CacheManager } from "./cache-manager";
import { LRUCacheWrapper } from "./cache/lru-cache-wrapper";

export type FetchContentTypesProps = {
  blogId: string;
  magicToken: string;
  page: number;
  limit: number;
};

const lruCacheWrapper = new LRUCacheWrapper();
const cacheManager = new CacheManager({ cache: lruCacheWrapper });

export const fetchContentTypes = async (
  props: FetchContentTypesProps
): Promise<ContentTypes> => {
  const fetchParams = {
    __mode: "filtered_list",
    blog_id: props.blogId,
    columns: "name",
    datasource: "content_type",
    items: "[]",
    limit: props.limit,
    magic_token: props.magicToken,
    page: props.page,
    sort_by: "id",
    sort_order: "descend",
  };

  return await cacheManager.fetchWithCache({
    key: cacheManager.generateCacheKey({
      prefix: "content_types",
      params: fetchParams,
    }),
    fetcher: async () => {
      const result = await jQuery.ajax(window.ScriptURI, {
        type: "POST",
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        data: fetchParams,
        dataType: "json",
      });
      const content_type: ContentType[] = result.result.objects.map(
        (object) => {
          const name = object[1].replace(/<("[^"]*"|'[^']*'|[^'">])*>/g, "");
          return {
            id: object[0],
            name: name,
          };
        }
      );
      return {
        count: Number.parseInt(result.result.count),
        page: Number.parseInt(result.result.page),
        pageMax: Number.parseInt(result.result.page_max),
        contentTypes: content_type,
      };
    },
  });
};

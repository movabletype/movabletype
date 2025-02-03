import { type ContentTypes } from "../@types/contenttype";
import { CacheManager } from "./cache-manager";
import { LRUCacheWrapper } from "./cache/lru-cache-wrapper";

export type FetchContentTypesProps = {
  blogId: string;
  magicToken: string;
};

const lruCacheWrapper = new LRUCacheWrapper();
const cacheManager = new CacheManager({ cache: lruCacheWrapper });

export const fetchContentTypes = async (
  props: FetchContentTypesProps,
): Promise<ContentTypes> => {
  const fetchParams = {
    __mode: "fetch_admin_header_content_types",
    blog_id: props.blogId,
    magic_token: props.magicToken,
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
      if (result.result.success !== 1) {
        return {
          contentTypes: [],
        };
      }
      return {
        contentTypes: result.result.content_types,
      };
    },
  });
};

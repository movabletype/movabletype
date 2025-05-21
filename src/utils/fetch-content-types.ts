import { type ContentTypes } from "../@types/contenttype";

export type FetchContentTypesProps = {
  blogId: string;
  magicToken: string;
};

export const fetchContentTypes = async (
  props: FetchContentTypesProps,
): Promise<ContentTypes> => {
  const fetchParams = {
    __mode: "content_types_for_search_action",
    blog_id: props.blogId,
    magic_token: props.magicToken,
  };

  let error;
  let result;
  try {
    result = await jQuery.ajax(window.ScriptURI, {
      type: "POST",
      contentType: "application/x-www-form-urlencoded; charset=utf-8",
      data: fetchParams,
      dataType: "json",
      error: (xmlHttpRequest) => {
        if (xmlHttpRequest.readyState === 0 || xmlHttpRequest.status === 0) {
          error = "possibly unloaded";
        }
      },
    });
  } catch (e) {
    error ??= e;
  }
  if (error || result.result.success !== 1) {
    return {
      contentTypes: [],
    };
  }
  return {
    contentTypes: result.result.content_types,
  };
};

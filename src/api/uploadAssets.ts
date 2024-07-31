interface UploadAssetsContext {
  blogId?: number;
}

interface UploadAssetsOptions {
  [key: string]: string;
}

interface UploadAssetsRequestOptions {
  onprogress?: (progressEvent: ProgressEvent) => void;
}

export interface UploadAssetsParam {
  files: FileList | File[] | null;
  context: UploadAssetsContext;
  options: UploadAssetsOptions;
  requestOptions: UploadAssetsRequestOptions;
}

export function uploadAssets({
  files,
  context,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  options,
  requestOptions,
}: UploadAssetsParam): Promise<Response>[] {
  return [...(files ?? [])].map(async (f) => {
    // FIXME:これで取れないケースは今はないと思うけれども、保証はされていない。
    // 今後JSでUIを作っていく前提になっていく場合ないこともあるかもしれない。
    // <meta name="csrf-token" value="xxxxxx" /> のようなものをヘッダーに入れるのがいいかもしれない。
    const magicToken = document.querySelector<HTMLInputElement>(
      `input[name="magic_token"]`
    )?.value;
    if (!magicToken) {
      throw new Error("Failed to get magick token.");
    }

    const body = new FormData();
    body.set("file", f);
    body.set("__mode", "js_upload_file");
    body.set("blog_id", String(context.blogId));
    body.set("magic_token", magicToken);

    const xhr = new XMLHttpRequest();
    xhr.open("POST", window.CMSScriptURI);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.send(body);

    Object.assign(xhr, requestOptions);

    return new Promise((resolve, reject) => {
      xhr.onload = () => {
        const responseInit: ResponseInit = {
          status: xhr.status,
          statusText: xhr.statusText,
          headers: Object.fromEntries(
            xhr
              .getAllResponseHeaders()
              .split(/\r\n/)
              .filter((s) => s.includes(":"))
              .map((line) => line.split(/\s*:\s*/, 2))
          ),
        };
        resolve(new Response(xhr.responseText, responseInit));
      };

      xhr.onerror = () => {
        reject("Request failed");
      };
    });
  });
}

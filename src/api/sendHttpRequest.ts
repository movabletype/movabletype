window.addEventListener("unhandledrejection", async (ev) => {
  if (!(ev.reason instanceof SendHttpRequestError)) {
    return;
  }

  ev.preventDefault();

  const Alert = await window.MT.import("Alert");
  Alert.danger(ev.reason);

  const Logger = await window.MT.import("Logger");
  Logger.error(`UNHANDLED PROMISE REJECTION: ${ev.reason}`);
});

class SendHttpRequestError extends Error {}

function buildRequest(
  input: RequestInfo | URLSearchParams | FormData,
  init: RequestInit
): Request {
  if (input instanceof URLSearchParams) {
    const uri = `${window.CMSScriptURI}?${input.toString()}`;
    return new Request(uri, init);
  } else if (input instanceof FormData) {
    // FIXME:これで取れないケースは今はないと思うけれども、保証はされていない。
    // 今後JSでUIを作っていく前提になっていく場合ないこともあるかもしれない。
    // <meta name="csrf-token" value="xxxxxx" /> のようなものをヘッダーに入れるのがいいかもしれない。
    const magicToken = document.querySelector<HTMLInputElement>(
      `input[name="magic_token"]`
    )?.value;
    if (!magicToken) {
      throw new Error("Failed to get magick token.");
    }

    input.append("magick_token", magicToken);

    return new Request(
      window.CMSScriptURI,
      Object.assign({}, init, {
        method: init.method ?? "POST",
        body: input,
      })
    );
  } else {
    // TODO: fillin magick_token if POST request
    return new Request(input, init);
  }
}

export function sendHttpRequest(
  input: Request | RequestInfo | URLSearchParams | FormData,
  init?: RequestInit
): Promise<Response> {
  const _init = Object.assign({}, init || {});
  _init.headers = Object.assign({}, _init.headers || {});
  _init.headers["X-Requested-With"] = "XMLHttpRequest";

  const request = input instanceof Request ? input : buildRequest(input, _init);

  return fetch(request)
    .then(async (response) => {
      if (response.status !== 200) {
        throw new SendHttpRequestError(await response.text());
      }

      return response;
    })
    .catch((e) => {
      throw new SendHttpRequestError(e.toString());
    });
}

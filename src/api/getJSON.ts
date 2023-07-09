window.addEventListener("unhandledrejection", async (ev) => {
  if (!(ev.reason instanceof GetJSONError)) {
    return;
  }

  ev.preventDefault();

  const Alert = await window.MT.import("Alert");
  Alert.danger(ev.reason);

  const Logger = await window.MT.import("Logger");
  Logger.error(`UNHANDLED PROMISE REJECTION: ${ev.reason}`);
});

class GetJSONError extends Error {}
export async function getJSON(
  input: RequestInfo | URLSearchParams | FormData,
  init?: RequestInit
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
): Promise<any> {
  const sendHttpRequest = await window.MT.import("sendHttpRequest");
  const response: Response = await sendHttpRequest(input, init);
  return new Promise((resolve, reject) => {
    response
      .json()
      .then(resolve)
      .catch((e) => {
        reject(new GetJSONError(e.toString()));
      });
  });
}

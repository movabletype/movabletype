const importPromiseMap = {};
const exportPromiseMap = {};

declare global {
  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  interface MTAPIMap {}
}

export interface ResolveHandler<T> {
  original: T;
  resolve: (result: T) => void;
}

function _import<T extends keyof MTAPIMap>(name: T): Promise<MTAPIMap[T]>;
async function _import<T>(name: string): Promise<T> {
  return (importPromiseMap[name] ||= new Promise((resolve) => {
    setTimeout(async () => {
      const resolved = await exportPromiseMap[name].reduce(
        async (prev, cur) => cur(await prev),
        () => Promise.resolve(),
      );
      resolve(resolved);
    }, 0);
  }));
}

async function _export<T>(name: string): Promise<ResolveHandler<T>> {
  exportPromiseMap[name] ||= [];

  return new Promise((resolve) => {
    exportPromiseMap[name].push((original) => {
      return new Promise((exportFunction) => {
        resolve({
          original,
          resolve: exportFunction,
        });
      });
    });
  });
}

export const Exporter = {
  import: _import,
  export: _export,
};

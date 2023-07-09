const getPromiseMap: Record<string, Promise<UIComponent[]>> = {};
const addPromiseMap: Record<
  string,
  (() => Promise<{ variant: string; component: UIComponent }>)[]
> = {};

export type UIComponent = string | typeof HTMLElement | HTMLElement;
type AddComponent = (result: UIComponent) => void;
export interface ResolveHandler {
  resolve: AddComponent;
}

async function getAll(namespace: string): Promise<UIComponent[]> {
  return (getPromiseMap[namespace] ||= new Promise((resolve) => {
    const [ns, _variant] = namespace.split(/\./, 2);
    setTimeout(async () => {
      let all = await Promise.all((addPromiseMap[ns] || []).map((f) => f()));
      if (_variant) {
        all = all.filter(({ variant }) => !variant || variant === _variant);
      }
      resolve(all.map(({ component }) => component));
    }, 0);
  }));
}

async function add(namespace: string): Promise<ResolveHandler> {
  const [ns, variant] = namespace.split(/\./, 2);
  addPromiseMap[ns] ||= [];

  return new Promise((resolve) => {
    addPromiseMap[ns].push(async () => {
      const component = await new Promise((addComponent: AddComponent) => {
        resolve({
          resolve: addComponent,
        });
      });
      return {
        variant,
        component,
      };
    });
  });
}

export const Component = { getAll, add };

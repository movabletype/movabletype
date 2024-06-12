import { writable } from "svelte/store";

const fields: Array<MT.ContentType.Field> = [];
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const config: { [key: string]: any } = {};

export const cfields = writable(fields);
export const mtConfig = writable(config); // TODO: change to readable

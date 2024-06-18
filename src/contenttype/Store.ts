import { writable } from "svelte/store";

const fields: Array<MT.ContentType.Field> = [];
const config: MT.ContentType.ConfigOpts = {};

export const cfields = writable(fields);
export const configStore = writable(config);

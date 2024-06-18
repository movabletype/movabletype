import { writable } from "svelte/store";

const config: MT.ContentType.ConfigOpts = {};
const fields: Array<MT.ContentType.Field> = [];

export const configStore = writable(config);
export const fieldsStore = writable(fields);

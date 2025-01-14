
export function isOuterClick(refs: Array<Node | null>, eventTarget: Node): boolean {
  return !refs.some((ref) => ref && ref.contains(eventTarget));
}

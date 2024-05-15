<script>
  let rawCount;
  let rawLimit;
  let rawPage;

  export { rawCount as count };
  export { rawLimit as limit };
  export { rawPage as page };

  $: count = rawCount == null ? 0 : rawCount;
  $: limit = rawLimit == null ? 0 : rawLimit;
  $: page = rawPage == null ? 0 : rawPage;

  $: from = count == 0 ? 0 : limit * (page - 1) + 1;
  $: to = limit * page > count ? count : limit * page;
</script>

<div>
  {from} - {to} / {count}
</div>

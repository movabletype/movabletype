
riot.tag2('ss', '<svg role="img" class="{opts.class}"> <title if="{opts.title}">{opts.title}</title> <use xlink:href=""> </use> </svg>', '', '', function(opts) {
    this.on('mount', function() {
      this.root.querySelector('use').setAttribute('xlink:href', opts.href);
    });
});


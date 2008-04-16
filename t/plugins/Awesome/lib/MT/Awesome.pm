
package MT::Awesome;

our @ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        title => 'string(255)',
        file => 'string(255)',
        mime_type => 'string meta',
    },
    meta => 1,
    class_type => 'foo',
    datasource => 'awesome',
    primary_key => 'id',
});

1;

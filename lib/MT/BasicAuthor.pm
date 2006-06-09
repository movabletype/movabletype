package MT::BasicAuthor;

# fake out the require for this package since we're
# declaring it inline...

use MT::Object;
@MT::BasicAuthor::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(50) not null',
        'password' => 'string(60) not null',
        'email' => 'string(75)',
        'hint' => 'string(75)',
    },
    indexes => {
        name => 1,
        email => 1,
    },
    datasource => 'author',
    primary_key => 'id',
});

sub is_valid_password {
    my $auth = shift;
    my($pass, $crypted) = @_;
    $pass ||= '';
    my $real_pass = $auth->column('password');
    return $crypted ? $real_pass eq $pass :
                      crypt($pass, $real_pass) eq $real_pass;
}

sub set_password {
    my $auth = shift;
    my($pass) = @_;
    my @alpha = ('a'..'z', 'A'..'Z', 0..9);
    my $salt = join '', map $alpha[rand @alpha], 1..2;
    $auth->column('password', crypt $pass, $salt);
}

sub magic_token {
    my $auth = shift;
    require MT::Util;
    MT::Util::perl_sha1_digest_hex($auth->column('password'));
}

1;

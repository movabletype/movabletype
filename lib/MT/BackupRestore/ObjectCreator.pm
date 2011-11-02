package MT::BackupRestore::ObjectCreator;
use strict;
use warnings;

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    return $self;
}

sub run_callback {
	my ($self, @msgs) = @_;
    $self->{callback}->($self->{state} . " " . join('', @msgs));
}

sub set_new_class {
	my ($self, $class_name) = @_;
    my $state = MT->translate( 'Restoring [_1] records:', $class_name );
    $self->{state} = $state;
}

sub start_non_mt_element {
    my ($self, $data) = @_;

    my $objects  = $self->{objects};
    my $deferred = $self->{deferred};
    my $callback = $self->{callback};

    my $name  = $data->{LocalName};
    my $ns    = $data->{NamespaceURI};

    my $obj = MT->run_callbacks( "Restore.$name:$ns",
        $data, $objects, $deferred, $callback );
    return $obj;
}

sub start_object {
    my ($self, $data) = @_;

    my $objects  = $self->{objects};
    my $attrs = $data->{Attributes};
    my $name  = $data->{LocalName};
    my $class = MT->model($name);


    my %column_data
        = map { $attrs->{$_}->{LocalName} => $attrs->{$_}->{Value} }
        keys(%$attrs);
    my $obj = $class->new;

    # Pass through even if an blog doesn't restore
    # the parent object
    my $success = $obj->restore_parent_ids( \%column_data, $objects );

    if ( !$success && ( 'blog' ne $name ) ) {
        $self->{deferred}->{ $class . '#' . $column_data{id} } = 1;
        return;
    }

    require MT::Meta;
    my @metacolumns
        = MT::Meta->metadata_by_class( ref($obj) );
    my %metacolumns
        = map { $_->{name} => $_->{type} } @metacolumns;
    $self->{metacolumns}{ ref($obj) } = \%metacolumns;
    my %realcolumn_data
        = map { $_ => MT::BackupRestore::BackupFileHandler::_decode( $column_data{$_} ) }
        grep { !exists( $metacolumns{$_} ) }
        keys %column_data;

    if ( !$success && 'blog' eq $name ) {
        $realcolumn_data{parent_id} = undef;
    }

    $obj->set_values( \%realcolumn_data );
    $obj->column( 'external_id',
        $realcolumn_data{external_id} )
        if $name eq 'author'
            && defined $realcolumn_data{external_id};
    foreach my $metacol ( keys %metacolumns ) {
        next
            if ( 'vclob' eq $metacolumns{$metacol} )
            || ( 'vblob' eq $metacolumns{$metacol} );
        $obj->$metacol( $column_data{$metacol} );
    }
    return $obj;
}

sub save_object {
    my ($self, $obj, $data) = @_;

    my $name  = $data->{LocalName};
    my $ns    = $data->{NamespaceURI};
    my $objects  = $self->{objects};
    my $class = MT->model($name);

    my $old_id = $obj->id;
    delete $obj->{column_values}->{id};
    delete $obj->{changed_cols}->{id};

    if ( 'tag' eq $name ) {
    	$obj = $self->__save_tag($class, $obj, $old_id, $objects);
    }
    elsif ( 'trackback' eq $name ) {
    	$obj = $self->__save_trackback($class, $obj, $old_id, $objects);
    }
    elsif ( 'permission' eq $name ) {
    	$obj = $self->__save_permission($class, $obj, $old_id, $objects);
    }
    elsif ( 'objectscore' eq $name ) {
    	$obj = $self->__save_objectscore($class, $obj, $old_id, $objects);
    }
    elsif ( 'field' eq $name ) {
    	$obj = $self->__save_field($class, $obj, $old_id, $objects);
    }
    elsif ( 'role' eq $name ) {
    	$obj = $self->__save_role($class, $obj, $old_id, $objects);
    }
    elsif ( 'filter' eq $name ) {
    	$obj = $self->__save_filter($class, $obj, $old_id, $objects);
    }
    elsif ( 'plugindata' eq $name ) {
    	$obj = $self->__save_plugindata($class, $obj, $old_id, $objects);
    }
    elsif ( 'author' eq $name ) {
    	$obj = $self->__save_author($class, $obj, $old_id, $objects);
    }
    elsif ( 'template' eq $name ) {
    	$obj = $self->__save_template($class, $obj, $old_id, $objects);
    }

    if ($obj) {
        my $result;
        if ( $obj->id ) {
            $result = $obj->update();
        }
        else {
            $result = $obj->insert();
        }
        if ($result) {
            if ( $class =~ /MT::Asset(::.+)*/ ) {
                $class = 'MT::Asset';
            }
            $self->{objects}->{"$class#$old_id"} = $obj;
            my $records = $self->{records} || 0;
            $self->run_callback(
                MT->translate( "[_1] records restored...", $records ),
                $data->{LocalName}
            ) if $records && ( $records % 10 == 0 );
            $self->{records} = $records + 1;
            my $cb = "restored.$name";
            $cb .= ":$ns"
                if MT::BackupRestore::NS_MOVABLETYPE() ne $ns;
            MT->run_callbacks( $cb, $obj, $self->{callback} );
            $obj->call_trigger( 'post_save', $obj );
        }
        else {
            push @{ $self->{errors} }, $obj->errstr;
            $self->{callback}->( $obj->errstr );
        }
    }
}

sub __save_tag {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    if (my $tag = MT::Tag->load(
            { name   => $obj->name },
            { binary => { name => 1 } }
        )
        )
    {
        $self->{objects}->{"$class#$old_id"} = $tag;
        $self->{callback}->("\n");
        $self->{callback}->(
            MT->translate(
                "Tag '[_1]' exists in the system.", $obj->name
            )
        );
        return;
    }
	return $obj;	
}

sub __save_trackback {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    my $term;
    my $message;
    if ( $obj->entry_id ) {
        $term = { entry_id => $obj->entry_id };
    }
    elsif ( $obj->category_id ) {
        $term = { category_id => $obj->category_id };
    }
    if ( my $tb = $class->load($term) ) {
        my $changed = 0;
        if ( $obj->passphrase ) {
            $tb->passphrase( $obj->passphrase );
            $changed = 1;
        }
        if ( $obj->is_disabled ) {
            $tb->is_disabled( $obj->is_disabled );
            $changed = 1;
        }
        $tb->save if $changed;
        $self->{objects}->{"$class#$old_id"} = $tb;
        my $records = $self->{records};
        $self->run_callback(
        	MT->translate("[_1] records restored...", $records),
            "trackback"
        ) if $records && ( $records % 10 == 0 );
        $self->{records} = $records + 1;
        return;
    }
	return $obj;	
}

sub __save_permission {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    my $perm = $class->exist(
        {   author_id => $obj->author_id,
            blog_id   => $obj->blog_id
        }
    );
    return if $perm;
	return $obj;	
}

sub __save_objectscore {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    my $score = $class->exist(
        {   author_id => $obj->author_id,
            object_id => $obj->object_id,
            object_ds => $obj->object_ds,
        }
    );
    return if $score;
	return $obj;	
}

sub __save_field {
	my ($self, $class, $obj, $old_id, $objects) = @_;

    # Available in propack only
    if ( $obj->blog_id == 0 ) {
        my $field = $class->exist(
            {   blog_id  => 0,
                basename => $obj->basename,
            }
        );
        return if $field;
    }
	return $obj;	
}

sub __save_role {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    my $role = $class->load( { name => $obj->name } );
    if ($role) {
        my $old_perms = join '',
            sort { $a cmp $b } split( ',', $obj->permissions );
        my $cur_perms = join '',
            sort { $a cmp $b } split( ',', $role->permissions );
        if ( $old_perms eq $cur_perms ) {
            $self->{objects}->{"$class#$old_id"} = $role;
            return;
        }
        else {

            # restore in a different name
            my $i        = 1;
            my $new_name = $obj->name . " ($i)";
            while ( $class->exist( { name => $new_name } ) ) {
                $new_name = $obj->name . ' (' . ++$i . ')';
            }
            $obj->name($new_name);
            MT->log(
                {   message => MT->translate(
                        "The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.",
                        $role->name,
                        $new_name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'restore',
                }
            );
        }
    }
	return $obj;	
}

sub __save_filter {
	my ($self, $class, $obj, $old_id, $objects) = @_;

    if ($objects->{ "MT::Author#" . $obj->author_id } )
    {
        my $existing_obj = $class->load(
            {   author_id => $obj->author_id,
                label     => $obj->label,
                object_ds => $obj->object_ds,
            }
        );
        if ($existing_obj) {
            $obj->restore_parent_ids( { blog_id => $obj->blog_id }, $objects );
            $objects->{"$class#$old_id"} = $obj;
            $obj->id($existing_obj->id);
        }
    }

    # Callback for restoring ID in the filter items
    MT->run_callbacks( 'restore_filter_item_ids', $obj, undef,
        $objects );
	return $obj;	
}

sub __save_plugindata {
	my ($self, $class, $obj, $old_id, $objects) = @_;

    # Skipping System level plugindata
    # when it was found in the database.

    if ( $obj->key !~ /^configuration:blog:(\d+)$/i ) {
        if ( my $obj
            = MT->model('plugindata')
            ->load( { key => $obj->key, } ) )
        {
            $self->{callback}->("\n");
            $self->{callback}->(
                MT->translate(
                    "The system level settings for plugin '[_1]' already exist.  Skipping this record.",
                    $obj->plugin
                )
            );
            return;
        }
    }
	return $obj;	
}

sub __save_author {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    my $existing_obj = $class->load( { name => $obj->name() } );
    if ($existing_obj) {
        if ( UNIVERSAL::isa( MT->instance, 'MT::App' ) && ( $existing_obj->id == MT->instance->user->id ) )
        {
            MT->log(
                {   message => MT->translate(
                        "User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.",
                        $obj->name
                    ),
                    level => MT::Log::INFO(),
                    metadata =>
                        'Permissions and Associations have been restored.',
                    class    => 'system',
                    category => 'restore',
                }
            );
            $objects->{ "$class#" . $old_id } = $existing_obj;
            $objects->{ "$class#" . $old_id }->{no_overwrite} = 1;
            return;
        }
        else {
            MT->log(
                {   message => MT->translate(
                        "User with the same name '[_1]' found (ID:[_2]).  Restore replaced this user with the data backed up.",
                        $obj->name,
                        $old_id
                    ),
                    level => MT::Log::INFO(),
                    metadata =>
                        'Permissions and Associations have been restored as well.',
                    class    => 'system',
                    category => 'restore',
                }
            );
            $obj->id($existing_obj->id);
            $objects->{"$class#$old_id"} = $obj;

            my $child_classes = $obj->properties->{child_classes} || {};
            for my $class ( keys %$child_classes ) {
                eval "use $class;";
                $class->remove( { author_id => $obj->id, blog_id => '0' } );
            }
            $obj->userpic_asset_id(0);
        }
    }
    return $obj;
}

sub __save_template {
	my ($self, $class, $obj, $old_id, $objects) = @_;
    if ( !$obj->blog_id ) {
        my $existing_obj = $class->load(
            {   blog_id => 0,
                (   $obj->identifier
                    ? ( identifier => $obj->identifier )
                    : ( name => $obj->name )
                ),
            }
        );
        if ($existing_obj) {
            if ( $self->{overwrite_template} ) {
                $obj->id($existing_obj->id);
            	$objects->{"$class#$old_id"} = $obj;
            }
            else {
                $obj = $existing_obj;
            	$objects->{"$class#$old_id"} = $obj;
                return;
            }
        }
    }
    return $obj;
}

1;
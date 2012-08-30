package WWW::Azantek;



use strict;
use WWW::Mechanize;
use WWW::Mechanize::Cached;
use Carp qw(croak);
use Test::LongString;
use Carp::Assert::More;

use base 'WWW::Mechanize';

my $TB = Test::Builder->new();

our $VERSION = '0.01';

sub new{
    my ( $class, $param ) = @_;
    my $stat;
    my  $url;
    my $mech ={  };
    my $agent = __PACKAGE__ . "-$VERSION";
    if ( $param->{mech} ) {
        $mech = $param->{mech};
    } elsif ( $param->{cache} ) {
        $mech = WWW::Mechanize::Cached->new( agent => $agent );
    } else {
        $mech = WWW::Mechanize->new( agent => $agent );
    }

    my $self = bless {
        base_url  => "http://localhost/cgi-bin/login.pl",
        url  =>  $param->{url} ,
        username  => $param->{username},
        password  => $param->{password},
        verbose   => $param->{verbose} || 0,
        mech      => $param->{mech},
        processor => $param->{processor},
    }, $class;

    if ( $self->{username} || $self->{password} ) {
        if ( ( not $self->{username} ) or ( not $self->{password} ) ) {
            croak 'Both username and password is required for authentication';
        }

        $self->{mech}->get( $self->{base_url} )
            or croak "Unable to retrieve base URL: $@";

        if (not $self->{mech}->submit_form(
                form_number => 0,
                fields      => {
                    username => $self->{username},
                    password => $self->{password},
                }
            )
            )
        {
            croak 'Unable to authenticate';
        }
    }

    $self->{mech}->get( $self->{url} ) or croak "Unable to retrieve URL: $@";

    my $content = $self->{mech}->content();

    if ( ref $self->{processor} eq 'CODE' ) {
        return &{ $self->{processor} }( \$content, $stat );
    } elsif ( ref $self->{processor} and UNIVERSAL::can($self->{processor}, 'process' )) {
        return $self->{processor}->process( \$content, $stat );
    } else {
        return $self->process( \$content, $stat );
    }
}

sub processor {
    my ( $self, $content ) = @_;

    return $self->process($content);
}

sub process {
    my ( $self, $content ) = @_;

    if ( $self->{verbose} ) {
        print STDERR "${$content}.\n";
    }

    return $content;
}



=item * get_ok()

=item * post_ok()

=item * submit_form_ok()

=item * follow_link_ok()

=item * click_ok()

=back

This means you no longer have to do the following:

    my $mech = Test::WWW::Mechanize->new();
    $mech->get_ok( $url, 'Fetch the intro page' );
    $mech->html_lint_ok( 'Intro page looks OK' );

and can simply do

    my $mech = Test::WWW::Mechanize->new( autolint => 1 );
    $mech->get_ok( $url, 'Fetch the intro page' );

The C<< $mech->get_ok() >> only counts as one test in the test count.  Both the
main IO operation and the linting must pass for the entire test to pass.

You can control autolint on the fly with the C<< autolint >> method.

=cut


=head1 METHODS: HTTP VERBS

=head2 $mech->get_ok($url, [ \%LWP_options ,] $desc)

A wrapper around WWW::Mechanize's get(), with similar options, except
the second argument needs to be a hash reference, not a hash. Like
well-behaved C<*_ok()> functions, it returns true if the test passed,
or false if not.

A default description of "GET $url" is used if none if provided.

=cut

sub get_ok {
    my $self = shift;

    my ($url,$desc,%opts) = $self->_unpack_args( 'GET', @_ );

    $self->get( $url, %opts );
    my $ok = $self->success;

    $ok = $self->_maybe_lint( $ok, $desc );

    return $ok;
}

sub _maybe_lint {
    my $self = shift;
    my $ok   = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    if ( $ok ) {
        if ( $self->is_html && $self->autolint ) {
            $ok = $self->_lint_content_ok( $desc );
        }
        else {
            $TB->ok( $ok, $desc );
        }
    }
    else {
        $TB->ok( $ok, $desc );
        $TB->diag( $self->status );
        $TB->diag( $self->response->message ) if $self->response;
    }

    return $ok;
}

=head2 $mech->head_ok($url, [ \%LWP_options ,] $desc)

A wrapper around WWW::Mechanize's head(), with similar options, except
the second argument needs to be a hash reference, not a hash. Like
well-behaved C<*_ok()> functions, it returns true if the test passed,
or false if not.

A default description of "HEAD $url" is used if none if provided.

=cut

sub head_ok {
    my $self = shift;

    my ($url,$desc,%opts) = $self->_unpack_args( 'HEAD', @_ );

    $self->head( $url, %opts );
    my $ok = $self->success;

    $TB->ok( $ok, $desc );
    if ( !$ok ) {
        $TB->diag( $self->status );
        $TB->diag( $self->response->message ) if $self->response;
    }

    return $ok;
}


=head2 $mech->post_ok( $url, [ \%LWP_options ,] $desc )

A wrapper around WWW::Mechanize's post(), with similar options, except
the second argument needs to be a hash reference, not a hash. Like
well-behaved C<*_ok()> functions, it returns true if the test passed,
or false if not.

A default description of "POST to $url" is used if none if provided.

=cut

sub post_ok {
    my $self = shift;

    my ($url,$desc,%opts) = $self->_unpack_args( 'POST', @_ );

    $self->post( $url, \%opts );
    my $ok = $self->success;
    $ok = $self->_maybe_lint( $ok, $desc );

    return $ok;
}

=head2 $mech->put_ok( $url, [ \%LWP_options ,] $desc )

A wrapper around WWW::Mechanize's put(), with similar options, except
the second argument needs to be a hash reference, not a hash. Like
well-behaved C<*_ok()> functions, it returns true if the test passed,
or false if not.

A default description of "PUT to $url" is used if none if provided.

=cut

sub put_ok {
    my $self = shift;

    my ($url,$desc,%opts) = $self->_unpack_args( 'PUT', @_ );
    $opts{content} = '' if !exists $opts{content};
    $self->put( $url, %opts );

    my $ok = $self->success;
    $TB->ok( $ok, $desc );
    if ( !$ok ) {
        $TB->diag( $self->status );
        $TB->diag( $self->response->message ) if $self->response;
    }

    return $ok;
}

=head2 $mech->submit_form_ok( \%parms [, $desc] )

Makes a C<submit_form()> call and executes tests on the results.
The form must be found, and then submitted successfully.  Otherwise,
this test fails.

I<%parms> is a hashref containing the parms to pass to C<submit_form()>.
Note that the parms to C<submit_form()> are a hash whereas the parms to
this function are a hashref.  You have to call this function like:

    $mech->submit_form_ok( {
            form_number => 3,
            fields      => {
                answer => 42
            },
        }, 'now we just need the question'
    );

As with other test functions, C<$desc> is optional.  If it is supplied
then it will display when running the test harness in verbose mode.

Returns true value if the specified link was found and followed
successfully.  The L<HTTP::Response> object returned by submit_form()
is not available.

=cut

sub submit_form_ok {
    my $self = shift;
    my $parms = shift || {};
    my $desc = shift;

    if ( ref $parms ne 'HASH' ) {
        Carp::croak 'FATAL: parameters must be given as a hashref';
    }

    # return from submit_form() is an HTTP::Response or undef
    my $response = $self->submit_form( %{$parms} );

    my $ok = $response && $response->is_success;
    $ok = $self->_maybe_lint( $ok, $desc );

    return $ok;
}


=head2 $mech->follow_link_ok( \%parms [, $desc] )

Makes a C<follow_link()> call and executes tests on the results.
The link must be found, and then followed successfully.  Otherwise,
this test fails.

I<%parms> is a hashref containing the parms to pass to C<follow_link()>.
Note that the parms to C<follow_link()> are a hash whereas the parms to
this function are a hashref.  You have to call this function like:

    $mech->follow_link_ok( {n=>3}, 'looking for 3rd link' );

As with other test functions, C<$desc> is optional.  If it is supplied
then it will display when running the test harness in verbose mode.

Returns a true value if the specified link was found and followed
successfully.  The L<HTTP::Response> object returned by follow_link()
is not available.

=cut

sub follow_link_ok {
    my $self = shift;
    my $parms = shift || {};
    my $desc = shift;

    if (!defined($desc)) {
        my $parms_str = join(', ', map { join('=', $_, $parms->{$_}) } keys(%{$parms}));
        $desc = qq{Followed link with "$parms_str"} if !defined($desc);
    }

    if ( ref $parms ne 'HASH' ) {
       Carp::croak 'FATAL: parameters must be given as a hashref';
    }

    # return from follow_link() is an HTTP::Response or undef
    my $response = $self->follow_link( %{$parms} );

    my $ok = $response && $response->is_success;
    $ok = $self->_maybe_lint( $ok, $desc );

    return $ok;
}


=head2 click_ok( $button[, $desc] )

Clicks the button named by C<$button>.  An optional C<$desc> can
be given for the test.

=cut

sub click_ok {
    my $self   = shift;
    my $button = shift;
    my $desc   = shift;

    my $response = $self->click( $button );
    if ( !$response ) {
        return $TB->ok( 0, $desc );
    }


    my $ok = $response->is_success;

    $ok = $self->_maybe_lint( $ok, $desc );

    return $ok;
}


sub _unpack_args {
    my $self   = shift;
    my $method = shift;
    my $url    = shift;

    my $desc;
    my %opts;

    if ( @_ ) {
        my $flex = shift; # The flexible argument

        if ( !defined( $flex ) ) {
            $desc = shift;
        }
        elsif ( ref $flex eq 'HASH' ) {
            %opts = %{$flex};
            $desc = shift;
        }
        elsif ( ref $flex eq 'ARRAY' ) {
            %opts = @{$flex};
            $desc = shift;
        }
        else {
            $desc = $flex;
        }
    } # parms left

    if ( not defined $desc ) {
        $url = $url->url if ref($url) eq 'WWW::Mechanize::Link';
        $desc = "$method $url";
    }

    return ($url, $desc, %opts);
}



=head1 METHODS: CONTENT CHECKING

=head2 $mech->html_lint_ok( [$desc] )

Checks the validity of the HTML on the current page.  If the page is not
HTML, then it fails.  The URI is automatically appended to the I<$desc>.

Note that HTML::Lint must be installed for this to work.  Otherwise,
it will blow up.

=cut

sub html_lint_ok {
    my $self = shift;
    my $desc = shift;

    my $uri = $self->uri;
    $desc = $desc ? "$desc ($uri)" : $uri;

    my $ok;

    if ( $self->is_html ) {
        $ok = $self->_lint_content_ok( $desc );
    }
    else {
        $ok = $TB->ok( 0, $desc );
        $TB->diag( q{This page doesn't appear to be HTML, or didn't get the proper text/html content type returned.} );
    }

    return $ok;
}

sub _lint_content_ok {
    my $self = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $module = "HTML::Lint 2.20";
    if ( not ( eval "use $module; 1;" ) ) {
        die "Test::WWW::Mechanize can't do linting without $module: $@";
    }

    my $lint = $self->{autolint};
    if ( ref $lint && $lint->isa('HTML::Lint') ) {
        $lint->newfile;
        $lint->clear_errors;
    }
    else {
        $lint = HTML::Lint->new();
    }

    $lint->parse( $self->content );

    my @errors = $lint->errors;
    my $nerrors = @errors;
    my $ok;
    if ( $nerrors ) {
        $ok = $TB->ok( 0, $desc );
        $TB->diag( 'HTML::Lint errors for ' . $self->uri );
        $TB->diag( $_->as_string ) for @errors;
        my $s = $nerrors == 1 ? '' : 's';
        $TB->diag( "$nerrors error$s on the page" );
    }
    else {
        $ok = $TB->ok( 1, $desc );
    }

    return $ok;
}

=head2 $mech->title_is( $str [, $desc ] )

Tells if the title of the page is the given string.

    $mech->title_is( 'Invoice Summary' );

=cut

sub title_is {
    my $self = shift;
    my $str = shift;
    my $desc = shift;
    $desc = qq{Title is "$str"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return is_string( $self->title, $str, $desc );
}

=head2 $mech->title_like( $regex [, $desc ] )

Tells if the title of the page matches the given regex.

    $mech->title_like( qr/Invoices for (.+)/

=cut

sub title_like {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Title is like "$regex"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return like_string( $self->title, $regex, $desc );
}

=head2 $mech->title_unlike( $regex [, $desc ] )

Tells if the title of the page matches the given regex.

    $mech->title_unlike( qr/Invoices for (.+)/

=cut

sub title_unlike {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Title is unlike "$regex"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return unlike_string( $self->title, $regex, $desc );
}

=head2 $mech->base_is( $str [, $desc ] )

Tells if the base of the page is the given string.

    $mech->base_is( 'http://example.com/' );

=cut

sub base_is {
    my $self = shift;
    my $str = shift;
    my $desc = shift;
    $desc = qq{Base is "$str"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return is_string( $self->base, $str, $desc );
}

=head2 $mech->base_like( $regex [, $desc ] )

Tells if the base of the page matches the given regex.

    $mech->base_like( qr{http://example.com/index.php?PHPSESSID=(.+)});

=cut

sub base_like {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Base is like "$regex"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return like_string( $self->base, $regex, $desc );
}

=head2 $mech->base_unlike( $regex [, $desc ] )

Tells if the base of the page matches the given regex.

    $mech->base_unlike( qr{http://example.com/index.php?PHPSESSID=(.+)});

=cut

sub base_unlike {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Base is unlike "$regex"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return unlike_string( $self->base, $regex, $desc );
}

=head2 $mech->content_is( $str [, $desc ] )

Tells if the content of the page matches the given string

=cut

sub content_is {
    my $self = shift;
    my $str = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    $desc = qq{Content is "$str"} if !defined($desc);

    return is_string( $self->content, $str, $desc );
}

=head2 $mech->content_contains( $str [, $desc ] )

Tells if the content of the page contains I<$str>.

=cut

sub content_contains {
    my $self = shift;
    my $str = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    if ( ref($str) ) {
        return $TB->ok( 0, 'Test::WWW::Mechanize->content_contains called incorrectly.  It requires a scalar, not a reference.' );
    }
    $desc = qq{Content contains "$str"} if !defined($desc);

    return contains_string( $self->content, $str, $desc );
}

=head2 $mech->content_lacks( $str [, $desc ] )

Tells if the content of the page lacks I<$str>.

=cut

sub content_lacks {
    my $self = shift;
    my $str = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    if ( ref($str) ) {
        return $TB->ok( 0, 'Test::WWW::Mechanize->content_lacks called incorrectly.  It requires a scalar, not a reference.' );
    }
    $desc = qq{Content lacks "$str"} if !defined($desc);

    return lacks_string( $self->content, $str, $desc );
}

=head2 $mech->content_like( $regex [, $desc ] )

Tells if the content of the page matches I<$regex>.

=cut

sub content_like {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Content is like "$regex"} if !defined($desc);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return like_string( $self->content, $regex, $desc );
}

=head2 $mech->content_unlike( $regex [, $desc ] )

Tells if the content of the page does NOT match I<$regex>.

=cut

sub content_unlike {
    my $self  = shift;
    my $regex = shift;
    my $desc  = shift || qq{Content is unlike "$regex"};

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return unlike_string( $self->content, $regex, $desc );
}

=head2 $mech->text_contains( $str [, $desc ] )

Tells if the text form of the page's content contains I<$str>.

When your page contains HTML which is difficult, unimportant, or
unlikely to match over time as designers alter markup, use
C<text_contains> instead of L</content_contains>.

 # <b>Hi, <i><a href="some/path">User</a></i>!</b>
 $mech->content_contains('Hi, User'); # Fails.
 $mech->text_contains('Hi, User'); # Passes.

Text is determined by calling C<< $mech->text() >>.
See L<WWW::Mechanize/content>.

=cut

sub text_contains {
    my $self = shift;
    my $str  = shift;
    my $desc = shift || qq{Text contains "$str"};

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    if ( ref($str) ) {
        return $TB->ok( 0, 'Test::WWW::Mechanize->text_contains called incorrectly.  It requires a scalar, not a reference.' );
    }

    return contains_string( $self->text, $str, $desc );
}

=head2 $mech->text_lacks( $str [, $desc ] )

Tells if the text of the page lacks I<$str>.

=cut

sub text_lacks {
    my $self = shift;
    my $str = shift;
    my $desc = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    if ( ref($str) ) {
        return $TB->ok( 0, 'Test::WWW::Mechanize->text_lacks called incorrectly.  It requires a scalar, not a reference.' );
    }
    $desc = qq{Text lacks "$str"} if !defined($desc);

    return lacks_string( $self->text, $str, $desc );
}

=head2 $mech->text_like( $regex [, $desc ] )

Tells if the text form of the page's content matches I<$regex>.

=cut

sub text_like {
    my $self  = shift;
    my $regex = shift;
    my $desc  = shift || qq{Text is like "$regex"};

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return like_string( $self->text, $regex, $desc );
}

=head2 $mech->text_unlike( $regex [, $desc ] )

Tells if the text format of the page's content does NOT match I<$regex>.

=cut

sub text_unlike {
    my $self  = shift;
    my $regex = shift;
    my $desc  = shift || qq{Text is unlike "$regex"};

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return unlike_string( $self->text, $regex, $desc );
}

=head2 $mech->has_tag( $tag, $text [, $desc ] )

Tells if the page has a C<$tag> tag with the given content in its text.

=cut

sub has_tag {
    my $self = shift;
    my $tag  = shift;
    my $text = shift;
    my $desc = shift || qq{Page has $tag tag with "$text"};

    my $found = $self->_tag_walk( $tag, sub { $text eq $_[0] } );

    return $TB->ok( $found, $desc );
}


=head2 $mech->has_tag_like( $tag, $regex [, $desc ] )

Tells if the page has a C<$tag> tag with the given content in its text.

=cut

sub has_tag_like {
    my $self = shift;
    my $tag  = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{Page has $tag tag like "$regex"} if !defined($desc);

    my $found = $self->_tag_walk( $tag, sub { $_[0] =~ $regex } );

    return $TB->ok( $found, $desc );
}


sub _tag_walk {
    my $self = shift;
    my $tag  = shift;
    my $match = shift;

    my $p = HTML::TokeParser->new( \($self->content) );

    while ( my $token = $p->get_tag( $tag ) ) {
        my $tagtext = $p->get_trimmed_text();
        return 1 if $match->( $tagtext );
    }
    return;
}

=head2 $mech->followable_links()

Returns a list of links that Mech can follow.  This is only http and
https links.

=cut

sub followable_links {
    my $self = shift;

    return $self->find_all_links( url_abs_regex => qr{^(?:https?|file)://} );
}

=head2 $mech->page_links_ok( [ $desc ] )

Follow all links on the current page and test for HTTP status 200

    $mech->page_links_ok('Check all links');

=cut

sub page_links_ok {
    my $self = shift;
    my $desc = shift;

    $desc = 'All links ok' unless defined $desc;

    my @links = $self->followable_links();
    my @urls = _format_links(\@links);

    my @failures = $self->_check_links_status( \@urls );
    my $ok = (@failures==0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->page_links_content_like( $regex [, $desc ] )

Follow all links on the current page and test their contents for I<$regex>.

    $mech->page_links_content_like( qr/foo/,
      'Check all links contain "foo"' );

=cut

sub page_links_content_like {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;

    $desc = qq{All links are like "$regex"} unless defined $desc;

    my $usable_regex=$TB->maybe_regex( $regex );

    if ( !defined( $usable_regex ) ) {
        my $ok = $TB->ok( 0, 'page_links_content_like' );
        $TB->diag(qq{     "$regex" doesn't look much like a regex to me.});
        return $ok;
    }

    my @links = $self->followable_links();
    my @urls = _format_links(\@links);

    my @failures = $self->_check_links_content( \@urls, $regex );
    my $ok = (@failures==0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->page_links_content_unlike( $regex [, $desc ] )

Follow all links on the current page and test their contents do not
contain the specified regex.

    $mech->page_links_content_unlike(qr/Restricted/,
      'Check all links do not contain Restricted');

=cut

sub page_links_content_unlike {
    my $self = shift;
    my $regex = shift;
    my $desc = shift;
    $desc = qq{All links are unlike "$regex"} unless defined($desc);

    my $usable_regex=$TB->maybe_regex( $regex );

    if ( !defined( $usable_regex ) ) {
        my $ok = $TB->ok( 0, 'page_links_content_unlike' );
        $TB->diag(qq{     "$regex" doesn't look much like a regex to me.});
        return $ok;
    }

    my @links = $self->followable_links();
    my @urls = _format_links(\@links);

    my @failures = $self->_check_links_content( \@urls, $regex, 'unlike' );
    my $ok = (@failures==0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->links_ok( $links [, $desc ] )

Follow specified links on the current page and test for HTTP status
200.  The links may be specified as a reference to an array containing
L<WWW::Mechanize::Link> objects, an array of URLs, or a scalar URL
name.

    my @links = $mech->find_all_links( url_regex => qr/cnn\.com$/ );
    $mech->links_ok( \@links, 'Check all links for cnn.com' );

    my @links = qw( index.html search.html about.html );
    $mech->links_ok( \@links, 'Check main links' );

    $mech->links_ok( 'index.html', 'Check link to index' );

=cut

sub links_ok {
    my $self = shift;
    my $links = shift;
    my $desc = shift;

    my @urls = _format_links( $links );
    $desc = _default_links_desc(\@urls, 'are ok') unless defined $desc;
    my @failures = $self->_check_links_status( \@urls );
    my $ok = (@failures == 0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->link_status_is( $links, $status [, $desc ] )

Follow specified links on the current page and test for HTTP status
passed.  The links may be specified as a reference to an array
containing L<WWW::Mechanize::Link> objects, an array of URLs, or a
scalar URL name.

    my @links = $mech->followable_links();
    $mech->link_status_is( \@links, 403,
      'Check all links are restricted' );

=cut

sub link_status_is {
    my $self = shift;
    my $links = shift;
    my $status = shift;
    my $desc = shift;

    my @urls = _format_links( $links );
    $desc = _default_links_desc(\@urls, "have status $status") if !defined($desc);
    my @failures = $self->_check_links_status( \@urls, $status );
    my $ok = (@failures == 0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->link_status_isnt( $links, $status [, $desc ] )

Follow specified links on the current page and test for HTTP status
passed.  The links may be specified as a reference to an array
containing L<WWW::Mechanize::Link> objects, an array of URLs, or a
scalar URL name.

    my @links = $mech->followable_links();
    $mech->link_status_isnt( \@links, 404,
      'Check all links are not 404' );

=cut

sub link_status_isnt {
    my $self = shift;
    my $links = shift;
    my $status = shift;
    my $desc = shift;

    my @urls = _format_links( $links );
    $desc = _default_links_desc(\@urls, "do not have status $status") if !defined($desc);
    my @failures = $self->_check_links_status( \@urls, $status, 'isnt' );
    my $ok = (@failures == 0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}


=head2 $mech->link_content_like( $links, $regex [, $desc ] )

Follow specified links on the current page and test the resulting
content of each against I<$regex>.  The links may be specified as a
reference to an array containing L<WWW::Mechanize::Link> objects, an
array of URLs, or a scalar URL name.

    my @links = $mech->followable_links();
    $mech->link_content_like( \@links, qr/Restricted/,
        'Check all links are restricted' );

=cut

sub link_content_like {
    my $self = shift;
    my $links = shift;
    my $regex = shift;
    my $desc = shift;

    my $usable_regex=$TB->maybe_regex( $regex );

    if ( !defined( $usable_regex ) ) {
        my $ok = $TB->ok( 0, 'link_content_like' );
        $TB->diag(qq{     "$regex" doesn't look much like a regex to me.});
        return $ok;
    }

    my @urls = _format_links( $links );
    $desc = _default_links_desc( \@urls, qq{are like "$regex"} ) if !defined($desc);
    my @failures = $self->_check_links_content( \@urls, $regex );
    my $ok = (@failures == 0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

=head2 $mech->link_content_unlike( $links, $regex [, $desc ] )

Follow specified links on the current page and test that the resulting
content of each does not match I<$regex>.  The links may be specified as a
reference to an array containing L<WWW::Mechanize::Link> objects, an array
of URLs, or a scalar URL name.

    my @links = $mech->followable_links();
    $mech->link_content_unlike( \@links, qr/Restricted/,
      'No restricted links' );

=cut

sub link_content_unlike {
    my $self = shift;
    my $links = shift;
    my $regex = shift;
    my $desc = shift;

    my $usable_regex=$TB->maybe_regex( $regex );

    if ( !defined( $usable_regex ) ) {
        my $ok = $TB->ok( 0, 'link_content_unlike' );
        $TB->diag(qq{     "$regex" doesn't look much like a regex to me.});
        return $ok;
    }

    my @urls = _format_links( $links );
    $desc = _default_links_desc( \@urls, qq{are not like "$regex"} ) if !defined($desc);
    my @failures = $self->_check_links_content( \@urls, $regex, 'unlike' );
    my $ok = (@failures == 0);

    $TB->ok( $ok, $desc );
    $TB->diag( $_ ) for @failures;

    return $ok;
}

# Create a default description for the link_* methods, including the link count.
sub _default_links_desc {
    my ($urls, $desc_suffix) = @_;
    my $url_count = scalar(@{$urls});
    return sprintf( '%d link%s %s', $url_count, $url_count == 1 ? '' : 's', $desc_suffix );
}

# This actually performs the status check of each url.
sub _check_links_status {
    my $self = shift;
    my $urls = shift;
    my $status = shift || 200;
    my $test = shift || 'is';

    # Create a clone of the $mech used during the test as to not disrupt
    # the original.
    my $mech = $self->clone();

    my @failures;

    for my $url ( @{$urls} ) {
        if ( $mech->follow_link( url => $url ) ) {
            if ( $test eq 'is' ) {
                push( @failures, $url ) unless $mech->status() == $status;
            }
            else {
                push( @failures, $url ) if $mech->status() == $status;
            }
            $mech->back();
        }
        else {
            push( @failures, $url );
        }
    } # for

    return @failures;
}

# This actually performs the content check of each url. 
sub _check_links_content {
    my $self = shift;
    my $urls = shift;
    my $regex = shift || qr/<html>/;
    my $test = shift || 'like';

    # Create a clone of the $mech used during the test as to not disrupt
    # the original.
    my $mech = $self->clone();

    my @failures;
    for my $url ( @{$urls} ) {
        if ( $mech->follow_link( url => $url ) ) {
            my $content=$mech->content();
            if ( $test eq 'like' ) {
                push( @failures, $url ) unless $content =~ /$regex/;
            }
            else {
                push( @failures, $url ) if $content =~ /$regex/;
            }
            $mech->back();
        }
        else {
            push( @failures, $url );
        }
    } # for

    return @failures;
}

# Create an array of urls to match for mech to follow.
sub _format_links {
    my $links = shift;

    my @urls;
    if (ref($links) eq 'ARRAY') {
        my $link = $links->[0];
        if ( defined($link) ) {
            if ( ref($link) eq 'WWW::Mechanize::Link' ) {
                @urls = map { $_->url() } @{$links};
            }
            else {
                @urls = @{$links};
            }
        }
    }
    else {
        push(@urls,$links);
    }
    return @urls;
}

=head2 $mech->stuff_inputs( [\%options] )

Finds all free-text input fields (text, textarea, and password) in the
current form and fills them to their maximum length in hopes of finding
application code that can't handle it.  Fields with no maximum length
and all textarea fields are set to 66000 bytes, which will often be
enough to overflow the data's eventual recepticle.

There is no return value.

If there is no current form then nothing is done.

The hashref $options can contain the following keys:

=over

=item * ignore

hash value is arrayref of field names to not touch, e.g.:

    $mech->stuff_inputs( {
        ignore => [qw( specialfield1 specialfield2 )],
    } );

=item * fill

hash value is default string to use when stuffing fields.  Copies
of the string are repeated up to the max length of each field.  E.g.:

    $mech->stuff_inputs( {
        fill => '@'  # stuff all fields with something easy to recognize
    } );

=item * specs

hash value is arrayref of hashrefs with which you can pass detailed
instructions about how to stuff a given field.  E.g.:

    $mech->stuff_inputs( {
        specs=>{
            # Some fields are datatype-constrained.  It's most common to
            # want the field stuffed with valid data.
            widget_quantity => { fill=>'9' },
            notes => { maxlength=>2000 },
        }
    } );

The specs allowed are I<fill> (use this fill for the field rather than
the default) and I<maxlength> (use this as the field's maxlength instead
of any maxlength specified in the HTML).

=back

=cut

sub stuff_inputs {
    my $self = shift;

    my $options = shift || {};
    assert_isa( $options, 'HASH' );
    assert_in( $_, ['ignore', 'fill', 'specs'] ) foreach ( keys %{$options} );

    # set up the fill we'll use unless a field overrides it
    my $default_fill = '@';
    if ( exists $options->{fill} && defined $options->{fill} && length($options->{fill}) > 0 ) {
        $default_fill = $options->{fill};
    }

    # fields in the form to not stuff
    my $ignore = {};
    if ( exists $options->{ignore} ) {
        assert_isa( $options->{ignore}, 'ARRAY' );
        $ignore = { map {($_, 1)} @{$options->{ignore}} };
    }

    my $specs = {};
    if ( exists $options->{specs} ) {
        assert_isa( $options->{specs}, 'HASH' );
        $specs = $options->{specs};
        foreach my $field_name ( keys %{$specs} ) {
            assert_isa( $specs->{$field_name}, 'HASH' );
            assert_in( $_, ['fill', 'maxlength'] ) foreach ( keys %{$specs->{$field_name}} );
        }
    }

    my @inputs = $self->find_all_inputs( type_regex => qr/^(text|textarea|password)$/ );

    foreach my $field ( @inputs ) {
        next if $field->readonly();
        next if $field->disabled();  # TODO: HTML::Form::TextInput allows setting disabled--allow it here?

        my $name = $field->name();

        # skip if it's one of the fields to ignore
        next if exists $ignore->{ $name };

        # fields with no maxlength will get this many characters
        my $maxlength = 66000;

        # maxlength from the HTML
        if ( $field->type ne 'textarea' ) {
            if ( exists $field->{maxlength} ) {
                $maxlength = $field->{maxlength};
                # TODO: what to do about maxlength==0 ?  non-numeric? less than 0 ?
            }
        }

        my $fill = $default_fill;

        if ( exists $specs->{$name} ) {
            # process the per-field info

            if ( exists $specs->{$name}->{fill} && defined $specs->{$name}->{fill} && length($specs->{$name}->{fill}) > 0 ) {
                $fill = $specs->{$name}->{fill};
            }

            # maxlength override from specs
            if ( exists $specs->{$name}->{maxlength} && defined $specs->{$name}->{maxlength} ) {
                $maxlength = $specs->{$name}->{maxlength};
                # TODO: what to do about maxlength==0 ?  non-numeric? less than 0?
            }
        }

        # stuff it
        if ( ($maxlength % length($fill)) == 0 ) {
            # the simple case
            $field->value( $fill x ($maxlength/length($fill)) );
        }
        else {
            # can be improved later
            $field->value( substr( $fill x int(($maxlength + length($fill) - 1)/length($fill)), 0, $maxlength ) );
        }
    } # for @inputs

    return;
}



=head2 $mech->lacks_uncapped_inputs( [$comment] )

Executes a test to make sure that the current form content has no
text input fields that lack the C<maxlength> attribute, and that each
C<maxlength> value is a positive integer.  The test fails if the current
form has such a field, and succeeds otherwise.

Returns an array containing all text input fields in the current
form that do not specify a maximum input length.  Fields for which
the concept of input length is irrelevant, and controls that HTML
does not allow to be capped (e.g. textarea) are ignored.

The inputs in the returned array are descended from HTML::Form::Input.

The return is true if the test succeeded, false otherwise.

=cut

sub lacks_uncapped_inputs {
    my $self    = shift;
    my $comment = shift;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my @uncapped;

    my @inputs = $self->grep_inputs( { type => qr/^(?:text|password)$/ } );
    foreach my $field ( @inputs ) {
        next if $field->readonly();
        next if $field->disabled();

        if ( not defined($field->{maxlength}) ) {
            push( @uncapped, $field->name . ' has no maxlength attribute' );
            next;
        }

        my $val = $field->{maxlength};
        if ( ($val !~ /^\s*\d+\s*$/) || ($val+0 <= 0) ) {
            push( @uncapped, $field->name . qq{ has an invalid maxlength attribute of "$val"} );
        }
    }

    my $ok = $TB->cmp_ok( scalar @uncapped, '==', 0, $comment );
    $TB->diag( $_ ) for @uncapped;

    return $ok;
}


=head1 METHODS: MISCELLANEOUS

=head2 $mech->autolint( [$status] )

Without an argument, this method returns a true or false value indicating
whether autolint is active.

When passed an argument, autolint is turned on or off depending on whether
the argument is true or false, and the previous autolint status is returned.
As with the autolint option of C<< new >>, C<< $status >> can be an
L<< HTML::Lint >> object.

If autolint is currently using an L<< HTML::Lint >> object you provided,
the return is that object, so you can change and exactly restore
autolint status:

    my $old_status = $mech->autolint( 0 );
    ... operations that should not be linted ...
    $mech->autolint( $old_status );

=cut

sub autolint {
    my $self = shift;

    my $ret = $self->{autolint};
    if ( @_ ) {
        $self->{autolint} = shift;
    }

    return $ret;
}


=head2 $mech->grep_inputs( \%properties )

grep_inputs() returns an array of all the input controls in the
current form whose properties match all of the regexes in $properties.
The controls returned are all descended from HTML::Form::Input.

If $properties is undef or empty then all inputs will be
returned.

If there is no current page, there is no form on the current
page, or there are no submit controls in the current form
then the return will be an empty array.

    # get all text controls whose names begin with "customer"
    my @customer_text_inputs =
        $mech->grep_inputs( {
            type => qr/^(text|textarea)$/,
            name => qr/^customer/
        }
    );

=cut

sub grep_inputs {
    my $self = shift;
    my $properties = shift;

    my @found;

    my $form = $self->current_form();
    if ( $form ) {
        my @inputs = $form->inputs();
        @found = _grep_hashes( \@inputs, $properties );
    }

    return @found;
}


=head2 $mech->grep_submits( \%properties )

grep_submits() does the same thing as grep_inputs() except that
it only returns controls that are submit controls, ignoring
other types of input controls like text and checkboxes.

=cut

sub grep_submits {
    my $self = shift;
    my $properties = shift || {};

    $properties->{type} = qr/^(?:submit|image)$/;  # submits only
    my @found = $self->grep_inputs( $properties );

    return @found;
}

# search an array of hashrefs, returning an array of the incoming
# hashrefs that match *all* the pattern in $patterns.
sub _grep_hashes {
    my $hashes = shift;
    my $patterns = shift || {};

    my @found;

    if ( ! %{$patterns} ) {
        # nothing to match on, so return them all
        @found = @{$hashes};
    }
    else {
        foreach my $hash ( @{$hashes} ) {

            # check every pattern for a match on the current hash
            my $matches_everything = 1;
            foreach my $pattern_key ( keys %{$patterns} ) {
                $matches_everything = 0 unless exists $hash->{$pattern_key} && $hash->{$pattern_key} =~ $patterns->{$pattern_key};
                last if !$matches_everything;
            }

            push @found, $hash if $matches_everything;
        }
    }

    return @found;
}


=head2 $mech->scrape_text_by_attr( $attr, $attr_value [, $html ] )

=head2 $mech->scrape_text_by_attr( $attr, $attr_regex [, $html ] )

Returns an array of strings, each string the text surrounded by an
element with attribute I<$attr> of value I<$value>.  You can also pass in
a regular expression.  If nothing is found the return is an empty list.
In scalar context the return is the first string found.

If passed, I<$html> is scraped instead of the current page's content.

=cut

sub scrape_text_by_attr {
    my $self = shift;
    my $attr = shift;
    my $value = shift;

    my $html = $self->_get_optional_html( @_ );

    my @results;

    if ( defined $html ) {
        my $parser = HTML::TokeParser->new(\$html);

        while ( my $token = $parser->get_tag() ) {
            if ( ref $token->[1] eq 'HASH' ) {
                if ( exists $token->[1]->{$attr} ) {
                    my $matched =
                        (ref $value eq 'Regexp')
                            ? $token->[1]->{$attr} =~ $value
                            : $token->[1]->{$attr} eq $value;
                    if ( $matched ) {
                        my $tag = $token->[ 0 ];
                        push @results, $parser->get_trimmed_text( "/$tag" );
                        if ( !wantarray ) {
                            last;
                        }
                    }
                }
            }
        }
    }

    return $results[0] if !wantarray;
    return @results;
}


=head2 scrape_text_by_id( $id [, $html ] )

Finds all elements with the given id attribute and pulls out the text that that element encloses.

In list context, returns a list of all strings found. In scalar context, returns the first one found.

If C<$html> is not provided then the current content is used.

=cut

sub scrape_text_by_id {
    my $self = shift;
    my $id   = shift;

    my $html = $self->_get_optional_html( @_ );

    my @results;

    if ( defined $html ) {
        my $found = index( $html, "id=\"$id\"" );
        if ( $found >= 0 ) {
            my $parser = HTML::TokeParser->new( \$html );

            while ( my $token = $parser->get_tag() ) {
                if ( ref $token->[1] eq 'HASH' ) {
                    my $actual_id = $token->[1]->{id};
                    $actual_id = '' unless defined $actual_id;
                    if ( $actual_id eq $id ) {
                        my $tag = $token->[ 0 ];
                        push @results, $parser->get_trimmed_text( "/$tag" );
                        if ( !wantarray ) {
                            last;
                        }
                    }
                }
            }
        }
    }

    return $results[0] if !wantarray;
    return @results;
}


sub _get_optional_html {
    my $self = shift;

    my $html;
    if ( @_ ) {
        $html = shift;
        assert_nonblank( $html, '$html passed in is a populated scalar' );
    }
    else {
        if ( $self->is_html ) {
            $html = $self->content();
        }
    }

    return $html;
}


=head2 $mech->scraped_id_is( $id, $expected [, $msg] )

Scrapes the current page for given ID and tests that it matches the expected value.

=cut

sub scraped_id_is {
    my $self     = shift;
    my $id       = shift;
    my $expected = shift;
    my $msg      = shift;

    if ( not defined $msg ) {
        my $what = defined( $expected ) ? $expected : '(undef)';

        $msg = qq{scraped id "$id" is "$what"};
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $got = $self->scrape_text_by_id($id);
    is( $got, $expected, $msg );

    return;
}

sub  browserToPage {
	my  ( $self  , $pageName  )   =  @_;
	$self->{agent}->click($pageName);
	my  $page =  $self->{agent}->follow_link('text' => $pageName);
	&load_class("WWW::Azantek::"+$page+"::Class") if $page->success; 
	}
			
sub load_class {
  my ($class) = @_;
  (my $file = $class+".pm") =~ s/::/\//g;
  unless( $INC{$file} ) {
		  require $file;
   	   $class->import;
		  }# end unless();
	}# end load_class()











1;

__END__

=pod

=head1 NAME

WWW::Azantek - class to assist in interacting with Azantek user interface

=head1 VERSION

This documentation describes version 0.01

=head1 SYNOPSIS

The module lets the user interact with Azanteks useristrative web interface.
This can be used for automating tasks of processing data exports etc.

    use WWW::Azantek;

    #All mandatory parameters
    #Please note Azantek can be configured to use authorization on IP
    #meaning authentication is unnessesary
    my $wd = WWW::Azantek->new({
        url => 'http://localhost/cgi-bin/login.pl',
    });

    #With optional authentication credentials
    my $wd = WWW::Azantek->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
    });

    #with verbosity enabled
    my $wd = WWW::Azantek->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
        verbose  => 1,
    });

    #With caching
    my $wd = WWW::Azantek->new({
        cache    => 1,
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
    });


    #With custom WWW::Mechanize object
    use WWW::Mechanize;

    my $mech = WWW::Mechanize->new(agent => 'MEGAnice bot');

    my $wd = WWW::Azantek->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
        mech     => $mech,
    });
    
    
    #The intended use
    package My::WWW::Azantek::Subclass;
    
    sub processor {
        my ( $self, $content ) = @_;
        
        #Note the lines terminations are Windows CRLF
        my @lines = split /\r\n/, $$content;
        
        ...
        
        }
    }
    
    
    #Using your new class
    my $my = My::WWW::Azantek::Subclass->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
    });
    
    my $content = $my->retrieve();
    
    print $$content;


    #Using a processor implemented as a code reference
    $wd = WWW::Azantek->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
    	processor => sub {                
            ${$_[0]} =~ s/test/fest/;        
            return $_[0];
        },
    });    


    #Implementing a processor class
    my $processor = MY::Processor->new();
    
    UNIVERSAL::can($processor, 'process');
    
    $wd = WWW::Azantek->new({
        username => 'tester@tester.com',
        password => 'tester29',
        url => 'http://localhost/cgi-bin/login.pl',
    	processor => $processor,
    });
    
    my $content = $wd->retrieve();
    
    print ${$content};

=head1 DESCRIPTION

This module is a simple wrapper around L<WWW::Mechanize> it assists the user
in getting going with automating tasks related to the Azantek useristrative
web interface.

Such as:

=over

=item * manipulating data exports (removing, adjusting, calculating, adding
columns)

=item * filling in missing data (combining data)

=item * converting formats (from CSV to XML, JSON, CSV, whatever)

=back

=head1 METHODS

=head2 new

This is the constructor.

The constructor takes a hash reference as input. The hash reference should
contain keys according to the following conventions:

=over

=item * username, optional username credential to access Azantek 

=item * password, optional password credential to access Azantek

=item * url, the mandatory URL to retrieve data from (L</retrieve>)

=item * mech, a L<WWW::Mechanize> object if you have a pre instantiated object
or some other object implementing the the same API as L<WWW::Mechanize>.

The parameter is optional. 

See also cache parameter below for an example.

=item * verbose, a flag for indicating verbosity, default is 0 (disabled), the
parameter is optional

=item * cache, usage of a cache meaning that we internally use
L<WWW::Mechanize::Cached> instead of L<WWW::Mechanize>.

The parameter is optional

=item * processor

This parameter can be used of you do not want to implement a subclass of
WWW::Azantek.

The processor parameter can either be:

=over

=item * an object implementing a L</proces> method, with the following profile:

    proces(\$content);

=item * a code reference with the same profile, adhering to the following example:

    sub { return ${$_[0]} };

=back

=back

=head2 retrieve

Parameters:

=over

=item * a hash reference, the reference can be populated with statistic
information based on the lineprocessing (L</processor>) initiated from
L</retrieve>.

=back

The method returns a scalar reference to a string containing the content
retrieved from the URL provided to the contructor (L</new>). If the
L</processor> method is overwritten you can manipulate the content prior
to being returned.

=head2 process

Takes the content retrieved (see: L</retrieve>) from the URL parameter provided
to the constructor (see: L</new>). You can overwrite the behaviour via the
constructor (see: L</new>).

Parameters:

=over

=item * a scalar reference to a string to be processed line by line

=back

The stub does however not do anything, but it returns the scalar reference
I<untouched>.

=head2 processor

This is a wrapper for L</process>, provided for backwards compatibility.

=head1 DIAGNOSTICS

=over

=item * Unable to authenticate, username and password not valid credentials

=item * Both username and password is required for authentication

If you want to use authentication you have to provide both B<username> and
B<password>.

=item * Unable to retrieve base URL: $@

The base URL provided to retrieve gives an error.

Please see: L<http://search.cpan.org/perldoc?HTTP%3A%3AResponse> or
L<http://search.cpan.org/~gaas/libwww-perl/lib/HTTP/Status.pm>

Test the URL in your browser to investigate.

=item * Unable to retrieve URL: $@

The base URL provided to retrieve gives an error.

Please see: L<http://search.cpan.org/perldoc?HTTP%3A%3AResponse> or
L<http://search.cpan.org/~gaas/libwww-perl/lib/HTTP/Status.pm>

Test the URL in your browser to investigate.

=back

=head1 CONFIGURATION AND ENVIRONMENT

The module requires Internet access to make sense and an account with Azantek
with username and password is required.

=head1 DEPENDENCIES

=over

=item * L<WWW::Mechanize>

=item * L<Carp>

=back

=head1 TEST AND QUALITY

The tests are based on L<Test::MockObject::Extends> and example data are
mocked dummy data. Please see the TODO section.

The test suite uses the following environment variables as flags:

=over

=item TEST_AUTHOR, to test prerequisites, using L<Test::Prereq>

=item TEST_CRITIC, to do a static analysis of the code, using L<Perl::Critic>,
see also QUALITY AND CODING STANDARD

=back

=head2 TEST COVERAGE

The following data are based on an analysis created using L<Devel::Cover> and
the distributions own test suite, instantiated the following way.

    % ./Build testcover --verbose

---------------------------- ------ ------ ------ ------ ------ ------ ------
File                           stmt   bran   cond    sub    pod   time  total
---------------------------- ------ ------ ------ ------ ------ ------ ------
blib/lib/WWW/Azantek.pm     100.0  100.0  100.0  100.0  100.0  100.0  100.0
Total                         100.0  100.0  100.0  100.0  100.0  100.0  100.0
---------------------------- ------ ------ ------ ------ ------ ------ ------

Please note the report is based on version 0.03 of WWW::Azantek

=head1 QUALITY AND CODING STANDARD

The code passes L<Perl::Critic> tests a severity: 1 (brutal)

The following policies have been disabled:

=over

=item L<Perl::Critic::Policy::InputOutput::RequireBracedFileHandleWithPrint>

=back

L<Perl::Critic> resource file, can be located in the t/ directory of the
distribution F<t/perlcriticrc>

L<Perl::Tidy> resource file, can be obtained from the original author

=head1 BUGS AND LIMITATIONS

No known bugs at this time.

=head1 BUG REPORTING

Please report any bugs or feature requests via:

=over

=item * email: C<bug-www-dandomain at rt.cpan.org>

=item * HTTP: L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Azantek>

=back

=head1 DEVELOPMENT

=over

=item * Subversion repository: L<http://logicLAB.jira.com/svn/DAND>

=back

=head1 TODO

=over

=item * Most of the work is done in the classes inheriting from this class,
there could however be work to do in the maintenance area, making this class
more informative if failing

=item * I would like to add some integration test scripts so I can see that the
package works with real data apart from the mock.

=back

=head1 SEE ALSO

=over

=item * L<http://www.dandomain.dk>

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Azantek

You can also look for information at:

=over 4

=item * Official Wiki


=item * AnnoCPAN: Annotated CPAN documentation




=head1 AUTHOR

=over

=item * pdam, C<< <pdam.2010 at gmail.com> >>

=back

=head1 MOTIVATION

This module grew out of a small script using L<WWW::Mechanize> to fetch some
data from a website and changing it to satisfy the client utilizing the data.

More a more scripts where based on the original script giving a lot of redundant
code. Finally I refactored the lot to use some common code base.

After some time I refactored to an object oriented structure making it even
easier to maintain and adding more clients. This made the actual connectivity
into a package (this package) letting it loose as open source.

=head1 ACKNOWLEDGEMENTS

=over

=item * Andy Lester (petdance) the author of L<WWW::Mechanize> and
L<WWW::Mechanize:Cached>, this module makes easy things easy and hard things
possible.


=back

=head1 LICENSE AND COPYRIGHT

Copyright 2012 pdam, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


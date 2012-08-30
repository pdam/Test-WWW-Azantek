package WWW::AzantekUser;
require  WWW::Mechanize;
require HTML::TableExtract;
use Carp qw(croak);
use base( 'WWW::Mechanize' );
our $VERSION = '0.10';
our $croak_on_error = 0;
our $errstr = '';
our $errhtml = '';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(agent => "Mozilla/4.0 \(compatible; MSIE 6.0; Windows NT 5.1\)");
    $self->cookie_jar({});
    return $self;
}

sub login {
	my ($self, $hostname , $email,$pass) = @_;
	unless ($email =~ m/\@([^.]+)\.(.+)/) {
		$errstr = 'You must supply full email addres as the username';
		croak $errstr if $croak_on_error;
		$self->error2html();
		return undef;
	}
	my $resp = $self->get('http://'.$hostname.'/cgi-bin/login.pl');
    $resp->is_success || do {
		$errstr = $resp->as_string();
		croak $errstr if $croak_on_error;
		$errhtml = $resp->error_as_HTML;
		return undef;
	};
	   

    $self->field(username => $email);
    $self->field(password => $pass);
    $resp = $self->submit();
    $resp->is_success || do {
		$errstr = $resp->as_string;
		croak $errstr if $croak_on_error;
		$errhtml = $resp->error_as_HTML;
		return undef;
	};
	    $self->{content} =~ /<p>Logged in as <b>.$email/ or do {
			$errstr = 'User Login failed got   '.$self->{content};
			croak $errstr if $croak_on_error;
			$self->error2html();
			return undef;
		};
		$self->{logged_in} = 1;
		return $self ;
	}


	sub get_tables_in_page {
            my $self = shift;
		my @tables  = ();
		unless (defined($self->{logged_in})) {
			$errstr = 'Not logged in!';
			croak $errstr if $croak_on_error;
			$self->error2html();
			return ();
				}
			$te = new HTML::TableExtract( count => 1 );
			@tables =  $te->parse($self->{content});
			return   @tables		
		}

	sub  find_columns_for_table  {
		my  $self  =  shift;
		my  $depth =  shift ;
		my  $count   =  shift ;
		@tables =  get_tables_in_page();
		foreach my $table (@tables) {
			if  (  $table == tables($depth , $count) ) {
				return  $table->columns() ;
                     }
		}
		}

	sub   find_column_data_as_list  {
		my $table = 'HTML::TableExtract'->new('headers', [@columns]);
		(my $content = $self->content) =~ s/&nbsp;?//g;
		$table->parse($content);
		my @lines;
		push @lines, join(', ', @columns), "\n";
		foreach my $ts ($table->table_states) {
		foreach my $row ($ts->rows) {
		push @lines, '>' . join(', ', @$row) . "<\n";
		}
		}
		print (@lines);
		return  (@lines);

	}


	sub error2html {
			shift if (ref($_[0]));
		my $body = shift || $errstr;
		$errhtml = <<EOM;
<HTML>
<HEAD><TITLE>Error</TITLE></HEAD>
<BODY>
<H1>Error</H1>
$body
</BODY>
</HTML>
EOM
}


1;
__END__

=head1 NAME

WWW::Azantek - Connect to Azantek, download, delete and send messages

=head1 SYNOPSIS

  use WWW::Azantek;
  
  my $hotmail = WWW::Azantek->new();
  
  $hotmail->login('foo@hotmail.com', "bar")
   or die $WWW::Azantek::errstr;
  
  my @msgs = $hotmail->messages();
  die $WWW::Azantek::errstr if ($!);

  print "You have ".scalar(@msgs)." messages\n";

  for (@msgs) {
  	print "messge from ".$_->from."\n";
	# retrieve the message from hotmail
  	my $mail = $_->retrieve;
	# deliver it locally
	$mail->accept;
	# forward the message
	$mail->resend('myother@email.address.com');
	# delete it from the inbox
  	$_->delete;
  }
  
  $hotmail->compose(
    to      => ['user@email.com','otheruser@otheremail.com'],
    subject => 'Hello Person!',
    body    => q[Dear Person,
  
  I am writing today to tell you about something important.

  Thanks for all your support.
  
  Sincerely,
  Other Person
  ]) or die $WWW::Azantek::errstr;

=head1 DESCRIPTION

This module is a partial replacement for the C<gotmail> script
(http://ssl.usu.edu/paul/gotmail/), so if this doesn't do what you want,
try that instead.

Create a new C<WWW::Azantek> object with C<new>, and then log in with
your MSN username and password with the C<login> method.

=head1 METHODS

=head2 login

Make sure to add the domain to your username, for example foo@hotmail.com.
Then this will allow you to use the C<messages> method to look at the mail
in your inbox. The login method does not retrieve messages on login.  The
messages method does that now.

=head2 messages

This method returns a list of C<WWW::Azantek::Message>s; each message
supports four methods: C<subject> gives you the subject of the email,
just because it was stunningly easy to implement. C<retrieve> retrieves
an email into a C<Mail::Audit> object - see L<Mail::Audit> for more
details. C<from> gives you the from field. Finally C<delete> moves it
to your trash.

=head2 compose

You can use the C<compose> message to send a message through the 
account you are currently logged in to.  You should be able to use
this method as many times and as often as you like during the life
of the C<WWW::Azantek> object.  As its argument, it takes a hash whose
keys are C<to>, C<cc>, C<bcc>, C<subject>, C<body>.  Newlines should
work fine in the C<body> argument.  Any field can be an array; it will
be joined with a comma.  This function returns 1 on success and undef 
on failure.  Check $WWW::Azantek::errstr for errors, or use 
$WWW::Azantek::errhtml for an html version of the error.

=head1 NOTES

This module used to croak errors for you.  If you would like this behavior,
then add $WWW::Azantek::croak_on_error = 1; to your script.  It will not
croak html.

This module should work with email addresses at charter.com, compaq.net,
hotmail.com, msn.com, passport.com, and webtv.net

This module is reasonably fragile. It seems to work, but I haven't
tested edge cases. If it breaks, you get to keep both pieces. I hope
to improve it in the future, but this is enough for release.

=head1 SEE ALSO

L<WWW::Mechanize>, L<Mail::Audit>, C<gotmail>

=head1 AUTHOR

David Davis, E<lt>xantus@cpan.orgE<gt>
- I've taken ownership of this module, please direct all questions to me.

=head1 ORIGINAL AUTHOR

Simon Cozens, E<lt>simon@kasei.comE<gt>

=head1 CONTRIBUTIONS

David M. Bradford E<lt>dave@tinypig.comE<gt>
- Added the ability to send messages via hotmail.

=head1 COPYRIGHT AND LICENSE

Copyright 2003-2004 by Kasei
Copyright 2004 by David Davis

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut


#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
use WWW::Mechanize::FormFiller;
use URI::URL;

my $agent = WWW::Mechanize->new( autocheck => 1 );
my $formfiller = WWW::Mechanize::FormFiller->new();
$agent->env_proxy();

  $agent->get('http://localhost/cgi-bin/login.pl');
   $agent->form_number(1) if $agent->forms and scalar @{$agent->forms};
  $formfiller->add_filler( 'username' => Fixed => 'tester@tester.com' );
  $formfiller->add_filler( 'password' => Fixed => 'tester29' );$formfiller->fill_form($agent->current_form);
  $agent->submit();
  $formfiller->add_filler( 'username' => Fixed => 'tester@tester.com' );
  $formfiller->add_filler( 'password' => Fixed => 'tester29' );$formfiller->fill_form($agent->current_form);
  $agent->submit();
  require HTML::TableExtract;
  my @columns = ( '0' );
  
      my $table = 'HTML::TableExtract'->new('headers', [@columns]);
      (my $content = $agent->content) =~ s/&nbsp;?//g;
      $table->parse($content);
      my @lines;
      push @lines, join(', ', @columns), "\n";
      foreach my $ts ($table->table_states) {
          foreach my $row ($ts->rows) {
              push @lines, '>' . join(', ', @$row) . "<\n";
          }
      }
      print (@lines);

  require HTML::TableExtract;
  my @columns = ( '1' );
  
      my $table = 'HTML::TableExtract'->new('headers', [@columns]);
      (my $content = $agent->content) =~ s/&nbsp;?//g;
      $table->parse($content);
      my @lines;
      push @lines, join(', ', @columns), "\n";
      foreach my $ts ($table->table_states) {
          foreach my $row ($ts->rows) {
              push @lines, '>' . join(', ', @$row) . "<\n";
          }
      }
      print (@lines);


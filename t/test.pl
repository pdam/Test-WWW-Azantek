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
  $agent->submit();
  $agent->get('http://test.azantek.com/cgi-bin/gps_read.pl');
   $agent->form_number(1) if $agent->forms and scalar @{$agent->forms};
  $agent->get('http://start/cgi-bin/gps_read.pl');
   $agent->form_number(1) if $agent->forms and scalar @{$agent->forms};
  $formfiller->add_filler( 'username' => Fixed => 'tester@tester.com' );
  $formfiller->add_filler( 'password' => Fixed => 'tester29' );$formfiller->fill_form($agent->current_form);
  $agent->submit();
  $agent->form_number(1);
  $formfiller->add_filler( 'username' => Fixed => 'tester@tester.com' );
  $formfiller->add_filler( 'password' => Fixed => 'tester29' );$formfiller->fill_form($agent->current_form);
  $agent->submit();
  require HTML::TableExtract;
  my @columns = ( '0,0' );
  
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
  my @columns = ( '0,1' );
  
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
  my @columns = ( '0,2' );
  
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
  my @columns = ( '0,3' );
  
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
  my @columns = ( '0:00,,No','Data,,0,,' );
  
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
  my @columns = ( '2' );
  
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
  my @columns = ( '22222' );
  
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
  my @columns = (  );
  
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
  my @columns = ( 'Subsistence,2096,Eur' );
  
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
  my @columns = ( 'Subsistence,2096,Eur' );
  
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

  print $agent->content,"\n";
  $agent->back();
  $agent->back();
  $agent->reload;
  $agent->follow_link('n' => 2);
  $agent->back();
  $agent->follow_link('n' => 3);
  $agent->follow_link('n' => 5);
  $agent->follow_link('n' => 6);
  $agent->follow_link('n' => 7);
  $agent->follow_link('n' => 8);
  $formfiller->add_filler( 'username' => Fixed => 'tester@tester.com' );
  $formfiller->add_filler( 'password' => Fixed => 'tester29' );$formfiller->fill_form($agent->current_form);
  $agent->submit();
  $agent->follow_link('text' => 'Diary');
  $agent->follow_link('text' => 'Places');
  $agent->follow_link('text' => 'Hours');
  $agent->follow_link('text' => 'Cars');
  $agent->follow_link('text' => 'Reports');
  $agent->follow_link('text' => 'Travel Expense Claim Sheet');
  require HTML::TableExtract;
  my @columns = ( '0,3' );
  
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
  my @columns = ( 'Date,Time,From,To,Meeting,Purpose,Distance,Car','Reg,Size,Rate,Mileage' );
  
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
  my @columns = ( 'Date' );
  
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
  my @columns = ( 'Time' );
  
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
  my @columns = ( 'Date,Time,From,To,Meeting,Purpose,Distance,Car','Reg,Size,Rate,Mileage' );
  
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
  my @columns = ( 'To' );
  
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
  my @columns = ( 'Meeting' );
  
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
  my @columns = ( 'Purpose' );
  
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
  my @columns = ( 'Dstance' );
  
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
  my @columns = ( 'Distance' );
  
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
  my @columns = ( 'Car' );
  
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
  my @columns = ( 'ReC' );
  
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
  my @columns = ( 'Re' );
  
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
  my @columns = ( 'ReC' );
  
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
  my @columns = ( 'Rec' );
  
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
  my @columns = ( 'Car','Reg,Size,Rate,Mileage' );
  
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
  my @columns = ( 'Car',',Reg' );
  
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
  my @columns = ( 'Reg' );
  
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
  my @columns = ( 'Size' );
  
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
  my @columns = ( 'Rate' );
  
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
  my @columns = ( 'Mileage' );
  
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

  $agent->back();

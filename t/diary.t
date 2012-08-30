#!/usr/bin/perl -w
use strict;
use  WWW::AzantekUser;
use WWW::Mechanize::FormFiller;
use URI::URL;
use Test::More   tests =>4 ;
use HTML::TableExtract ;

use_ok('WWW::AzantekUser');
my $az = WWW::AzantekUser->new();
$az->login("localhost" , "tester\@testser.com"  ,"tester29");
ok ( $az->{_logged_in}  == 1 );
ok ( scalar($az->get_tables_in_page())  == 4  );
print   $az->find_columns_for_table();
print   $az->find_columns_for_table();
ok ( scalar($az->find_columns_for_table())  == 4  );




done_testing();


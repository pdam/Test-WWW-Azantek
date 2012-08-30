#!/usr/bin/env perl

use strict;
use diagnostics;
use  Data::Dumper();
use  WWW::AzantekUser;
use Test::More  tests => 28;
my  $mech  ;
my  $m ;
my $az = WWW::AzantekUser->new( );

get_ok($az->get("http://localhost/cgi-bin/login.pl"));
title_is($az ,  "WHEREABOUTZ Portal");

MAIN: {
    my $mech = Test::WWW::Mechanize->new();
    my $uri =  "http://localhost/cgi-bin/login.pl" ; 

    EMPTY_FIELDS: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs();
        field_checks(
            $mech, {
                username         => '',
                password        => '',
            },
            'filling empty fields'
        );
    }


    MULTICHAR_FILL: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs( { fill => '123' } );
        field_checks(
            $mech, {
                username       => ('123' x 23_333) . '1',
                password  => '123' x 22_000,
            },
            'multichar_fill'
        );
    }


    OVERWRITE: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs();
        is( $mech->value('username'), '@' x 10, 'overwriting fields: initial fill as expected' );
        $mech->stuff_inputs( { fill => 'X' } );
        field_checks(
            $mech, {
                username  => 'X' x 6_000,
                password     => 'X' x 6_000,
            },
            'overwriting fields'
        );
    }


    CUSTOM_FILL: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs( {
                fill => 'z',
                specs => {
                    username => { fill=>'#' },
                    password => { fill=>'*' },
                }
            } );
        field_checks(
            $mech, {
                username         => '',
                password         => '',
            },
            'custom fill'
        );
    }


    MAXLENGTH: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs( {
                specs => {
                    username  => { maxlength=>9 },
                    password  => { fill=>'*', maxlength=>9 },
                }
            }
        );
        field_checks(
            $mech, {
                username         => '@'x9,
                password         => '@'x9,
            },
            'maxlength'
        );
    }


    IGNORE: {
        $mech->get_ok( $uri ) or die;

        add_test_fields( $mech );
        $mech->stuff_inputs( { ignore => [ 'username' ] } );
        field_checks(
            $mech, {
                username         => 'tester@tester.com',
                password         => 'tester29',
            },
            'ignore'
        );
    }
}



sub add_test_fields {
    my $mech = shift;
    HTML::Form::Input->new( type=>'text', name=>'username' )->add_to_form( $mech->current_form() );
    HTML::Form::Input->new( type=>'password', name=>'password' )->add_to_form( $mech->current_form() );
    return;
}


sub field_checks {
    my $mech = shift;
    my $expected = shift;
    my $desc = shift;

    foreach my $key ( qw( username  password ) ) {
        is( $mech->value($key), $expected->{$key}, "$desc: field $key" );
    }

    return;
}


is( $m->status, 200 );

$m->follow_link('text' => 'Places');
is( $m->status, 200 );

$m->follow_link('text' => 'Hours');
is( $m->status, 200 );

$m->follow_link('text' => 'Cars');
is( $m->status, 200 );

$m->follow_link('text' => 'Reports');
is( $m->status, 200 );

$m->follow_link('text' => 'Travel Expense Claim Sheet');
is( $m->status, 200 );

done_testing();

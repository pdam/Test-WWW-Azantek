#!/usr/bin/perl -w


use strict;
use warnings;
use Test::More tests => 10;
use Carp;
use Test::MockObject::Extends;
use File::Slurp qw(slurp);
use WWW::Azantek;
use Test::Exception;
use Env qw(TEST_VERBOSE);

my $mech = Test::MockObject::Extends->new('WWW::Mechanize');
my $wd;

$mech->mock(
    'content',
    sub {
        my ( $mb, %params ) = @_;

        my $content = slurp('t/testdata')
            || croak "Unable to read file - $!";

        return $content;
    }
);
$mech->set_true('get', 'follow_link', 'submit_form');

my $content;

$wd = WWW::Azantek->new({
	username => 'tester@tester.com',
	password => 'topsecret',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

can_ok($wd, qw(retrieve));

ok($content = $wd->retrieve());

isa_ok($content, 'SCALAR');

is($$content, 'test');

$mech->set_series('get', 1, 1);
$mech->set_series('submit_form', undef);

$wd = WWW::Azantek->new({
	username => 'tester@tester.com',
	password => 'topsecret',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$mech->set_series('get', undef, undef);
$mech->set_series('submit_form', 1);

$wd = WWW::Azantek->new({
	username => 'tester@tester.com',
	password => 'topsecret',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$mech->set_series('get', 1, undef);

$wd = WWW::Azantek->new({
	username => 'tester@tester.com',
	password => 'topsecret',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$wd = WWW::Azantek->new({
	password => 'topsecret',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$wd = WWW::Azantek->new({
	username => 'tester@tester.com',
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$mech->set_true('get', 'follow_link', 'submit_form');

$wd = WWW::Azantek->new({
	url      => 'http://test.azantek.com/cgi-bin',
    verbose  => 1,
    mech     => $mech,
});

ok($content = $wd->retrieve());


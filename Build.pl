#!/usr/bin/env perl
use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Prtik Dam <pdam@gmail.com>',
    module_name          => 'WWW::Azantek',
    dist_version_from    => 'lib/WWW/Azantek.pm',
    dist_abstract        => 'WWW::Azantek',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    create_makefile_pl   => 'traditional',
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'WWW::Mechanize::Cached' => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://www.azantek.com',
            bugtracker =>
                'http://Azantek.atlassian.net',
            repository => 'http://github.com/pdam/Test-WWW-Azantek',
        }
    },

);

my $build2 = Module::Build->new(
    dist_author          => 'Prtik Dam <pdam@gmail.com>',
    module_name          => 'WWW::Azantek::Diary',
    dist_version_from    => 'lib/WWW/Azantek/Diary.pm',
    dist_abstract        => 'WWW::Azantek::Diary',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    create_makefile_pl   => 'traditional',
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'WWW::Mechanize::Cached' => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://www.azantek.com'
			}
}

);



$build2->create_build_script();



my $build3 = Module::Build->new(
    dist_author          => 'Prtik Dam <pdam@gmail.com>',
    module_name          => 'WWW::Azantek::Diary',
    dist_version_from    => 'lib/WWW/Azantek/Diary.pm',
    dist_abstract        => 'WWW::Azantek::Diary',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    create_makefile_pl   => 'traditional',
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'WWW::Mechanize::Cached' => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://www.azantek.com',
            bugtracker =>
	}
}
);


$build3->create_build_script();


my $build4 = Module::Build->new(
    dist_author          => 'Prtik Dam <pdam@gmail.com>',
    module_name          => 'WWW::Azantek::Diary',
    dist_version_from    => 'lib/WWW/Azantek/Diary.pm',
    dist_abstract        => 'WWW::Azantek::Diary',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    create_makefile_pl   => 'traditional',
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'WWW::Mechanize::Cached' => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://www.azantek.com',
            bugtracker =>
	}
}
);








my $build5 = Module::Build->new(
    dist_author          => 'Prtik Dam <pdam@gmail.com>',
    module_name          => 'WWW::Azantek::Hours',
    dist_version_from    => 'lib/WWW/Azantek/Hours.pm',
    dist_abstract        => 'WWW::Azantek::Hours',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    create_makefile_pl   => 'traditional',
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'WWW::Mechanize::Cached' => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://www.azantek.com',
            bugtracker =>
	}
}
);







1;




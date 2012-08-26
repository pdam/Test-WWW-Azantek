use ExtUtils::MakeMaker;
WriteMakefile
(
          'NAME' => 'WWW::Azantek',
          'VERSION_FROM' => 'lib/WWW/Azantek.pm',
          'PREREQ_PM' => {
                           'Carp' => '0',
                           'Data::Dumper' => '0',
                           'Env' => 0,
                           'File::Slurp' => 0,
                           'Module::Build' => '0.30',
                           'Test::Exception' => 0,
                           'Test::MockObject::Extends' => 0,
                           'Test::More' => 0,
                           'Test::Perl::Critic' => 0,
                           'Test::Prereq::Build' => 0,
                           'WWW::Mechanize' => '0',
                           'WWW::Azantek' => '0',
                           'WWW::Mechanize::Cached' => '0'
                         },
          'INSTALLDIRS' => 'site',
          'EXE_FILES' => [],
          'PL_FILES' => {},
          'test' => {
                      'TESTS' => 't/*.t t/.svn/*.t t/.svn/prop-base/*.t t/.svn/props/*.t t/.svn/text-base/*.t t/.svn/tmp/*.t t/.svn/tmp/prop-base/*.t t/.svn/tmp/props/*.t t/.svn/tmp/text-base/*.t'
                    }
        )
;


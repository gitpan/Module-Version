# Note: this file was auto-generated by Module::Build::Compat version 0.3607
use ExtUtils::MakeMaker;
WriteMakefile
(
          'NAME' => 'Module::Version',
          'VERSION_FROM' => 'lib/Module/Version.pm',
          'PREREQ_PM' => {
                           'Carp' => 0,
                           'Exporter' => 0,
                           'ExtUtils::MakeMaker' => '6.56',
                           'Getopt::Long' => 0,
                           'Test::More' => 0,
                           'autodie' => 0
                         },
          'INSTALLDIRS' => 'site',
          'EXE_FILES' => [
                           'bin/mversion'
                         ],
          'PL_FILES' => {}
        )
;

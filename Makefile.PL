use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Sledge::Plugin::Validation',
    'VERSION_FROM' => 'lib/Sledge/Plugin/Validation.pm', # finds $VERSION
    'PREREQ_PM'    => {
        Sledge::Constants  => 0,
        Sledge::Exceptions => 0,
        Test::More         => 0.32,
    },
);

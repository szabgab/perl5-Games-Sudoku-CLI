use ExtUtils::MakeMaker;

my %opts = (
     'NAME'          => 'Games::Sudoku::CLI',
     'VERSION_FROM'  => 'lib/Games/Sudoku/CLI.pm',
     'PREREQ_PM' => {
          'Test::More'                           => 0.47,
          'Games::Sudoku::Component::Controller' => '0.02',
     },
);
WriteMakefile( %opts );

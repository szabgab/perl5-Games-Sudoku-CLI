use strict;
use warnings;
use Test::More;
use Games::Sudoku::CLI;

plan tests => 2;

my @input;
my @output;

no warnings 'redefine';
sub Games::Sudoku::CLI::print_as_grid {
    my ($self) = @_;
    push @output, $self->{ctrl}->table->as_string;
}

sub Games::Sudoku::CLI::msg {
    my ($self, $msg) = @_;
    push @output, $msg;
}

sub Games::Sudoku::CLI::get_input {
    my ($self) = @_;
    $self->{input} = shift @input;
}
sub Games::Sudoku::CLI::get_game_start_input {
    my ($self) = @_;
    $self->{input} = shift @input;
}

my @expected_intro = (
    'Welcome to CLI Sudoku version 0.01',
    'Would you like to start a new game, load saved game, or exit?',
    'Type in "n NUMBER" to start a new game with NUMBER empty slots',
    'Type in "l FILENAME" to load the file called FILENAME',
    'Type x to exit',
);

subtest 'immediate exit' => sub {
    @input = (
        'x',
    );
    @output = ();

    Games::Sudoku::CLI->new->play;
    #diag explain \@output;

    is_deeply \@output, [
        @expected_intro,
        'BYE BYE',
    ];
};

subtest 'load and exit' => sub {
    @input = (
        'l t/files/a.txt',
        'x',
    );
    @output = ();

    Games::Sudoku::CLI->new->play;
    #diag explain \@output;

    my $expected = slurp('t/files/a.txt');
    chomp $expected;

    is_deeply \@output, [
        @expected_intro,
        $expected,
        'BYE',
    ];
};

sub slurp {
    my $file = shift;
    open my $fh, '<', $file or die;
    local $/ = undef;
    return scalar <$fh>;
}


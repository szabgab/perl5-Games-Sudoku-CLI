use strict;
use warnings;
use Test::More;
use Games::Sudoku::CLI;

plan tests => 1;

my @input = (
    'q',
);

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


Games::Sudoku::CLI->new->play;
#diag explain \@output;

is $output[-1], 'quit game';


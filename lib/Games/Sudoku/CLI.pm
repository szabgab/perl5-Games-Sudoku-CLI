package Games::Sudoku::CLI;
use strict;
use warnings;
use 5.010;

use Games::Sudoku::Component::Controller;

our $VERSION = '0.01';

sub new {
    my ($class) = @_;

    return bless {}, $class;
}

sub play {
    my ($self) = @_;

    $self->{ctrl} = Games::Sudoku::Component::Controller->new(size => 9);
    $self->{ctrl}->solve;
    $self->{ctrl}->make_blank(2);

    while (1) {
        $self->print_as_grid;
        $self->get_input();
        if ($self->{input} eq 'x') {
            $self->msg('BYE');
            return;  
        }
        if ($self->{input} eq 'q') {
            $self->msg('quit game');
            last;  
        }
        $self->{ctrl}->set(@{ $self->{step} });

        if ($self->{ctrl}->table->is_finished) {
            $self->print_as_grid;
            $self->msg('DONE');
            last;
        }
    }
    return;
}

sub get_input {
    my ($self) = @_;

    while (1) {
        print 'Enter your choice (row, col, value) or [q-quit game, x-exit app]: ';
        $self->{input} = lc <STDIN>;
        chomp $self->{input};
        last if $self->verify_input();
    }
    return;
}

sub verify_input {
    my ($self) = @_;

    if ($self->{input} =~ /^[xq]$/) {
        return 1;
    }

    (my $spaceless_input = $self->{input}) =~ s/\s+//g;
    my ($row, $col, $value) = $spaceless_input =~ /^(\d+),(\d+),(\d+)$/;
    if (not defined $value) {
        $self->msg("Invalid format: '$self->{input}'");
        return;
    }
    if ($row > 9 or $col > 9 or $value > 9) {
        $self->msg("Invalid values in: '$self->{input}'");
        return; 
    }
    if (not $self->{ctrl}->table->cell($row,$col)->is_allowed($value)) {
        $self->msg("Value $value is not allowed in ($row, $col)");
        return;
    }

    $self->{step} = [$row, $col, $value];

    return 1;
}

sub print_as_grid {
    my ($self) = @_;

    my $table =  $self->{ctrl}->table;

    my $size   = $table->{size};
    my $digit  = int(log($size) / log(10)) + 1;
 
    print "    ";
    for my $c (1 .. $size) {
        print " $c ";
        if ($c % 3 == 0 and $c < 9) {
            print ' | ';
        }
    }
    print "\n";
    say '   |' . '-' x 33;
    
    foreach my $row (1..$size) {
        print " $row |";
        foreach my $col (1..$size) {
            my $value = $table->cell($row, $col)->value;
            print $value ? " $value " : '   ';
            if ($col % 3 == 0 and $col < 9) {
                print ' | ';
            }
        }
        print "\n";
        if ($row % 3 == 0 and $row < 9) {
            say '   |' . '-' x 33;
        }
    }
    return;
}

sub msg {
    my ($self, $msg) = @_;
    say $msg;
    return;
}


1;


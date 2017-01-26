#!usr/bin/perl
# By Corey Skinner
use warnings;
use strict;
use GD::Graph::lines; # Produces plot
use GD::Graph::colour; # For color
use List::Util qw(reduce); # For use in factorial

# Debug settings
use Data::Dumper qw(Dumper);
$| = 1;

sub main {
    # Plot P_0 through P_5
    my @indices = 0 .. 5;
    # Set up range for which to plot over -1 to 1
    my @x = range(-1.0, 1.0, 0.01);
    my @legendre;
    my @y;
    foreach my $index (@indices) {
        $#y = -1;
        foreach my $point (@x) {
            # Generate the sum term first
            my $sum = 0.0;
            my $sumto = $index / 2.0;
            $sumto = ($index - 1.0) / 2.0 unless $index % 2.0 == 0;
            for (my $i = 0.0; $i <= $sumto; $i++) {
                $sum += (-1.0)**$i * fact(2.0*$index - 2.0*$i) /
                    (fact($i) * fact($index - $i) * fact($index - 2.0*$i)) *
                    $point**($index - 2.0*$i);
            }
            # Now generate the polynomial point
            my $val = 1.0 / 2.0**$index * $sum;
            push @y, $val;
        }
        push @legendre, [@y];
    }
    unshift @legendre, \@x;
    # Create the graph object
    my $graph = GD::Graph::lines->new(800, 800);
    $graph->set(
        x_label         => 'x',
        y_label         => 'y',
        title           => 'Legendre Polynomials',
        x_tick_number   => 10,
        bgclr           => 'white',
        dclrs           => [qw(lred black lgreen lblue cyan pink)],
        transparent     => 0
    ) or die $graph->error;
    $graph->set_legend('P_0', 'P_1', 'P_2', 'P_3', 'P_4', 'P_5');
    # Now plot and save the image
    {
        open my $out, '>', 'legendre.png' or die "can't output: $!";
        binmode $out;
        print $out $graph->plot(\@legendre)->png or die $graph->error;
    }
}

# Factorial; returns value
sub fact {
    my $n = shift;
    $n ||= 1;
    our ($a, $b);
    return reduce {$a * $b} (1 .. $n);
}

# Range between two numbers; returns array
sub range {
    my ($start, $end, $step) = @_;
    $step ||= 1;
    return map {$_ * $step} ($start / $step .. $end / $step);
}

main() unless caller;

__END__

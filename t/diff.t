
# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

use Mojo::Collection 'c';
use Mojo::Collection::Role::Set 'set';
use Mojo::File;

#
# start simple
#
is_deeply set(1 .. 20)->diff(c(10 .. 30))->to_array, [1 .. 9], 'integers';

my $c1 = set(qw{alpha beta gamma delta});
ok $c1, 'created';

my $c2 = set(qw{gamma delta epsilon theta});
ok $c2, 'created';

my $c3 = $c1->diff($c2);
ok $c3, 'diff with strings';
is_deeply $c3->to_array, [qw{alpha beta}], 'correct set op';

my $c4 = $c2->diff($c1);
ok $c4, 'diff other way';
is_deeply $c4->to_array, [qw{epsilon theta}], 'correct set op';

#
# objects with "" overload
#
$c1 = $c1->map(sub { Mojo::File->new('/tmp')->child($_) });
$c2 = $c2->map(sub { Mojo::File->new('/tmp')->child($_) });

my $c6 = $c1->diff($c2);
ok $c6, 'diff with objects';
is_deeply $c6->to_array, 
    $c3->map(sub { Mojo::File->new('/tmp')->child($_) }),
    'same as with strings';
#
# passing callbacks to stringify
#
is_deeply set(qw{alpha beta gamma})
    ->diff(c(qw{ALPHA alPHa delta}), sub { lc }), [qw{beta gamma}],
    'case insensitive';

my $c7 = set(map { {name => $_, age => rand(90)} } qw{bob alice john Jeremy});
my $c8 = set(map { {name => $_, age => rand(90)} } qw{bob alex joan John});

# diff on HASH(0x...)
is_deeply $c7->diff($c8)->map(sub { $_->{name} })->to_array,
    [qw{bob alice john Jeremy}], 'hash refaddr string';
# diff only on name
is_deeply $c7->diff($c8, sub { $_->{name} })->map(sub { $_->{name} })->to_array,
    [qw{alice john Jeremy}], 'compare names';
# diff on initial
is_deeply $c7->diff($c8, sub { substr($_->{name}, 0, 1) }), [], 'empty';

done_testing();

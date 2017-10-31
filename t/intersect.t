
# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

use Mojo::Collection 'c';
use Mojo::File;

my $c1 = c(qw{alpha beta gamma delta})->with_roles('+Set');

ok $c1, 'created';
is @$c1, 4, 'size good';
like ref($c1), qr/__WITH__Mojo::Collection::Role::Set$/, 'role added';

my $c2 = c(qw{gamma delta epsilon theta})->with_roles('+Set');
ok $c2, 'created';
is @$c2, 4, 'size good';
like ref($c2), qr/__WITH__Mojo::Collection::Role::Set$/, 'role added';

my $c3 = $c1->intersect($c2);
ok $c3, 'intersect with strings';
is_deeply $c3->to_array, [qw{gamma delta}], 'correct set op';

$c1 = $c1->map(sub { Mojo::File->new('/tmp')->child($_) });
$c2 = $c2->map(sub { Mojo::File->new('/tmp')->child($_) });

my $c4 = $c1->intersect($c2);
ok $c4, 'intersect with objects';
is_deeply $c4->to_array, 
    $c3->map(sub { Mojo::File->new('/tmp')->child($_) }),
    'same as with strings';


is_deeply c(1, 2, 3, 4, 5, 6, 7)->with_roles('+Set')
    ->intersect(c(4, 3, 2, 1, 9, 8, 7))->sort->to_array,
    [1, 2, 3, 4, 7], 'intersect';

done_testing();

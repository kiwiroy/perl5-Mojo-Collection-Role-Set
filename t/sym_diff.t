
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

my $c3 = $c1->sym_diff($c2);
ok $c3, 'sym diff with strings';
is_deeply $c3->to_array, [qw{alpha beta epsilon theta}], 'correct set op';

$c1 = $c1->map(sub { Mojo::File->new('/tmp')->child($_) });
$c2 = $c2->map(sub { Mojo::File->new('/tmp')->child($_) });

my $c4 = $c1->sym_diff($c2);
ok $c4, 'syn diff with objects';
is_deeply $c4->to_array, 
    $c3->map(sub { Mojo::File->new('/tmp')->child($_) }),
    'same as with strings';

is_deeply c(qw{alpha beta gamma})->with_roles('+Set')
    ->sym_diff(c(qw{ALPHA Delta})),
    c(qw{alpha beta gamma ALPHA Delta}), 'case sensitive';

is_deeply c(qw{alpha beta gamma})->with_roles('+Set')
    ->sym_diff(c(qw{ALPHA Delta}), sub { lc }),
    c(qw{beta gamma Delta}), 'case insensitive';


done_testing();

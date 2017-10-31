
# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

use Mojo::Collection::Role::Set 'set';

isa_ok set('alpha'), 'Mojo::Collection__WITH__Mojo::Collection::Role::Set',
    'role added';

is_deeply set(1 .. 10), [1 .. 10], 'set function';

my $s = set(1 .. 10);
can_ok $s, qw{diff duplicates intersect sym_diff union};

done_testing();


# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

use Mojo::Collection 'c';
use Mojo::File;

my $c1 = c(qw{alpha alpha beta gamma delta epsilon gamma})->with_roles('+Set');

ok $c1, 'created';
is @$c1, 7, 'size good';
like ref($c1), qr/__WITH__Mojo::Collection::Role::Set$/, 'role added';

my $c2 = $c1->duplicates;
ok $c2, 'created';
is_deeply $c2->to_array, c(qw{alpha gamma}), 'correct duplicates';

$c1 = c(qw{alpha ALPHA beta beta})->with_roles('+Set')->duplicates;
is_deeply $c1->to_array, c('beta'), 'more dups';

done_testing();

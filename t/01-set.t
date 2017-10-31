
# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More;

use Mojo::Collection::Role::Set 'set';

isa_ok set('alpha'), 'Mojo::Collection__WITH__Mojo::Collection::Role::Set',
    'role added';

is_deeply set(1 .. 10), [1 .. 10], 'set function';


done_testing();

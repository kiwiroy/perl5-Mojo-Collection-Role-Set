package Mojo::Collection::Role::Set;


use Exporter 'import';
use Mojo::Collection 'c';
use Role::Tiny;

our @EXPORT_OK = ('set');
our $VERSION = '0.01';

sub set { c(@_)->with_roles(__PACKAGE__) }

# self and not in alt
sub diff {
    my ($self, $alt, $cb) = (shift, shift, shift);

    my %seen;
    $alt->each(sub { $seen{$cb ? $_->$cb : $_}++; });

    return $self->grep(sub { not exists $seen{$_->$cb} }) if $cb;
    return $self->grep(sub { not exists $seen{$_} });
}

sub duplicates {
    my ($self, $cb) = (shift, shift);
    my %seen; 
    return $self->grep(sub { ++$seen{$_->$cb(@_)} > 1 }) if $cb;
    return $self->grep(sub { ++$seen{$_} > 1 });
}

sub intersect {
    my ($self, $alt, $cb) = (shift, shift, shift);
    my %seen;

    $alt->each(
	sub {
	    $seen{$cb ? $_->$cb : $_}++;
	});

    my $res = $self->grep(
	sub {
	    # each incremented
	    1 == $seen{$cb ? $_->$cb : $_}++;
	});

    return $res;
}

# symmetric difference
sub sym_diff {
    my ($self, $alt, $cb) = (shift, shift, shift);
    my %seen;

    $alt->each(
	sub {
	    $seen{$cb ? $_->$cb : $_}++;
	});

    my $res = $self->grep(
	sub {
	    # each did not increment
	    0 == $seen{$cb ? $_->$cb : $_}++;
	});

    push @$res, @{ $alt->grep(
		       sub {
			   # first pass (each) incremented, but grep didn't
			   1 == $seen{$cb ? $_->$cb : $_}++; 
		       }) };
    return $res;
}

# union everything - not unique
sub union {
    my ($self, $alt) = (shift, shift);
    my $ret = $self->to_array;
    push @$ret, @$alt;
    return $ret;
}

1;

=pod

=head1 NAME

Mojo::Collection::Role::Set - Set operations for collections

=for html <a href="https://travis-ci.org/kiwiroy/perl5-Mojo-Collection-Role-Set"><img src="https://travis-ci.org/kiwiroy/perl5-Mojo-Collection-Role-Set.svg?branch=master" alt="Build Status"></a>

=for html <a href="https://coveralls.io/github/kiwiroy/perl5-Mojo-Collection-Role-Set?branch=master"><img src="https://coveralls.io/repos/github/kiwiroy/perl5-Mojo-Collection-Role-Set/badge.svg?branch=master" alt="Coverage Status"></a>

=head1 DESCRIPTION

A L<role|Role::Tiny> for L<Mojo::Collection> objects to provide set operations
L</diff>, L</duplicates>, L</intersect>, L</sym_diff> and L</union>.

=head1 SYNOPSIS

  # [2]
  c(2, 3, 5, 7, 11, 13, 17)->with_roles('+Set')
    ->interset(c(grep { ! $_ % 2 } 1 .. 20))->to_array;

=head1 EXPORTED FUNCTIONS

=head2 set

  # import
  use Mojo::Collection::Role::Set 'set';
  # [1, 2, 3, 4, 5]
  set(1 .. 5);

Like the L<Mojo::Collection> C<c()>, this is sugar for creating a collection
with this role.

=head1 METHODS

=head2 diff

  # [1, 2, 3, 4, 5, 6, 7, 8, 9]
  c(1 .. 20)->with_roles('+Set')->diff(c(10 .. 30))->to_array;

The values in a L<Mojo::Collection> that are not in the second one.

=head2 duplicates

=head2 intersect

=head2 sym_diff

=head2 union

=cut

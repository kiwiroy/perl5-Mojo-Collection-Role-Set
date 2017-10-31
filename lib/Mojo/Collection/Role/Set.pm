package Mojo::Collection::Role::Set;

use feature 'say';
use Mojo::Collection;
use Role::Tiny;

# self and not in alt
sub diff {
    my ($self, $alt, $cb) = (shift, shift, shift);

    my %seen;
    $alt->each(
	sub {
	    $seen{$cb ? $_->$cb : $_}++;
	});

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

# port from RSAVAGE Set::Array
sub intersect_ {
    my ($self, $alt, $cb) = (shift, shift, shift);
    my $result = Mojo::Collection->new();
 
    my(%seen);
 
    $self->each(sub {
	my ($e, $i) = @_;
	my $ek = $cb ? $e->$cb : $e;

	$alt->each(sub{
	    my ($c, $j) = @_;
	    my $ck = $cb ? $c->$cb : $c;

	    next if (defined $seen{ $ck } && $seen{ $ck } eq $i);

	    if ($ek eq $ck){
		push @$result, $ek;
		$seen{ $ck } = $i;
	    }
	});	   
    });

    return $result;
}

# symmetric diff
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

sub union {
    my ($self, $alt) = (shift, shift);
    my $ret = $self->to_array;
    push @$ret, @$alt;
    return $ret->uniq(@_);
}

1;

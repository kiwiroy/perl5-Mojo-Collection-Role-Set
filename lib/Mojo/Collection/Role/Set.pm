package Mojo::Collection::Role::Set;

use feature 'say';
use Mojo::Collection;
use Role::Tiny;

# port from RSAVAGE Set::Array
sub intersect {
    my ($self, $alt, $swap) = @_;
    ($alt, $self) = ($self, $alt) if $swap;
    my $result = Mojo::Collection->new();
 
    my(%seen);
 
    $self->each(sub {
	my ($e, $n) = @_;
	$alt->each(sub{
	    my ($c) = @_;

	    next if (defined $seen{ $c } && $seen{ $c } eq $n);

	    if (lc $e eq lc $c){
		push @$result, $e;
		$seen{ $c } = $n;
	    }
	});	   
    });

    return $result;
}

sub diff {
    my ($self, $alt, $swap) = @_;
    ($alt, $self) = ($self, $alt) if $swap;

    my %alt_idx;
    @alt_idx{map { lc } @$alt} = (1) x $alt->size;

    return $self->grep(sub { not exists $alt_idx{lc $_} });
}

sub sym_diff{
    my ($self, $alt, $swap) = @_;
    ($alt, $self) = ($self, $alt) if $swap;
 
    my (%count1, %count2, %count3);
    @count1{@$self} = (1) x $self->size;
    @count2{@$alt}  = (1) x $alt->size;
 
    foreach(keys %count1, keys %count2){
	$count3{lc $_}++ 
    }

    my $res = $self->grep(sub { exists $count3{lc $_} && 1 == $count3{lc $_}});
    push @$res, @{ $alt->grep(sub { exists $count3{lc $_} && 1 == $count3{lc $_} }) };
    return $res;
}

1;

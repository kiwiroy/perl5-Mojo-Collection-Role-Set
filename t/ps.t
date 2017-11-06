
# -*- mode: perl; -*-
use strict;
use warnings;
use Test::More;
use Mojo::Collection::Role::Set 'set';
use Mojo::Home;

my $home = Mojo::Home->new->detect;

my ($now, $then) = $home->child(qw{t data})->list->grep(sub { /\.output$/ })->each;

like "$then", qr/start\.ps\.output$/, 'start point file';
like "$now", qr/end\.ps\.output$/, 'end point file';

my $now_lines = set( split /\n/, $now->slurp );
my $then_lines = set( split /\n/, $then->slurp );

my $diff = $then_lines->diff($now_lines, sub { (split /\s+/, $_)[1] });

is $diff->join("\n"), 
"root      9209  0.0  0.0 196176   736 ?        Sl   Oct27   0:02 /usr/libexec/docker/docker-proxy-current -proto tcp -host-ip 0.0.0.0 -host-port 8085 -container-ip 172.17.0.6 -container-port 80
root      9214  0.0  0.0 280636    12 ?        Sl   Oct27   0:00 /usr/bin/docker-containerd-shim-current c0e4d51f5b4da51d9ac91f6d5ca18e6848cb69fde3fb1d107f90303ae96d725a /var/run/docker/libcontainerd/c0e4d51f5b4da51d9ac91f6d5ca18e6848cb69fde3fb1d107f90303ae96d725a /usr/libexec/docker/docker-runc-current
root      9229  0.0  0.0  17972     0 ?        Ss   Oct27   0:00 /bin/bash /var/www/run_apache.sh
root      9281  0.0  0.0 297928    72 ?        Ss   Oct27   0:30 /usr/sbin/apache2 -k start
root      9285  0.0  0.0   4388     0 ?        S    Oct27   0:00 tail -F /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log", 'output good';

done_testing;

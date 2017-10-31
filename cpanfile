# process with cpanm --installdeps .

requires 'Mojolicious' => 7.20;
requires 'Role::Tiny' => 0;

on develop => sub {
  requires 'Devel::Cover::Report::Coveralls' => '0.11';
  requires 'Test::CPAN::Changes';
  requires 'Test::Pod';
  requires 'Test::Pod::Coverage';
};

test_requires 'Test::More';

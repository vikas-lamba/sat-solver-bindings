#!/usr/bin/perl

#
# attr_values.pl
#
# Test iterating over values of a specific attribute
#
#

use lib '../../../build/bindings/perl';

use satsolver;


# Create Pool and Repository 
my $pool = new satsolver::Pool;
$pool->set_arch( "i686" );
my $repo = $pool->create_repo('test') || die;

# Add Solvable to Repository
$repo->add_solv ("../../testdata/os11-beta5-i386.solv");

$pool->prepare();

# Print how much we have
print "\"" . $repo->name() . "\" size: " . $repo->size() . "\n";

print "\nFinding values for attribute 'solvable:keywords' ...\n";

my $solvable = $repo->find("perl") || die;
foreach my $value ($solvable->attr_values("solvable:keywords")) {
  print "  solvable keyword: $value\n";
}


#!/usr/bin/perl

use lib '../../../build/bindings/perl';

use satsolver;

# Open Solvable file
# open(F, "gzip -cd tmp/primary.gz |") || die;

# Create Pool and Repository 
my $pool = new satsolver::Pool;
$pool->set_arch('i686');
my $repo = $pool->create_repo('repo');

# Add solv file to Repository
$repo -> add_solv("tmp/primary");
# close(F) || die;

# Create Solver
my $solver = $pool->create_solver();

# Create dependencies to provides table
$pool->prepare();

# Create Request
my $job = $pool->create_request();

# Push jobs on Queue
my $pat = $pool->find("pattern:default") || die;
$job->install($pat);

# $job -> install( "pattern:default" );

# Solve the jobs
$solver->solve($job);

# Print packages to install
$a = $solver->getInstallList();
for my $c (@$a) {
  print "$c\n";
}


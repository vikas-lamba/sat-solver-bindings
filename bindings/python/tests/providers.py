#
# Check each_provider callback
#

$:.unshift ".."

# test EachProvider
require 'test/unit'
require 'satsolver'

class EachProviderTest < Test::Unit::TestCase
  def test_repo_create
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "x86_64"
    repo = pool.add_solv( "os11-biarch.solv" )
    repo.name = "openSUSE 11.0 Beta3 BiArch"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
    system = pool.add_rpmdb( "/" )
    system.name = "@system"
    puts "Repo #{system.name} loaded with #{system.size} solvables"
    
    pool.prepare

    puts "Providers of 'ispell_dictionary':"
    pool.each_provider( "ispell_dictionary" ) { |s|
      puts "  #{s} [#{s.repo.name}]"
    }
    
    rel = pool.create_relation( "ispell_english_dictionary", Satsolver::REL_GT, "3.3.02-23" )

    puts "Providers of #{rel}:"
    pool.each_provider(rel) { |s|
      puts "  #{s} [#{s.repo.name}]"
    }
  end
end
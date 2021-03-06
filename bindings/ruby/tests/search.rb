require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# Search
#

# test Repodata
class RepodataTest < Test::Unit::TestCase
  #
  # Pool search
  #
  def test_pool_search
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "x86_64"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "openSUSE 11.0 Beta3 BiArch"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
    
    pool.search("yast2", Satsolver::SEARCH_STRING) do |d|
      puts "#{d.solvable} matches 'yast2' in #{d.key.name}:  #{d.value}"
    end
  end
    
  def test_pool_search_files
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "test"
    pool.search("/usr/bin/python", Satsolver::SEARCH_STRING|Satsolver::SEARCH_FILES) do |d|
      puts "#{d.solvable} matches '/usr/bin/python' in #{d.key.name}: #{d.value}"
    end
  end

  #
  # Repo search
  #
  def test_repo_search
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "x86_64"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "openSUSE 11.0 Beta3 BiArch"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
    
    repo.search("yast2", Satsolver::SEARCH_STRING) do |d|
      puts "#{d.solvable} matches 'yast2' in #{d.key.name}: #{d.value}"
    end
  end
    
  def test_repo_search_files
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "test"
    repo.search("/usr/bin/python", Satsolver::SEARCH_STRING|Satsolver::SEARCH_FILES) do |d|
      puts "#{d.solvable} matches '/usr/bin/python' in #{d.key.name}: #{d.value}"
    end
  end

end

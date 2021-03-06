require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# A Repo (repository) groups Solvables
# A Repo has a name and always belongs to a Pool. The size of a Repo is the number
# of Solvables it contains.
#
# A Repo can be created
#  - from a .solv file
#    repo = Pool.add_solv( "path/to/repo.solv" )
#  - from the rpm database
#    repo = pool.add_rpmdb( "/" )
#  - empty
#    repo = pool.create_repo( "repo name" )
#
# Solvables are added to a Repo by creation. There is no 'add' method, use either
#   Repo.create_solvable( ... )
# or
#   Solvable.new( repo, ... )
#
# Solvables can be retrieved from a Repo by
# - index
#   repo.get( i ) or repo[i]
# - iteration
#   repo.each { |solvable| ... }
# - name
#   repo.find( "A" )
#   this will return the 'best' solvable named 'A' or nil if no such solvable exists.
#

# test Repo
class RepoTest < Test::Unit::TestCase
  def test_repo_create
    pool = Satsolver::Pool.new
    assert pool
    repo = Satsolver::Repo.new( pool, "test" )
    # equivalent: repo = pool.create_repo( "test" )
    assert repo
    assert repo.size == 0
    assert repo.empty?
    assert repo.name == "test"
  end
  def test_repo_add
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "test"
    assert repo.name == "test"
    assert repo.size > 0
  end
  def test_deps
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    repo = pool.add_solv( solvpath )
#    repo.each { |s|
#      assert s
#    }
    assert true
  end
  def test_attr
    pool = Satsolver::Pool.new
    assert pool
    pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "timestamp.solv"
    repo = pool.add_solv( solvpath )
    val = repo.attr("repository:timestamp")
    puts "timestamp = #{val}"
    assert val == repo["repository:timestamp"]
  end
end

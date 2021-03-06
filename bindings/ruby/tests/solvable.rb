require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

# test Solvable
def show_dep name, deps
  return unless deps
  puts "    #{deps.size} #{name}: "
  i = 0
  while (i < deps.size)
    d = deps[i]
    puts "\t#{d.name} : #{d}" 
    i += 1
  end

  deps.each { |d|
    puts "\t#{d.name} #{d.op_s} #{d.evr}"
  }
end

class SolvableTest < Test::Unit::TestCase
  def setup
    @pool = Satsolver::Pool.new
    assert @pool
    @pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    @pool.add_solv( solvpath )
    assert @pool.size > 0
  end
  def test_deps
    i = 0
    puts "test_deps"
    @pool.each { |s|
      puts "Solvable >#{s}< @ #{s.location.inspect}"
      show_dep "Provides", s.provides
      show_dep "Requires", s.requires
      show_dep "Obsoletes", s.obsoletes
      show_dep "Conflicts", s.conflicts
      i += 1
      break if i > 5
    }
  end
  
  def test_attributes
    @pool.each do |s|
      assert s.name
      assert s.arch
      assert s.evr
#      assert s.vendor
      assert s.location.size == 2
    end
  end
  
  def test_iterate_pool
    @pool.each do |s|
      assert s.pool == @pool
    end
  end

  def test_creation
    repo = @pool.create_repo( 'test' )
    assert repo
    solv1 = repo.create_solvable( 'one', '42:1.0-0' )
    assert solv1
    assert repo.size == 1
    assert solv1.name == 'one'
    assert solv1.evr == "42:1.0-0"
    assert solv1.epoch == "42"
    assert solv1.version == "1.0"
    assert solv1.revision == "0"
    assert solv1.vendor.nil?
    solv2 = Satsolver::Solvable.new( repo, 'two', '2.0-0', 'noarch' )
    assert solv2
    assert repo.size == 2
    assert solv2.name == 'two'
    assert solv2.evr == "2.0-0"
    solv2.vendor = "Ruby"
    assert solv2.vendor == "Ruby"
    
    rel = Satsolver::Relation.new( @pool, "two", Satsolver::REL_GE, "2.0-0" )
    assert rel
    solv1.requires << rel
    assert solv1.requires.size == 1
    
    request = @pool.create_request
    request.install( solv1 )
    
    solver = @pool.create_solver( )
#    @pool.debug = 255
    solver.solve( request )
    solver.each_to_install { |s|
      puts "Install #{s}"
    }
    solver.each_to_remove { |s|
      puts "Remove #{s}"
    }

  end
end

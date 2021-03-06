require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# Relations are the primary means to specify dependencies.
# Relations combine names and version through an operator.
# Relations can be compared (<=> operator) or matched (=~ operator)
#
# The following operators are defined:
#   REL_GT: greater than
#   REL_EQ: equals
#   REL_GE: greater equal
#   REL_LT: less than
#   REL_NE: not equal
#   REL_LE: less equal
# Future extensions (not fully defined currently)
#   REL_AND:  and
#   REL_OR:   or
#   REL_WITH: with
#   REL_NAMESPACE: namespace
#
#

# test Relation
class SolvableTest < Test::Unit::TestCase
  def setup
    @pool = Satsolver::Pool.new
    assert @pool
    @repo = Satsolver::Repo.new( @pool, "test" )
    assert @repo
    @pool.arch = "i686"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "os11-biarch.solv"
    @repo = @pool.add_solv( solvpath )
    assert @repo.size > 0
  end
  def test_relation_accessors
    rel1 = Satsolver::Relation.new( @pool, "A" )
    assert rel1
    assert rel1.name == "A"
    assert rel1.op == 0
    assert rel1.evr == nil
    rel2 = Satsolver::Relation.new( @pool, "A", Satsolver::REL_EQ, "1.0-0" )
    assert rel2
    assert rel2.name == "A"
    assert rel2.op == Satsolver::REL_EQ
    assert rel2.evr == "1.0-0"
  end
  
  def test_relation
    rel = @pool.create_relation( "A", Satsolver::REL_EQ, "1.0-0" )
    assert rel
    puts "Relation: #{rel}"
    @repo.each { |s|
      unless (s.provides.empty?)
	puts "#{s} provides #{s.provides[1]}"
      end
      s.provides.each { |p|
	res1 = (p <=> rel)
#	puts "#{p} cmp #{rel} => #{res1}"
	res2 = (p =~ rel)
#	puts "#{p} match #{rel} => #{res1}"
      }
    }
  end
end

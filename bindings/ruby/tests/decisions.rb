#
# After successful solving, the solver returns the result as list of Decisions.
#
# A Decision consitst of
#  - an operation (see below)
#  - a solvable (affected by the operation)
#  - a reason (the reason for the decision)
#
# Operation can be one of
#  - DEC_INSTALL
#     install solvable, required by 'reason' (if reason is set)
#  - DEC_REMOVE
#     remove solvable, updated/obsoleted/conflicted by 'reason' (if reason is set)
#  - DEC_OBSOLETE
#     auto-remove solvable through an obsoletes/update coming from 'reason'
#  - DEC_UPDATE
#     install solvable, thereby updating 'reason'
#
# The number of decision steps is available through Solver.decision_count
#

$: << "../../../build/bindings/ruby"
# test Decisions
require 'test/unit'
require 'satsolver'

class DecisionTest < Test::Unit::TestCase
  def test_decision
    pool = SatSolver::Pool.new
    assert pool
    
    installed = pool.create_repo( 'system' )
    assert installed
    installed.create_solvable( 'A', '0.0-0' )
    installed.create_solvable( 'B', '1.0-0' )
    solv = installed.create_solvable( 'C', '2.0-0' )
    solv.requires << SatSolver::Relation.new( pool, "D", SatSolver::REL_EQ, "3.0-0" )
    installed.create_solvable( 'D', '3.0-0' )

    repo = pool.create_repo( 'test' )
    assert repo
    
    solv1 = repo.create_solvable( 'A', '1.0-0' )
    assert solv1
    solv1.obsoletes << SatSolver::Relation.new( pool, "C" )
    solv1.requires << SatSolver::Relation.new( pool, "B", SatSolver::REL_GE, "2.0-0" )
    
    solv2 = repo.create_solvable( 'B', '2.0-0' )
    assert solv2
    
    solv3 = repo.create_solvable( 'CC', '3.3-0' )
    solv3.requires << SatSolver::Relation.new( pool, "A", SatSolver::REL_GT, "0.0-0" )
    repo.create_solvable( 'DD', '4.4-0' )

    
    transaction = pool.create_transaction
    transaction.install( solv3 )
    transaction.remove( "D" )
    
    solver = pool.create_solver( installed )
    solver.allow_uninstall = 1;
#    @pool.debug = 255
    solver.solve( transaction )
    puts "** Problems found" if solver.problems?
    assert solver.decision_count > 0
    i = 0
    solver.each_decision { |d|
      i += 1
      case d.op
      when SatSolver::DEC_INSTALL
	puts "#{i}: Install #{d.solvable} #{d.reason}"
      when SatSolver::DEC_REMOVE
	puts "#{i}: Remove #{d.solvable} #{d.reason}"
      when SatSolver::DEC_OBSOLETE
	puts "#{i}: Obsolete #{d.solvable} #{d.reason}"
      when SatSolver::DEC_UPDATE
	puts "#{i}: Update #{d.solvable} #{d.reason}"
      else
	puts "#{i}: Decision op #{d.op}"
      end
    }
  end
end

#
# Check Repodata of Repo
#

import unittest

import os 
cwd = os.path.abspath(os.path.dirname(__file__)) 
import sys
sys.path.insert(0, cwd + '/../../../build/bindings/python')

import satsolver


class TestSequenceFunctions(unittest.TestCase):
    
  def test_repodata(self):
    pool = satsolver.Pool()
    assert pool
    pool.set_arch("x86_64")
    repo = pool.add_solv( "../../testdata/os11-biarch.solv" )
    repo.set_name( "openSUSE 11.0 Beta3 BiArch" )
    print "Repo ", repo.name(), " loaded with ", repo.size(), " solvables"
    
    print "Repo has ", repo.datasize(), " Repodatas attached"
    assert repo.datasize() > 0
    assert repo.data(-1) == None
    assert repo.data(repo.datasize()) == None
    assert repo.data(repo.datasize()-1)
    for d in repo.datas():
      assert d
    
    repodata = repo.data(0)
    assert repodata
    
    print "Repodata has ", repodata.size(), " keys"
    for k in repodata.keys():
        print "  Key ", k.name(), " is ", k.type().__str__(), "[", k.type_id(), "] with ", k.size(), " bytes"
    
    i = 0;
    for s in repo:
      print "Solvable %s: mediadir %s group %s, time %s, downloadsize %s, installsize %s" % (s, s.attr('solvable:mediadir'), s.attr('solvable:group'), s.attr('solvable:buildtime'), s.attr('solvable:downloadsize'), s.attr('solvable:installsize'))
      i += 1;
      if i == 10:
          break

if __name__ == '__main__':
  unittest.main()


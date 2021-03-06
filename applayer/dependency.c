/*
 * Copyright (c) 2007, Novell Inc.
 *
 * This program is licensed under the BSD license, read LICENSE.BSD
 * for further information
 */

/************************************************
 * Dependency
 *
 * Collection of Relations -> Dependency
 */

#include <stdlib.h>

#include "dependency.h"


Dependency *
dependency_new( XSolvable *xsolvable, int dep )
{
  Dependency *dependency = (Dependency *)malloc( sizeof( Dependency ));
  dependency->dep = dep;
  dependency->xsolvable = xsolvable;
  return dependency;
}


void
dependency_free( Dependency *d )
{
  free( d );
}


/* get pointer to offset for dependency */
Offset *
dependency_relations( const Dependency *dep )
{
  Solvable *s;
  if (!dep) return NULL;

  s = xsolvable_solvable( dep->xsolvable );
  switch (dep->dep) {
      case DEP_PRV: return &(s->provides); break;
      case DEP_REQ: return &(s->requires); break;
      case DEP_CON: return &(s->conflicts); break;
      case DEP_OBS: return &(s->obsoletes); break;
      case DEP_REC: return &(s->recommends); break;
      case DEP_SUG: return &(s->suggests); break;
      case DEP_SUP: return &(s->supplements); break;
      case DEP_ENH: return &(s->enhances); break;
  }
  return NULL;
}


int
dependency_size( const Dependency *dep )
{
  Offset *relations = dependency_relations( dep );
  if (relations) {
    Solvable *s = xsolvable_solvable( dep->xsolvable );
    Id *ids = s->repo->idarraydata + *relations;
    int i = 0;
    while (*ids++)
      ++i;
    return i;
  }
  return 0;
}


void
dependency_relation_add( Dependency *dep, Relation *rel, int pre )
{
  Solvable *s = xsolvable_solvable( dep->xsolvable );
  Offset *relations = dependency_relations( dep );
  *relations = repo_addid_dep( s->repo, *relations, rel->id, pre ? SOLVABLE_PREREQMARKER : 0 );
  return;
}


Relation *
dependency_relation_get( Dependency *dep, int i )
{
  Solvable *s = xsolvable_solvable( dep->xsolvable );
  Offset *relations = dependency_relations( dep );
  if (relations) {
    /* loop over it to detect end */
    Id *ids = s->repo->idarraydata + *relations;
    while ( i >= 0 ) {
      if ( !*ids )
	break;
      if ( i-- == 0 ) {
	return relation_new( s->repo->pool, *ids );
      }
      ++ids;
    }
  }
  return NULL;
}


void
dependency_relations_iterate( Dependency *dep, int (*callback)(const Relation *rel, void *user_data), void *user_data)
{
  Solvable *s = xsolvable_solvable( dep->xsolvable );
  Offset *relations = dependency_relations( dep );
  Id *ids = s->repo->idarraydata + *relations;
  while (*ids)
    {
      if (callback( relation_new( s->repo->pool, *ids ), user_data ) )
	break;
      ++ids;
    }
}

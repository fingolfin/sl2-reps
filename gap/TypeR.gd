#
# SL2Reps: Constructs representations of SL2(Z).
#
# Representations of type R.

#! @Chapter Irreps

#! @Section Representations of type R
#!
#! See <Ref Sect="Chapter_Description_Section_Weyl_Subsection_Type_R"/>.

#! @Arguments p,ld,sigma,r,t
#! @Returns a record describing $(M,Q)$
#! @Description
#!  Constructs information about the underlying quadratic module $(M,Q)$ of type $R$.
DeclareGlobalFunction( "SL2Reps_ModuleR" );

#! @Arguments p,ld,sigma,r,t,chi_index
#! @Returns a list of lists of the form $[S,T]$
#! @Description
#!  Constructs the irreducible representation(s) of type $R$ with level $p^\lambda$
#!  corresponding to the character $\chi$ indexed by `chi_index`.
DeclareGlobalFunction( "SL2Reps_RepR" );

#! @Arguments p,ld,r
#! @Returns a list of lists of the form $[S,T]$
#! @Description
#!  Constructs the irreducible representation(s) of unary type $R$ (that is, with $\sigma = \lambda$)
#!  with level $p^\lambda$.
DeclareGlobalFunction( "SL2Reps_RepRUnary" );

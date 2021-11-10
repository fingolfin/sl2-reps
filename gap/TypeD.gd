#
# SL2Reps: Constructs representations of SL2(Z).
#
# Representations of type D.


#! @Chapter Irreps
#! @ChapterTitle Irreducible representations of prime-power level
#!  Methods for generating individual irreducible representations of
#!  $\mathrm{SL}_2(\mathbb{Z}/p^\lambda\mathbb{Z})$ for a given level $p^\lambda$.
#!
#!  In each case (except the unary type $R$, for which see <Ref Func="SL2IrrepRUnary"/>),
#!  the underlying module $M$ is of rank $2$, so its elements have the form $(x,y)$
#!  and are thus represented by lists $[x,y]$.


#! @Section Representations of type D
#!
#! See Section <Ref Sect="Chapter_Description_Section_Weil_Subsection_Type_D"/>.


#! @Arguments p,ld
#! @Returns a record `rec(Agrp, Bp, Char, IsPrim)` describing $(M,Q)$
#! @Description
#!  Constructs information about the underlying quadratic module $(M,Q)$ of type $D$, for
#!  $p$ a prime and $\lambda \geq 1$.
#!
#!  `Agrp` is a list describing the elements of
#!  \[\mathfrak{A} = (\mathbb{Z}/p^\lambda\mathbb{Z})^\times\]
#!  (see <Cite Key="NW76" Where="Section 2.1"/>). The group $\mathfrak{A}$ has the following form.
#!  When $p=2$ and $\lambda \geq 3$, it is generated by $\alpha = -1$ and $\zeta = 5$.
#!  Otherwise, it is cyclic; in this case, we choose a generator $\alpha$ and (for simplicity) say $\zeta = 1$.
#!  Each element $a$ of $\mathfrak{A}$ is represented in `Agrp` by a list `[v, a, a_inv]`,
#!  where `v` is a list defined by $a = \alpha^{\mathtt{v[1]}} \zeta^{\mathtt{v[2]}}$.
#!
#!  `Bp` is a list of representatives for the $\mathfrak{A}$-orbits on $M^\times$, which
#!  correspond to a basis the $\mathrm{SL}_2(\mathbb{Z}/p^\lambda\mathbb{Z})$-invariant subspace
#!  associated to any primitive character $\chi \in \hat{\mathfrak{A}}$ with $\chi^2 \not\equiv 1$.
#!  For other characters, we must use different bases which are particular to each case.
#!
#!  `Char(i,j)` converts two integers $i$, $j$ to a function representing a character of $\mathfrak{A}$.
#!  Each character in $\hat{\mathfrak{A}}$ is of the form $\chi_{i,j}$, given by
#!  \[\chi_{i,j}(\alpha^{v}\zeta^{w}) \mapsto \mathbf{e}\left(\frac{vi}{|\alpha|}\right) \mathbf{e}\left(\frac{wj}{|\zeta|}\right)~.\]
#!  Note that $j$ is irrelevant in the cases where $\mathfrak{A}$ is cyclic.
#!
#!  `IsPrim(chi)` tests whether the output of `Char(i,j)` represents a primitive character.
#!  A character is primitive if it is injective on $\langle\omicron\rangle \leq \mathfrak{A}$,
#!  where $\omicron$ is defined as follows.  If $p=2$ and $\lambda \geq 3$, $\omicron = 5$.
#!  If $\lambda = 1$, $\omicron = \alpha$.  In all other cases, $\omicron = 1+p$.
DeclareGlobalFunction( "SL2ModuleD" );

#! @Arguments p,ld,chi_index
#! @Returns a list of lists of the form $[S,T]$
#! @Description
#!  Constructs the modular data for the irreducible representation(s) of type $D$ with
#!  level $p^\lambda$, for $p$ a prime and $\lambda \geq 1$, corresponding to the
#!  character $\chi$ indexed by `chi_index = [i,j]`
#!  (see the discussion of `Char(i,j)` in <Ref Func="SL2ModuleD"/>).
#!
#!  Depending on the parameters, $W(M,Q)$ will contain either 1 or 2 such irreps.
DeclareGlobalFunction( "SL2IrrepD" );

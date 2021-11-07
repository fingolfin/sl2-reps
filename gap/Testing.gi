#
# SL2Reps: Constructs representations of SL2(Z).
#
# Testing functions
#
# Implementations
#

InstallGlobalFunction( SL2WithConjClasses,
function(p, ld)
    local l, CC, o, s, t, G, C1, c, ccl;

    if not IsPrime(p) then
        Error("p must be a prime.");
    elif not ld in PositiveIntegers then
        Error("ld must be a positive integer.");
    fi;

    l := p^ld;
    CC := _SL2ConjClasses(p, ld);
    o := ZmodnZObj(1, l);
    s := [[0,1],[-1,0]] * o;
    t := [[1,1],[0,1]] * o;
    G := Group([s,t]);

    C1 := [];
    if p > 2 then
        for c in CC[1] do
            if Length(c[1]) = 1 then
                Add(C1, t^(c[1][1]) * s * (-1)^(c[2]));
            elif (Length(c[1]) = 4 and c[1][1] <> 1) or Length(c[1]) = 2 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            fi;
        od;
    else
        for c in CC[1] do
            if Length(c[1])=4 and c[1][1]<>1 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            elif Length(c[1])=2 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            elif Length(c[1])=3 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            elif Length(c[1])=5 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            elif Length(c[1])=1 then
                Add(C1, Product(c[1], m -> t^m * s) * (-1)^(c[2]));
            fi;
        od;
    fi;

    ccl := List(C1, x -> ConjugacyClass(G, x));
    if Sum(ccl, x -> Size(x)) <> Size(G) then
        Error("Conjugacy class size mismatch.");
    fi;

    SetConjugacyClasses( G, ccl );

    return G;
end );

InstallGlobalFunction( SL2ChiST,
function(S, T, p, ld)
    local l, ordT, dim, CC, s2, TS, i, ProdTrace,
            C1, Du, c,
            Dh, h, e1, e1inv, e2, e2inv, j, jinv, Dhmap;

    dim := DimensionsMat(S);
    if dim = fail or dim[1] <> dim[2] then
        Error("S must be a square matrix.");
    fi;
    dim := DimensionsMat(T);
    if dim = fail or dim[1] <> dim[2] then
        Error("T must be a square matrix.");
    fi;
    ordT := Order(T);
    if (not IsPrimePowerInt(ordT)) or (p^ld mod ordT <> 0) then
        Error("T must have prime power order dividing p^ld.");
    fi;

    l := p^ld;

    CC := _SL2ConjClasses(p, ld);

    s2 := S^2;
    s2 := s2[1][1]; # assuming S^2 = +-1
    TS := [S];
    for i in [1 .. l-1] do
        Add(TS, T * TS[i]);
    od;

    ProdTrace := function(A, B)
        # assumes they are both square matrices of same size
        return Sum([1..Length(A)], x -> Sum([1..Length(A)], y -> A[x][y]*B[y][x]));
    end;

    C1:=[];
    if p > 2 then
        Du := TS[CC[2]+1] * TS[CC[3]+1] * TS[CC[2]+1];
        for c in CC[1] do
            if Length(c[1]) = 1 then
                Add(C1, Trace(TS[(c[1][1] mod l) +1] * s2^(c[2])));
            elif Length(c[1]) = 4 and c[1][1]<>1 then
                Add(C1, ProdTrace(Du,TS[(c[1][4] mod l) +1]) * s2^(c[2]));
            elif Length(c[1]) = 2 then
                Add(C1, ProdTrace(TS[(c[1][1] mod l)+1], TS[(c[1][2] mod l)+1]) * s2^(c[2]));
            fi;
        od;
    else
        Dh:=[];

        for h in [3..ld] do
            e1 := 1+2^(h-1);
            e1inv := e1^-1 mod l;
            Add(Dh, [e1inv,TS[e1inv+1] * TS[e1+1] * TS[e1inv+1]]);
            e2 := (-e1) mod l;
            e2inv := (-e1inv) mod l;
            Add(Dh, [e2inv, TS[e2inv+1] * TS[e2+1] * TS[e2inv+1]]);
        od;

        for i in [3,5,7] do
            j := i mod l;
            jinv:=j^-1 mod l;
            Add(Dh, [jinv,TS[jinv+1] * TS[j+1] * TS[jinv+1]]);
        od;
        Dh := AsSet(Dh);

        Dhmap:=function(uinv)
            local x;
            x := First(Dh, y -> y[1] = uinv);
            return x[2];
        end;

        for c in CC[1] do
            if Length(c[1])=4 and c[1][1]<>1 then
                Add(C1, ProdTrace(Dhmap(c[1][1]), TS[(c[1][4] mod l) +1]) * s2^(c[2]));
            elif Length(c[1])=2 then
                Add(C1, ProdTrace(TS[(c[1][1] mod l)+1], TS[(c[1][2] mod l)+1]) * s2^(c[2]));
            elif Length(c[1])=3 then
                Add(C1, Trace(Dhmap(c[1][1] mod l)) * s2^(c[2]));
            elif Length(c[1])=5 then
                Add(C1, ProdTrace((TS[(c[1][1] mod l)+1] * Dhmap(c[1][2] mod l)), TS[(c[1][5] mod l)+1]) * s2^(c[2]));
            elif Length(c[1])=1 then
                Add(C1, Trace(TS[(c[1][1] mod l)+1]) * s2^(c[2]));
            fi;
        od;
    fi;

    return C1;
end );

InstallGlobalFunction( SL2IrrepPositionTest,
function(p, ld)
    local irrep_list, count, i, G, irreps, PositionTest, pos_list, rho;

    if not IsPrime(p) then
        Error("p must be a prime.");
    elif not ld in PositiveIntegers then
        Error("ld must be a positive integer.");
    fi;

    Info(InfoSL2Reps, 1, "SL2Reps : Constructing irreps via Nobs-Wolfart.");
    irrep_list := [];
    count := 0;
    for i in [1 .. ld] do
        Info(InfoSL2Reps, 1, "SL2Reps : Level ", p^i, ":");
        irrep_list[i] := SL2PrimePowerIrrepsOfLevel(p, i);
        count := count + Length(irrep_list[i]);
    od;
    Info(InfoSL2Reps, 1, "SL2Reps : In total, ", count, " non-trivial irreps of level dividing ", p^ld, " found.");

    Info(InfoSL2Reps, 1, "SL2Reps : Constructing irreps via conjugacy classes.");
    G := SL2WithConjClasses(p, ld);
    irreps := Irr(G);
    # This always includes the trivial irrep, so we ignore it.
    Info(InfoSL2Reps, 1, "SL2Reps : ", Length(irreps)-1, " non-trivial irreps of level dividing ", p^ld, " found.");

    PositionTest := function(irreps, rho, pos_list)
        local pos;

        pos := Position(irreps, SL2ChiST(rho.S, rho.T, p, ld));
        if pos = fail then
            Info(InfoSL2Reps, 1, "SL2Reps : ", rho.name, " not found!");
        else
            Info(InfoSL2Reps, 1, "SL2Reps : ", rho.name, ": ", pos);
            Add(pos_list, pos);
        fi;
    end;

    pos_list := [];

    Info(InfoSL2Reps, 1, "SL2Reps : Performing position test:");
    for i in [1 .. ld] do
        for rho in irrep_list[i] do
            PositionTest(irreps, rho, pos_list);
        od;
    od;

    if Length(pos_list) <> Length(AsSet(pos_list)) then
        Info(InfoSL2Reps, 1, "SL2Reps : WARNING: duplicates found:\n", pos_list);
        return false;
    elif Length(pos_list) <> Length(irreps)-1 then
        Info(InfoSL2Reps, 1, "SL2Reps : WARNING: mismatched number of irreps:\n", pos_list);
        return false;
    else
        Info(InfoSL2Reps, 1, "SL2Reps : 1-to-1 correspondence confirmed.");
        return true;
    fi;
end );

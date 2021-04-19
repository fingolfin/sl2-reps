#-------------------------------------------------------------
# MN gives the module and character information of type N.
#
# The basis for a type N representation for a primitive chi depends only on p and ld,
# so it can also be produced here.
#-------------------------------------------------------------

MN := function(p, ld)
    local l, t, M, pM, tM, A, Nm, Prod, Pow, Ord, alpha, zeta, Aind, Agrp, Char, i, j, u, theta, Bp;

    l := p^ld;

    # Find t.
    if p = 2 then t := 3;
    else
        t := First([0..4*l], i -> (i mod 4 = 3) and (Jacobi(-i, p) = -1));
    fi;

    # Construct the module.
    M := Tuples([0..l-1], 2);
    tM := Tuples([0..l-1], 2);
    pM := Tuples(List([0..l/p-1], x -> p*x mod l), 2);
    SubtractSet(tM, pM);

    # Product, power and order.
    Prod := function(a, x)
        return [(a[1]*x[1] - (1 + t)*a[2]*x[2]/4) mod l, (a[1]*x[2]+a[2]*x[1]+a[2]*x[2]) mod l];
    end;

    Pow := function(a, n)
        local y, i;
        y := [a[1] mod l, a[2] mod l];
        if n > 1 then
            for i in [1..n-1] do
                y := Prod(y, a);
            od;
        elif n = 0 then
            y := [1,0];
        fi;
        return y;
    end;

    Ord := function(a)
        local x, b;
        x := 1;
        b := a;
        while b <> [1,0] do
            b := Prod(a, b);
            x := x + 1;
        od;
        return x;
    end;

    # Norm and the group A of norm 1.
    Nm := function(a)
        return (a[1]^2 + a[1]*a[2] + (1 + t)*a[2]^2/4) mod l;
    end;

    A := Filtered(M, a -> Nm(a) = 1);

    # Use Ord(zeta) = p+1 or 6 to find zeta.
    if ld = 1 or ((p > 2) and (ld > 1)) then
        zeta := First(A, x -> Ord(x) = p+1);
    else
        zeta := First(A, x -> Ord(x) = 6);
    fi;

    # Use Ord(alpha) = 2^(ld - 2) or p^(ld - 1) to find alpha.
    if ld = 1 then
        alpha := [1,0];
    elif p = 2 then
        alpha := First(A, x -> (Ord(x) = 2^(ld-2)) and (x[1] mod 4 = 1) and (x[2] mod 4 = 0));
    else
        alpha := First(A, x -> Ord(x) = p^(ld-1) and (x[1] mod p = 1) and (x[2] mod p = 0));
    fi;

    # Use powers of alpha and zeta to index elements in A.
    Aind := Cartesian([0..Ord(alpha)-1], [0..Ord(zeta)-1]);
    Agrp := List(Aind, x -> [x[1], x[2], Prod(Pow(alpha,x[1]), Pow(zeta, x[2]))]);

    # Use (i, j) to index chars. Each chi(i, j) is a function Agrp -> C^*.
    Char := function(i, j)
        local Chi;
        Chi := function(x)
            return E(Ord(alpha))^(x[1]*i) * E(Ord(zeta))^(x[2]*j);
        end;
        return Chi;
    end;

    # Find the bases for primitive chars, which depend only on p and ld.
    # For odd p, pick u to be the smallest quad nonres mod p (any quad nonres works).
    if p > 2 then
        u := First([0..p-1], x -> Jacobi(x, p) = -1);
    fi;

    # Find the sets theta. Only works for p = odd or p = 2 and ld > 2.
    theta := function(a)
        local i, eta, t1;
        eta := [1, 0];
        if a > 1 then
            eta := First(tM, x -> Nm(x) = a);
        fi;
        if p > 2 then
            t1 := Filtered([1..(l-1)/2], n -> Gcd(n, p) = 1);
        elif p = 2 and ld > 2 then
            t1 := Filtered([1..2^(ld-2)-1], n -> n mod 2 = 1);
        elif p = 2 and ld = 2 then
            t1 := [1];
        fi;
        return List(t1, x -> Prod([x, 0], eta));
    end;

    # The basis for primitive chars.
    if p = 2 and ld = 1 then
        Bp := [[1, 0]];
    elif p = 2 and ld = 2 then
        Bp := [[1, 0], theta(3)[1]];
    elif p = 2 and ld > 2 then
        Bp := Concatenation(theta(1), theta(3), theta(5), theta(7));
    else
        Bp := Concatenation(theta(1), theta(u));
    fi;

    # Return.
    return [Agrp, Char, Bp, Nm, Prod, alpha, zeta, Ord(alpha), Ord(zeta)];
end;

#-------------------------------------------------------------
# Representation of type N. Input: p, ld and [i, j], where [i, j] labels the character.
#-------------------------------------------------------------

RepN := function(p, ld, chi_index, silent)
    local l, M, Agrp, Chi, Bp, Nm, Prod, Tr, sxy, S, T, deg,
            N, B, O, tO, BQ, a, j, k, VInd, Prim1, Prim2, Prim3, S1, S2, T1, T2, U;

    l := p^ld;
    M := MN(p, ld);
    Agrp := M[1]; Chi := M[2](chi_index[1], chi_index[2]); Bp := M[3];
    Nm := M[4]; Prod := M[5];

    Tr := function(x)
        return (2*x[1] + x[2]) mod l;
    end;

    BQ := function(x, y)
        return (Nm([x[1]+y[1], x[2]+y[2]]) - Nm(x) - Nm(y)) mod l;
    end;

    Prim1 := (((p = 2) and (ld > 2)) or ((p > 2) and (ld > 1))) and (Gcd(chi_index[1], p) = 1);

    Prim2 := (p = 2) and (ld = 2) and (Chi([ 0, 3, [ 3, 0 ] ]) = -1);

	Prim3 := (p>2) and (ld = 1) and ((chi_index[2] mod (p+1)/2) <> 0);

    if Prim1 or Prim2 or Prim3 then
        if not silent then
            Print("Chi is primitive.\n");

            if (Length(AsSet(List(Agrp, x -> Chi(x)^2))) > 1) then
                Print("Chi^2 != 1.\n");
            fi;
        fi;

        sxy := function(x, y)
            local z;
            z := Prod(x, [y[1] + y[2], -y[2]]);
            return (-1)^ld/l * Sum(Agrp, a -> Chi(a)*E(l)^(Tr(Prod(a[3], z))));
        end;

        S := List(Bp, x -> List(Bp, y -> sxy(x, y)));
        T := DiagonalMat(List(Bp, x -> E(l)^(Nm(x))));

        deg := Length(Bp);
    elif (ld = 1 and Length(AsSet(List(Agrp, x -> Chi(x)))) = 1) then
        if not silent then
            Print("ld = 1, and Chi is the trivial character. This representation is also called the Steinberg representation.\n");
        fi;

        Bp := Concatenation([[0,0]], Bp);

        sxy := function(x, y)
            local z;
            if x = [0,0] and y = [0,0] then
                return -1/p;
            elif x = [0,0] or y = [0,0] then
                return -Sqrt(p+1)/p;
            else
                z := Prod(x, [y[1] + y[2], -y[2]]);
                return (-1)^ld/l * Sum(Agrp, a -> Chi(a)*E(l)^(Tr(Prod(a[3], z))));
            fi;
        end;

        S := List(Bp, x -> List(Bp, y -> sxy(x, y)));
        T := DiagonalMat(List(Bp, x -> E(l)^(Nm(x))));
        deg := Length(Bp);
    else
        if not silent then
            Print("Chi is not primitive or Ord(Chi) <= 2. It is also not the Steinberg representation. The first decomposition method gives the following representation corresponding to Chi that is REDUCIBLE.\n");
        fi;

        N:=Tuples([0..l-1], 2);;
        B:=[];
        O:=[];
        while Length(N) > 0 do
            Add(B,N[1]);
            tO:=Set(Agrp, a -> Prod(a[3], N[1]));
            Add(O, tO);
            SubtractSet(N, tO);
        od;

        VInd := [];
        for k in [1..Length(B)] do
            for a in Agrp do
                if a <> [0, 0, [1, 0]] and Chi(a) <> 1 and Prod(a[3], B[k]) = B[k] then
                    Add(VInd, k); break;
                fi;
            od;
        od;

        SubtractSet(B, List(VInd, k -> B[k]));
        SubtractSet(O, List(VInd, k -> O[k]));

        deg := Length(B);
        sxy := function(x, y)
            return (-1)^ld/l * Sum(Agrp, a -> Sum(Agrp, b -> Chi(a)*ComplexConjugate(Chi(b))*E(l)^(BQ(Prod(a[3], x), Prod(b[3], y)))));
        end;

        S := List([1..deg], x -> List([1..deg], y -> Sqrt(Length(O[x])*Length(O[y]))*sxy(B[x], B[y])/(Length(Agrp))^2));

        T := DiagonalMat(List(B, x -> E(l)^(Nm(x))));
    fi;

    if [p, ld, chi_index[1] mod 2, chi_index[2] mod 6] = [2, 3, 1, 0] then
        if not silent then
            Print("Special case [2, 3, 1, 0]. The character is primitive of order 2 and the representation is reducible. It decomposes into two irreducible components. The output is of the form [N_3(chi)_+, N_3(chi)_-].\n");
        fi;

        S1 := S{[1,2]}{[1,2]};
        T1 := T{[1,2]}{[1,2]};
        S2 := S{[3,4]}{[3,4]};
        T2 := T{[3,4]}{[3,4]};
        deg := 2;
        return [[S1, T1, deg], [S2, T2, deg]];
    elif [p, ld, chi_index[1] mod 2, chi_index[2] mod 6] = [2, 3, 1, 3] then
        if not silent then
            Print("Special case [2, 3, 1, 3]. The character is primitive of order 2 and the representation is reducible. It decomposes into two irreducible components. The output is of the form [N_3(chi)_+, N_3(chi)_-].\n");
        fi;

        U := [
            [1, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
            [0, 1, 0, 0]
        ];
        S := U^(-1)*S*U;
        T := U^(-1)*T*U;
        S1 := S{[1,2]}{[1,2]};
        T1 := T{[1,2]}{[1,2]};
        S2 := S{[3,4]}{[3,4]};
        T2 := T{[3,4]}{[3,4]};
        deg := 2;
        return [[S1, T1, deg], [S2, T2, deg]];
    else
        return [S, T, deg];
    fi;
end;





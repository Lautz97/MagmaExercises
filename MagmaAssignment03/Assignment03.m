""; 
"";
"Implemented by Lauterio Davide @Lautz97";

function CRTsolver(L, M)
    // Check if the input sequences have the same length
    if #L ne #M then
        return "Error: incompatible lengths";
    end if;
    
    // Check if the elements in M are pairwise coprime
    for i in [1..#M-1] do
        for j in [i+1..#M] do
            if GCD(M[i], M[j]) ne 1 then
                "GCD(",M[i],",",M[j],") =",GCD(M[i], M[j]);
                return "Error: modules are not pairwise coprime";
            end if;
        end for;
    end for;
    
    // Compute the product of all elements in M
    n := &*M;
    
    // Compute the solution x
    x := 0;
    for i in [1..#L] do
        // Compute Mi and bi using the extended Euclidean algorithm
        Mi := n div M[i];
        _, bi, _ := XGCD(Mi, M[i]);
        bi := bi mod M[i];
        if bi lt 0 then
            bi +:= M[i];
        end if;
        
        // Update x
        x +:= L[i] * Mi * bi;
    end for;
    
    // Return the solution x
    return x mod n;
end function;


function verifyCRTsolver()
    // Generate random input data
    n := Random(3, 6);
    L := [Random(0, 10^n-1) : i in [1..n]];
    M := [Random(2, 10^n) : i in [1..n]];
    
    // Print the input data
    "Input:";
    "L =", L;
    "M =", M;
    
    // Use CRTsolver to obtain the solution
    x := CRTsolver(L, M);
    
    // Use CRT to obtain the solution
    y := CRT(L, M);
    
    if(y eq -1) then
        if x eq "Error: incompatible lengths" or x eq "Error: modules are not pairwise coprime" then
            x;
            return true;
        else
            return false;
        end if;
    end if;

    // Print the solutions
    "CRTsolver solution: x =", x;
    "CRT solution: y =", y;
    return x eq y;
end function;

// for i in [1..100] do
//     if not verifyCRTsolver() then
//         "Error";
//         break;
//     end if;
// end for;

// L := [ 361738, 967349, 494650, 891842, 276767, 441733 ];
// "L =", L;
// M := [ 686930, 840083, 398756, 161988, 397233, 508297 ];
// "M =", M;
// x := CRTsolver(L, M);
// y := CRT(L, M);
// x;
// y;

"TEST FOR BIG NUMBERS";
L:=[ 10638784, 1737071, 16169135, 12905265, 14234907, 877386, 15188741, 9195743, 13670607, 3458056,
    13558519, 11600283, 11645270, 6947678, 4768756, 694829, 1810593, 12407916, 98442, 608566, 16395486,
    691504, 3246142, 15527265, 9665987, 8544511, 11777512, 11747585, 5172355, 13598298, 1169031, 1545563,
    9139227, 15605688, 4512519 ];
M:=[ 21170174777, 23503512751, 64846122461, 36850814327, 50763375841, 50195685061, 21546251059, 7506186031,
    60339670067, 8223946987, 4385245511, 46227313061, 30239971459, 4221029669, 64047382211, 22790773253,
    36858157631, 46147508651, 37994298703, 21123704149, 58266963817, 18559503161, 19642682903, 62813026891,
    27254602651, 49252472183, 65373833461, 17685478463, 31982075431, 42626962397, 38899354961, 29058919537,
    40195057583, 27193036939, 5792841172 ];
x := CRTsolver(L, M);
x;
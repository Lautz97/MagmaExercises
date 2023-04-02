""; 
"";
"Implemented by Lauterio Davide @Lautz97"; 

function extended_gcd_custom(a,b)
    if b eq 0 then
        if a eq 0 then
            return "ERROR A = B = 0","ERROR A = B = 0","ERROR A = B = 0";
        else 
            return a, 1, 0;
        end if;
    else
        d, x, y := extended_gcd_custom(b, a mod b);
        return d, y, x - (a div b)*y;
    end if;
end function;

function gcd_custom(a,b)
    while b ne 0 do
        r := a mod b;
        a := b;
        b := r;
    end while;
    return a;
end function;
"";"";"";
"Call gcd_custom(a,b) to compute the GCD of a,b.";
"Call extended_gcd_custom(a,b) to compute the GCD and the values of x and y with the extended euclidean algo.";
"The first function require just one output variable, while the second requires three.\n\nExample: ";

a := 24;
"a := ",a;
b := 36;
"b := ",b;
g, x, y := extended_gcd_custom(a,b);
;
g," = ",a," * ",x," + ",b," * ",y;
;

unsetLogWithSeed();

verifyCustom := function()
    "Try it now!\n";
    while (1 eq 1) do
        "a:=";
        readi a;
        "b:=";
        readi b;
        g, x, y := extended_gcd_custom(a,b);
        ;
        g," = ",a," * ",x," + ",b," * ",y;
        ;
        read r, "try again? y/n" ;
        if r eq "n" then
            break;
        end if;
    end while;
    return "";
end function;

verifyCustom();
""; 
"";
"Implemented by Lauterio Davide @Lautz97";

Fact1AuxFun := function(x,y)
    if x mod 2 eq 0 then
        x := x div 2;
    elif y mod 2 eq 0 then
        y := y div 2;
    elif x gt y then
        x := (x - y) div 2;
    else
        y := (y - x) div 2;
    end if;
    return x,y;
end function;

binaryGCD := function(a, b)
    // Make sure a and b are non-negative
    if a lt 0 or b lt 0 then
        "input has being made positive";
        a:=Abs(a);
        b:=Abs(b);
    end if;

    // Make sure a and b are int
    if a notin Integers() or b notin Integers() then
        return "please input two positive integers";
    end if;

    // Handle the case where one or both inputs are zero
    if a eq 0 then
        return b;
    elif b eq 0 then
        return a;
    end if;

    // Compute the power of 2 dividing both a and b
    k := 0;
    while (a mod 2 eq 0) and (b mod 2 eq 0) do
        a := a div 2;
        b := b div 2;
        k := k + 1;
    end while;

    // Perform the binary gcd algorithm
    while a ne b do
        a,b := Fact1AuxFun(a,b);
    end while;

    // Compute the final result
    return a * (2^k);
end function;


"";
"call verifyGCD() to check if the implemented function binaryGCD(a,b) is correctly working";
"";

verifyGCD := function()
    while (1 eq 1) do
        "a:=";
        readi a;
        "b:=";
        readi b;
        "";
        g0 := binaryGCD(a, b);
        "binaryGCD(", a, ",", b, ") = ", g0;
        g1 := GCD(a,b);
        "the built in function GCD returns: ", g1;
        "";
        "the output of the implemented binaryGCD() is: ", g1 eq g0;
        "";
        read r, "try again? y/n" ;
        if r eq "n" then
            break;
        end if;
    end while;
    return "";
end function;

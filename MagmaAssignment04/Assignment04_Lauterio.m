""; 
"";
"Implemented by Lauterio Davide matricola: 282248", "\n"; 

// Definizione parametri per il metodo di Pohlig-Hellman
G := 0;
ordG := 0;

//* Funzione per il calcolo del logaritmo discreto utilizzando l'algoritmo brute force
dLogBruteforce := function(gPowerHexp, target, group)
    exponent := 0;
    while group!gPowerHexp^exponent ne target do
        exponent +:=  1;
    end while;
    return exponent;
end function;

//* Metodo per generare un nuovo valore di x, a, b in base ai valori correnti e ai set S1, S2, S3
function new_xab(x,a,b,g,h,S1,S2,S3,p,ord)
    
    if x in S2 then
        return x*x mod p,2*a mod ord,2*b mod ord;
    elif x in S3 then
        return x*g mod p,a+1 mod ord,b mod ord;
    else
        return x*h mod p,a mod ord,b+1 mod ord;
    end if; 
    
end function;

function pollardrho(g,h,p)
    
    R := Integers(p);
    G := R!g;
    
    ord := Order(G);
    n1 := Ceiling(p/3);
    
    S1 := [0..n1-1];
    S2 := [n1..(n1-1)*2+1];
    S3 := [(n1-1)*2+2..p-1];  
    
    n := p-1;  
    
    x := 1;
    a := 0;
    b := 0;
    
    X := x;
    A := a;
    B := b;

    for i in [1..n] do
        x,a,b := new_xab(x,a,b,g,h,S1,S2,S3,p,ord);
        X,A,B := new_xab(X,A,B,g,h,S1,S2,S3,p,ord);
        X,A,B := new_xab(X,A,B,g,h,S1,S2,S3,p,ord);
        
        if x eq X then
            // return x,X,a,b,A,B;
            break;
        end if;
    end for;

    a_result := (p-1-(A-a) mod (p-1));
    b_result := B-b;
    d,s,t := XGCD(b_result,p-1);
    expp := (a_result*s) mod (p-1);
    for i in [0..d-1] do
        yi := ((expp div d) + i*(p-1) div d) mod (p-1);
        if (R!g^yi) eq (R!h) then
            return yi;
        end if;
    end for; 

    "error"; 
    return "error";

end function;


//* Funzione per il calcolo del logaritmo discreto
mydLog := function(g, h, p)

    // p è un numero primo?
    if not IsPrime(p) then
        return "p is not a prime number";
    end if;

    // G è il gruppo ciclico di ordine p-1
    G := Integers(p);
    
    // g è un generatore di G?
    // if not IsPrimitive(G!g) then
    //     "g is not a generator of G";
    // else
    //     "g is a generator of G";
    // end if;

    // ordG è l'ordine di G
    ordG := Order(G!g);

    // fattorizzazione di ordG
    factorization := Factorization(ordG);
    factors := [];
    Hexp := [];
    // H è il set di tutti i possibili valori di x dato
    // x = ordG / (i[1]^i[2]) per ogni i nella fattorizzazione di ordG
    for i in factorization do
        // i[1] è il fattore primo
        // i[2] è l'esponente
        // i[1]^i[2] è il fattore primo elevato all'esponente
        f:=(i[1]^i[2]);
        Append(~factors, f);
        Append(~Hexp, (ordG div f));
    end for;

    // phiVector è il set di tutti i possibili valori di phi(h,x,G) dato x in Hexp
    phiVector := [];
    for i in Hexp do
        // Append(~phiVector, phi(h,i,G));
        Append(~phiVector, G!h^i);
    end for;

    // per ogni elemento di phiVector, calcoliamo il logaritmo discreto
    AVector := [];
    for i in [1..#phiVector] do
        // ricerca del logaritmo discreto con algoritmo brute force
        if (true) then
            "pollardo";
            Append(~AVector, pollardrho(Integers()!(G!g^Hexp[i]), Integers()!phiVector[i], p));
        end if;
        if (false) then
            "brute force";
            Append(~AVector, dLogBruteforce(G!g^Hexp[i], phiVector[i], G));
        end if;
    end for;

    // applicazione del teorema cinese del resto per trovare il risultato
    result := CRT(AVector, factors);

    // controllo del risultato
    if G!g^result eq h then
        return result;
    else
        return "error";
    end if;
end function;

// p1a:=2898919;
// "p := ",p1a;
// g1a:=6;
// "g := ", g1a;
// h1a:=2023414;
// "h := ", h1a;

// "dLog_", g1a, "(",h1a,")","mod", p1a,":=", mydLog(g1a , h1a , p1a), "\n";

// p1a:=47;
// g1a:=5;
// h1a:=15;

// "dLog_", g1a, "(",h1a,")","mod", p1a,":=", mydLog(g1a , h1a , p1a), "\n";

// p1:=433;
// g1:=7;
// h1:=166;

// "dLog_", g1, "(",h1,")","mod", p1,":=", mydLog(g1 , h1 , p1), "\n";

// p1b:=257;
// g1b:=7;
// h1b:=166;

// "dLog_", g1b, "(",h1b,")","mod", p1b,":=", mydLog(g1b , h1b , p1b), "\n";

"Task 1";
pDH:=137438953481;
gDH:=3;
hDH:=114534287914;
aDH := mydLog(gDH , hDH , pDH);
"dLog_", gDH, "(",hDH,")","mod", pDH,":=", aDH, "\n";

R := Integers(pDH);
Dpub := 47963704417;
s := R!Dpub^aDH;

"Davide's public key: ", Dpub;
"shared secret between davide and professor: ", s, "\n";

load "../EncodingExercise/EncodeDecodeAlphabet.m";

S := Integers()!s;
ciphertext := "FUAUM";
plaintext := DecryptAlphabet(S, ciphertext);

"ciphertext := ", ciphertext;
"plaintext := ", plaintext, "\n";


"Task 2";
p2:=130916962986128335495933;
g2:=1234567;
h2:=8987654321;
a2 := mydLog(g2 , h2 , p2);
"dLog_", g2, "(",h2,")","mod", p2,":=", a2, "\n";


"Task 3";
p3:=414304826390894663085077217775069766737984045706834393;
g3:=3;
h3:=350245296247225487828410712825238569959396265055090989;
a3 := mydLog(g3 , h3 , p3);
"dLog_", g3, "(",h3,")","mod", p3,":=", a3, "\n";
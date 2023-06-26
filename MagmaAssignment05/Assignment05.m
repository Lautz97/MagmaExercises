""; 
"";
"Implemented by Lauterio Davide @Lautz97";


n1:=31920373292612398506116036157900063143614276101840204886089126262814698458589093426458124455537356800316441467726727702004255007697479368898815671165929111081756920911182000762239827024353960266200914439424491790442597612442582117135700390457904810432816553509548683111315115678752114655743861209495357279083;
e1:=65537; 
d1:=10820985602666732648891160341792662203971472178381430824637107560324002558165217947962527290365342570343933657147637355317279300334389720903077464123982587056288964378742893865864935092276068969277225199904389760317448067994560443340211313945270645888972357646040068444755654890246022424335043913562499140553; 

n2:=38115612444044249287386522963934750227697588238773431470249469761201625659638150779372126736188139210482505558240496087730224600589043818744164226529344084099947072857796233467251619923075189521479155912724897057549008185027825867769479088091163323419220343569646408567271640061919434616913415417531831207231; 
c:=1881670473761131333651168192230717376362371954519596462438876322825518161;

// error was using a/b instead of a div b
function FactorsFromD (n, e, d)

    Z := Integers();
    modN := Integers(n);
    p := 0;
    q := 0;
    // X := {2..9};
    x := Random(n);

    i := 2;
    exp := (e * d) - 1;
    y := modN!x^(Z!(exp div i));

    while y eq 1 do
        i := i * 2;
        y := modN!x^(Z!(exp div i));       
    end while;


    p := Z!GCD(y-1, n);
    q := Z!(n div p);

    if(p eq 1 or q eq 1) then
        return FactorsFromD(n, e, d);
    end if;
    return p,q;
end function;

p1,q1 := FactorsFromD(n1,e1,d1);
if(p1 * q1 eq n1) then
    "p1 * q1 = n1 :",p1 * q1 eq n1;
    "p1 = ", p1;
    "q1 = ", q1;
else
    "p1, q1 not found";
end if;
/*/
// testing factors from d
function GenerateKeys ()
    p := NextPrime(2^Random(2^6));
    q := NextPrime(2^Random(2^6));
    n := p * q;
    phiN := (p - 1) * (q - 1);
    e := Random(2^10);
    while (GCD(e, phiN) ne 1) or (e le 1) do
        e := Random(2^10);
    end while;
    d := Modinv(e, phiN);
    if(d le 1) then
        return GenerateKeys();
    end if;
    return n, e, d;
end function;


for i in [0..10000] do
    if i mod 100 eq 0 then
        i;
    end if;
    n1,e1,d1 := GenerateKeys();
    if(e1 lt 2 or d1 lt 2) then
        "error PINO";
        break;
    end if;
    // n1,e1,d1;
    p1,q1 := FactorsFromD(n1,e1,d1);
    // p1,q1;
    if(p1 * q1 ne n1) then
        "error";
        break;
    end if;
end for;
// /**/


"\n\n";

e2:=3;
// n2;
// c;

N2 := Integers(n2);
m := Floor(Root(Integers()!N2!c, e2))mod n2;

if(c mod n2 eq m^e2 mod n2) then
    "c = ", c;
    "c = m^3 mod n2";
    "m = ", m;
else
    "m not found";
end if;
/**/
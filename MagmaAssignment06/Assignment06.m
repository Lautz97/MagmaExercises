""; 
"";
"Implemented by Lauterio Davide @Lautz97";

GF2 := GF(2);
// P<x> is the polynomial ring over GF(2)
P<x> := PolynomialRing(GF2);

// This function checks if a polynomial is irreducible over GF(2)
testIrreducibility := function(polyToCheck)
    if polyToCheck eq 0 then
        return false;
    end if;
    if polyToCheck eq 1 then
        return false;
    end if;
    // cast polyToCheck to P
    polyToCheck := P!polyToCheck;
    // if the degree of the polynomial is 1, then it is irreducible
    if Degree(polyToCheck) eq 1 then
        return true;
    end if;
    // we must check that for any polynomial g of degree 1 < deg(g) < deg(f)
    // the greatest common divisor of f and g is 1
    // so we must generate the set of all polynomials of degree 1 < deg(g) < deg(f)
    // and check that the gcd of f and g is 1
    // we can generate the set of all polynomials of degree 1 < deg(g) < deg(f)
    V := VectorSpace(GF2, Degree(polyToCheck));
    // the set of all polynomials of degree 1 < deg(g) < deg(f) is the set of all vectors in V
    // so we can generate the set of all polynomials in V that are not coprime with f
    // and check if it is empty   
    SetOfPoly := {a : a in V | ((GCD(polyToCheck, P!(Eltseq(a))) ne 1) and (a ne 0))};
    if #SetOfPoly eq 0 then
        return true;
    else
        return false;
    end if; 
end function;

listIrreds := function(n)
    if n le 1 then
        "ERROR: n must be greater than 1";
        return [];
    end if;

    S := {P!Eltseq(v) :v in VectorSpace(GF2, n+1) | ((Degree(P!Eltseq(v)) eq n) and (testIrreducibility(P!Eltseq(v))))};
    return S;
end function;

Z := Integers();

// Define the vector space V128 over the Galois field GF(2) with 128 elements
V128 := VectorSpace(GF2, 128);
V8 := VectorSpace(GF2, 8);

// The substitution matrix A used in SubBytes operation
GF28 := GF(2, 8);

bitSeqToInt := function(s)
    hint := 0;
    for j in [1..#s] do
        hint +:= (Z!s[j])*(2^(#s-j));
    end for;
    return Z!hint;
end function;

PrecomputedSBOX :=[
    [0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76],
    [0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0],
    [0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15],
    [0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75],
    [0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84],
    [0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf],
    [0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8],
    [0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2],
    [0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73],
    [0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb],
    [0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79],
    [0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08],
    [0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a],
    [0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e],
    [0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf],
    [0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16]
];

PrecomputedSBOXInverted := [
    [0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb],
    [0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb],
    [0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e],
    [0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25],
    [0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92],
    [0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84],
    [0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06],
    [0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b],
    [0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73],
    [0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e],
    [0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b],
    [0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4],
    [0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f],
    [0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef],
    [0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61],
    [0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d]
];

// Perform the substitution operation (SubBytes) on the state vector s
SubBytes := function(s)
    copy := Eltseq(s);
    for i in [0..15] do
        byte := copy[8*i+1..8*i+8];
        h1 := bitSeqToInt(byte[1..4]);
        h2 := bitSeqToInt(byte[5..8]);
        // Convert to integer
        // h1 := (2^(3*Z!h1[1])) + (2^(2*Z!h1[2])) + (2^(1*Z!h1[3])) + (2^(0*Z!h1[4]));
        // h2 := (2^(3*Z!h2[1])) + (2^(2*Z!h2[2])) + (2^(1*Z!h2[3])) + (2^(0*Z!h2[4]));
        // Get the corresponding value from the S-box
        val := PrecomputedSBOX[h1+1][h2+1];
        
        // Convert back to binary
        val := Z!val;
        val := Reverse(IntegerToSequence(val, 2, 8));
        // Replace the byte in the copy
        for j in [1..8] do
            copy[8*i+j] := val[j];
        end for;
    end for;

    return copy;
end function;

InvSubBytes := function(s)
    copy := Eltseq(s);
    for i in [0..15] do
        byte := copy[8*i+1..8*i+8];
        h1 := bitSeqToInt(byte[1..4]);
        h2 := bitSeqToInt(byte[5..8]);
        // Convert to integer
        // h1 := (2^(3*Z!h1[1])) + (2^(2*Z!h1[2])) + (2^(1*Z!h1[3])) + (2^(0*Z!h1[4]));
        // h2 := (2^(3*Z!h2[1])) + (2^(2*Z!h2[2])) + (2^(1*Z!h2[3])) + (2^(0*Z!h2[4]));
        // Get the corresponding value from the S-box
        val := PrecomputedSBOXInverted[h1+1][h2+1];
        // Convert back to binary
        val := Z!val;
        val := Reverse(IntegerToSequence(val, 2, 8));
        // Replace the byte in the copy
        for j in [1..8] do
            copy[8*i+j] := val[j];
        end for;
    end for;

    return copy;
end function;

// Perform the row shifting operation (ShiftRows) on the state vector s
ShiftRows := function(s)
    result := V128!0;
    s:=Eltseq(s);
    k:=0;
    for i in [0..3] do
        // Shift each row by concatenating the bits accordingly
        // Eltseq(s[(32*i)+1..(32*i)+32]);
        for _ in [0..k] do
            tail := s[32*i+1..(32*i)+8];
            head := s[(32*i)+9..(32*i)+32];
            vec := (head cat tail);
            for j in [1..32] do
                s[(32*i)+j] := vec[j];
            end for;
        end for;
        // Eltseq(head cat tail);
        k := k+1 mod 4;
    end for;
    return s;
end function;

InvShiftRows := function(s)
    result := V128!0;
    s:=Eltseq(s);
    k:=0;
    for i in [0..3] do
        // Shift each row by concatenating the bits accordingly
        // Eltseq(s[(32*i)+1..(32*i)+32]);
        for _ in [0..k] do
            head := s[(32*i)+25..(32*i)+32];
            tail := s[32*i+1..(32*i)+24];
            vec := (head cat tail);
            for j in [1..32] do
                s[(32*i)+j] := vec[j];
            end for;
        end for;
        // Eltseq(head cat tail);
        k := k+1 mod 4;
    end for;
    return s;
end function;

// Perform the key addition operation (AddRoundKey) on the state vector s with key k
AddRoundKey := function(s, k)
    // perform s xor k bitwise
    res := V128!0;
    for i in [1..128] do
        res[i] := s[i] + k[i];
    end for;
    return res;
end function;

// Implement the weakenedAES encryption algorithm
weakenedAES := function(m, k)
    state := m; // Initialize the state vector with the message
    for _ in [1..4] do
        // Apply SubBytes, ShiftRows, and AddRoundKey operations four times
        state := SubBytes(state);
        state := ShiftRows(state);
        state := AddRoundKey(state, k);
    end for;
    return V128!state; // Return the final state as the ciphertext
end function;

// Implement the weakenedAES decryption algorithm
weakenedAESInv := function(c, k)
    state := c; // Initialize the state vector with the ciphertext
    for _ in [1..4] do
        // Apply InvSubBytes, ShiftRows, and AddRoundKey operations four times
        state := AddRoundKey(state, k);
        state := InvShiftRows(state);
        state := InvSubBytes(state);
    end for;
    return V128!state; // Return the final state as the plaintext
end function;

V128ToHexArray := function(s)
    s := Eltseq(s);
    // Convert the state vector to a hexadecimal array
    hexArray := [];
    for i in [0..15] do
        byte := s[8*i+1..8*i+8];
        // Convert to integer
        h := byte[1..8];
        // convert to integer
        // Append to the hexadecimal array
        h := bitSeqToInt(h);
        h := IntegerToString(h, 16);
        if #h eq 1 then
            h := "0" cat h;
        end if;
        h := "0x" cat h;
        Append(~hexArray, h);
    end for;
    return hexArray;
end function;   

//*****************************************************************************************/

GenerateRandomPoly := function(maxExponent)
    // P<x> is the polynomial ring over GF(2)
    P<x> := PolynomialRing(GF2);
    // generate a random polynomial of degree at most maxExponent
    randomPoly := 0;
    for i in [0..maxExponent] do
        randomPoly := randomPoly + Random(GF2)*x^i;
    end for;
    return randomPoly;
end function;

GenerateRandomF128Vector := function()
    message := V128!0; // Initialize the message vector
    for i in [0..127] do
        // Generate a random bit (0 or 1) and set it in the message vector
        message[i+1] := Random(GF2);
    end for;
    return message;
end function;

activateTask1 := true;
if activateTask1 then
    maxDegree := 20;
    maxIterations := 10;
    cycleEndlessly := false;
    iter := 0;

    "TASK 1";
    "testing irreducibility of a list of random polynomials";
    "max degree of the polynomials: ", maxDegree;
    while true do
        read deny,"press enter to continue, q to block the execution of this task, d to set a different max degree, r to define a max number of iterations: ";
        if (deny eq "q") then
            activateTask1 := false;
            "blocking the execution of this task...\n";
            break;
        end if;
        if (deny eq "d") then
            readi maxDegree,"insert the new max degree of the polynomials: ";
            break;
        end if;
        if (deny eq "r") then
            readi maxIterations,"insert the new max number of iterations, or 0 to set as infinite: ";
            if maxIterations eq 0 then
                cycleEndlessly := true;
            else
                cycleEndlessly := false;
            end if;
            break;
        end if;
        if (deny eq "") then
            "continuing...\n";
            break;
        end if;
        "invalid input, try again...\n";
    end while;

    if activateTask1 then
        "testing irreducibility of an endless list of random polynomials.";
    end if;
    while (activateTask1 and ((cycleEndlessly eq true) or (iter lt maxIterations))) do
        f := GenerateRandomPoly(Random(maxDegree));
        if f eq 0 then
            continue;
        end if;
        myResult := testIrreducibility(f);
        magmaResult := IsIrreducible(f);
        if myResult ne magmaResult then
            "f = ", f, " ! ", myResult;
            Factorization(f);
            IsIrreducible(f);
            "ERROR";
            break;
        else 
            "f = ", f, " == ", myResult;
        end if;
        if cycleEndlessly eq false then
            iter +:= 1;
        end if;
    end while;
    "TASK 1 END\n";
end if;

activateTask2 := true;
if activateTask2 then 
    again := "y";
    "TASK 2";
    "Using TASK 1 function to check irreducibility generate a list of all irreducible polynomials of degree exactly n";
    while true do
        read deny,"press enter to continue, q to block the execution of this task";
        if (deny eq "q") then
            activateTask2 := false;
            "blocking the execution of this task...\n";
            break;
        elif (deny eq "") then
            "continuing...\n";
            break;
        else
            "invalid input, try again...\n";
        end if;
    end while;
    while ((again eq "y") and (activateTask2 eq true)) do
        again := "n";
        readi n,"insert the degree of the polynomials: ";
        list := listIrreds(n);
        list;
        "number of irreducible polynomials of degree exactly ", n, ": ", #list;
        read again,"repeat? (y/N)";
    end while;
    "TASK 2 END\n";
end if;

activateTask3 := true;
if activateTask3 then 
    "TASK 3";
    "TASK 3 DESCRIPTION";
    while true do
        read deny,"press enter to continue, q to block the execution of this task";
        if (deny eq "q") then
            activateTask3 := false;
            "blocking the execution of this task...\n";
            break;
        elif (deny eq "") then
            "continuing...\n";
            break;
        else
            "invalid input, try again...\n";
        end if;
    end while;
    while ((true) and (activateTask3 eq true)) do
        activateTask3 := false;
        "generating random message and key...";
        message := V128!GenerateRandomF128Vector(); // 128-bit message
        "PLAINTEXT \t:= ", V128ToHexArray(message);
        key := V128!GenerateRandomF128Vector(); // 128-bit key
        "SECRETKEY \t:= ", V128ToHexArray(key);
        ciphertext := V128!Eltseq(weakenedAES(message, key)); // Encrypt the message using weakenedAES
        "CYPHERTEXT \t:= ", V128ToHexArray(ciphertext); // Display the resulting ciphertext
        
        decodedMsg := V128!Eltseq(weakenedAESInv(ciphertext, key)); // Decrypt the ciphertext using weakenedAES
        "decrypted message is equal to the original message: ", message eq decodedMsg; // Check if the decryption is correct
        if message ne decodedMsg then
            "ERROR";
            "ORIGINAL PLAINTEXT := ", V128ToHexArray(message);
            "DECODED PLAINTEXT  := ",V128ToHexArray(decodedMsg);
            break;
        end if;

        read rep, "want to repeat this task? y/N";
        if(rep eq "y") then
            activateTask3 := true;
        end if;
    end while;
    "TASK 3 END\n";
end if;


activateTask4 := true;
if activateTask4 then 
    "TASK 4";
    "IND-CPA game with weakened-aes.";
    "For simplicity consider message and key space to be the same, namely GF_2^128.";
    while true do
        read deny,"press enter to continue, q to block the execution of this task";
        if (deny eq "q") then
            activateTask4 := false;
            "blocking the execution of this task...\n";
            break;
        elif (deny eq "") then
            "continuing...\n";
            break;
        else
            "invalid input, try again...\n";
        end if;
    end while;
    while ((true) and (activateTask4 eq true)) do
        activateTask4 := false;

        "Let the challenger generate a private key: ...";
        privateKey := V128!GenerateRandomF128Vector(); // 128-bit key
        "C generated a private key";

        "Let the attacker generate a list of messages for the challenger to encrypt: ...";
        "Such list of messages must be at least of length 2. Using 2 messages for simplicity.";
        messages := [];
        for i in [1..2] do
            plain := V128!GenerateRandomF128Vector(); // 128-bit message
            // let last 8 bit of plain be all 0
            for i in [121..128] do
                plain[i] := 0;
            end for;
            messages[i]:=plain;
        end for;
        "\nA generated messages are : ";
        for i in [1..#messages] do
            i, ") : ", V128ToHexArray(messages[i]);
        end for;

        "C chooses b in {0,1} : ...";
        b := Random(GF2);
        // if needed show b to confirm
        // "C chose b = ", b;
        "... ok\n\nNow based on b, C generates a list of responses: ...";
        responses := [];
        if(b eq 1) then
            for i in [1..#messages] do
                responses[i] := weakenedAES(messages[i], privateKey);
            end for;
        else
            for i in [1..#messages] do
                responses[i] := V128!GenerateRandomF128Vector();
            end for;
        end if;
        "C generated responses are :";
        for i in [1..#responses] do
            i, ") : ", V128ToHexArray(responses[i]);
        end for;

        "\nA receives the responses and guesses b' in {0,1} : ...";
        bPrime := 1;
        for i in [1..(#responses)-1] do
            for j in [121..128] do
                if responses[i][j] ne responses[i+1][j] then
                    bPrime := 0;
                    break;
                end if; 
            end for;
        end for;
        "A guessed b' = ", bPrime;
        if(bPrime eq b) then
            "A wins the game, b was ", b;
        else
            "A loses the game, b was ", b;
            break;
        end if;

        "\tRepeat this task enough times to get a good estimate of the probability of A winning the game.";
        "\tWhich is 1";

        read rep,"want to repeat this task? y/N";
        if(rep eq "y") then
            activateTask4 := true;
        end if;
    end while;
end if;

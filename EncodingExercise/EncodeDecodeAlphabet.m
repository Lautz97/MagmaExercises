""; 
"";
"Implemented by Lauterio Davide @Lautz97"; 
// codex
alphabet := [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ];

S := 01234567890; // 11 digits shared secret

StartFromWhat := 0;

SplitItemsInCouplesModN := function(item, n) 
    // Check if the item has an even number of digits
    item := IntegerToString(item);
    if IsOdd(#item) then
        // Remove the last digit from the item
        item := item[1..#item-1];
    end if;
    
    // Split the item into sequential couples of digits
    splitChar := [];

    for i in [1..#item] do
        if(IsOdd(i))then
            toAppend:=item[i..i+1];
            Append(~splitChar, toAppend);
        end if;
    end for;

    split := [];

    for i in [1..#splitChar] do
        inserting := StringToInteger(splitChar[i])mod n;
        Append(~split, inserting);
    end for;
    
    return split;
end function;

SplitTextByChar := function(text)
    list := [];
    for i in [1..#text] do
        Append(~list, text[i]);
    end for;
    return list; 
end function;

CodeAsLetters := function(array,startingFrom:Bool)

    list := [];
    for i in array do
        if (startingFrom eq 0) then
            Append(~list, alphabet[i+1]);
        else
            Append(~list, alphabet[i]+1);
        end if;
    end for;
    return list;
end function;

CodeAsNumbers := function(array,startingFrom:Bool)

    list := [];
    for i in array do
        if (startingFrom eq 0) then
            Append(~list, Position(alphabet,(i))-1);
        else
            Append(~list, Position(alphabet,(i)));
        end if;
    end for;
    return list;
end function;



EncryptAlphabet := function(key, plainAsString)
    modA := Integers(#alphabet);

    splittedKey := SplitItemsInCouplesModN(key, #alphabet);

    splittedPlain := CodeAsNumbers(SplitTextByChar(plainAsString),StartFromWhat);

    cipherList := [];
    for i in [0..#splittedPlain-1] do
        if (StartFromWhat eq 0) then
            Append(~cipherList, Integers()!modA!(splittedPlain[i+1] + splittedKey[(i mod #splittedKey)+1]));
        else
            Append(~cipherList, Integers()!(modA!(splittedPlain[i+1] + splittedKey[(i mod #splittedKey)+1]))+1);
        end if;
    end for;
    cipherList := CodeAsLetters(cipherList,StartFromWhat);
    str := "";
    for i in cipherList do
        str := str cat i;
    end for;
    return str;
end function;

DecryptAlphabet := function(key, cipherAsString)

    modA := Integers(#alphabet);

    splittedKey := SplitItemsInCouplesModN(key, #alphabet);

    splittedCipher := CodeAsNumbers(SplitTextByChar(cipherAsString),StartFromWhat);

    plainList := [];

    for i in [0..#splittedCipher-1] do
        if (StartFromWhat eq 0) then
            Append(~plainList, Integers()!modA!(splittedCipher[i+1] - splittedKey[(i mod #splittedKey)+1]));
        else
            Append(~plainList, Integers()!modA!((splittedCipher[i+1] - splittedKey[(i mod #splittedKey)+1])-1));
        end if;
    end for;

    plainList := CodeAsLetters(plainList,StartFromWhat);
    str := "";
    for i in plainList do
        str := str cat i;
    end for;
    return str;


end function;

"shared secred memorized in variable S";
"Accept only caps, and a single word, no matter how long."
"Uncomment last lines for an example of use :)"

plain := "";
"plaintext to encode: ";
read plain;
ciph := EncryptAlphabet(S,plain);
"ciphertext:= ", ciph;
decrypted := DecryptAlphabet(S,ciph);

"is encoding correct? ", decrypted eq plain;
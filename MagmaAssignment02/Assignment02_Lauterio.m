""; 
"";
"Implemented by Lauterio Davide @Lautz97";
"PLEASE CHECK COMMENTS IN THE CODE FOR MORE DETAILS"; 

/**
 * THIS WAS A FIRST IMPLEMENTATION OF HAS MULTIPPLICITY AT MOST T FUNCTION
 * THE TIME COMPLEXITY WAS O(n^2)
 * THE NEW IMPLEMENTATION HAS TIME COMPLEXITY O(n) USING AN ASSOCIATIVE ARRAY AS AN HASH TABLE
 */
// Define a function to check if the given partition has multiplicity at most t
function hasMultiplicityAtMostT(part, t)
    // Loop through each part of the part
    for i in [1..#part] do
        // Count the number of times this part appears in the part
        count := 0;
        for j in [1..#part] do
            if part[j] eq part[i] then
                count := count + 1;
            end if;
        end for;
        // If the multiplicity of this part is greater than t, return false
        if count gt t then
            return false;
        end if;
    end for;
    // If all parts have multiplicity at most t, return true
    return true;
end function;

// This version of the function is slower that the uncommented one
// because it uses the Partitions function to generate all partitions
// of n and then filters them to keep only those with multiplicity at most t
// while the uncommented version generates partitions with parts <= k and
// multiplicity <= t. This is why the uncommented version is faster than this one.

// Define the main function
function filteredPartitions(n, t)
    if not (n in Integers()) or not (t in Integers()) then
        "n and t must be integers";
        return [], 0;
    end if;

    if(n lt 0) or (t lt 0) then
        "n and t must be positive integers excluding zero";
        n := Abs(n);
        t := Abs(t);
        "n and t have been set to Abs(n) and Abs(t)";
    end if;

    if(n eq 0) or (t eq 0) then
        "n and t must be positive integers excluding zero";
        return [], 0;
    end if;

    // Use the Partitions function to get all partitions of n
    allPartitions := Partitions(n); 
    // Filter the partitions to keep only those with multiplicity at most t
    filtPart := [];
    for i in [1..#allPartitions] do
        if hasMultiplicityAtMostT(allPartitions[i], t) then
            Append(~filtPart, allPartitions[i]);
        end if;
    end for;
    // Return the filtered partitions and the number of such partitions
    return filtPart, #filtPart;
end function;

// CHECKING VALIDITY OF THE IMPLEMENTATION
// Define a function to check if the given partition is a valid partition of n
function isValidPartition(part, n)
    // Check if the sum of the parts is equal to n
    if &+part eq n then
        return true;
    else
        return false;
    end if;
end function;



"Some examples.";
"";
"";
"filteredPartitions(6,1): ",filteredPartitions(6,1);
"filteredPartitions(6,4): ",filteredPartitions(6,4);
"filteredPartitions(6,10): ",filteredPartitions(6,10);
"";
"filteredPartitions(10,1): ",filteredPartitions(10,1);
"filteredPartitions(10,4): ",filteredPartitions(10,4);
"filteredPartitions(10,10): ",filteredPartitions(10,10);


complessivo := 0;
max := 10;
for i in [1..max] do
    for i in [1..max] do
        t:=Cputime();
        n := Random(1, 10);
        t := Random(1, 5);
        // n," ",t;
        part, numPart := filteredPartitions(n, t);
        // part, numPart := filteredPartitionsUsingBuiltInFun(n, t);
        complessivo +:= Cputime(t);
        for i in [1..#part] do
            if not isValidPartition(part[i], Abs(n)) then
                "ERROR: The partition ", part[i], " is not a valid partition of ", n;
                break;
            end if;
        end for;
    end for;
end for;
"using custom function";
// "using built-in function";
"avg time for each partitioning := ", (complessivo/max)/max;

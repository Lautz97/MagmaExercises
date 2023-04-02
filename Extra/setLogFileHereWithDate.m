""; 
"";
"Implemented by Lauterio Davide @Lautz97"; 

prjDir := "/home/username/Projects/ProjectName/";

procedure setLogWithSeed()
    ChangeDirectory(prjDir);
    s :=  Getpid();
    s := IntegerToString(s) cat " - MagmaLog.txt";
    SetLogFile(s);

    System("date /t");

    "New log set";
    "";
    "Dir: " cat prjDir cat s;
    "";
    "program ID: " cat IntegerToString(Getpid());
    "";
    "Seed: " cat IntegerToString(GetSeed());
    "";
    "";
end procedure;


procedure unsetLogWithSeed()
    "Unsetting Log File Now";
    UnsetLogFile();
end procedure;

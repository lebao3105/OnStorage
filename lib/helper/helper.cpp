#include <filesystem>
#include <cstdio>
#include <fstream>
#include <cstring>

#ifndef _WIN32
    #include <unistd.h>
#endif

void sendOutThisMessage() {
    printf("Usage: RootHelper [action] [path]\n");
    printf("Made by Le Bao Nguyen (@lebao3105 on GitHub and GitLab)\n");
    printf("Written in C++ and Pascal (2 different versions). Write once, run almost everywhere!\n");
    printf("(This verison, in fact, mostly uses C things.)\n\n");

    printf("Available [action]s:\n");
    printf("del / d [path]                             : Deletes [path]\n");
    printf("list / l [path]                            : Shows the content [path]\n");
    printf("create / c [path]                          : Creates [path]\n");
    printf("createdir / md [path]                      : Creates [path] as a directory\n");
    printf("move / mv [path, list must not be odd]     : Moves files and folders\n");
    printf("copy / cp [path, list must not be odd]     : Copies files and folders to another location\n");
    #ifndef _WIN32
    printf("getuid / guid                              : Gets and shows the current UID\n");
    printf("getgid / gid                               : Gets and shows the current GID\n");
    #endif

    printf("\n");
    printf("[path] can in any number of absolute paths that the program and system can handle.\n");
    printf("\n");
}

void isMod2Equal0(int argc) {
    if (!(argc % 2 == 0))
        throw std::runtime_error("Not enough arguments!");
}

bool checkArg(char* arg, char* longarg, char* shortarg) {
    return (strcmp(longarg, arg) == 0 || strcmp(shortarg, arg) == 0);
}

void enoughArgs(int argc) {
    if (argc <= 2) {
        sendOutThisMessage();
        throw std::runtime_error("Not enough arguments!");
    }
}

int main(int argc, char* argv[]) {
    if (argc == 1) { sendOutThisMessage(); return 0; }
    
    /* Removes a file or folder (RECURSIVELY) - use std::filesystem::remove to avoid that */
    if (checkArg(argv[1], "del", "d")) {
        enoughArgs(argc);
        for (int i = 2; i < argc; ++i)
            std::filesystem::remove_all(argv[i]);
    }

    /* Lists the content of a directory */
    else if (checkArg(argv[1], "list", "l"))
    {
        enoughArgs(argc);
        for (int i = 2; i < argc; ++i)
            for (auto const& dir_entry: std::filesystem::directory_iterator{argv[i]})
                printf("%s\n", dir_entry.path().filename().c_str());
    }

    /* Creates a file */
    else if (checkArg(argv[1], "create", "c"))
    {
        enoughArgs(argc);
        for (int i = 2; i < argc; ++i) {
            std::ofstream file(argv[i]);
            file << "";
            file.close();
        }
    }

    /* Creates a folder */
    else if (checkArg(argv[1], "createdir", "md"))
    {
        enoughArgs(argc);
        for (int i = 2; i < argc; ++i)
            std::filesystem::create_directory(argv[i]);
    }

    /* Moves files or folders */
    else if (checkArg(argv[1], "move", "mv"))
    {
        enoughArgs(argc);
        isMod2Equal0(argc);
        for (int i = 2; i < argc; ++i) {
            std::filesystem::copy(argv[i], argv[i+1], std::filesystem::copy_options::recursive);
            std::filesystem::remove_all(argv[i]);
            i += 2;
        }
    }

    /* Copies files or folders 
        Same method as the move function, but without the remove_all line
        (sounds newbie moment, but works) */
    else if (checkArg(argv[1], "copy", "cp"))
    {
        enoughArgs(argc);
        isMod2Equal0(argc);
        for (int i = 2; i < argc; ++i) {
            std::filesystem::copy(argv[i], argv[i+1], std::filesystem::copy_options::recursive);
            i += 2;
        }
    }

    // these are not available under Windows.
    #ifndef _WIN32
    /* Gets UID */
    else if (checkArg(argv[1], "getuid", "guid"))
    {
        printf("UID: %d", getuid());
    }

    /* Gets PID */
    else if (checkArg(argv[1], "getgid", "gid"))
    {
        printf("GID: %d", getgid());
    }
    #endif

    else
    {
        sendOutThisMessage();
        throw std::runtime_error("Unknown command used. Quit now.");
    }

    return 0;
}
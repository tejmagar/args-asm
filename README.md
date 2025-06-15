# Args reading in assembly x86_64 linux

This is a recreational and fun attempt to read arguments in assembly x86_64 linux.

## Stack Layout
```
+-------------------------------+
rsp -> | argc                          |  ← number of arguments (int)
+-------------------------------+
| argv[0] (pointer to string)   |
+-------------------------------+
| argv[1] (pointer to string)   |
+-------------------------------+
| argv[2] (pointer to string)   |
+-------------------------------+
| ...                           |
+-------------------------------+
| argv[argc - 1]                |
+-------------------------------+
| NULL (end of argv)            |
+-------------------------------+
| envp[0] (pointer to string)   |
+-------------------------------+
| envp[1]                       |
+-------------------------------+
| ...                           |
+-------------------------------+
| NULL (end of envp)            |
+-------------------------------+
| Auxiliary vector...           |
| (system info for libc)        |
+-------------------------------+
| ...                           |
```

# Execution

Install nasm if not installed.

```bash
nasm -f elf64 args.asm -o args.o && ld args.o -o args
./args
```

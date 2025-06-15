        ; +-------------------------------+
        ; | argc                          |  ← number of arguments (int)
; rsp ->    +-------------------------------+
        ; | argv[0] (pointer to string)   |
        ; +-------------------------------+
        ; | argv[1] (pointer to string)   |
        ; +-------------------------------+
        ; | argv[2] (pointer to string)   |
        ; +-------------------------------+
        ; | ...                           |
        ; +-------------------------------+
        ; | argv[argc - 1]                |
        ; +-------------------------------+
        ; | NULL (end of argv)            |
        ; +-------------------------------+
        ; | envp[0] (pointer to string)   |
        ; +-------------------------------+
        ; | envp[1]                       |
        ; +-------------------------------+
        ; | ...                           |
        ; +-------------------------------+
        ; | NULL (end of envp)            |
        ; +-------------------------------+
        ; | Auxiliary vector...           |
        ; | (system info for libc)        |
        ; +-------------------------------+
        ; | ...                           |


section .data
    argc dq 0 ; Define 8 byte memory to store argc
    counter dq 0 ; Define 8 byte counter
    arg_value_len dq 0 ; Length of the current argument of loop block
    seperate db " "
    seperate_len equ $ - seperate


section .text
    global _start

_start:

.read_argc:
    ; Copy argc located by rsp stack pointer temporarily to rax
    mov rax, [rsp]
    mov [argc], rax

mov r8, rsp ; Copy stack pointer value to r8

.read_args:
    ; Load counter value from memory then loop
    mov rax, [counter] ; Load counter variable to register
    cmp rax, [argc] ; Compare counter and argc
    jge _exit ; Loop exit

    inc rax ; Increment counter value
    mov [counter], rax; Move incremented counter value back to the memory

    ; Read arg
    ; Double dereference ; rsp + (8 * narg) byte points => actual arg value pointer
    add r8, 8 ; Increment (narg + 8) in each iteration. Move temp stack pointer
    mov r9, [r8]; Dereference memory address where actual argument is located. Now it holds the memory address of the stack where narg starts.

    ; Argument value start address is pointed by r9 register.
    mov rax, 0 ; Use this as length counter
    mov r10, r9 ; Use this as a movable pointer which contains the address of value.

    ; Read cstring value argument
    call .search_null_value

    ; Print argument
    mov rax, 1 ; write syscall = 1
    mov rdi, 1 ; stdout file descriptor = 1
    mov rsi, r9 ; Memory address address
    mov rdx, [arg_value_len] ; Length of the string
    syscall

    mov rax, 1 ; write syscall = 1
    mov rdi, 1 ; stdout file descriptor = 1
    mov rsi, seperate ; Memory address
    mov rdx, seperate_len ; Length of the string
    syscall

    ; Continue loop
    jmp .read_args


; Search for null value
.search_null_value:
    inc rax ; Increment length in each loop
    cmp byte [r10], 0
    je .found

    inc r10 ; Increment lookup character address
    jmp .search_null_value ; Continue loop


.found:
    mov [arg_value_len], rax ; Copy rax value to the memory
    ret


_exit:
    mov rax, 60 ; exit syscall = 60
    mov rsi, 0 ; exit code = 0
    syscall

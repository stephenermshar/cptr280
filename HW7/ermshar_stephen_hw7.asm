# Stephen Ermshar
# CPTR 280
# HW 7
# 2017 NOV 6
# version history: https://github.com/sermshar/cptr280

# • Initialize;
.data
    prompt2:    .asciiz     "\nEnter a positive integer to test: "
    bye:        .asciiz     "End Program"
    ans_p:      .asciiz     " is prime."
    ans_np:     .asciiz     " is not prime, with a lowest prime devisor of "

.text
    main:

# • Prompt the user to enter an integer to test;
    ask_prime:
        la      $a0,    prompt2
        li      $v0,    4                   		# syscall_4: print string
        syscall

        li      $v0,    5                   		# syscall_5: read int
        syscall

        beq     $v0,    $0,     end         		# if 0, terminate
        nop

        add     $a1,    $0,     $v0  				# move $s0 to $a1

        jal     chk_prime
        nop

        j       ask_prime
        nop

# • Report whether or not the number is prime;
    chk_prime:
        # $t1 will be checked for 0 after each division to see divisibilty
        # $t0 will hold the number we're deviding $a0 by to see divisibilty
        # $t2 will hold the top limit of numbers to check divisibilty against (ie. n/2)
        # $t3 checks to see if the input is automaticaly prime (ie. less than 4) 
        #	then is used to check to see if we've reached $t2

        bltz    $a1,    ask_prime                   # make sure input isn't negative
        nop

        li      $t1,    4
        slt     $t1,    $a1,    $t1
        li      $t3,    1
        beq     $t1,    $t3,    is_prime

        # by 2
        li      $t0,    2
        div     $a1,    $t0                         # if mod returns 0 it isn't prime
        mfhi    $t1
        beq     $t1,    $0,     not_prime

        # largest number to check 3's divisbility by
        mflo    $t2

        # by 3's
        li      $t0,    3

    odd_chk:
        div     $a1,    $t0
        mfhi    $t1
        beq     $t1,    $0,     not_prime
        nop

        addi    $t0,    $t0,    2
        sub     $t3,    $t0,    $t2                 # becuase branch on greater than register isn't a thing...
        bgez    $t3,    is_prime                    # if you've looped enough times to make this line happy, you deserve your prime-y-ness

        j       odd_chk                             # do it again...
        nop

    is_prime:

		add		$a0,	$0,		$a1
        li      $v0,    1                           # syscall_1: print int
        syscall

        la      $a0,    ans_p
        li      $v0,    4                           # syscall_4: print string
        syscall

        jr      $ra                                 # now go home...
        nop

    not_prime:

		add 	$a0,	$0,		$a1
        li      $v0,    1                           # syscall_1: print int
        syscall

        la      $a0,    ans_np
        li      $v0,    4                           # syscall_4: print string
        syscall

        add     $a0,    $0,     $t0
        li      $v0,    1
        syscall

        jr      $ra                                 # get thee hence back to thy main!
        nop

# • Print a goodbye message;
# • Terminate.
    end:
        la      $a0,    bye
        li      $v0,    4                           # syscall_4: print string
        syscall

        li      $v0,    10
        syscall
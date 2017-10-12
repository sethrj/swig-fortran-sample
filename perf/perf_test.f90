program main

    use ISO_FORTRAN_ENV
    implicit none

    call test_perf()
contains

subroutine test_perf()
    use ISO_FORTRAN_ENV
    use, intrinsic :: ISO_C_BINDING
    use timerlib, only : Timer
    use formatrix
    implicit none
    integer :: i, j, k
    integer :: nx, ny, n, nnz, num_repeats

    type(Timer) :: t
    type(Matrix) :: A
    real(c_double), dimension(:), allocatable :: x, b

    integer(c_int), pointer :: rows(:), cols(:)
    real(c_double), pointer :: vals(:)

    call t%create()

    nx = 400
    ny = 400
    num_repeats = 300

    n = nx*ny

    call A%create(nx, ny)
    allocate(x(n))
    allocate(b(n))


    ! Fine grained
    call t%start()
    do k = 1, num_repeats
        do i = 1, n
            nnz = A%row_nnz(i-1)

            do j = 1, nnz
                b(i) = b(i) + A%get_value(i-1,j-1) * x(A%get_column(i-1,j-1)+1)
            end do
        end do
    end do
    call t%stop()
    write(0, '(A, F10.3)') "Loop (fine)  :", t%walltime()

    ! Medium grained
    call t%reset()
    call t%start()
    do k = 1, num_repeats
        do i = 1, n
            nnz = A%row_nnz(i-1)

            cols => A%get_columns(i-1)
            vals => A%get_values(i-1)

            do j = 1, nnz
                b(i) = b(i) + vals(j) * x(cols(j)+1)
            end do
        end do
    end do
    call t%stop()
    write(0, '(A, F10.3)') "Loop (medium):", t%walltime()

    ! Coarse grained
    call t%reset()
    call t%start()
    do k = 1, num_repeats
        rows => A%get_row_ptrs()
        cols => A%get_col_inds()
        vals => A%get_values()

        do i = 1, n
            do j = rows(i)+1, rows(i+1)+1
                b(i) = b(i) + vals(j) * x(cols(j)+1)
            end do
        end do
    end do
    call t%stop()
    write(0, '(A, F10.3)') "Loop (coarse):", t%walltime()

    call A%release()
end subroutine

end program

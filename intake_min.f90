! Minimal request intake validator (refusal-first, no heuristic JSON parsing)
!
! Supported scope:
! - source_context.content_id (string, required)
! - source_context.repository_id (string, may be empty)
! - declared_inputs == {}
! - declared_initial_state == {}
!
module intake_min
  use iso_fortran_env, only: error_unit
  implicit none
  private

  public :: read_entire_file
  public :: extract_string_field
  public :: require_empty_object_field

contains

  subroutine read_entire_file(path, text)
    character(len=*), intent(in) :: path
    character(len=:), allocatable, intent(out) :: text
    integer :: u, ios
    character(len=4096) :: line

    text = ""

    open(newunit=u, file=path, status="old", action="read", iostat=ios)
    if (ios /= 0) then
      write(error_unit,'(A)') "executor failure: cannot open " // trim(path)
      stop 1
    end if

    do
      read(u,'(A)', iostat=ios) line
      if (ios /= 0) exit
      text = text // trim(line)
    end do
    close(u)
  end subroutine read_entire_file

  ! Extract a JSON string field of the form:
  !   "key" : "value"
  !
  subroutine extract_string_field(src, key, value, found)
    character(len=*), intent(in)  :: src
    character(len=*), intent(in)  :: key
    character(len=*), intent(out) :: value
    logical, intent(out)          :: found

    integer :: kpos, cpos, q1, q2

    found = .false.
    value = ""

    ! Locate the key
    kpos = index(src, '"' // trim(key) // '"')
    if (kpos == 0) return

    ! Locate the colon AFTER the key
    cpos = index(src(kpos+len(key)+2:), ":")
    if (cpos == 0) return
    cpos = kpos + len(key) + 1 + cpos

    ! Locate opening quote of value
    q1 = index(src(cpos+1:), '"')
    if (q1 == 0) return
    q1 = cpos + q1

    ! Locate closing quote
    q2 = index(src(q1+1:), '"')
    if (q2 == 0) return
    q2 = q1 + q2

    value = src(q1+1 : q2-1)
    found = .true.
  end subroutine extract_string_field

  subroutine require_empty_object_field(src, field_name, ok)
    character(len=*), intent(in) :: src
    character(len=*), intent(in) :: field_name
    logical, intent(out)         :: ok

    integer :: p, cpos, brace1, brace2

    ok = .false.

    p = index(src, '"' // trim(field_name) // '"')
    if (p == 0) return

    cpos = index(src(p:), ":")
    if (cpos == 0) return
    cpos = p + cpos - 1

    brace1 = index(src(cpos:), "{")
    if (brace1 == 0) return
    brace1 = cpos + brace1 - 1

    brace2 = index(src(brace1:), "}")
    if (brace2 == 0) return

    ok = .true.
  end subroutine require_empty_object_field

end module intake_min
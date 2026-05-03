! Minimal request intake validator (refusal-first, no heuristic JSON parsing)
!
! Supported scope:
! - source_context.content_id (string, required)
! - source_context.repository_id (string, may be empty)
! - declared_initial_state == {} (must be empty object)
! - declared_inputs.ready_flag (boolean, required)
! - declared_inputs.rule_definition.name (string, required)
! - declared_inputs.rule_definition.expression (string, required)
!
module intake_min
  use iso_fortran_env, only: error_unit
  implicit none
  private

  public :: read_entire_file
  public :: extract_string_field
  public :: require_empty_object_field
  public :: extract_boolean_declared_input
  public :: extract_rule_definition

contains

  ! Robust whole-file reader using stream + file size (avoids allocatable concat pitfalls).
  subroutine read_entire_file(path, text)
    character(len=*), intent(in) :: path
    character(len=:), allocatable, intent(out) :: text
    integer :: u, ios
    integer :: nbytes

    text = ""

    open(newunit=u, file=trim(path), status="old", action="read", access="stream", form="unformatted", iostat=ios)
    if (ios /= 0) then
      write(error_unit,'(A)') "executor failure: cannot open " // trim(path)
      stop 1
    end if

    inquire(unit=u, size=nbytes)
    if (nbytes < 0) nbytes = 0

    allocate(character(len=nbytes) :: text)
    if (nbytes == 0) then
      close(u)
      return
    end if

    read(u, iostat=ios) text
    close(u)

    if (ios /= 0) then
      write(error_unit,'(A)') "executor failure: cannot read " // trim(path)
      stop 1
    end if
  end subroutine read_entire_file


  ! Extract a JSON string field of the form:
  !   "key" : "value"
  subroutine extract_string_field(src, key, value, found)
    character(len=*), intent(in)  :: src
    character(len=*), intent(in)  :: key
    character(len=*), intent(out) :: value
    logical, intent(out)          :: found

    integer :: kpos, cpos, q1, q2
    character(len=:), allocatable :: needle

    found = .false.
    value = ""

    needle = '"' // trim(key) // '"'
    kpos = index(src, needle)
    if (kpos == 0) return

    cpos = index(src(kpos+len(needle):), ":")
    if (cpos == 0) return
    cpos = kpos + len(needle) + cpos - 1  ! points at ':'

    q1 = index(src(cpos+1:), '"')
    if (q1 == 0) return
    q1 = cpos + q1

    q2 = index(src(q1+1:), '"')
    if (q2 == 0) return
    q2 = q1 + q2

    value = src(q1+1:q2-1)
    found = .true.
  end subroutine extract_string_field


  ! Require that a field is an EMPTY object: {} with only whitespace inside.
  subroutine require_empty_object_field(src, field_name, ok)
    character(len=*), intent(in) :: src
    character(len=*), intent(in) :: field_name
    logical, intent(out)         :: ok

    integer :: p, cpos, brace1, brace2, i
    character(len=1) :: ch
    character(len=:), allocatable :: needle

    ok = .false.

    needle = '"' // trim(field_name) // '"'
    p = index(src, needle)
    if (p == 0) return

    cpos = index(src(p+len(needle):), ":")
    if (cpos == 0) return
    cpos = p + len(needle) + cpos - 1

    brace1 = index(src(cpos:), "{")
    if (brace1 == 0) return
    brace1 = cpos + brace1 - 1

    call find_matching_brace(src, brace1, brace2, ok)
    if (.not. ok) return

    do i = brace1+1, brace2-1
      ch = src(i:i)
      if (ch /= ' ' .and. ch /= achar(9) .and. ch /= achar(10) .and. ch /= achar(13)) then
        ok = .false.
        return
      end if
    end do

    ok = .true.
  end subroutine require_empty_object_field


  ! Extract declared_inputs.<key> boolean, scoped strictly inside declared_inputs object.
  subroutine extract_boolean_declared_input(src, key, value, found)
    character(len=*), intent(in) :: src
    character(len=*), intent(in) :: key
    logical, intent(out)         :: value
    logical, intent(out)         :: found

    character(len=:), allocatable :: inputs_obj
    logical :: ok_inputs

    found = .false.
    value = .false.

    call slice_object_value(src, "declared_inputs", inputs_obj, ok_inputs)
    if (.not. ok_inputs) return

    call extract_boolean_field(inputs_obj, key, value, found)
  end subroutine extract_boolean_declared_input


  ! Extract declared_inputs.rule_definition.{name,expression}
  subroutine extract_rule_definition(src, name, expression, found)
    character(len=*), intent(in) :: src
    character(len=*), intent(out) :: name
    character(len=*), intent(out) :: expression
    logical, intent(out) :: found

    character(len=:), allocatable :: inputs_obj
    character(len=:), allocatable :: rule_obj
    logical :: ok_inputs, ok_rule
    logical :: f1, f2

    name = ""
    expression = ""
    found = .false.

    call slice_object_value(src, "declared_inputs", inputs_obj, ok_inputs)
    if (.not. ok_inputs) return

    call slice_object_value(inputs_obj, "rule_definition", rule_obj, ok_rule)
    if (.not. ok_rule) return

    call extract_string_field(rule_obj, "name", name, f1)
    call extract_string_field(rule_obj, "expression", expression, f2)

    found = (f1 .and. f2)
  end subroutine extract_rule_definition


  ! ----------------------------
  ! Internal helpers (private)
  ! ----------------------------

  subroutine extract_boolean_field(obj_src, key, value, found)
    character(len=*), intent(in) :: obj_src
    character(len=*), intent(in) :: key
    logical, intent(out)         :: value
    logical, intent(out)         :: found

    integer :: kpos, cpos_rel, cpos, i, n, j
    character(len=1) :: ch
    character(len=5) :: tok
    character(len=:), allocatable :: needle

    found = .false.
    value = .false.

    needle = '"' // trim(key) // '"'
    kpos = index(obj_src, needle)
    if (kpos == 0) return

    cpos_rel = index(obj_src(kpos+len(needle):), ":")
    if (cpos_rel == 0) return
    cpos = kpos + len(needle) + cpos_rel - 1  ! points at ':'

    n = len(obj_src)
    i = cpos + 1

    ! Skip whitespace
    do while (i <= n)
      ch = obj_src(i:i)
      if (ch /= ' ' .and. ch /= achar(9) .and. ch /= achar(10) .and. ch /= achar(13)) exit
      i = i + 1
    end do
    if (i > n) return

    ! Read alphabetic token true/false
    tok = "     "
    j = 1
    do while (i <= n .and. j <= 5)
      ch = obj_src(i:i)
      if (.not. ((ch >= 'a' .and. ch <= 'z') .or. (ch >= 'A' .and. ch <= 'Z'))) exit
      tok(j:j) = ch
      j = j + 1
      i = i + 1
    end do

    if (tok(1:4) == "true") then
      value = .true.
      found = .true.
      return
    end if

    if (tok(1:5) == "false") then
      value = .false.
      found = .true.
      return
    end if
  end subroutine extract_boolean_field


  ! Slice object value by name: "field_name": { ...matching braces... }
  subroutine slice_object_value(src, field_name, obj_out, ok)
    character(len=*), intent(in) :: src
    character(len=*), intent(in) :: field_name
    character(len=:), allocatable, intent(out) :: obj_out
    logical, intent(out) :: ok

    integer :: p, cpos, brace1, brace2
    character(len=:), allocatable :: needle

    ok = .false.
    obj_out = ""

    needle = '"' // trim(field_name) // '"'
    p = index(src, needle)
    if (p == 0) return

    cpos = index(src(p+len(needle):), ":")
    if (cpos == 0) return
    cpos = p + len(needle) + cpos - 1

    brace1 = index(src(cpos:), "{")
    if (brace1 == 0) return
    brace1 = cpos + brace1 - 1

    call find_matching_brace(src, brace1, brace2, ok)
    if (.not. ok) return

    obj_out = src(brace1:brace2)
    ok = .true.
  end subroutine slice_object_value


  ! Find matching '}' for '{' at position open_pos using brace depth.
  subroutine find_matching_brace(src, open_pos, close_pos, ok)
    character(len=*), intent(in) :: src
    integer, intent(in) :: open_pos
    integer, intent(out) :: close_pos
    logical, intent(out) :: ok

    integer :: i, n, depth
    character(len=1) :: ch

    ok = .false.
    close_pos = 0

    n = len(src)
    if (open_pos < 1 .or. open_pos > n) return
    if (src(open_pos:open_pos) /= "{") return

    depth = 0
    do i = open_pos, n
      ch = src(i:i)
      if (ch == "{") depth = depth + 1
      if (ch == "}") then
        depth = depth - 1
        if (depth == 0) then
          close_pos = i
          ok = .true.
          return
        end if
      end if
    end do
  end subroutine find_matching_brace

end module intake_min
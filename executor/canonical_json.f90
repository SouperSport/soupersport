! Deterministic JSON canonicalization utilities (minimal, purpose-built)
!
! Goals:
! - Stable ordering of object keys (no reliance on source formatting)      [appendix-canonicalization-notes.md]
! - Canonical bytes for hashing inputs/traces/provenance payloads          [provenance-payload.md]
! - No locale/platform dependent formatting (no pretty-print, no floats)   [appendix-canonicalization-notes.md]
!
! This module is intentionally NOT a general JSON library.
! It provides:
!   - JSON string escaping
!   - deterministic object/array emission
!   - canonical emission for:
!       * trace identity (schema name + version)                           [trace-schema.md]
!       * provenance payload (shape from types.f90)                        [provenance-payload.md]
!
module canonical_json
  use souper_types
  implicit none
  private

  public :: json_escape
  public :: json_string
  public :: json_object_fixed
  public :: json_array
  public :: canonical_trace_identity_json
  public :: canonical_provenance_payload_json

contains

  ! ----------------------------
  ! Basic JSON helpers
  ! ----------------------------

  function json_escape(s) result(out)
    character(len=*), intent(in) :: s
    character(len=:), allocatable :: out
    integer :: i, c
    character(len=2) :: hx

    out = ""
    do i = 1, len(s)
      c = iachar(s(i:i))
      select case (s(i:i))
      case ('"')
        out = out // '\\"'
      case ('\')
        out = out // '\\\\'
      case (achar(8))
        out = out // '\\b'
      case (achar(9))
        out = out // '\\t'
      case (achar(10))
        out = out // '\\n'
      case (achar(12))
        out = out // '\\f'
      case (achar(13))
        out = out // '\\r'
      case default
        if (c < 32) then
          hx = to_hex2(c)
          out = out // '\\u00' // hx
        else
          out = out // s(i:i)
        end if
      end select
    end do
  end function json_escape

  function to_hex2(v) result(h)
    integer, intent(in) :: v
    character(len=2) :: h
    integer :: hi, lo
    hi = iand(ishft(v, -4), 15)
    lo = iand(v, 15)
    h(1:1) = hex_digit(hi)
    h(2:2) = hex_digit(lo)
  end function to_hex2

  function hex_digit(n) result(ch)
    integer, intent(in) :: n
    character(len=1) :: ch
    select case (n)
    case (0:9)
      ch = achar(iachar('0') + n)
    case (10:15)
      ch = achar(iachar('a') + (n - 10))
    case default
      ch = '0'
    end select
  end function hex_digit

  function json_string(s) result(out)
    character(len=*), intent(in) :: s
    character(len=:), allocatable :: out
    out = '"' // json_escape(s) // '"'
  end function json_string

  function json_array(elems) result(out)
    character(len=*), dimension(:), intent(in) :: elems
    character(len=:), allocatable :: out
    integer :: i

    out = "["
    do i = 1, size(elems)
      if (i > 1) out = out // ","
      out = out // trim(elems(i))
    end do
    out = out // "]"
  end function json_array

  ! Emit an object with a FIXED key order.
  ! Caller provides keys and already-encoded JSON values.
  function json_object_fixed(keys, values) result(out)
    character(len=*), dimension(:), intent(in) :: keys
    character(len=*), dimension(:), intent(in) :: values
    character(len=:), allocatable :: out
    integer :: i

    if (size(keys) /= size(values)) then
      out = "{}"
      return
    end if

    out = "{"
    do i = 1, size(keys)
      if (i > 1) out = out // ","
      out = out // json_string(trim(keys(i))) // ":" // trim(values(i))
    end do
    out = out // "}"
  end function json_object_fixed

  ! ----------------------------
  ! Canonical emitters for SouperSport artifacts
  ! ----------------------------

  ! Canonical JSON for trace identity.
  ! Key order is fixed: schema_name, schema_version
  function canonical_trace_identity_json(t) result(out)
    type(trace_t), intent(in) :: t
    character(len=:), allocatable :: out

    character(len=16)  :: keys(2)
    character(len=512) :: vals(2)

    keys(1) = "schema_name"
    keys(2) = "schema_version"

    vals(1) = json_string(trim(t%schema_name))
    vals(2) = json_string(trim(t%schema_version))

    out = json_object_fixed(keys, vals)
  end function canonical_trace_identity_json

  ! Canonical JSON for provenance payload (shape from provenance-payload.md).
  !
  ! Key order is fixed and stable:
  !   name, version, semantic_law_name, input_hash, initial_state_hash,
  !   results, trace_schema, tool, source_context
  function canonical_provenance_payload_json(p) result(out)
    type(provenance_payload_t), intent(in) :: p
    character(len=:), allocatable :: out

    character(len=32)   :: keys(9)
    character(len=1024) :: vals(9)

    keys(1) = "name"
    keys(2) = "version"
    keys(3) = "semantic_law_name"
    keys(4) = "input_hash"
    keys(5) = "initial_state_hash"
    keys(6) = "results"
    keys(7) = "trace_schema"
    keys(8) = "tool"
    keys(9) = "source_context"

    vals(1) = json_string(trim(p%name))
    vals(2) = json_string(trim(p%version))
    vals(3) = json_string(trim(p%semantic_law_name))
    vals(4) = json_string(trim(p%input_hash))
    vals(5) = json_string(trim(p%initial_state_hash))

    vals(6) = canonical_results_json(p%results)
    vals(7) = canonical_trace_schema_json(p%trace_schema_name, p%trace_schema_version)
    vals(8) = canonical_tool_json(p%tool)
    vals(9) = canonical_source_context_json(p%source_context)

    out = json_object_fixed(keys, vals)
  end function canonical_provenance_payload_json

  function canonical_results_json(r) result(out)
    type(execution_results_t), intent(in) :: r
    character(len=:), allocatable :: out

    character(len=16)  :: keys(2)
    character(len=512) :: vals(2)

    keys(1) = "output_hash"
    keys(2) = "trace_hash"

    vals(1) = json_string(trim(r%output_hash))
    vals(2) = json_string(trim(r%trace_hash))

    out = json_object_fixed(keys, vals)
  end function canonical_results_json

  function canonical_trace_schema_json(name, version) result(out)
    character(len=*), intent(in) :: name, version
    character(len=:), allocatable :: out

    character(len=16)  :: keys(2)
    character(len=512) :: vals(2)

    keys(1) = "name"
    keys(2) = "version"

    vals(1) = json_string(trim(name))
    vals(2) = json_string(trim(version))

    out = json_object_fixed(keys, vals)
  end function canonical_trace_schema_json

  function canonical_tool_json(t) result(out)
    type(tool_identity_t), intent(in) :: t
    character(len=:), allocatable :: out

    character(len=16)  :: keys(2)
    character(len=512) :: vals(2)

    keys(1) = "name"
    keys(2) = "version"

    vals(1) = json_string(trim(t%name))
    vals(2) = json_string(trim(t%version))

    out = json_object_fixed(keys, vals)
  end function canonical_tool_json

  function canonical_source_context_json(s) result(out)
    type(source_context_t), intent(in) :: s
    character(len=:), allocatable :: out

    character(len=16)  :: keys(2)
    character(len=512) :: vals(2)

    keys(1) = "content_id"
    keys(2) = "repository_id"

    vals(1) = json_string(trim(s%content_id))
    vals(2) = json_string(trim(s%repository_id))

    out = json_object_fixed(keys, vals)
  end function canonical_source_context_json

end module canonical_json
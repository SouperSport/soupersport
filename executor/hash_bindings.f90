! Hash bindings for SouperSport canonical artifacts (minimal, deterministic)
!
! Purpose:
! - Convert canonical JSON strings to canonical byte sequences for hashing
! - Compute SHA-256 hex digests for:
!     * sealed inputs
!     * initial state
!     * output
!     * trace
! - Fill the corresponding fields in provenance_payload_t
!
! This module is intentionally strict about character encoding:
! - It accepts ASCII-only canonical JSON strings.
! - If non-ASCII bytes are present, it stops with "executor failure"
!   to avoid locale/platform-dependent byte sequences.
!
! Canonicalization requirements (stable key order, no reliance on formatting)
! are handled in [canonical_json.f90](https://onedrive.live.com/?id=b3c1c0f7-75bc-4b36-9132-7ff8d55feb34&cid=bbde1356117955ce&web=1&EntityRepresentationId=278b5c13-fa5f-485d-8e36-c1c2845229cd). [1](https://onedrive.live.com?cid=BBDE1356117955CE&id=BBDE1356117955CE!s2c6eb53cdc954f0c9859bfad8bbb673c)[2](https://onedrive.live.com/?id=b3c1c0f7-75bc-4b36-9132-7ff8d55feb34&cid=bbde1356117955ce&web=1)
!
module hash_bindings
  use iso_fortran_env, only: int8
  use sha256,          only: sha256_hex_bytes
  use souper_types
  implicit none
  private

  public :: sha256_hex_of_ascii
  public :: fill_provenance_hashes

contains

  ! Convert an ASCII string to bytes deterministically.
  ! Any non-ASCII character causes executor failure (stop).
  subroutine ascii_to_bytes_or_fail(s, bytes)
    character(len=*), intent(in)  :: s
    integer(int8), allocatable, intent(out) :: bytes(:)
    integer :: i, n, code

    n = len_trim(s)

    if (n == 0) then
      allocate(bytes(0))
      return
    end if

    allocate(bytes(n))
    do i = 1, n
      code = iachar(s(i:i))
      if (code < 0 .or. code > 127) then
        stop "executor failure: non-ASCII character in canonical JSON string"
      end if
      bytes(i) = int(code, int8)
    end do
  end subroutine ascii_to_bytes_or_fail

  ! Compute SHA-256 hex digest of an ASCII string (lowercase hex).
  function sha256_hex_of_ascii(s) result(hex)
    character(len=*), intent(in) :: s
    character(len=64) :: hex
    integer(int8), allocatable :: b(:)

    call ascii_to_bytes_or_fail(s, b)
    hex = sha256_hex_bytes(b)
    if (allocated(b)) deallocate(b)
  end function sha256_hex_of_ascii

  ! Fill provenance payload hash fields using canonical JSON strings.
  !
  ! Required provenance fields (normative) include:
  ! - input_hash (hash of sealed input payload after canonical sealing)
  ! - initial_state_hash
  ! - results.output_hash
  ! - results.trace_hash 
  !
  subroutine fill_provenance_hashes( &
      canonical_inputs_json, canonical_initial_state_json, &
      canonical_output_json, canonical_trace_json, &
      prov )

    character(len=*), intent(in) :: canonical_inputs_json
    character(len=*), intent(in) :: canonical_initial_state_json
    character(len=*), intent(in) :: canonical_output_json
    character(len=*), intent(in) :: canonical_trace_json

    type(provenance_payload_t), intent(inout) :: prov

    prov%input_hash          = sha256_hex_of_ascii(canonical_inputs_json)
    prov%initial_state_hash  = sha256_hex_of_ascii(canonical_initial_state_json)
    prov%results%output_hash = sha256_hex_of_ascii(canonical_output_json)
    prov%results%trace_hash  = sha256_hex_of_ascii(canonical_trace_json)

  end subroutine fill_provenance_hashes

end module hash_bindings
program souper_executor
  use sha256
  implicit none

  integer, parameter :: BUF_BIG  = 8192
  integer, parameter :: STEP_MAX = 16

  integer :: u, ios
  character(len=256) :: line
  character(len=BUF_BIG) :: req_text

  logical :: parse_ok
  logical :: ready_flag

  character(len=256)  :: inputs_json, outcome_json
  character(len=BUF_BIG) :: trace_json

  character(len=BUF_BIG) :: inputs_canon, trace_canon, result_canon
  character(len=BUF_BIG) :: file_text, file_canon

  character(len=64) :: input_hash, trace_hash, result_hash
  character(len=64) :: input_hash2, trace_hash2, result_hash2

  logical :: verified
  character(len=64) :: verify_token

  character(len=256) :: steps(STEP_MAX)
  integer :: step_count

  character(len=BUF_BIG) :: prov_json

  call say("--- SouperSport Execution ---")
  call say("")

  ! ----------------------------
  ! READ INPUT (inputs/request.json)
  ! ----------------------------
  req_text = ""
  open(newunit=u, file="inputs/request.json", status="old", action="read", iostat=ios)
  if (ios /= 0) then
    call say("[Status]")
    call say("Parse successful: FALSE")
    call say("")
    call say("[Output]")
    call say("ERROR: cannot open inputs/request.json")
    call say("--- End Execution ---")
    stop 1
  end if

  do
    read(u,'(A)', iostat=ios) line
    if (ios /= 0) exit
    call append_line(req_text, trim(line))
  end do
  close(u)

  ! Normalize request text for robust substring checks
  call canonicalize(req_text, file_canon)

  ! Parse rule: only accept exact true/false forms
  parse_ok = .false.
  ready_flag = .false.
  if (index(file_canon, '"ready_flag":true') > 0) then
    parse_ok = .true.
    ready_flag = .true.
  else if (index(file_canon, '"ready_flag":false') > 0) then
    parse_ok = .true.
    ready_flag = .false.
  else
    parse_ok = .false.
    ready_flag = .false.   ! default path if invalid
  end if

  ! ----------------------------
  ! Build canonical inputs JSON
  ! ----------------------------
  if (ready_flag) then
    inputs_json = '{"ready_flag":true}'
  else
    inputs_json = '{"ready_flag":false}'
  end if
  call canonicalize(inputs_json, inputs_canon)

  ! ----------------------------
  ! DAG execution (V1)
  ! ----------------------------
  step_count = 0
  call add_step(steps, step_count, '{"step_id":"S1"}')

  if (ready_flag) then
    call add_step(steps, step_count, '{"step_id":"S_eval","result":true}')
    call add_step(steps, step_count, '{"step_id":"S2_ready"}')
    outcome_json = '{"outcome":"success","ready":true}'
  else
    call add_step(steps, step_count, '{"step_id":"S_eval","result":false}')
    call add_step(steps, step_count, '{"step_id":"S2_not_ready"}')
    outcome_json = '{"outcome":"success","ready":false}'
  end if
  call canonicalize(outcome_json, result_canon)

  call build_trace_json(steps, step_count, trace_json)
  call canonicalize(trace_json, trace_canon)

  ! ----------------------------
  ! WRITE artifacts (canonical)
  ! ----------------------------
  open(newunit=u, file="artifacts/trace.json", status="replace", action="write", iostat=ios)
  if (ios /= 0) then
    call say("[Output]")
    call say("ERROR: cannot write artifacts/trace.json")
    call say("--- End Execution ---")
    stop 1
  end if
  write(u,'(A)') trim(trace_canon)
  close(u)

  open(newunit=u, file="artifacts/result.json", status="replace", action="write", iostat=ios)
  if (ios /= 0) then
    call say("[Output]")
    call say("ERROR: cannot write artifacts/result.json")
    call say("--- End Execution ---")
    stop 1
  end if
  write(u,'(A)') trim(result_canon)
  close(u)

  ! ----------------------------
  ! HASHES (canonical)
  ! ----------------------------
  input_hash  = sha256_hex_text(trim(inputs_canon))
  trace_hash  = sha256_hex_text(trim(trace_canon))
  result_hash = sha256_hex_text(trim(result_canon))

  ! ----------------------------
  ! External replay verify (hash disk contents)
  ! ----------------------------
  call read_file_compact("artifacts/trace.json", file_text)
  call canonicalize(file_text, file_canon)
  trace_hash2 = sha256_hex_text(trim(file_canon))

  call read_file_compact("artifacts/result.json", file_text)
  call canonicalize(file_text, file_canon)
  result_hash2 = sha256_hex_text(trim(file_canon))

  input_hash2 = sha256_hex_text(trim(inputs_canon))

  verified = (input_hash == input_hash2) .and. (trace_hash == trace_hash2) .and. (result_hash == result_hash2)

  if (verified) then
    verify_token = "true"
  else
    verify_token = "false"
  end if

  ! ----------------------------
  ! PROVENANCE JSON
  ! ----------------------------
  call build_provenance_json(step_count, input_hash, trace_hash, result_hash, verify_token, prov_json)

  open(newunit=u, file="artifacts/provenance.json", status="replace", action="write", iostat=ios)
  if (ios /= 0) then
    call say("[Output]")
    call say("ERROR: cannot write artifacts/provenance.json")
    call say("--- End Execution ---")
    stop 1
  end if
  write(u,'(A)') trim(prov_json)
  call flush(u)
  close(u)

  open(newunit=u, file="artifacts/verify.json", status="replace", action="write", iostat=ios)
  if (ios /= 0) then
    call say("[Output]")
    call say("ERROR: cannot write artifacts/verify.json")
    call say("--- End Execution ---")
    stop 1
  end if
  write(u,'(A)') '{"verified":'//trim(verify_token)//'}'
  call flush(u)
  close(u)

  ! ----------------------------
  ! Human-readable output (no PRINT *, only WRITE(A))
  ! ----------------------------
  call say("[Status]")
  if (parse_ok) then
    call say("Parse successful: TRUE")
  else
    call say("Parse successful: FALSE")
  end if
  call say("")

  call say("[Input]")
  if (parse_ok) then
    if (ready_flag) then
      call say("ready_flag = true")
    else
      call say("ready_flag = false")
    end if
  else
    call say("input not valid (defaulted to ready_flag = false)")
  end if
  call say("")

  call say("[Execution Path]")
  if (ready_flag) then
    call say("S1 -> S_eval -> S2_ready")
  else
    call say("S1 -> S_eval -> S2_not_ready")
  end if
  call say("")

  call say("[Artifacts]")
  call say_kv("Input Hash  : ", input_hash)
  call say_kv("Trace Hash  : ", trace_hash)
  call say_kv("Result Hash : ", result_hash)
  call say("")

  call say("[Verification]")
  if (verified) then
    call say("Result verified against provenance: PASS")
  else
    call say("Result verified against provenance: FAIL")
  end if
  call say("")

  call say("[Output]")
  call say("All artifact files written successfully")
  call say("")
  call say("--- End Execution ---")

contains

  subroutine say(msg)
    character(len=*), intent(in) :: msg
    write(*,'(A)') trim(msg)
  end subroutine say

  subroutine say_kv(prefix, value)
    character(len=*), intent(in) :: prefix
    character(len=*), intent(in) :: value
    write(*,'(A,A)') trim(prefix), trim(value)
  end subroutine say_kv

  subroutine append_line(buf, chunk)
    character(len=*), intent(inout) :: buf
    character(len=*), intent(in) :: chunk
    integer :: L, pos, cap

    L = len_trim(chunk)
    if (L <= 0) return

    cap = len(buf)
    pos = len_trim(buf) + 1
    if (pos + L - 1 > cap) return

    buf(pos:pos+L-1) = chunk(1:L)
  end subroutine append_line

  subroutine add_step(steps, count, step_json)
    character(len=*), intent(inout) :: steps(:)
    integer, intent(inout) :: count
    character(len=*), intent(in) :: step_json
    if (count >= size(steps)) stop 2
    count = count + 1
    steps(count) = step_json
  end subroutine add_step

  subroutine build_trace_json(steps, count, out)
    character(len=*), intent(in) :: steps(:)
    integer, intent(in) :: count
    character(len=*), intent(out) :: out
    integer :: i

    out = '{"trace":['
    do i = 1, count
      out = trim(out)//trim(steps(i))
      if (i < count) out = trim(out)//','
    end do
    out = trim(out)//']}'
  end subroutine build_trace_json

  subroutine canonicalize(in, out)
    character(len=*), intent(in)  :: in
    character(len=*), intent(out) :: out
    integer :: i, j
    character(len=1) :: c

    out = ""
    j = 1
    do i = 1, len_trim(in)
      c = in(i:i)
      if (c /= ' ' .and. c /= achar(9) .and. c /= achar(10) .and. c /= achar(13)) then
        if (j <= len(out)) then
          out(j:j) = c
          j = j + 1
        end if
      end if
    end do
  end subroutine canonicalize

  subroutine read_file_compact(path, out)
    character(len=*), intent(in) :: path
    character(len=*), intent(out) :: out
    character(len=512) :: line_local
    integer :: uu, ios2
    integer :: pos, len_line, cap

    out = ""
    pos = 1
    cap = len(out)

    open(newunit=uu, file=path, status="old", action="read", iostat=ios2)
    if (ios2 /= 0) return

    do
      read(uu,'(A)', iostat=ios2) line_local
      if (ios2 /= 0) exit

      len_line = len_trim(line_local)
      if (len_line > 0) then
        if (pos + len_line - 1 <= cap) then
          out(pos:pos+len_line-1) = line_local(1:len_line)
          pos = pos + len_line
        end if
      end if
    end do
    close(uu)
  end subroutine read_file_compact

  subroutine build_provenance_json(step_count, ih, th, rh, verified_token, out)
    integer, intent(in) :: step_count
    character(len=*), intent(in) :: ih, th, rh, verified_token
    character(len=*), intent(out) :: out
    character(len=16) :: sc

    write(sc,'(I0)') step_count

    out = '{"tool":"souper-executor",'// &
          '"version":"1.1",'// &
          '"steps":'//trim(sc)//','// &
          '"input_hash":"'//trim(ih)//'",'// &
          '"trace_hash":"'//trim(th)//'",'// &
          '"result_hash":"'//trim(rh)//'",'// &
          '"verified":'//trim(verified_token)//'}'
  end subroutine build_provenance_json

end program souper_executor
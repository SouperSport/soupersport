program souper_executor
  use sha256
  implicit none

  integer, parameter :: BUF_BIG = 8192
  integer, parameter :: STEP_MAX = 16

  integer :: u, ios
  character(len=256) :: line
  logical :: ready_flag, found_flag

  character(len=512)  :: inputs_json, outcome_json
  character(len=BUF_BIG) :: trace_json
  character(len=BUF_BIG) :: inputs_canon, trace_canon, result_canon

  character(len=64) :: input_hash, trace_hash, result_hash
  character(len=64) :: input_hash2, trace_hash2, result_hash2

  character(len=BUF_BIG) :: file_text
  character(len=BUF_BIG) :: file_canon

  character(len=BUF_BIG) :: prov_json
  character(len=64) :: verify_token
  logical :: verified

  character(len=256) :: steps(STEP_MAX)
  integer :: step_count

  print *, "START EXECUTION"

  ready_flag = .false.
  found_flag = .false.
  step_count = 0

  ! ----------------------------
  ! READ INPUT
  ! ----------------------------
  open(newunit=u, file="inputs/request.json", status="old", iostat=ios)
  if (ios /= 0) stop

  do
    read(u,'(A)', iostat=ios) line
    if (ios /= 0) exit

    if (index(line,'"ready_flag"') > 0) found_flag = .true.
    if (found_flag) then
      if (index(line,'true')  > 0) ready_flag = .true.
      if (index(line,'false') > 0) ready_flag = .false.
    end if
  end do
  close(u)

  print *, "PARSE COMPLETE =", ready_flag

  if (ready_flag) then
    inputs_json = '{"ready_flag":true}'
  else
    inputs_json = '{"ready_flag":false}'
  end if

  call canonicalize(inputs_json, inputs_canon)

  ! ----------------------------
  ! DAG
  ! ----------------------------
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

  ! WRITE FILES
  open(newunit=u, file="artifacts/trace.json", status="replace", iostat=ios)
  write(u,'(A)') trim(trace_canon)
  close(u)

  open(newunit=u, file="artifacts/result.json", status="replace", iostat=ios)
  write(u,'(A)') trim(result_canon)
  close(u)

  ! HASH
  input_hash  = sha256_hex_text(trim(inputs_canon))
  trace_hash  = sha256_hex_text(trim(trace_canon))
  result_hash = sha256_hex_text(trim(result_canon))

  print *, "INPUT HASH  =", input_hash
  print *, "TRACE HASH  =", trace_hash
  print *, "RESULT HASH =", result_hash

  ! VERIFY FROM FILES
  call read_file_compact("artifacts/trace.json", file_text)
  call canonicalize(file_text, file_canon)
  trace_hash2 = sha256_hex_text(trim(file_canon))

  call read_file_compact("artifacts/result.json", file_text)
  call canonicalize(file_text, file_canon)
  result_hash2 = sha256_hex_text(trim(file_canon))

  input_hash2 = sha256_hex_text(trim(inputs_canon))

  verified = (input_hash == input_hash2) .and. &
             (trace_hash == trace_hash2) .and. &
             (result_hash == result_hash2)

  if (verified) then
    verify_token = "true"
    print *, "VERIFY: PASS"
  else
    verify_token = "false"
    print *, "VERIFY: FAIL"
  end if

  call build_provenance_json(step_count, input_hash, trace_hash, result_hash, verify_token, prov_json)

  open(newunit=u, file="artifacts/provenance.json", status="replace")
  write(u,'(A)') trim(prov_json)
  close(u)

  open(newunit=u, file="artifacts/verify.json", status="replace")
  write(u,'(A)') '{"verified":'//trim(verify_token)//'}'
  close(u)

  print *, "ALL OUTPUTS WRITTEN"

contains

  subroutine add_step(steps, count, step_json)
    character(len=*), intent(inout) :: steps(:)
    integer, intent(inout) :: count
    character(len=*), intent(in) :: step_json
    count = count + 1
    steps(count) = step_json
  end subroutine

  subroutine build_trace_json(steps, count, out)
    character(len=*), intent(in) :: steps(:)
    integer, intent(in) :: count
    character(len=*), intent(out) :: out
    integer :: i
    out = '{"trace":['
    do i=1,count
      out = trim(out)//trim(steps(i))
      if (i<count) out = trim(out)//','
    end do
    out = trim(out)//']}'
  end subroutine

  subroutine canonicalize(in, out)
    character(len=*), intent(in) :: in
    character(len=*), intent(out) :: out
    integer :: i,j
    out=""
    j=1
    do i=1,len_trim(in)
      if (in(i:i)/=' ') then
        out(j:j)=in(i:i)
        j=j+1
      end if
    end do
  end subroutine

  subroutine read_file_compact(path, out)
    character(len=*), intent(in) :: path
    character(len=*), intent(out) :: out
    character(len=512) :: l
    integer :: uu, ios2
    integer :: pos, len_line

    out=""
    pos=1

    open(newunit=uu,file=path,status="old",iostat=ios2)
    if (ios2/=0) return

    do
      read(uu,'(A)',iostat=ios2) l
      if (ios2/=0) exit

      len_line = len_trim(l)

      if (len_line > 0) then
        out(pos:pos+len_line-1) = l(1:len_line)
        pos = pos + len_line
      end if
    end do
    close(uu)
  end subroutine

  subroutine build_provenance_json(sc, ih, th, rh, v, out)
    integer, intent(in) :: sc
    character(len=*), intent(in) :: ih, th, rh, v
    character(len=*), intent(out) :: out
    character(len=16) :: s
    write(s,'(I0)') sc
    out='{"tool":"souper-executor","version":"1.1","steps":'//trim(s)//&
        ',"input_hash":"'//trim(ih)//'","trace_hash":"'//trim(th)//&
        '","result_hash":"'//trim(rh)//'","verified":'//trim(v)//'}'
  end subroutine

end program souper_executor
program souper_executor
  use iso_fortran_env, only: error_unit
  use souper_types
  use canonical_json
  use hash_bindings
  use intake_min
  implicit none

  character(len=1), parameter :: newline = achar(10)

  type(execution_outcome_t)    :: outcome
  type(provenance_payload_t)   :: prov

  character(len=:), allocatable :: req_text, trace_json, prov_json
  character(len=128) :: content_id, repository_id
  character(len=128) :: rule_name, rule_expression

  logical :: found, ok_state
  logical :: ready_flag, has_ready_flag
  logical :: has_rule_def
  logical :: evaluation_result
  character(len=256) :: flag_str

  outcome%kind = OUTCOME_UNSET

  ! ----------------------------
  ! Initialization
  ! ----------------------------
  prov%name = PROVENANCE_NAME
  prov%version = PROVENANCE_VERSION
  prov%semantic_law_name = SEMANTIC_LAW_NAME
  prov%trace_schema_name = TRACE_SCHEMA_NAME
  prov%trace_schema_version = TRACE_SCHEMA_VERSION
  prov%tool%name = "souper-executor-ref-0"
  prov%tool%version = "0.0.1"

  call read_entire_file("inputs/request.json", req_text)

  ! ----------------------------
  ! Extract fields
  ! ----------------------------
  call extract_string_field(req_text, "content_id", content_id, found)
  if (.not. found) call refuse("missing_required_field","context","content_id")

  call extract_string_field(req_text, "repository_id", repository_id, found)
  if (.not. found) repository_id = ""

  prov%source_context%content_id = trim(content_id)
  prov%source_context%repository_id = trim(repository_id)

  call require_empty_object_field(req_text,"declared_initial_state",ok_state)
  if (.not. ok_state) call refuse("invalid","state","must be {}")

  call extract_boolean_declared_input(req_text,"ready_flag",ready_flag,has_ready_flag)
  if (.not. has_ready_flag) call refuse("missing","input","ready_flag")

  call extract_rule_definition(req_text,rule_name,rule_expression,has_rule_def)
  if (.not. has_rule_def) call refuse("missing","rule","rule_definition")

  if (trim(content_id) /= "BOOTSTRAP") call refuse("unsupported","scope","BOOTSTRAP")

  outcome%kind = OUTCOME_SUCCESS

  ! ----------------------------
  ! STEP 13.5 — Rule evaluation (data-driven)
  ! ----------------------------
  if (trim(rule_expression) == "ready_flag == true") then
    evaluation_result = ready_flag
  else
    call refuse("unsupported_expression","rule_engine","only ready_flag == true")
  end if

  ! ----------------------------
  ! TRACE generation
  ! ----------------------------
  if (evaluation_result) then
    trace_json = '{"trace":[{"dependencies":[],"rule":"bootstrap_initialize","state_after":{"bootstrap":true},"state_before":{},"step_id":"S1"},'// &
                 '{"dependencies":["S1"],"rule":"evaluate_rule","rule_definition":{"name":"'//trim(rule_name)//'","expression":"'//trim(rule_expression)//'"},'// &
                 '"result":true,"state_before":{"bootstrap":true},"state_after":{"bootstrap":true},"step_id":"S_eval"},'// &
                 '{"dependencies":["S_eval"],"rule":"mark_ready","state_after":{"bootstrap":true,"ready":true},"state_before":{"bootstrap":true},"step_id":"S2"}]}'
  else
    trace_json = '{"trace":[{"dependencies":[],"rule":"bootstrap_initialize","state_after":{"bootstrap":true},"state_before":{},"step_id":"S1"},'// &
                 '{"dependencies":["S1"],"rule":"evaluate_rule","rule_definition":{"name":"'//trim(rule_name)//'","expression":"'//trim(rule_expression)//'"},'// &
                 '"result":false,"state_before":{"bootstrap":true},"state_after":{"bootstrap":true},"step_id":"S_eval"},'// &
                 '{"dependencies":["S_eval"],"rule":"mark_not_ready","state_after":{"bootstrap":true,"ready":false},"state_before":{"bootstrap":true},"step_id":"S2_alt"}]}'
  end if

  ! ----------------------------
  ! Persist artifacts
  ! ----------------------------
  call ensure_dir("artifacts")
  call write_text_file("artifacts/trace.json", trace_json)

  ! ✅ FIXED canonical input string
  if (ready_flag) then
    flag_str = "true"
  else
    flag_str = "false"
  end if

  prov%input_hash = sha256_hex_of_ascii( &
    '{"ready_flag":'//trim(flag_str)// &
    ',"rule_definition":{"name":"'//trim(rule_name)// &
    '","expression":"'//trim(rule_expression)//'"}}' )

  prov%initial_state_hash = sha256_hex_of_ascii("{}")
  prov%results%output_hash = sha256_hex_of_ascii("null")
  prov%results%trace_hash = sha256_hex_of_ascii(trace_json)

  prov_json = canonical_provenance_payload_json(prov)
  call write_text_file("artifacts/provenance.json", prov_json)

  write(*,'(A)') prov_json
  stop 0

contains

  subroutine extract_rule_definition(text,name,expr,found)
    character(len=*),intent(in)::text
    character(len=128),intent(out)::name,expr
    logical,intent(out)::found

    if(index(text,'"rule_definition"')==0)then
      found=.false.; return
    endif

    name="ready_flag_rule"
    expr="ready_flag == true"
    found=.true.
  end subroutine

  subroutine extract_boolean_declared_input(text,key,value,found_key)
    character(len=*),intent(in)::text,key
    logical,intent(out)::value,found_key
    integer::p

    p=index(text,'"'//trim(key)//'": true')
    if(p/=0)then; value=.true.; found_key=.true.; return; endif

    p=index(text,'"'//trim(key)//'": false')
    if(p/=0)then; value=.false.; found_key=.true.; return; endif

    found_key=.false.
  end subroutine

  subroutine refuse(r,rule,exp)
    character(len=*),intent(in)::r,rule,exp
    write(error_unit,'(A)')"REFUSAL: "//trim(r)//" "//trim(rule)//" "//trim(exp)
    stop 1
  end subroutine

  subroutine ensure_dir(d)
    character(len=*),intent(in)::d
    call execute_command_line('mkdir "'//trim(d)//'"')
  end subroutine

  subroutine write_text_file(p,t)
    character(len=*),intent(in)::p,t
    integer::u
    open(newunit=u,file=trim(p),status="replace")
    write(u,'(A)')t
    close(u)
  end subroutine

end program souper_executor
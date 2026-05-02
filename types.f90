! SouperSport semantic core types (structure only)
module souper_types
  implicit none

  ! ----------------------------
  ! Canonical identities (normative)
  ! ----------------------------
  character(len=32), parameter :: TRACE_SCHEMA_NAME    = "souper.trace.state-transition"
  character(len=16), parameter :: TRACE_SCHEMA_VERSION = "1.0.0"

  character(len=48), parameter :: PROVENANCE_NAME    = "souper.provenance.deterministic-execution"
  character(len=16), parameter :: PROVENANCE_VERSION = "1.0.0"

  character(len=32), parameter :: SEMANTIC_LAW_NAME = "Deterministic Replayability"

  ! ----------------------------
  ! Outcome kinds (explicit labels; decision logic comes later)
  ! ----------------------------
  character(len=16), parameter :: OUTCOME_UNSET   = "unset"
  character(len=16), parameter :: OUTCOME_SUCCESS = "success"
  character(len=16), parameter :: OUTCOME_REFUSAL = "refusal"

  ! ----------------------------
  ! Core semantic structures (still structure-only)
  ! ----------------------------
  type :: execution_outcome_t
    character(len=16) :: kind
  end type execution_outcome_t

  type :: refusal_t
    character(len=64)  :: reason
    character(len=128) :: violated_rule
    character(len=256) :: explanation
  end type refusal_t

  type :: trace_t
    character(len=32) :: schema_name
    character(len=16) :: schema_version
  end type trace_t

  ! ----------------------------
  ! Provenance structures (shape only; hashing comes later)
  ! ----------------------------
  type :: tool_identity_t
    character(len=64) :: name
    character(len=32) :: version
  end type tool_identity_t

  type :: source_context_t
    character(len=128) :: content_id
    character(len=128) :: repository_id
  end type source_context_t

  type :: execution_results_t
    character(len=64) :: output_hash
    character(len=64) :: trace_hash
  end type execution_results_t

  type :: provenance_payload_t
    character(len=48) :: name              ! must match PROVENANCE_NAME
    character(len=16) :: version

    character(len=32) :: semantic_law_name

    character(len=64) :: input_hash
    character(len=64) :: initial_state_hash

    type(execution_results_t) :: results

    character(len=32) :: trace_schema_name
    character(len=16) :: trace_schema_version

    type(tool_identity_t)  :: tool
    type(source_context_t) :: source_context
  end type provenance_payload_t

end module souper_types
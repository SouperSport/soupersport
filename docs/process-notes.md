### Process Notes

This document records notable process‑level issues, decisions, failures,
and deliberate course corrections made during the evolution of the
SouperSport project.

It exists to preserve reasoning and context without distorting the core
design narrative, rewriting history, or overloading foundational
documentation.

This file is intended to answer the question:
“What happened, what did we learn, and why did we choose not to hide it?”

---

#### Terminology Transition: Gate vs Phase

Early in the project, the term **Gate** was used inconsistently to refer
to both internal enforcement checkpoints and major conceptual milestones.

During Phase 10, the project standardized on the term **Phase** as the
canonical label for high‑level conceptual progress.

The term **Gate** is now reserved exclusively for internal mechanisms
such as CI enforcement boundaries or verification checkpoints.

Earlier commits, CI logs, and enforcement history may continue to
reference **Gate** when referring to milestones. These references have
not been rewritten.

This was a deliberate decision to preserve an accurate and auditable
record of how the project evolved, even where earlier terminology was
imperfect.

All future project documentation and milestone references use **Phase**
as the canonical term, unless a document’s purpose is explicitly
historical or comparative.

---

#### CI Incident: Determinism Certificate Gate #7 Failure

On April 20, during development of determinism and provenance
enforcement, the following CI run failed:
- Enforce sealed inputs, golden certificates, and counterfactual
  equivalence in CI
- Determinism Certificate Gate #7
- Commit: a1109ee
- Outcome: Failure

This failure occurred during a period of rapid iteration on CI
enforcement logic, when strict guarantees were introduced before
surrounding process and documentation were fully stabilized.

The failure exposed fragility in enforcement sequencing rather than
semantic unsoundness in the underlying goals.

Subsequent commits refined enforcement boundaries, clarified update
policies, and improved separation between conceptual progress and
mechanical tooling.

The failure was not retroactively corrected, suppressed, or rewritten.
It is preserved as part of the project’s history and informed later
decisions about pacing, documentation discipline, and phase separation.

---

#### Documentation Text Format Standardization

At a later stage of project maturation, the documentation set underwent
a deliberate **text format standardization pass**.

Earlier documents contained defensive escaping and formatting artifacts
introduced by prior authoring contexts. While technically valid, these
artifacts reduced readability and made human review more difficult.

As part of this standardization:
- Unnecessary escape characters were removed.
- Markdown formatting was normalized for clarity and consistency.
- No semantic wording, obligations, or guarantees were changed.

This was a **presentation‑only change**, not a semantic revision.

---

#### Documentation Index Creation

Once the public documentation set stabilized semantically and
presentation issues were resolved, a **documentation index** was added
to the project.

The purpose of the index is to:
- provide an intended reading order for human readers,
- distinguish between semantic authority, explanatory material, and
  phase‑scoped decision records,
- reduce ambiguity about how documents relate to one another.

The index is explicitly **non‑normative**. It does not:
- introduce semantic meaning,
- confer authority,
- alter the interpretation of any document.

Semantic authority remains defined solely within the documents
themselves.

The index exists only to improve human navigation and comprehension and
may be updated as documentation evolves without constituting a semantic
change.

---

#### Normative vs Phase‑Scoped Document Clarification

During the same pass, documents were explicitly distinguished by role:

**Timeless semantic authority documents** (for example, semantic laws,
the semantic target, trace definitions, and conformance policies) were
treated as **phase‑neutral** reference artifacts. Phase identifiers were
removed where they risked conflating project sequencing with semantic
meaning.

**Phase‑scoped analysis and decision documents** (for example,
representation comparisons, reference execution selection, and execution
sketching) intentionally retain phase notation, as their purpose is to
record decision order, alternatives considered, and sequencing context.

This distinction was made explicit to ensure that:
- semantic meaning remains stable and timeless,
- project history remains auditable,
- future readers can distinguish constitutional rules from decision
  records.

---

#### Preservation Principle

When inconsistencies, failures, or early missteps are identified, the
project follows these principles:
- Forward correction instead of historical rewriting
- Explicit documentation instead of silent fixes
- Auditability instead of cosmetic cleanliness

This principle reflects the project’s emphasis on explicit reasoning,
traceability, and semantic integrity.

---

#### CI / Executor Boundary Correction: STDOUT Is Not a Semantic Artifact (Artifact Persistence Made Executor‑Authoritative)

A recurring source of friction during semantic authority transfer was a
mismatch between what the executor produced and what CI was attempting
to verify.

**Observed behavior (pre‑correction):**
- The reference executor could successfully validate intake and construct
  a correct deterministic provenance payload.
- The executor emitted that payload to **STDOUT** (human-visible), but did
  not persist it as a file.
- CI was configured to verify the presence (and later byte-level
  stability) of executor-emitted artifacts on disk.
- Result: CI failures were repeatedly triggered even when semantic
  execution succeeded, because the “artifact” existed only as log output
  rather than as a durable, verifiable file.

This was not a semantic failure. It was an interface-contract failure
between:
- the executor’s output discipline, and
- CI’s verification discipline.

**Correction (deliberate, forward-only):**
The executor’s success path was updated so that deterministic success
produces durable artifacts as files, not only as console output.
Specifically:
- On successful deterministic execution, the executor creates
  ./artifacts/ (relative to the working directory) and writes the
  canonical provenance payload to artifacts/provenance.json.
- The executor exits with a conventional success code (0) on success.
- Refusal behavior remains refusal-first and explicit; missing required
  intake continues to refuse rather than guess.

**Why this was necessary (principle):**
STDOUT is not a stable semantic boundary. Log output can be truncated,
interleaved, reformatted, or treated as non-authoritative by tooling.
CI must be able to verify semantics using durable, byte-stable artifacts
without parsing or interpreting logs.

This change makes semantic authority resident in executor-emitted
artifacts, and reduces CI to a pure verifier.

**Preservation note:**
This incident is recorded rather than erased. The project follows forward
correction instead of historical rewriting, and prefers explicit
documentation over silent fixes. This entry exists so future work does
not reintroduce the same failure mode by “successfully” printing artifacts
without persisting them.

---

#### CI Incident: Determinism Workflow Failures During GitHub Transition (Build/Run Environment Parity)

During the first transition from local verification to GitHub CI
enforcement, the determinism workflow failed multiple times for
**non-semantic reasons** before reaching a stable externally verifiable
state.

These failures were preserved and treated as part of the project’s
auditable history rather than being hidden or “patched around.”

##### Failure Mode 1: Attempting to Run a Nonexistent Binary

**Observed behavior:**
- The workflow attempted to run `.\souper_executor.exe` immediately after
  checkout.
- The repository intentionally did not commit `souper_executor.exe` as a
  build artifact.
- Result: CI failed because the binary did not exist.

**Lesson:**
CI must **build** the reference executor from source before it can verify
any determinism properties.

**Forward correction:**
A build step was added to the workflow so CI compiles the executor before
running it.

##### Failure Mode 2: Compiler Not Available in CI Environment

**Observed behavior:**
- After adding a build step, CI failed with `gfortran: command not found`.
- Root cause: the runner environment did not include a Fortran compiler
  by default.

**Lesson:**
The CI workflow must explicitly provision the toolchain required to build
the semantic core.

**Forward correction:**
MSYS2 was installed in the workflow, and the MinGW64 Fortran toolchain
(`mingw-w64-x86_64-gcc-fortran`) was installed explicitly.

##### Failure Mode 3: Build/Run Environment Mismatch (MSYS2 vs PowerShell)

**Observed behavior:**
- The workflow successfully compiled the binary in MSYS2/MinGW64.
- The workflow then attempted to run the executable from PowerShell.
- Result: the executor step exited nonzero under CI even when local runs
  succeeded.

**Lesson:**
A binary built in the MSYS2/MinGW environment should be executed inside
the same environment to avoid runtime dependency and PATH mismatches.

**Forward correction:**
The workflow was updated to both **build and run** the executor inside the
MSYS2 shell, while leaving artifact verification (file presence checks)
in PowerShell.

##### Stabilization Outcome

After these corrections:
- CI successfully builds the Fortran executor from source.
- CI runs the executor and obtains a deterministic success exit code.
- CI verifies presence of emitted artifacts (`artifacts/trace.json` and
  `artifacts/provenance.json` on success).
- CI prints provenance output for auditability.

This establishes the intended discipline:
- local runs prove correctness,
- CI proves reproducibility,
- failures are surfaced as explicit workflow contract violations rather
  than hidden heuristics.

---

End of document.
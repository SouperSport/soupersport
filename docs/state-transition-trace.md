## State‑Transition Trace

**Status:** Final and Normative  

This document defines binding semantic behavior for deterministic execution
and must not be altered except by explicit revision.

This document defines what is meant by a _state‑transition trace_ in SouperSport.
It exists to support **Semantic Law #1 — Deterministic Replayability** by making
explicit what must be preserved for execution to be replayable, rewindable,
and explainable.

This document is intentionally semantic. It does not define storage formats,
data structures, or implementation strategies.

---

## Motivation

A program cannot be replayed or rewound unless there is a precise account
of _what changed_, _when it changed_, and _why it changed_.

In SouperSport, this account is the **state‑transition trace**.

The trace is not a debugger log, nor an execution transcript.
It is a semantic artifact: part of the program’s meaning in Deterministic
regions.

---

## What Counts as State

In a Deterministic region, **state** consists of all information whose
variation could change observable program behavior.

State includes:

- User‑declared state objects (records, collections, aggregates).
- Values bound to identifiers in scope.
- Control‑flow decisions (branch selection, loop progression).
- Search progress in declarative or goal‑directed evaluation.
- Error states once an error is produced.

If two executions differ in any of the above, they are different executions.

### What Is Not State

The following do _not_ count as state, provided they are fully determined by
state and control flow:

- Cached or memoized values that can be recomputed uniquely.
- Runtime bookkeeping (allocation metadata, garbage collection state).
- Implementation‑specific intermediates with no semantic effect.

If removal or alteration of such information cannot change the trace,
it is not state.

---

## Transitions

A **state transition** is any change from one semantic state to the next.

Transitions include:

- Assignment or mutation of declared state.
- Advancing control flow (entering or exiting a branch or iteration).
- Emitting an error or outcome value.
- Selecting a result in goal‑directed evaluation.

Transitions are ordered.

If two executions produce the same semantic states in a different causal
sequence, they produce different traces.

---

## The Trace

A **state‑transition trace** is a canonical sequence of semantic states and
transitions produced by execution of a Deterministic region.

The trace must be sufficient to support:

- **Replay** — re‑execution produces the same outputs and trace.
- **Rewind** — prior states can be reconstructed causally.
- **Explanation** — it is possible to answer “why did this happen?”

The trace is not required to preserve implementation detail,
only semantic distinction.

---

## Trace Granularity and Observability Profiles

Deterministic replayability constrains **what must be true** about execution,
not **how much detail** an implementation must expose or retain.

SouperSport separates **semantic determinism** from **trace granularity**.

### Canonical Requirement

All Deterministic regions are subject to Semantic Law #1:

Identical declared inputs and identical declared initial state must produce an
identical semantic state‑transition trace.

---

### Trace Granularity

A trace records only distinctions necessary to explain observable behavior
and causal outcomes.

The trace **must include**:

- semantic state changes,
- control‑flow decisions,
- goal or selection outcomes,
- error or outcome emission.

The trace **may exclude**:

- recomputable intermediates,
- implementation‑specific bookkeeping,
- optimization artifacts that do not affect meaning.

Exclusion is permitted only when recomputation is uniquely determined by
recorded state and transitions.

Canonicalization must be defined over bytes, independent of locale, encoding
defaults, or platform conventions.

---

### Observability Profiles

SouperSport supports observability profiles governing retention and visibility:

- **Minimal**
- **Diagnostic**
- **Certifying**

All profiles MUST correspond to the same semantic execution; they differ only in
visibility and retention, never in meaning.

---

### Stability Guarantee

Reducing trace granularity must never cause:

- execution divergence,
- loss of replayability,
- ambiguity in causal explanation.

Trace reduction is valid only if rewind and causal explanation remain complete.

---

### Trace Equivalence

Executions may be trace‑equivalent only when semantic distinctions observable at
the language level are identical.

Equivalence is permitted only when causal explanation remains unambiguous.

Order‑independence claims are invalid when operations are numeric or otherwise
non‑associative under the active model.

---

## Numeric Determinism and Floating‑Point Behavior

Deterministic replayability requires that numeric computation produce
semantically identical results across re‑execution.

Floating‑point behavior may vary across platforms; therefore numeric operations
that influence semantic state, control flow, or output MUST be deterministic
under the active numeric model.

If numeric determinism cannot be guaranteed, the computation cannot reside in a
Deterministic region.

---

## Environmental Influence

Time, randomness, scheduling, external I/O, unspecified iteration order,
environment variables, locale, timezone, and ambient configuration must not
influence deterministic traces unless sealed as declared inputs.

This restriction applies transitively: deterministic code must not depend on
libraries whose behavior is nondeterministic under identical inputs.

---

## Interoperation Between Deterministic and Nondeterministic Regions

A Deterministic region MUST NOT observe nondeterminism directly.

Nondeterministic effects may influence deterministic computation only by being
converted into declared, sealed inputs at an explicit boundary.

Sealed inputs must be canonicalized prior to deterministic consumption and may
include provenance metadata when required to prevent substitution or tampering.

If sealing a value requires consulting the external world, sealing must occur
outside Deterministic.

The deterministic trace begins where sealed inputs and declared initial state are
fixed.

---

## Relationship to Counterfactual Execution

Counterfactual execution varies assumptions while holding the baseline trace
fixed.

A valid trace must preserve enough structure to support “what if” questions.

---

## Non‑Goals

The trace is not intended to:

- record every instruction,
- expose operational execution order,
- capture performance artifacts,
- replace debuggers or profilers,
- model machine or OS state.

The trace preserves semantic causality, not operational detail.
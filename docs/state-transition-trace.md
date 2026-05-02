# State‑Transition Trace

**Status:** Final and Normative  

This document defines binding semantic behavior for deterministic execution
and must not be altered except by explicit revision.

This document defines what is meant by a _state‑transition trace_ in SouperSport.

It exists to support **Semantic Law #1 — Deterministic Replayability** by making
explicit what must be preserved for execution to be replayable, rewindable,
and explainable.

This document is intentionally semantic.

It does not define storage formats, data structures, or implementation strategies.

---

## Motivation

A program cannot be replayed or rewound unless there is a precise account of:

- what changed  
- when it changed  
- why it changed  

In SouperSport, this account is the **state‑transition trace**.

The trace is not a debugger log or execution transcript.

It is a **semantic artifact**.

---

## What Counts as State

State consists of all information whose variation could change observable
program behavior.

This includes:

- user‑declared state objects  
- values bound to identifiers  
- control‑flow decisions  
- search progress  
- error states  

If two executions differ in any of the above, they are different executions.

---

### What Is Not State

Not state (if derivable from state + control flow):

- cached or memoized values  
- runtime bookkeeping  
- implementation intermediates  

If removing it does not change the trace, it is not state.

---

## Transitions

A **state transition** is any change from one state to the next.

This includes:

- assignment or mutation  
- control‑flow progression  
- emitting outputs or errors  
- selecting results  

Transitions are ordered.

Changing the causal sequence changes the trace.

---

## The Trace

A **state‑transition trace** is a canonical sequence of:

- semantic states  
- transitions between them  

It must support:

- **Replay** — reproduce output and trace  
- **Rewind** — reconstruct prior state  
- **Explanation** — answer “why”  

The trace preserves semantic meaning, not implementation detail.

---

## Trace Granularity and Observability Profiles

Determinism defines **what must be true**, not how much must be recorded.

SouperSport separates:

- semantic determinism  
- trace granularity  

---

### Canonical Requirement

Identical inputs and initial state MUST produce identical traces.

---

### Trace Granularity

The trace MUST include:

- state changes  
- control decisions  
- goal selections  
- error emissions  

The trace MAY exclude:

- recomputable intermediates  
- implementation bookkeeping  
- optimization artifacts  

Only if exclusion preserves replay and explanation.

---

### Observability Profiles

Supported profiles:

- Minimal  
- Diagnostic  
- Certifying  

All represent the same execution.

---

### Stability Guarantee

Reducing trace detail must never cause:

- divergence  
- loss of replayability  
- explanation ambiguity  

---

### Trace Equivalence

Traces are equivalent only if semantic behavior is identical.

Different ordering may be allowed only when meaning is unchanged.

---

## Numeric Determinism

Numeric computation must be deterministic.

If not guaranteed, it must not be used in Deterministic regions.

---

## Environmental Influence

The following must not influence execution unless sealed:

- time  
- randomness  
- I/O  
- environment  

This applies transitively to dependencies.

---

## Interoperation Boundaries

Deterministic regions must not observe nondeterminism directly.

All external influence must:

- be sealed  
- become declared input  

The trace begins at the sealed boundary.

---

## Counterfactual Support

Traces must support “what if” reasoning through causal structure.

---

## Non‑Goals

The trace is not intended to:

- record every instruction  
- represent runtime scheduling  
- capture performance data  
- replace debugging tools  

It preserves **semantic causality only**.
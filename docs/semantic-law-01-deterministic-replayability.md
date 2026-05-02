# Semantic Law #1 — Deterministic Replayability

---

## Statement (binding)

Within a Deterministic region, evaluation is a pure function of:

- the declared inputs  
- the declared initial state  

For identical initial state and identical inputs, execution MUST produce:

- identical outputs  
- an identical state‑transition trace  

If any dependency on time, randomness, scheduling, external I/O, or unspecified
iteration order influences results, the program is illegal in Deterministic.

This law exists to make determinism, rewindability, and counterfactual reasoning
real rather than aspirational.

---

## Scope

This law applies only inside regions explicitly declared Deterministic.

Other regions may permit nondeterminism, but nondeterminism MUST NOT leak into
Deterministic regions across an interoperability boundary.

---

## Definitions

**Declared input**

Any value explicitly passed into a deterministic computation.

---

**Declared initial state**

The complete state snapshot referenced at computation entry.

---

**State‑transition trace**

A canonical sequence of semantic state changes produced during evaluation.

The trace is not a log — it is part of program meaning for deterministic regions.

If two traces differ, the executions differ.

---

**Observable output**

Return values, emitted proofs or certificates (if applicable),
and the final declared state.

---

## Prohibitions

Inside Deterministic, the following are illegal unless explicitly modeled:

- Wall‑clock or monotonic time  
- Entropy or randomness  
- External I/O  
- Unspecified iteration order  
- Scheduler‑dependent concurrency  
- Undefined behavior influencing outcomes  

---

## Obligations

A valid Deterministic region MUST guarantee:

- **Stable iteration semantics** — defined and consistent  
- **Stable numeric semantics (where relevant)**  
- **Stable error semantics**  
- **Replayability**  

---

## Test

A violation occurs if:

- Output or final state changes for the same inputs and initial state  
- The trace differs across executions  

No “close enough.” Any divergence is a violation.

---

## Examples

**Allowed**

- Sorting with defined ordering  
- Iterating in stable order  
- Deterministic error handling  

**Disallowed**

- Iterating unordered maps  
- Using system time  
- Random tie‑breaking  
- Scheduler‑dependent concurrency  

---

## Design consequence

If a feature cannot obey this law:

- it must be restricted, or  
- it must be redesigned  

The law is the rule.  
Features are negotiable.
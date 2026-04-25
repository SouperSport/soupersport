# Semantic Law #1 — Deterministic Replayability

## Statement (binding)

Within a `Deterministic` region, evaluation is a pure function of:

1) the declared inputs, and  
2) the declared initial state.

For identical initial state and identical inputs, execution MUST produce:

- identical outputs, and  
- an identical state-transition trace.

If any dependency on time, randomness, scheduling, external I/O, or unspecified
iteration order influences results, the program is illegal in `Deterministic`.

This law exists to make determinism, rewindability, and counterfactual reasoning
real rather than aspirational.

---

## Scope

This law applies only inside regions explicitly declared `Deterministic`.

Other regions may permit nondeterminism, but nondeterminism MUST NOT leak into
`Deterministic` regions across an interoperability boundary.

---

## Definitions

**Declared input**

Any value explicitly passed into a deterministic computation
(parameters, arguments, explicitly declared configuration).

**Declared initial state**

The complete state snapshot referenced by the deterministic computation at entry.

**State-transition trace**

A canonical sequence of semantic state changes produced during evaluation.

The trace is not a log: it is part of program meaning for deterministic regions.

If two traces differ, the executions differ.

**Observable output**

Return values, emitted proofs or certificates (if applicable),
and the final declared state.

---

## Prohibitions (what is illegal in Deterministic)

Inside `Deterministic`, the following are illegal unless explicitly modeled
as declared input or declared state:

- Reading the wall clock or monotonic time.
- Reading entropy, randomness, or any nondeterministic source.
- Accessing external I/O (network, filesystem, system APIs) directly.
- Using data structures or operations with unspecified iteration order.
- Using concurrency primitives where scheduling can change results.
- Using undefined or implementation-defined behavior to influence outcomes.

---

## Obligations (what the language must guarantee)

A valid `Deterministic` region MUST guarantee:

- **Stable iteration semantics:** iteration order must be defined and consistent.
- **Stable numeric semantics (where relevant):** operations that can diverge
  across platforms must be constrained, forbidden, or explicitly modeled.
- **Stable error semantics:** if an error occurs, error outcomes and propagation
  must be deterministic given inputs and state.
- **Replayability:** the region can be executed again to produce the same outputs
  and the same state-transition trace.

---

## Test (how to falsify the law)

A `Deterministic` region violates this law if either of the following is true:

1) Re-running the region with the same declared inputs and same declared initial
   state changes the output or final state.

2) Re-running the region produces a different state-transition trace.

No “close enough.” Any divergence is a violation.

---

## Examples (informal)

**Allowed**

- Sorting using a defined ordering.
- Iterating over a list with stable index order.
- Returning `Result[T, E]` where error cases depend only on inputs and state.

**Disallowed**

- Iterating over a hash map without defined ordering.
- Using `now()` or reading system time.
- Using randomness for tie-breaking.
- “Best-effort” concurrency where race order changes results.
- Reading environment variables unless explicitly passed as declared input.

---

## Relationship to other SouperSport concepts

- **Rewindability:** a deterministic trace makes rewind causal and explainable.
- **Counterfactual execution:** counterfactual analysis is meaningful only if
  baseline execution is stable.
- **Interop boundaries:** nondeterministic regions must be explicitly separated
  so deterministic regions remain valid.

---

## Design consequence (intentional constraint)

If a proposed feature cannot obey this law inside `Deterministic`, then either:

- the feature must be restricted to nondeterministic regions, or  
- the feature must be redesigned until deterministic replayability holds.

The law is the rule. Features are negotiable.
## Minimal Execution Model — Phase 11.2

This document refines the semantic commitments defined in
`semantic-target.md` by describing the **minimum concrete structures**
that must exist to support a valid SouperSport execution.

This document does not introduce syntax, tooling, execution engines,
or implementation strategies. It exists to answer **what must exist**,
not **how it is built**.

---

## 1. Minimal State Representation

This section defines the **minimum structure required to represent
state** in a SouperSport execution, independent of syntax, storage
format, or implementation strategy.

### 1.1 What Constitutes State

State consists solely of values that are:

- explicitly declared as persistent across execution steps, and
- intended to participate in semantic reasoning and equivalence.

State does not include:

- transient intermediate values,
- implicit caches,
- runtime artifacts not declared as state.

Only declared state contributes to the meaning of an execution.

---

### 1.2 Initial State

Every execution begins from an initial state.

The initial state is defined as the complete set of declared state
values available before any execution steps occur. These values must be:

- explicitly provided, or
- explicitly derived from declared inputs using declared rules.

No implicit defaults, ambient values, or undeclared initialization
behavior are permitted.

---

### 1.3 State Evolution

State evolves through **declared transformations**.

Each transformation:

- consumes prior state (and possibly declared inputs),
- produces a new state, and
- is attributable to a specific declared rule or operation.

State transitions must be **locally attributable**, meaning the cause
of any state change is identifiable without reference to execution order
outside the declared model.

No state may change without a declared cause.

---

### 1.4 Minimal Information Content of State

For state to support semantic reasoning, it must contain sufficient
information to allow:

- comparison with other states for equivalence,
- explanation of downstream effects, and
- attribution of changes to declared causes.

State must not encode historical execution details unless those details
are themselves declared as part of state.

---

### 1.5 State Equivalence

Two states are considered equivalent if:

- all declared state components are equivalent under the system’s
  equivalence rules, and
- no refused or undeclared influences contributed to their values.

State equivalence is determined independently of how the state was
reached and independently of execution history.

---

### 1.6 Non‑Requirements

The minimal state representation does not require:

- a specific data structure,
- a serialization format,
- versioning or snapshot mechanisms,
- temporal ordering information, or
- performance‑oriented optimizations.

These concerns are intentionally deferred to later phases.

---

### 1.7 Role of State in Later Phases

This section defines what state **must mean**, not how it is stored
or manipulated.

Future phases may introduce concrete representations or optimizations,
but only insofar as they preserve the semantic commitments defined here
and in `semantic-target.md`.

---

## 2. Minimal Execution Ordering

This section defines the **minimum ordering guarantees** required for
execution to support semantic reasoning in SouperSport.

Execution ordering exists to make causality explicit, not to optimize
performance or scheduling.

---

### 2.1 What Execution Ordering Represents

Execution ordering represents the **declared causal relationship**
between execution steps.

Ordering is not defined in terms of time or scheduling, but in terms of
dependency:

- which execution steps depend on the results of others, and
- which steps may be considered independent under the semantic model.

Execution order exists to preserve meaning, not to control evaluation
strategy.

---

### 2.2 Declared Order and Dependencies

An execution step may only depend on:

- explicitly declared inputs,
- explicitly declared state, and
- the results of explicitly identified predecessor steps.

All dependencies must be declared.

No execution step may implicitly depend on:

- ambient ordering,
- evaluation side effects, or
- undeclared prior computation.

Declared dependencies define a **partial order** over execution steps.

---

### 2.3 Minimal Ordering Requirement

The minimal requirement for execution ordering is:

- that the dependency structure of all execution steps is explicit, and
- that this structure is sufficient to reproduce equivalent execution
  outcomes under deterministic constraints.

The semantic model does not require a total order unless such an order
is explicitly declared.

Independent steps remain unordered unless meaning requires otherwise.

---

### 2.4 Ordering and Determinism

Determinism is enforced at the level of declared meaning, not scheduling.

If two execution steps are semantically independent, variation in their
evaluation order is permitted, provided that:

- the declared state and outputs remain equivalent, and
- no undeclared influence alters the result.

If ordering affects meaning, that ordering must be explicitly declared.

---

### 2.5 Ordering and Explanation

Execution ordering must support explanation.

Given any execution result, the system must be able to:

- identify which prior steps contributed to that result, and
- explain their contribution through declared dependencies.

Ordering exists so explanations can follow declared causality without
relying on observed execution behavior.

---

### 2.6 Non‑Requirements

The minimal execution ordering model does not require:

- a total or linear execution order,
- timestamps or temporal metrics,
- concurrency or parallel execution semantics,
- scheduling policies or strategies,
- execution optimization rules.

These concerns are intentionally deferred.

---

### 2.7 Relationship to Traces

Execution ordering defines **what must be explainable**.

Execution traces will exist to record sufficient information to
reconstruct ordering relationships for replay and explanation.

Ordering defines meaning; traces support reasoning about it.

---

### 2.8 Role of Ordering in Later Phases

This section defines what execution ordering **must mean**, not how it
is implemented or enforced.

Later phases may introduce concrete realization strategies only insofar
as they preserve the semantic commitments defined here and in
`semantic-target.md`.

---

## 3. Minimal Execution Trace Representation

This section defines the **minimum information required** to support
replay, explanation, and counterfactual reasoning over execution meaning.

Traces exist to support semantic reasoning. They are not debugging
artifacts, performance logs, or diagnostic tools.

---

### 3.1 Purpose of a Trace

An execution trace exists to make the semantic consequences of execution
inspectable after the fact.

A trace must allow a reader or system to:

- reconstruct the declared execution ordering,
- observe state transitions,
- and explain why resulting state took its final form.

Traces do not define correctness; they support reasoning about it.

---

### 3.2 Required Trace Content

A minimal execution trace must include:

- the set of execution steps that occurred,
- the declared dependencies of each step,
- the state transitions applied by each step, and
- the declared rules that justified each transition.

No additional information is required for semantic reasoning.

---

### 3.3 Trace and Replay

Replay consists of re‑applying declared execution steps and state
transitions in accordance with declared ordering and dependencies.

Replay correctness is evaluated by whether it reproduces equivalent
declared state—not whether it reproduces timing, scheduling, or
incidental behavior.

---

### 3.4 Trace and Explanation

Given a trace and a final state, the system must be able to:

- identify which execution steps contributed to each state component,
- explain why those steps were applied, and
- connect outcomes to declared inputs and rules.

Explanation must rely on declared semantics, not inferred behavior.

---

### 3.5 Trace and Counterfactuals

Traces must contain sufficient information to support counterfactual
reasoning.

For any deliberate alteration to a declared rule, input, or dependency,
a trace must allow the system to:

- determine which execution steps are affected, and
- explain how and why resulting state diverges.

---

### 3.6 Non‑Requirements

Minimal execution traces do not require:

- timestamps or wall‑clock information,
- memory addresses or runtime artifacts,
- performance metrics,
- debugging annotations,
- implementation‑specific metadata.

Such information may exist in tooling, but is not part of the semantic
trace.

---

### 3.7 Role of Traces in Later Phases

This section defines what trace information **must exist** to support
semantic reasoning.

Later phases may introduce concrete trace representations or storage
formats only insofar as they preserve the semantic commitments defined
here and in `semantic-target.md`.

---

## 4. Minimal Counterfactual Evaluation

This section defines the **minimum semantic requirements** for evaluating
counterfactuals in SouperSport.

Counterfactual evaluation exists to explain why execution meaning
changes under deliberate, controlled variation.

---

### 4.1 What Counterfactual Evaluation Represents

A counterfactual evaluation is a **semantic comparison** between two
executions that differ by a single, deliberate change.

The purpose of counterfactual evaluation is to:

- isolate the semantic impact of that change, and
- explain how and why the resulting meaning differs.

Counterfactuals operate on declared semantics, not observed behavior.

---

### 4.2 Permissible Counterfactual Changes

A counterfactual change may consist of:

- modifying a declared input,
- modifying a declared rule, or
- modifying a declared execution dependency.

Exactly one class of change must be evaluated at a time.

Undeclared or compound changes are not permitted.

---

### 4.3 Counterfactual Evaluation Scope

Counterfactual evaluation must determine:

- which execution steps are affected by the declared change,
- which state transitions differ as a result, and
- which declared rules explain the divergence.

Evaluation scope is constrained by declared dependencies; steps not
semantically dependent on the change remain unaffected.

---

### 4.4 Counterfactual Explanation Requirements

A valid counterfactual explanation must:

- identify the minimal set of affected execution steps,
- trace divergence through declared dependencies, and
- explain how altered rules or inputs propagated into state differences.

Explanation must rely exclusively on declared semantics and traceable
causality.

---

### 4.5 Non‑Requirements

Minimal counterfactual evaluation does not require:

- speculative execution,
- probabilistic reasoning,
- optimization or performance modeling,
- runtime execution of alternate paths,
- rollback or undo mechanisms.

These concerns are intentionally deferred.

---

### 4.6 Relationship to Other Model Components

Counterfactual evaluation relies on:

- the state model defined in Section 1,
- the execution ordering defined in Section 2, and
- the trace representation defined in Section 3.

No additional semantic structures are introduced by counterfactual
evaluation.

---

## Status

With this document complete:

- Phase 11.2 specifies state, ordering, tracing, and counterfactual
  meaning.
- No implementation commitments have been introduced.
- The semantic execution model is sufficient to reason about preserved
  meaning and divergence.
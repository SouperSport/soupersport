### Minimal Execution Model

This document refines the semantic commitments defined in semantic-target.md by describing the **minimum concrete structures** that must exist to support a valid SouperSport execution.

This document does not introduce syntax, tooling, execution engines, or implementation strategies.

It exists to answer:

- **what must exist**, not  
- **how it is built**

---

## 1. Minimal State Representation

This section defines the **minimum structure required to represent state** in a SouperSport execution, independent of syntax, storage format, or implementation strategy.

### 1.1 What Constitutes State

State consists solely of values that are:

- explicitly declared as persistent across execution steps, and  
- intended to participate in semantic reasoning and equivalence  

State does not include:

- transient intermediate values  
- implicit caches  
- runtime artifacts not declared as state  

Only declared state contributes to the meaning of an execution.

---

### 1.2 Initial State

Every execution begins from an initial state.

The initial state is defined as the complete set of declared state values available before any execution steps occur.

These values must be:

- explicitly provided, or  
- explicitly derived from declared inputs using declared rules  

No implicit defaults, ambient values, or undeclared initialization behavior are permitted.

---

### 1.3 State Evolution

State evolves through **declared transformations**.

Each transformation:

- consumes prior state (and possibly declared inputs)  
- produces a new state  
- is attributable to a specific declared rule or operation  

State transitions must be **locally attributable**, meaning the cause of any state change is identifiable without reference to execution order outside the declared model.

No state may change without a declared cause.

---

### 1.4 Minimal Information Content of State

For state to support semantic reasoning, it must contain sufficient information to allow:

- comparison with other states for equivalence  
- explanation of downstream effects  
- attribution of changes to declared causes  

State must not encode historical execution details unless those details are themselves declared as part of state.

---

### 1.5 State Equivalence

Two states are considered equivalent if:

- all declared state components are equivalent under the system’s equivalence rules, and  
- no refused or undeclared influences contributed to their values  

State equivalence is determined independently of how the state was reached and independently of execution history.

---

### 1.6 Non‑Requirements

The minimal state representation does not require:

- a specific data structure  
- a serialization format  
- versioning or snapshot mechanisms  
- temporal ordering information  
- performance optimizations  

These are intentionally out of scope.

---

### 1.7 Role of State

This section defines what state **must mean**, not how it is stored or manipulated.

Future work may introduce representations or optimizations only if they preserve these semantics.

---

## 2. Minimal Execution Ordering

This section defines the **minimum ordering guarantees** required for execution to support semantic reasoning.

Execution ordering exists to make causality explicit.

---

### 2.1 What Execution Ordering Represents

Execution ordering represents **declared causal relationships** between execution steps.

It defines:

- which steps depend on others  
- which steps are independent  

Ordering is not defined in terms of time or scheduling.

---

### 2.2 Declared Dependencies

An execution step may only depend on:

- declared inputs  
- declared state  
- explicitly identified predecessor steps  

All dependencies must be declared.

No step may implicitly depend on:

- ambient ordering  
- evaluation side effects  
- undeclared computation  

---

### 2.3 Minimal Ordering Requirement

The minimum requirement is:

- dependency structure must be explicit  
- structure must be sufficient to reproduce equivalent outcomes  

A total ordering is **not required**.

Only dependencies matter.

---

### 2.4 Ordering and Determinism

If steps are independent, execution order may vary **only if meaning remains identical**.

If ordering affects meaning, it must be declared.

---

### 2.5 Ordering and Explanation

Ordering must support explanation.

The system must be able to:

- identify which steps contributed to a result  
- explain those contributions through dependencies  

---

### 2.6 Non‑Requirements

The model does not require:

- total ordering  
- timestamps  
- concurrency semantics  
- scheduling strategies  

---

### 2.7 Relationship to Traces

Ordering defines what must be explainable.

Traces exist to **record enough information to reconstruct ordering**.

---

### 2.8 Role of Ordering

This section defines meaning, not implementation.

---

## 3. Minimal Execution Trace Representation

This section defines the **minimum information required** for replay and explanation.

A trace is a **semantic artifact**, not a log.

---

### 3.1 Purpose of a Trace

A trace must allow:

- reconstruction of execution ordering  
- observation of state transitions  
- explanation of final state  

---

### 3.2 Required Trace Content

A minimal trace must include:

- execution steps  
- dependencies of each step  
- state transitions of each step  
- rules that justify each transition  

---

### 3.3 Trace and Replay

Replay consists of re-applying declared steps and transitions.

Replay correctness is determined by reproducing **equivalent state**, not timing.

---

### 3.4 Trace and Explanation

The system must:

- identify which steps contributed to each state component  
- explain why those steps occurred  
- connect outcomes to inputs and rules  

---

### 3.5 Trace and Counterfactuals

Traces must support:

- identifying affected steps  
- explaining divergence under change  

---

### 3.6 Non‑Requirements

Traces do not require:

- timestamps  
- memory addresses  
- performance data  
- debug annotations  

---

### 3.7 Role of Traces

This section defines what must exist, not how it is stored.

---

## 4. Minimal Counterfactual Evaluation

This section defines the requirements for reasoning about change.

---

### 4.1 What Counterfactual Evaluation Represents

A counterfactual compares two executions differing by one deliberate change.

Its purpose is to:

- isolate the effect of that change  
- explain resulting differences  

---

### 4.2 Permissible Changes

A valid change is exactly one of:

- declared input  
- declared rule  
- declared dependency  

---

### 4.3 Evaluation Scope

The system must determine:

- which steps are affected  
- which transitions differ  
- why divergence occurs  

---

### 4.4 Explanation Requirements

A valid explanation must:

- identify affected steps  
- trace divergence  
- explain propagation through dependencies  

---

### 4.5 Non‑Requirements

Counterfactual evaluation does not require:

- speculative execution  
- probabilistic reasoning  
- optimization modeling  

---

### 4.6 Relationship to Other Components

Counterfactual evaluation depends on:

- state  
- ordering  
- trace  

No new semantic structures are introduced.

---

## Status

With this document complete:

- The minimal execution model defines:
  - state  
  - ordering  
  - trace  
  - counterfactual requirements  

- No implementation commitments are introduced

- The model is sufficient to support:
  - deterministic execution  
  - explanation  
  - replay  
  - semantic reasoning
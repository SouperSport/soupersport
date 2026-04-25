\# Reference Execution — Phase 11.4



This document selects a single \*\*reference execution approach\*\* for

SouperSport.



The purpose of a reference execution is to anchor semantic correctness:

to provide a canonical way to interpret, explain, and reason about

execution meaning as defined in earlier phases.



This document makes a semantic selection only. It does not introduce

implementation details, tooling decisions, or performance expectations.



\---



\## 1. Purpose of a Reference Execution



A reference execution exists to answer the question:



What does it mean, concretely, for an execution to be correct with

respect to the SouperSport semantic model?



The reference execution is not optimized, user‑facing, or

production‑oriented.



Its role is to:



\- preserve the semantic commitments defined in Phase 11.1,

\- realize the minimal structures defined in Phase 11.2,

\- provide an unambiguous point of semantic interpretation, and

\- serve as the standard against which other implementations are judged.



Correctness, not efficiency, is the controlling principle.



\---



\## 2. Selected Representation Family



SouperSport adopts an \*\*explicit graph‑based execution representation\*\*

as its reference execution model.



In this approach:



\- execution steps are represented as explicit nodes,

\- declared dependencies are represented as explicit edges,

\- state transitions are labeled transformations, and

\- execution ordering is derived from the graph’s dependency structure.



This representation is selected because it best preserves explicit

causality and semantic traceability without introducing additional

meaning.



\---



\## 3. Semantic Justification



The explicit graph‑based representation is selected on semantic grounds.



\### 3.1 State Preservation



\- Declared state exists independently of traversal or evaluation order.

\- State transitions can be represented as explicit, attributable effects.

\- Hidden mutation is structurally difficult to introduce.



This aligns directly with the minimal state model defined in Phase 11.2.



\---



\### 3.2 Execution Ordering



\- Partial ordering is expressed naturally through dependency edges.

\- Independent execution steps remain unordered unless meaning requires

&#x20; otherwise.

\- Ordering is semantic, not temporal.



This satisfies the execution ordering requirements without imposing an

artificial total order.



\---



\### 3.3 Trace Construction and Explanation



\- Traces can be derived directly from graph structure.

\- Causal chains are explicit and inspectable.

\- Explanation follows declared dependencies rather than observed behavior.



This cleanly supports replay and explanation as defined in the execution

trace model.



\---



\### 3.4 Counterfactual Reasoning



\- Counterfactuals can be evaluated by modifying nodes or edges and

&#x20; observing semantic consequences.

\- Affected execution steps are directly identifiable through graph

&#x20; reachability.



This enables counterfactual explanation without speculative execution.



\---



\## 4. Rejected Alternatives



The following representation families were considered and rejected as

the reference execution model, strictly for semantic reasons.



\### 4.1 Step‑Indexed Transition Log



While this approach provides strong replay semantics, it risks:



\- encoding total order where partial order is sufficient,

\- conflating semantic ordering with temporal progression.



These risks complicate explanation and counterfactual reasoning.



\---



\### 4.2 Constraint‑Driven Functional Core



This approach aligns well with immutability, but risks:



\- obscuring individual execution steps,

\- under‑specifying trace materialization,

\- hiding causality inside rule application.



These risks weaken explicit explainability.



\---



\### 4.3 Relational / Declarative Representation



This approach naturally expresses derivation but risks:



\- abstracting execution steps into inference mechanisms,

\- blurring state transition boundaries.



These risks conflict with the requirement for explicit execution steps.



\---



\## 5. Non‑Implications



Selecting a graph‑based reference execution does \*\*not\*\* imply:



\- a specific programming language,

\- a concrete data structure or storage format,

\- a runtime or evaluation strategy,

\- performance characteristics,

\- user‑visible syntax or APIs.



These decisions are explicitly deferred.



\---



\## 6. Phase Boundary Declaration



With this selection:



\- Phase 11.4 is complete.

\- SouperSport now has a canonical reference execution model.

\- All subsequent implementation work must preserve this semantic

&#x20; interpretation.



The project may now proceed to \*\*Phase 11.5 — Reference Execution

Sketch\*\* when ready.



\---



\## Status



The semantic foundation of SouperSport is now complete from intent

(Phase 11.1) through realization choice (Phase 11.4).



Further work transitions from semantic definition to representational

and executable exploration.


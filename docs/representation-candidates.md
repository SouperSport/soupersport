\# Representation Candidates — Phase 11.3



This document enumerates and evaluates \*\*candidate representation families\*\*

that could satisfy the semantic commitments defined in:



\- `semantic-target.md` (Phase 11.1), and

\- `minimal-execution-model.md` (Phase 11.2).



The purpose of this phase is to \*\*identify viable classes of representation\*\*

and their semantic trade‑offs, not to select or implement any approach.



No new semantics are introduced here.



\---



\## 1. Framing and Constraints



The semantic model defined in earlier phases is \*\*fixed\*\*.



Any representation considered in this document must:



\- preserve declared state without hidden mutation,

\- express execution ordering through explicit dependencies,

\- support execution traces sufficient for replay and explanation, and

\- support counterfactual reasoning over declared changes.



Representations are evaluated \*\*solely\*\* on their ability to uphold

these semantic requirements.



Performance, ergonomics, tooling, syntax, and implementation effort

are intentionally out of scope.



\---



\## 2. Candidate Representation Families



\### 2.1 Explicit Graph‑Based Representation



In this family, execution is represented as an explicit graph.



Typical characteristics:



\- nodes represent declared execution steps,

\- edges represent declared dependencies,

\- state transitions are represented as labeled transformations,

\- execution ordering is derived from graph structure.



This family emphasizes \*\*explicit causality\*\*.



\---



\### 2.2 Step‑Indexed Transition Log



In this family, execution is represented as a sequence (or partial order)

of state transitions indexed by step identifiers.



Typical characteristics:



\- state snapshots and transitions are explicitly recorded,

\- step identifiers encode ordering and dependency constraints,

\- provenance information is attached per transition.



This family emphasizes \*\*trace clarity and replay\*\*.



\---



\### 2.3 Constraint‑Driven Functional Core



In this family, execution is expressed as the application of constraints

or rules over immutable state.



Typical characteristics:



\- state is treated as immutable structures,

\- execution applies declared rules to derive new state,

\- counterfactuals are evaluated by re‑derivation under modified constraints.



This family emphasizes \*\*declarative meaning and equivalence\*\*.



\---



\### 2.4 Relational / Declarative Representation



In this family, state and execution are represented relationally.



Typical characteristics:



\- state is modeled as a set of relations,

\- execution steps derive new relations from existing ones,

\- traces correspond to justification or derivation graphs.



This family emphasizes \*\*explainability through logical derivation\*\*.



\---



\## 3. Semantic Fit Analysis



\### 3.1 Explicit Graph‑Based Representation



Semantic fit:



\- ✅ Can represent declared state explicitly.

\- ✅ Naturally expresses partial ordering via edges.

\- ✅ Supports trace reconstruction using graph traversal.

\- ✅ Can support counterfactual reasoning by graph modification.



Semantic risks:



\- Accidental introduction of implicit ordering if traversal semantics

&#x20; are underspecified.

\- Risk of conflating graph structure with execution scheduling.



\---



\### 3.2 Step‑Indexed Transition Log



Semantic fit:



\- ✅ Directly represents declared state transitions.

\- ✅ Explicitly records execution ordering.

\- ✅ Strong support for replay and explanation.

\- ✅ Counterfactual reasoning supported by step comparison.



Semantic risks:



\- Risk of encoding total order where partial order is sufficient.

\- Risk of drifting toward timeline semantics if ordering is over‑emphasized.



\---



\### 3.3 Constraint‑Driven Functional Core



Semantic fit:



\- ✅ Strong alignment with state equivalence and immutability.

\- ✅ Execution ordering derived from dependency declarations.

\- ✅ Counterfactuals expressed as rule variation.



Semantic risks:



\- Potential ambiguity in how execution steps are enumerated.

\- Risk of under‑specifying traces if derivation steps are implicit.



\---



\### 3.4 Relational / Declarative Representation



Semantic fit:



\- ✅ Naturally expresses dependency and provenance.

\- ✅ Traces emerge as justification graphs.

\- ✅ Counterfactual analysis supported via derivation changes.



Semantic risks:



\- Risk of hiding execution steps inside logical inference.

\- Risk of over‑abstracting state transition boundaries.



\---



\## 4. Semantic Risk Register



Across all candidate families, recurring semantic risks include:



\- implicit execution ordering emerging from tooling assumptions,

\- hidden mutation introduced through convenience abstractions,

\- insufficient trace materialization for explanation,

\- accidental coupling of representation with scheduling or performance.



Any selected representation must explicitly counter these risks.



\---



\## 5. Explicit Non‑Decision Statement



This phase \*\*does not select\*\* a representation.



No candidate is preferred or endorsed at this time.



The purpose of Phase 11.3 is to constrain future choices, not to

make them.



Representation selection, if any, occurs in \*\*Phase 11.4\*\*.



\---



\## Status



With this document complete:



\- Phase 11.3 has enumerated viable representation families.

\- At least one semantic risk has been identified for each family.

\- No implementation or design commitment has been made.



The project may now proceed to Phase 11.4 when and only when a

reference execution approach is ready to be chosen deliberately.


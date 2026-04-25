\# Semantic Law #2 — Explicit Control Flow



\*\*Status:\*\* Final and Normative



\---



\## Statement (binding)



All control flow that affects semantic outcome must be explicit,

representable, and traceable.



This includes:



\- branching,

\- iteration,

\- error propagation,

\- goal or search selection,

\- and early termination.



Control flow must be structurally local to its declared handling context.



It MUST NOT:



\- depend on implicit runtime behavior,

\- rely on ambient or hidden state,

\- bypass explicit handling structure,

\- or alter outcome without appearing in semantic state and trace.



Errors are control‑flow events and are subject to the same requirements.



An error that affects execution or outcome MUST be:



\- explicitly represented,

\- deterministically propagated in deterministic regions,

\- and visible in semantic state and trace.



This law exists to ensure explainability, rewindability,

and counterfactual reasoning across all execution modes.


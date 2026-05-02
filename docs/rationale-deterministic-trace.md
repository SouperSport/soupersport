\# Rationale — Deterministic Traces and Boundaries



SouperSport’s deterministic model is designed to survive contact with

real‑world systems without degrading correctness guarantees.



This document explains key design choices.



\---



\## Why Determinism Is Region‑Scoped



Determinism is opt‑in to avoid over‑constraining all code.



This allows:



\- ordinary I/O and interaction  

\- alongside strictly deterministic computation  



\---



\## Why Nondeterminism Is Forced to the Boundary



Nondeterminism is not eliminated.



It is constrained to boundaries where it becomes declared input.



This prevents accidental observation of nondeterminism.



\---



\## Why Traces Are Semantic, Not Operational



Semantic traces allow:



\- replay without over‑specification  

\- causal rewind  

\- counterfactual reasoning  



Operational detail is left to tooling.



\---



\## Why Trace Granularity Is Configurable



\- Correctness requires semantic stability  

\- Productivity requires flexibility  



Observability profiles support both.



\---



\## Why Numeric Determinism Is Constrained



Floating‑point variability introduces hidden nondeterminism.



Treating numeric variance as a semantic issue preserves guarantees.



\---



\## Outcome



This model prevents:



\- hidden nondeterminism  

\- replay divergence  

\- unexplainable behavior  

\- audit gaps  



while remaining viable for software development.


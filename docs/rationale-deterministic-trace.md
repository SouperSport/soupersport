\# Rationale — Deterministic Traces and Boundaries



SouperSport’s deterministic model is designed to survive contact with

real‑world systems without degrading correctness guarantees.



This rationale explains key design choices validated through stress testing.



\---



\## Why Determinism Is Region‑Scoped



Determinism is opt‑in and enforced to avoid imposing unnecessary constraints

on all code while making guarantees strong where they matter.



This allows:



\- ordinary I/O, networking, and interaction,

\- alongside strictly deterministic computation.



\---



\## Why Nondeterminism Is Forced to the Boundary



Real‑world nondeterminism (time, randomness, I/O, scheduling) is not eliminated;

it is constrained to explicit boundaries where it becomes declared input.



This prevents accidental observation of nondeterminism while preserving

practical expressiveness.



\---



\## Why Traces Are Semantic, Not Operational



Recording semantic transitions instead of operational steps allows:



\- replay without over‑specification,

\- rewind with causal explanation,

\- counterfactual reasoning without instrumentation artifacts.



Operational detail is left to tooling, not the language.



\---



\## Why Trace Granularity Is Configurable



Security and correctness require semantic stability.



Developer productivity requires flexibility.



Observability profiles allow different tooling needs

without changing program meaning.



\---



\## Why Numeric Determinism Is Constrained



Floating‑point variability is one of the most common sources of hidden

nondeterminism.



Treating numeric variance as a semantic issue rather than a runtime bug

ensures correctness guarantees remain meaningful across platforms.



\---



\## Outcome



Under stress testing, this model prevents:



\- hidden nondeterminism,

\- replay divergence,

\- unexplainable behavior,

\- audit and verification gaps,



while remaining viable for general software development.


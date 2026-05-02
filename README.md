## SouperSport

SouperSport is a programming language design project focused on making
execution **explicit, deterministic where claimed, and explainable**.

The project explores what becomes possible when a language is designed
around:
- explicit execution semantics
- visible and intentional state transitions
- constraints that prioritize reasoning over convenience

SouperSport exists to address persistent failures in complex systems,
including hidden nondeterminism, irreproducible behavior, unsafe
refactoring, and the inability to explain _why_ a change altered system
behavior.

A minimal reference executor exists to validate semantic behavior and
determinism, but the project is not yet a production language or
toolchain.

This repository contains **design foundations, semantic specifications,
and process history**, along with a minimal executable reference used for
validation.

### Status

The project’s **semantic foundations and core constraints are now
stable**.

A minimal deterministic reference executor is implemented and verified
in CI. This executor demonstrates:
- deterministic execution from canonical input
- explicit state transitions
- rule‑driven evaluation
- trace generation as a semantic artifact
- provenance binding and hashing

Public documentation includes:
- explicit semantic laws
- a defined semantic execution target
- a minimal semantic contract
- state‑transition trace definitions
- conformance, refusal, and equivalence rules
- provenance and trace schema definitions
- a selected reference execution model and realization sketch

These materials collectively define what it means for an execution to be
considered meaningful, deterministic (when claimed), and explainable
under the SouperSport model.

Work remains **design‑focused**. The implementation is minimal and
exists solely to validate semantic guarantees, not to serve as a
production system.

### What engaging with SouperSport currently means

At this stage, working with SouperSport means reasoning about:
- deterministic regions of execution
- explicit boundaries where nondeterminism is permitted or refused
- state transitions that are deliberate, visible, and traceable
- provenance‑backed explanations of behavior
- counterfactual and rewind‑style reasoning about change

These concepts define the project’s intended _first‑hour experience_,
even with only minimal executable tooling.

SouperSport is **not** intended to be:
- a general‑purpose scripting language
- a frontend language
- a drop‑in replacement for JavaScript, Python, or similar ecosystems
- a shortcut to performance, parallelism, or convenience

### Repository contents

This repository intentionally contains **public, durable artifacts only**.

For orientation and intended reading order, start with:
- docs/index.md

A non‑normative documentation index describing the role and ordering of
the public documents.

Key contents include:
- docs/semantic-law-*.md  
  Binding semantic laws governing determinism, control flow, and
  execution meaning.

- docs/semantic-target.md  
  The definition of what constitutes executable meaning under the
  SouperSport model.

- docs/minimal-semantic-contract.md  
  The minimum semantic obligations required for conformance.

- docs/state-transition-trace.md  
  The definition of traces as semantic artifacts.

- docs/process-notes.md  
  A factual record of process decisions, terminology corrections,
  CI incidents, and deliberate choices to preserve project history.

Private project‑control documents, workflow reminders, and planning
notes are maintained **outside this repository by design**.
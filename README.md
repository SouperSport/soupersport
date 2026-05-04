# SouperSport

SouperSport is a programming language design project focused on making  
execution **explicit, deterministic where claimed, and explainable**.

The project explores what becomes possible when a language is designed around:

- explicit execution semantics  
- visible and intentional state transitions  
- constraints that prioritize reasoning over convenience  

SouperSport exists to address persistent failures in complex systems,  
including hidden nondeterminism, irreproducible behavior, unsafe  
refactoring, and the inability to explain _why_ a change altered system behavior.

A minimal reference executor exists to validate semantic behavior and determinism,  
but the project is not a production language or toolchain.

This repository contains **design foundations, semantic specifications,  
and process history**, along with a minimal executable reference used solely  
for semantic validation.

---

## Project website

An overview and entry point for the project is available at:

https://soupersport.dev

The website provides high‑level orientation and context.  
All authoritative specifications, semantic definitions, and guarantees  
originate in this repository.

---

## Status

The project’s **semantic foundations and core constraints are stable**.

A **V1 semantic baseline** has been established, and a minimal deterministic  
reference executor is implemented and verified in continuous integration.

The reference executor demonstrates:

- deterministic execution from canonical input  
- explicit state transitions  
- rule‑driven evaluation  
- trace generation as a semantic artifact  
- provenance binding and hashing  

Public documentation defines:

- explicit semantic laws  
- a defined semantic execution target  
- a minimal semantic contract  
- state‑transition trace definitions  
- conformance, refusal, and equivalence rules  
- provenance and trace schema definitions  

These materials collectively define what it means for an execution to be  
considered meaningful, deterministic (when claimed), and explainable  
under the SouperSport model.

Work remains **design‑focused**.

The implementation is intentionally minimal and exists to validate semantic  
guarantees, not to serve as a general‑purpose production system.

---

## Guarantees (Current scope)

The current reference executor establishes the following guarantees:

- **Deterministic execution**  
  Identical declared inputs produce identical outputs and traces.

- **Canonical trace as meaning**  
  Execution produces a structured state‑transition trace (`trace.json`)  
  representing semantic behavior.

- **Rule‑as‑data evaluation**  
  Execution decisions are derived from input‑defined rules  
  (`rule_definition`), not hardcoded logic.

- **Provenance binding**  
  Execution produces a provenance payload (`provenance.json`) including:  
  `input_hash`, `trace_hash`, and `output_hash`.

- **Canonical input hashing**  
  Changes to inputs or rules produce different hashes; identical inputs do not.

- **Refusal correctness**  
  Unsupported or invalid inputs result in explicit refusal.

- **External reproducibility**  
  All guarantees are validated in CI using clean build‑from‑source execution.

---

## What engaging with SouperSport currently means

At this stage, working with SouperSport primarily involves reasoning about:

- deterministic regions of execution  
- explicit boundaries where nondeterminism is permitted or refused  
- deliberate, visible state transitions  
- provenance‑backed explanations of behavior  
- counterfactual and rewind‑style reasoning about change  

These concepts define the project’s intended _first‑hour experience_,  
even with only minimal executable tooling.

---

## What SouperSport is not

SouperSport is **not** intended to be:

- a general‑purpose scripting language  
- a frontend language  
- a drop‑in replacement for JavaScript, Python, or similar ecosystems  
- a shortcut to performance, parallelism, or convenience  

---

## Repository contents

This repository intentionally contains **public, durable artifacts only**.

For orientation and intended reading order, begin with:

- `docs/index.md`  

A non‑normative documentation index describing how the documents relate.

---

### Key contents

- `docs/semantic-law-*.md`  
  Binding semantic laws governing determinism and execution meaning  

- `docs/semantic-target.md`  
  Definition of executable meaning under the SouperSport model  

- `docs/minimal-semantic-contract.md`  
  Minimum semantic obligations required for conformance  

- `docs/state-transition-trace.md`  
  Definition of traces as semantic artifacts  

- `docs/process-notes.md`  
  Record of decisions, CI incidents, and preserved project history  

---

Private project‑control documents, workflow reminders, and planning notes  
are intentionally maintained **outside this repository**.

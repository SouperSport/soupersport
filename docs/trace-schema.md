# Deterministic Trace Schema

**Status:** Normative  
**Applies to:** Deterministic execution regions  
**Audience:** Tooling, CI enforcement, auditors, future language evolution

This document defines the **versioned schema contract** for deterministic
state‑transition traces.

It exists to ensure that evolution of tooling, instrumentation, or internal
representation does **not** silently change the meaning of a trace.

This document is complementary to, and subordinate to:

- `state-transition-trace.md` (semantic definition)
- `semantic-law-01-deterministic-replayability.md` (binding constraints)

If two executions produce traces that differ **in schema version**, they are
*not* comparable unless an explicit migration rule is defined.

---

## 1. Schema Identity

**Schema name:** `souper.trace.state-transition`  
**Schema version:** `1.0.0`

This version applies to all deterministic traces currently emitted and verified
by CI.

The schema version MUST be treated as part of trace identity.

---

## 2. Stability Guarantees

Within a given schema version:

- The **semantic meaning** of each trace element MUST remain stable.
- Hashing, replay, counterfactual comparison, and golden verification assume
  identical schema structure and interpretation.
- Differences in trace payloads under the same schema version indicate
  **semantic divergence**, not tooling variation.

Tooling MAY add auxiliary metadata *outside* the trace schema (for example,
debug annotations), provided such metadata is explicitly excluded from
normalization and hashing.

---

## 3. What Constitutes a Schema Change

The following require a **schema version bump**:

- Adding, removing, or reordering semantic trace elements.
- Changing the interpretation of an existing trace field.
- Altering canonical ordering rules.
- Changing normalization rules that affect hashing or comparison.
- Introducing new mandatory elements.

The following do **not** require a schema version bump:

- Changes to internal representation formats that normalize to the same
  semantic trace.
- Performance optimizations.
- Tooling‑only metadata explicitly excluded from canonicalization.

---

## 4. Versioning Rules

Schema versions follow **semantic versioning**:

- **MAJOR:** Semantic incompatibility; old traces are not comparable.
- **MINOR:** Backward‑compatible additions with explicit defaults.
- **PATCH:** Clarifications or bug fixes with no structural effect.

CI MUST reject comparisons between traces of different MAJOR versions.

Future tooling MAY provide explicit migration paths between schema versions,
but migration MUST be explicit and reviewable.

---

## 5. CI and Golden Certificate Interaction

Golden certificates implicitly bind to:

- declared inputs,
- declared initial state,
- **trace schema version**.

A change in trace schema version INVALIDATES existing golden certificates
unless they are regenerated intentionally via the sanctioned workflow.

CI enforcement relies on exact schema version matches when verifying:

- deterministic replay,
- golden immutability,
- counterfactual equivalence.

---

## 6. Forward Evolution

This document enables safe future evolution by making schema changes
**deliberate events**, rather than accidental consequences of refactors.

Any change to this file constitutes a change to the system’s semantic
contract and MUST be reviewed accordingly.

Trace schema stability is a prerequisite for:

- auditability,
- long‑term reproducibility,
- counterfactual reasoning,
- and verifiable governance under load.

---

**End of schema definition.**
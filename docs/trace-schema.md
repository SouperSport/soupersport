# Deterministic Trace Schema

**Status:** Normative  
**Applies to:** Deterministic execution regions  
**Audience:** Tooling, CI enforcement, auditors, future evolution  

---

## Overview

This document defines the versioned schema contract for deterministic
state‑transition traces.

It ensures that changes in tooling or representation do not alter the
semantic meaning of a trace.

This document is subordinate to:

- state-transition-trace.md  
- semantic-law-01-deterministic-replayability.md  

If two traces differ in schema version, they are not comparable unless
an explicit migration rule exists.

---

## 1. Schema Identity

- Schema name: souper.trace.state-transition  
- Schema version: 1.0.0  

Schema version is part of trace identity.

---

## 2. Stability Guarantees

Within a schema version:

- semantic meaning of trace elements MUST remain stable  
- identical structure and interpretation are assumed  
- differences indicate semantic divergence  

Tooling may add metadata outside the schema if excluded from hashing.

---

## 3. Schema Changes

Require version bump:

- adding/removing/reordering elements  
- changing meaning of fields  
- altering canonical ordering  
- changing normalization rules  
- introducing mandatory elements  

Do NOT require bump:

- internal representation changes  
- performance changes  
- excluded metadata  

---

## 4. Versioning Rules

Semantic versioning:

- MAJOR — not comparable  
- MINOR — backward compatible  
- PATCH — clarification only  

CI MUST reject mismatched major versions.

Migration must be explicit.

---

## 5. CI and Golden Certificates

Golden certificates bind to:

- inputs  
- initial state  
- trace schema version  

Schema changes invalidate existing certificates.

---

## 6. Forward Evolution

Schema changes must be deliberate, not accidental.

This document defines a stable contract required for:

- auditability  
- reproducibility  
- counterfactual reasoning  

---

**End of schema definition**
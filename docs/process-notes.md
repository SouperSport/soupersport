# Process Notes

This document records notable process‑level issues, decisions, failures,
and deliberate course corrections made during the evolution of the
SouperSport project.

It exists to preserve reasoning and context without distorting the core
design narrative, rewriting history, or overloading foundational
documentation.

This file is intended to answer the question:

“What happened, what did we learn, and why did we choose not to hide it?”

---

## Terminology Transition: Gate vs Phase

Early in the project, the term **Gate** was used inconsistently to refer
to both internal enforcement checkpoints and major conceptual milestones.

During Phase 10, the project standardized on the term **Phase** as the
canonical label for high‑level conceptual progress.

The term **Gate** is now reserved exclusively for internal mechanisms
such as CI enforcement boundaries or verification checkpoints.

Earlier commits, CI logs, and enforcement history may continue to
reference **Gate** when referring to milestones. These references have
not been rewritten.

This was a deliberate decision to preserve an accurate and auditable
record of how the project evolved, even where earlier terminology was
imperfect.

All future project documentation and milestone references use **Phase**
as the canonical term, unless a document’s purpose is explicitly
historical or comparative.

---

## CI Incident: Determinism Certificate Gate #7 Failure

On April 20, during development of determinism and provenance
enforcement, the following CI run failed:

- Enforce sealed inputs, golden certificates, and counterfactual
  equivalence in CI
- Determinism Certificate Gate #7
- Commit: `a1109ee`
- Outcome: Failure

This failure occurred during a period of rapid iteration on CI
enforcement logic, when strict guarantees were introduced before
surrounding process and documentation were fully stabilized.

The failure exposed fragility in enforcement sequencing rather than
semantic unsoundness in the underlying goals.

Subsequent commits refined enforcement boundaries, clarified update
policies, and improved separation between conceptual progress and
mechanical tooling.

The failure was not retroactively corrected, suppressed, or rewritten.

It is preserved as part of the project’s history and informed later
decisions about pacing, documentation discipline, and phase separation.

---

## Documentation Text Format Standardization

At a later stage of project maturation, the documentation set underwent
a deliberate **text format standardization pass**.

Earlier documents contained defensive escaping and formatting artifacts
introduced by prior authoring contexts. While technically valid, these
artifacts reduced readability and made human review more difficult.

As part of this standardization:

- Unnecessary escape characters were removed.
- Markdown formatting was normalized for clarity and consistency.
- No semantic wording, obligations, or guarantees were changed.

This was a **presentation‑only change**, not a semantic revision.

---

## Documentation Index Creation

Once the public documentation set stabilized semantically and
presentation issues were resolved, a **documentation index** was added
to the project.

The purpose of the index is to:

- provide an intended reading order for human readers,
- distinguish between semantic authority, explanatory material, and
  phase‑scoped decision records,
- reduce ambiguity about how documents relate to one another.

The index is explicitly **non‑normative**. It does not:

- introduce semantic meaning,
- confer authority,
- alter the interpretation of any document.

Semantic authority remains defined solely within the documents
themselves.

The index exists only to improve human navigation and comprehension and
may be updated as documentation evolves without constituting a semantic
change.

---

## Normative vs Phase‑Scoped Document Clarification

During the same pass, documents were explicitly distinguished by role:

**Timeless semantic authority documents** (for example, semantic laws,
the semantic target, trace definitions, and conformance policies) were
treated as **phase‑neutral** reference artifacts. Phase identifiers were
removed where they risked conflating project sequencing with semantic
meaning.

**Phase‑scoped analysis and decision documents** (for example,
representation comparisons, reference execution selection, and execution
sketching) intentionally retain phase notation, as their purpose is to
record decision order, alternatives considered, and sequencing context.

This distinction was made explicit to ensure that:

- semantic meaning remains stable and timeless,
- project history remains auditable,
- future readers can distinguish constitutional rules from decision
  records.

---

## Preservation Principle

When inconsistencies, failures, or early missteps are identified, the
project follows these principles:

- Forward correction instead of historical rewriting
- Explicit documentation instead of silent fixes
- Auditability instead of cosmetic cleanliness

This principle reflects the project’s emphasis on explicit reasoning,
traceability, and semantic integrity.
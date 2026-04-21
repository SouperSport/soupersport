Process Notes

This document records notable process-level issues, decisions, failures, and

deliberate course corrections made during the evolution of the SouperSport

project.

It exists to preserve reasoning and context without distorting the core design

narrative, rewriting history, or overloading foundational documentation.

This file is intended to answer the question:

“What happened, what did we learn, and why did we choose not to hide it?”



Terminology Transition: Gate vs Phase

Early in the project, the term “Gate” was used inconsistently to refer to both

internal enforcement checkpoints and major conceptual milestones.

During Phase 10, the project standardized on the term “Phase” as the canonical

label for high-level conceptual progress.

The term “Gate” is now reserved exclusively for internal mechanisms such as

CI enforcement boundaries or verification checkpoints.

Earlier commits, CI logs, and enforcement history may continue to reference

“Gate” when referring to milestones. These references have not been rewritten.

This was a deliberate decision to preserve an accurate and auditable record

of how the project evolved, even where earlier terminology was imperfect.

All future project documentation and milestone references use “Phase” as the

canonical term.



CI Incident: Determinism Certificate Gate #7 Failure

On April 20, during development of determinism and provenance enforcement,

the following CI run failed:

Enforce sealed inputs, golden cert, and counterfactual equivalence in CI

Determinism Certificate Gate #7

Commit: a1109ee

Outcome: Failure

This failure occurred during a period of rapid iteration on CI enforcement

logic, when strict guarantees were introduced before surrounding process

and documentation were fully stabilized.

The failure exposed fragility in enforcement sequencing rather than semantic

unsoundness in the underlying goals.

Subsequent commits refined enforcement boundaries, clarified update policies,

and improved separation between conceptual progress and mechanical tooling.

The failure was not retroactively corrected, suppressed, or rewritten.

It is preserved as part of the project’s history and informed later decisions

about pacing, documentation discipline, and phase separation.



Preservation Principle

When inconsistencies, failures, or early missteps are identified, the project

follows these principles:



Forward correction instead of historical rewriting

Explicit documentation instead of silent fixes

Auditability instead of cosmetic cleanliness



This principle reflects the project’s emphasis on explicit reasoning,

traceability, and semantic integrity.


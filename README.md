# SouperSport

SouperSport is a programming language design project.

The project explores what can be achieved when a language is designed around
**explicit execution semantics**, **deliberate state transitions**, and
**constraints that favor reasoning over convenience**.

SouperSport exists to address common failures in complex systems:
hidden nondeterminism, irreproducible behavior, unsafe refactoring,
and the inability to explain why a change altered system behavior.

There is no implementation yet, and none is promised at this stage.
This repository captures early design foundations and guiding decisions.

## Status

SouperSport is currently in **Phase 10: Narrative Stabilization**.

This phase focuses on:
- clarifying core constraints and binding non-goals
- establishing a clear and explainable execution model
- aligning introductory documentation with settled design decisions
- resisting premature commitments to syntax, tooling, or implementation

Structural changes during this phase are expected and intentional.

SouperSport is **not** intended to be:
- a general-purpose scripting language
- a frontend language
- a drop-in replacement for existing ecosystems such as JavaScript or Python

## What exploring SouperSport currently means

At this stage, working with SouperSport primarily involves reasoning about:
- deterministic regions of execution
- explicit boundaries where nondeterminism is allowed
- visible and intentional state transitions
- provenance-aware explanations of behavior
- counterfactual and rewind-style reasoning

These concepts form the intended **first-hour experience**, even before any
executable tooling exists.

## Contents

- `docs/foundations.md` — binding design constraints and non-goals
- `CURRENT-STATE.md` — authoritative project status and frozen decisions
- `reminders.md` — durable workflow and interaction assumptions
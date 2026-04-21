# SouperSport

SouperSport is a programming language design project.

The project explores what can be achieved when a language is designed around
**explicit execution semantics**, **deliberate state transitions**, and
**constraints that favor reasoning over convenience**.

**SouperSport exists to address failures common in complex systems: hidden
nondeterminism, irreproducible behavior, unsafe refactoring, and the inability
to explain why a change altered system behavior.**

There is no implementation yet, and none is promised at this stage.
This repository captures early design foundations and guiding decisions.

## Status

SouperSport is in an **exploratory design phase**.

This phase focuses on:
- identifying core constraints and explicit non-goals
- establishing a clear execution and state-transition model
- defining what must be refused or made explicit to preserve correctness
- resisting premature commitments to syntax or implementation

Structural changes are expected and intentional.

**SouperSport is not intended to be a general-purpose scripting language,
a frontend language, or a drop-in replacement for existing ecosystems such as
JavaScript or Python.**

## What exploring SouperSport currently means

At this stage, working with SouperSport primarily involves reasoning about:
- deterministic regions of execution
- explicit boundaries where nondeterminism is allowed
- provenance-backed reasoning about state changes
- counterfactual and rewind-style explanations of behavior

These concepts form the intended *first-hour experience*, even before any
executable tooling exists.

## Contents

- `docs/foundations.md` — core design constraints and commitments

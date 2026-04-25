# Tutorial — Your First Deterministic Region

This tutorial demonstrates three SouperSport commitments:

1) **Sealed input**: nondeterministic values become declared inputs at a boundary.  
2) **Deterministic evaluation**: same input and state produce the same output and trace.  
3) **Explicit outcomes**: errors and early exits are explicit control flow.

**Note:** The code below is illustrative pseudocode to teach the model.
It is not final syntax.

---

## Step 1 — Obtain Data Outside Deterministic (Nondeterministic Region)

Example sources include:
- user input,
- network responses,
- current time,
- randomness.

The key requirement is:

**Do this outside deterministic execution**, and then **seal** the result.

---

## Step 2 — Seal the Input

Sealing means:

- canonical representation (locale‑independent),
- normalized text or structured data,
- stable byte‑level form.

---

## Step 3 — Evaluate Deterministically

Inside Deterministic, computation is a pure function of:

- declared sealed inputs,
- declared initial state.

Example (pseudocode model):

- Input: a sealed string `amount`
- Output: either a parsed numeric value or an explicit error outcome

---

## Step 4 — Explicit Outcomes (Semantic Law #2)

Errors are control flow, not hidden exceptions.
They must be explicit and traceable.

The deterministic region produces:

- an output value, or
- an explicit error outcome,
- plus a trace that can be replayed.

---

## What You Should Be Able to Do

- Rerun with the same sealed input and same initial state ⇒ identical output and trace.
- Change input ⇒ deterministic change in output and trace.
- Compare traces in tooling or CI to catch regressions.
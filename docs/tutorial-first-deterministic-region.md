# Tutorial — Your First Deterministic Region

---

## What You Will Learn

This tutorial introduces the core execution model of SouperSport.

You will see how:

- nondeterministic input is isolated  
- deterministic execution is enforced  
- outcomes are explicit and traceable  

This example focuses on behavior, not syntax.

---

## Step 1 — Obtain Data Outside Deterministic

Deterministic execution cannot observe external systems directly.

Collect nondeterministic data outside execution, such as:

- user input  
- network responses  
- time  
- randomness  

---

## Step 2 — Seal the Input

Sealing converts data into a canonical, reproducible form.

This includes:

- standardized encoding  
- normalized structure  
- stable representation  

After sealing, the value becomes a declared input.

---

## Step 3 — Evaluate Deterministically

Execution is a pure function of:

- sealed inputs  
- initial state  

Example:

- Input: a string amount  
- Output:
  - parsed number  
  - or explicit error  

No external influence is permitted.

---

## Step 4 — Explicit Outcomes

Errors are control‑flow events.

Execution produces:

- a value OR  
- an explicit error  

Each execution also produces a trace.

---

## What You Can Do Now

You should be able to:

- rerun → identical output and trace  
- change input → predictable change  
- compare traces → detect divergence  

---

## Key Takeaway

Determinism is enforced by:

- isolating nondeterminism  
- sealing inputs  
- eliminating hidden influence  

Execution becomes:

- replayable  
- explainable  
- reliable

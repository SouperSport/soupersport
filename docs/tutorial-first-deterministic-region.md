\# Tutorial — Your First Deterministic Region



This tutorial demonstrates three SouperSport commitments:



1\) \*\*Sealed input\*\*: nondeterministic values become declared inputs at a boundary.  

2\) \*\*Deterministic evaluation\*\*: same input/state ⇒ same output/trace.   

3\) \*\*Explicit outcomes\*\*: errors and early exits are explicit control flow.   



> Note: The code below is illustrative pseudocode to teach the model.

> It is not final syntax.



\## Step 1 — Obtain data outside Deterministic (nondeterministic region)



Example: user input, network response, current time, randomness.



The key requirement is: \*\*do this outside deterministic execution\*\* and then \*\*seal\*\* it.



\## Step 2 — Seal the input



Sealing means:

\- canonical representation (locale independent),

\- normalized text/structured data,

\- stable byte-level form. 



\## Step 3 — Evaluate deterministically



Inside `Deterministic`, computation is a pure function of:

\- declared sealed inputs,

\- declared initial state. 



Example (pseudocode):



\- Input: a sealed string amount

\- Output: either a parsed numeric value or an explicit error outcome



\## Step 4 — Explicit outcomes (Law #2)



Errors are control flow, not hidden exceptions. They must be explicit and traceable. 



The deterministic region produces:

\- output value, or

\- explicit error outcome,

\- plus a trace that can be replayed.



\## What you should be able to do



\- rerun with same sealed input + same initial state ⇒ identical output/trace

\- change input ⇒ deterministic change in output/trace

\- compare traces in tooling/CI to catch regressions


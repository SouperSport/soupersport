\# Semantic Law #2 — Explicit Control Flow



\---



\## Statement (binding)



All control flow that affects semantic outcome MUST be:



\- explicit  

\- representable  

\- traceable  



This includes:



\- branching  

\- iteration  

\- concurrency and synchronization  

\- error propagation  

\- goal or search selection  

\- early termination  



Control flow must be structurally local.



It must not:



\- depend on implicit behavior  

\- rely on hidden state  

\- bypass declared structure  

\- alter outcome without trace representation  



Errors are control‑flow events.



They must be:



\- explicitly represented  

\- deterministically propagated  

\- visible in state and trace  



\---



\## Definitions



\*\*Control flow\*\*



Mechanisms determining execution structure and ordering.



\---



\*\*Explicit control flow\*\*



Control flow that is:



\- visible in structure  

\- traceable in execution  

\- attributable to declared rules  



\---



\## Prohibitions



Illegal if they affect outcome:



\- implicit control flow  

\- hidden state‑dependent flow  

\- structure bypass  

\- untraceable outcome changes  



\---



\## Relationship to other concepts



\- Deterministic replayability requires explicit control flow  

\- Traces include control decisions  

\- Lack of explicitness results in refusal  



\---



\## Design consequence



If control flow cannot be explicit:



\- it must be redesigned  

\- or isolated outside deterministic regions  



There is no implicit control flow in SouperSport.


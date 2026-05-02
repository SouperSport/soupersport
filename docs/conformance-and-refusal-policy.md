\# Conformance and Refusal Policy



\---



\## Status and Purpose



This document defines:



\- what it means to claim conformance  

\- how refusal is treated  

\- the structure and guarantees of both  



It prevents:



\- unofficial semantic interpretation  

\- tool-driven redefinition of meaning  

\- divergence across implementations  

\- ambiguity in acceptable behavior  



\---



\## Conformance Claims



\---



\### Binary Nature



Conformance is binary:



\- either conformant  

\- or not  



There is no graded or partial conformance.



\---



\### Scope-Limited Conformance



A system may limit its supported scope.



Within that scope:



\- all semantic rules apply fully  

\- all requirements must be satisfied  

\- refusal is required where guarantees fail  



Outside that scope:



\- the system must refuse  

\- silence is not allowed  



\---



\### Invalid Claims



A system must not claim conformance if it:



\- omits required artifacts  

\- substitutes heuristics  

\- degrades under constraints  

\- invents or suppresses refusal  

\- executes without explanation  



\---



\## Refusal as a Semantic Result



\---



\### Definition



Refusal is a semantic outcome.



It indicates:



\- illegality, or  

\- unprovability  



It is not an error condition.



\---



\### Required Conditions



A system must refuse if it cannot:



\- establish legality  

\- enforce semantic rules  

\- construct required artifacts  

\- provide explanations  

\- maintain determinism  



Continuing execution is non‑conformant.



\---



\## Refusal Structure



Every refusal must include:



\- identification as refusal  

\- the rule or boundary involved  

\- contextual explanation  



\---



\### Classification



Refusal classifications:



\- may be structured  

\- may be identified  

\- may be versioned  



But must not:



\- redefine legality  

\- weaken semantics  



Text explanation is always sufficient.



\---



\### Stability



Refusal meaning must be:



\- semantically stable  

\- attributable to rules  



Exact wording may vary.



\---



\## Tooling and Testing



Tools may:



\- observe  

\- validate  

\- assert expectations  



They may not:



\- define legality  

\- override refusal  

\- reinterpret results  



\---



\## Non‑Goals



This document does not define:



\- error codes  

\- formats  

\- UX  

\- testing approaches  



\---



\## Closing Rule



If a system cannot clearly state:



\- outcome  

\- reason under semantic rules  



it must not claim conformance.


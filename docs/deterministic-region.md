\# Deterministic Region



\---



\## Purpose



This document defines what a Deterministic region is and what it requires.



It centralizes the concept so it is not only implied across other documents.



This document does not add new laws.



It restates required meaning in one place.



\---



\## Definition



A \*\*Deterministic region\*\* is a declared execution context in which:



\- evaluation is a pure function of declared inputs and declared initial state  

\- identical inputs and initial state produce identical output and identical trace  

\- any illegal influence causes refusal  



Determinism is not a statistical claim.



It is an enforceable semantic guarantee.



\---



\## Requirements



A Deterministic region requires:



\- explicitly declared inputs  

\- explicitly declared initial state (or explicit statement that none exists)  

\- explicit execution structure and dependencies where ordering affects meaning  

\- stable iteration behavior  

\- stable error behavior  

\- numeric determinism constraints where numeric behavior influences meaning  



\---



\## Forbidden Influences



Within a Deterministic region, the following are illegal unless explicitly

modeled as declared input or declared state:



\- ambient time  

\- randomness or entropy  

\- external I/O  

\- environment variables  

\- locale or timezone  

\- unspecified iteration order  

\- scheduler-dependent concurrency  



If any forbidden influence affects meaning, the region is illegal.



\---



\## Boundary Sealing



Deterministic execution must not observe nondeterminism directly.



Nondeterministic values may influence deterministic computation only if:



\- obtained outside the deterministic region  

\- sealed into canonical form  

\- introduced as declared inputs at an explicit boundary  



The deterministic trace begins at the point where:



\- sealed inputs are fixed  

\- initial state is fixed  



\---



\## Relationship to Refusal



If determinism is claimed but cannot be upheld:



\- refusal is required  



Executing anyway is non-conformant.



\---



\## Closing Rule



A Deterministic region is defined by enforceability.



If it cannot be enforced, it is not deterministic.


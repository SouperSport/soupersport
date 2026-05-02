\# Reference Execution



This document defines a canonical reference execution model.



\---



\## Purpose



The reference execution defines:



\- how meaning is interpreted  

\- how correctness is judged  



It establishes a single standard.



\---



\## 1. Role



The reference execution:



\- preserves semantic commitments  

\- provides a correct interpretation  

\- serves as comparison baseline  



It is not optimized or user-facing.



\---



\## 2. Chosen Model



Execution is graph‑based:



\- nodes = steps  

\- edges = dependencies  

\- transitions = labeled changes  



Ordering follows dependencies.



\---



\## 3. Justification



\### State



\- explicit  

\- attributable  



\---



\### Ordering



\- dependency-driven  

\- partial ordering  



\---



\### Trace



\- derived from graph  

\- supports replay and explanation  



\---



\### Counterfactuals



\- modify graph  

\- observe impact  



\---



\## 4. Rejected Models



Rejected due to:



\- over-ordering  

\- hidden steps  

\- abstraction of causality  



\---



\## 5. Non‑Implications



This does not define:



\- syntax  

\- runtime  

\- storage  

\- optimization  



\---



\## Status



A canonical interpretation model is now defined.



All implementations must preserve it.


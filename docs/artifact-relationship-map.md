\# Artifact Relationship Map



\---



\## Purpose



This document defines how SouperSport semantic artifacts relate to one another.



It makes explicit:



\- what artifacts exist  

\- how they depend on one another  

\- where semantic identity is established  

\- what is verified during execution  



This document does not introduce new semantics.



It clarifies relationships required by existing definitions.



\---



\## Core Artifacts



A deterministic execution depends on or produces:



\- declared inputs (canonical and sealed)  

\- declared initial state (or explicit absence)  

\- semantic execution trace  

\- resulting state (if execution succeeds)  

\- execution outcome (success or refusal)  

\- provenance payload  

\- optional signature over provenance  



Each artifact participates in defining execution meaning.



\---



\## Relationship Overview



The relationship between artifacts is:



Declared inputs and initial state define execution.



Execution produces:



\- trace  

\- outcome  

\- resulting state (if any)



Provenance binds the identities of all semantic artifacts.



A signature (if present) protects the provenance.



\---



\## Dependency Order



Artifacts depend on one another in this order:



Declared inputs and initial state  

→ evaluation  

→ trace, outcome, resulting state  

→ provenance payload  

→ signature (optional)



Each step depends on the correctness of the previous step.



\---



\## Declared Inputs



Declared inputs:



\- must be explicit  

\- must be canonical  

\- must fully determine execution  



They are identified by a stable identity (for example, an input hash).



All downstream artifacts depend on inputs.



\---



\## Initial State



Initial state:



\- must be explicit if present  

\- must be reproducible  

\- is part of execution input  



If no initial state exists, that absence must be explicit.



Initial state also has an identity.



\---



\## Evaluation Output



Evaluation produces:



\- execution outcome  

\- semantic trace  

\- resulting state (if successful)



These define what actually happened.



\---



\## Trace



The semantic trace:



\- defines execution structure  

\- records state transitions  

\- captures dependencies and causality  



It is part of program meaning.



The trace has a stable identity.



If trace identity changes, meaning has changed.



\---



\## Resulting State



If execution succeeds:



\- resulting state must be explicit  

\- must be reproducible  

\- must be attributable to inputs and trace  



If execution does not succeed, absence of state must be explicit.



\---



\## Execution Outcome



Execution outcome is exactly one of:



\- success  

\- refusal  



No other outcome exists.



Outcome is part of semantic identity.



\---



\## Provenance Payload



The provenance payload binds:



\- input identity  

\- initial state identity  

\- trace identity  

\- output or resulting state identity  

\- trace schema identity  

\- tool identity  

\- source context (if present)



Provenance defines a complete, verifiable execution record.



If any bound identity changes, meaning changes.



\---



\## Signature



A signature may be applied to the provenance payload.



The signature provides:



\- authenticity  

\- tamper evidence  

\- attribution  



The signature protects meaning but does not define it.



\---



\## Golden Artifacts



Golden artifacts define expected identities.



They fix:



\- trace identity  

\- output identity (if applicable)  

\- provenance relationships  



Rules:



\- must not change unintentionally  

\- must only change through deliberate semantic change  

\- must be updated explicitly  



If a golden artifact changes, meaning has changed.



\---



\## Logs vs Artifacts



Logs may display execution details.



Logs are not semantic artifacts.



Artifacts must be:



\- explicit  

\- durable  

\- verifiable  



If something is not captured in artifacts, it is not part of meaning.



\---



\## Verification



Verification operates on artifacts.



Verification checks:



\- identity consistency  

\- schema compatibility  

\- provenance correctness  

\- determinism guarantees  



Verification does not interpret behavior.



It validates artifacts.



\---



\## Closing Rule



Artifacts define truth.



Relationships define how truth is constructed.



If relationships break, meaning is invalid


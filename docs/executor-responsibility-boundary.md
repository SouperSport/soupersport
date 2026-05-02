\# Executor Responsibility Boundary



\---



\## Purpose



This document defines what a SouperSport executor MUST do, MAY do,

and MUST NOT do.



It exists to prevent semantic authority drift into:



\- CI scripts  

\- tooling  

\- orchestration layers  

\- convenience wrappers  



The executor is responsible for semantic truth.



Other systems may verify or present that truth.



\---



\## Definitions



\*\*Executor\*\*



The component that evaluates declared inputs and declared initial state

under SouperSport semantic rules and produces semantic artifacts.



\*\*Verifier\*\*



A component that checks emitted artifacts for correctness and stability

but does not define meaning.



\*\*Orchestration\*\*



Non-authoritative wiring: invoking the executor, collecting artifacts,

displaying results, running CI.



\---



\## MUST (Executor Requirements)



The executor MUST:



\- accept declared inputs and declared initial state as the basis of evaluation  

\- enforce deterministic replayability when determinism is claimed  

\- refuse rather than guess when legality or guarantees cannot be upheld  

\- produce required semantic artifacts for every execution attempt  

\- ensure artifacts are durable and verifiable (not log-only)  

\- ensure canonical hashing is stable and reproducible  

\- ensure trace meaning matches the trace definition and schema identity  



If the executor cannot satisfy obligations, it must refuse.



\---



\## MUST NOT (Hard Prohibitions)



The executor MUST NOT:



\- consult ambient environment (time, randomness, external I/O) during deterministic execution  

\- infer missing inputs or invent defaults  

\- “best-effort” execute when legality is unknown  

\- hide uncertainty or convert refusal into an error substitute  

\- depend on scheduler behavior or unspecified ordering  

\- encode semantic meaning in orchestration conventions  

\- treat logs as authoritative semantic artifacts  



Semantic output must be artifact-based, not narrative-based.



\---



\## MAY (Allowed Flexibility)



The executor MAY:



\- support a limited scope of features  

\- refuse outside that scope  

\- emit tooling-only metadata explicitly excluded from hashing  

\- provide multiple observability profiles, if meaning is unchanged  



Any optional behavior must not alter semantic meaning.



\---



\## Artifacts (Minimum Expectations)



On successful execution, the executor produces:



\- a semantic trace artifact  

\- a provenance payload binding inputs, state, outputs, and trace identity  



On refusal, the executor produces:



\- an explicit refusal outcome  

\- an explanation sufficient to identify the violated rule or boundary  

\- provenance (if required by your contract or CI discipline)  



The executor must never produce ambiguous outcomes.



\---



\## Role of CI and Tooling



CI and tooling:



\- may verify  

\- may fail loudly  

\- may enforce immutability boundaries  



They must never:



\- define legality  

\- simulate semantic execution  

\- override executor refusal  

\- reinterpret meaning  



If CI behavior conflicts with executor-emitted artifacts, the executor is the authority.



\---



\## Closing Rule



Semantic authority belongs in the executor.



Everything else is a verifier or a presenter.



If any other component becomes the authority, the system is off-track.


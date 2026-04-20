\# SouperSport - Design Foundations



This document captures the constraints that guide SouperSport's design.

They are not features. They exist to limit the design space so reasoning

remains tractable as the language evolves.



If a future idea violates one of these foundations, the violation should

be explicit and justified.



\## 1. Explicit execution



Execution order must be representable and reasoned about without relying

on convention, folklore, or implicit rules.



If something happens, it should be possible to explain:

\- when it happens

\- why it happens

\- what it depends on



\## 2. State is visible and intentional



State transitions are first-class.



Hidden mutation, ambient state, and action at a distance are treated as

costs rather than conveniences.



When state changes, that change should be local in description and

difficult to perform accidentally.



\## 3. Composition over abstraction



SouperSport favors composition mechanisms that preserve understanding

over abstraction mechanisms that compress meaning.



If an abstraction makes reasoning harder than the thing it replaces,

it is likely out of scope.



\## 4. Small semantic surface



The language should aim for:

\- few core concepts

\- minimal special cases

\- uniform rules



Expressiveness should emerge from combination, not exception.



\## 5. Non-goals are binding constraints



SouperSport does not optimize for:

\- minimal keystrokes

\- syntactic cleverness

\- familiarity with existing languages



Readability to human reasoning and to compilers is prioritized over habit.


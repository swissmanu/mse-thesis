# Introduction

A program implemented in an imperative language (e.g., Fortran, Pascal, or C) modifies implicit state using side-effects, achieved with assignment and various flow control statements like `while` or `if` [@Hudak_1989]. With a declarative programming language, computational results (i.e., state) is carried explicitly from one unit of the program to the next [@Hudak_1989]. The source code of such a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually, whereas its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

The Functional (FP) as well as the Data-Flow Programming (DFP) paradigms belong to the family of declarative languages.

FP is based on the concept of expression evaluation: Flow control statements are replaced by recursive function calls and conditional expressions [@Hudak_1989]. Thus, a programs final outcome is the result of its full evaluation rather than its implicit state. With DFP, a program is modeled as a directed graph where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004].

Functional Reactive Programming (RP) combines FP and DFP, forming a new paradigm: Software engineers describe a data-flow graph using Domain Specific Languages (DSL) enabled by FP. DFP provides the execution model to process data using that graph accordingly.






- Background/Context
- Problem/Justification
- Research Questions
  - RQ 1 What challenges do software engineers face when debugging RxJS-based applications?
  - RQ 2 How can the experience of software engineers during the debugging process of RxJS-based applications be improved?
  - RQ 3 Is it feasible to implement the proposed solution in order to improve the debugging experience of software engineers?

- Structure of this thesis
- Open Science
  - Why?
  - Where?

# Related Work

- Main
	- Salvaneschi [@Salvaneschi_Mezini_2016]
	- Banken [@Banken_Meijer_Gousios_2018]
	- Alabor [@Alabor_Stolze_2020]
- Other sources which might be interesting, but did not make it into my own papers.
- More recent research/products since the latest paper?
	- https://www.replay.io
	- ... others?

# Research Process

- Find the right abstraction level for this section!
	- Necessary to go "deep"?
	- Keep bullets only?
	- Use some graphical representation of the process?
		- Timeline?
	- Highlight main aspects of different project phases:
		- HCI / UCD
		- Empirical Software Engineering

- Interviewes
- War stories
- Remote observational study
- *First paper published *[@Alabor_Stolze_2020]
- Sketching a solution
- Proof of concept extension
- Cognitive Walkthrough [@Wharton_Rieman_Clayton_Polson_1994]
- Prototype extension
- Remote user testing
- Prototype refinement
- Release first minor version of extension
  - nodejs
  - Log points for RxJS operator
- *Second paper published (hopefully)*
- Release first major version of extension

# Future Work

- Where to pick things up
- Sustainability of Work
	- Testing
	- Open Source Community
- Project ideas for other student contributors?

# Conclusion

- Recap
- Contributions


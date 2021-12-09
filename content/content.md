# Introduction

Debugging is an important part of a software engineers daily job. Various techniques, some better suited for the task than others, help engineers to explore the functionality of an unknown program. Rather traditional debugging is done by the interpretation of memory dumps or the analysis of log entries.  Modern debugging solutions hook into a program at runtime and allow more involved inspection and control.

Imperative programming languages like Java, C#, or Python dominated the mainstream software engineering industry over the last decades [@CITE]. Because of the prevalence of imperative programming langugaes, integrated development environments (IDE) like Eclipse, Idea, or Visual Studio provide specialized debugging utilities specifically tailored to imperative programming languages. This results in an excellent, fully integrated developer experience, where tool supported debugging is only one or two clicks away.

This experience degrades rapidly when software engineers start using programming languages and tools based on different programming paradigms. Because traditional debugging utilities apparently cannot provide answers to what engineers are interested in, engineers tend to use simpler debugging techniques instead.

Within the scope of my master studies research, I examined the necessity of paradigm-specific debugging utilities, when software engineers debug programs based on RxJS, a functional reactive programming library for JavaScript. During my research, I explored how professionals debug RxJS programs, what tools and techniques they employ, and why most of them prefer to use print statements instead of specialized debugging utilities. In doing so, I identified a key factor for the success of a debugging tool: It needs to be "ready to hand", or its users will not use it at all.

Based on the premise of "readiness to hand", I developed a practical debugging tool for reactive programming with RxJS, which makes manual print statements in this context obsolete. 

TODO

This debugger was developed using an iterative, user-centered design process, which ensures  A usability inspection and a usability test The resulting extension integrates with Visual Studio Code and provides a proof by existence o

In this summative thesis, 






## Programming Paradigms

A program implemented in an imperative language (e.g., Java or C#) modifies implicit state using side-effects, achieved with assignment and various flow control statements like `while` or `if` [@Hudak_1989]. With a declarative programming language, computational results (i.e., state) are carried explicitly from one unit of the program to the next [@Hudak_1989]. The source code of such a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually, whereas its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

The Functional (FP) as well as the Data-Flow Programming (DFP) paradigm belongs to the family of declarative languages.

FP languages (e.g., Haskell or Erlang) are based on the concept of expression evaluation: Flow control statements are replaced with recursive function calls and conditional expressions [@Hudak_1989]. Thus, a programs final outcome is the result of its full evaluation rather than its implicit state. With DFP, a program is modeled as a directed graph where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004].

Functional Reactive Programming (RP) combines FP and DFP, forming a new paradigm: Software engineers describe a data-flow graph using Domain Specific Languages (DSL) enabled by FP. DFP provides the execution model to process data using that graph accordingly. These two components are often not part of programming languages themselves and are provided as libraries  instead (e.g., REScala for Scala or RxJS for JavaScript).

## Debugging Concepts

Debuggers traditionally part of modern IDE's are meant to work with an interpret imperatively implemented programs. 




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

- Interviews
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
- Second paper submitted to ICSE, got rejected. See appendix for full review.
- Release first major version of extension
	- Webpack support

# Future Work



## Sustainability of Work


- Where to pick things up
- Sustainability of Work
	- Testing
	- Open Source Community
- Project ideas for other student contributors?

# Conclusion

- Recap
- Contributions


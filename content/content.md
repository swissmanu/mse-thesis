# Introduction

Debugging is an important part of a software engineers daily job. Various techniques, some better suited for the task than others, help engineers to explore the functionality of an unknown program. Rather traditional debugging is done by the interpretation of memory dumps or the analysis of log entries.  Modern debugging solutions hook into a program at runtime and allow more involved inspection and control.

Imperative programming languages like Java, C#, or Python dominated the mainstream software engineering industry over the last decades [@CITE]. Because of the prevalence of imperative programming languages, integrated development environments (IDE) like Eclipse, Microsoft Visual Studio, or the JetBrains IDE platform provide specialized debugging utilities specifically tailored to imperative programming languages. This results in an excellent, fully integrated developer experience, where tool supported debugging is only one or two clicks away.

This experience degrades rapidly when software engineers start using programming languages and tools based on different programming paradigms. Because traditional debugging utilities apparently cannot provide answers to what engineers are interested in, engineers tend to use simpler debugging techniques instead.

Within the scope of my master studies research, I examined the necessity of paradigm-specific debugging utilities, when software engineers debug programs based on RxJS^[https://rxjs.dev/], a functional reactive programming library for JavaScript. During my research, I explored how professionals debug RxJS programs, what tools and techniques they employ, and why most of them prefer to use print statements instead of specialized debugging utilities. In doing so, I identified a key factor for the success of a debugging tool: It needs to be "ready to hand", or its users will not use it at all.

Based on the premise of "readiness to hand", I developed a practical debugging tool for reactive programming with RxJS, which makes manual print statements in this context obsolete.

In this summative thesis, I consolidate my research results documented and published in two research papers. I will complete this introduction with an overview on relevant programming paradigms, the specific debugging challenges they carry, and a glance on reactive programming with RxJS. Relevant work will be discussed in [@sec:related-work], followed by an overview on the full research process and its results in [@sec:research-process]. [@sec:future-work] presents a list of opportunities for future work and highlights provisions taken to ensure sustainability of the demonstrated results. Before the reader is left with the study of the research papers in the appendix, I will wrap up on the topic of debugging support for reactive programming with RxJS in [@sec:conclusion].

## Programming Paradigms

A program implemented in an imperative language (e.g., Java or C#) modifies implicit state using side-effects, achieved with assignment and various flow control statements like `while` or `if` [@Hudak_1989]. With a declarative programming language, computational results (i.e., state) are carried explicitly from one unit of the program to the next [@Hudak_1989]. The source code of a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually, whereas its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

```{.include}
content/figures/paradigm-taxonomy.tex
```

The Functional (FP) as well as the Data-Flow Programming (DFP) paradigm belongs to the family of declarative languages.

FP languages (e.g., Haskell or Erlang) are based on the concept of expression evaluation: Flow control statements are replaced with recursive function calls and conditional expressions [@Hudak_1989]. Thus, a programs final outcome is the result of its full evaluation rather than its implicit state. With DFP, a program is modeled as a directed graph where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004]. Examples for DFP can be found in visual programming environments like Node-RED^[https://nodered.org/].




NEEDS A REVISION! FRP !== RP



Functional Reactive Programming (FRP) [@Wan_Hudak_2000] combines FP and DFP in order to describe Software engineers describe a data-flow graph using Domain Specific Languages (DSL) enabled by FP. DFP provides the execution model to process data using that graph accordingly. These two components are often not integrated within a programming language itself. Instead, optional libraries (e.g., REScala for Scala [@Salvaneschi_Hintz_Mezini_2014] or RxJS for JavaScript) provide FRP functionality to them.

## Debugging Concepts




## Reactive Programming with RxJS

RxJS is the JavaScript-based implementation of the ReactiveX API specification. The core concept of this API, the *Observable*, is "[..] a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming"[@reactivex]. Like the Observer pattern [@gof], is the *Observable* an abstraction for notifying observers about changed state of the subject.



# Related Work {#sec:related-work}

- Main
	- Salvaneschi [@Salvaneschi_Mezini_2016]
	- Banken [@Banken_Meijer_Gousios_2018]
	- Alabor [@Alabor_Stolze_2020]
- Other sources which might be interesting, but did not make it into my own papers.
- More recent research/products since the latest paper?
	- https://www.replay.io
	- ... others?


# Research Process {#sec:research-process}

```{.include}
content/figures/research-process.tex
```

The iterative research process follows the principles of empirical software engineering and applies methods of the user-centered design approach. Its results are documented in two research papers. The process is structured in four distinct phases: (i) Exploration, (ii) Proof of Concept (PoC), (iii) Prototype, and (iv) Finalize. This section gives an overview of every stage, presents the most important insights, and lists the developed artifacts.

```{.include}
content/tables/artifact-overview.tex
```

## Exploration

The Exploration phase was all about empirical software engineering. Based on the data collected from five informal interviews and the sentiment of five written "war story" reports, I set up a remote observational study with four subjects. The study was designed to verify what kind of debugging tools and techniques the subjects actually use when being confronted with an unknown, malfunctioning RxJS program. As shown in [@fig:result-observational-study], all of the subjects used manual code modifications (i.e., print statements) to understand the behavior of the presented problems. Over the half of them tried to use a traditional, imperative debugger. It was surprising that, even though two subjects stated to know about specialized RxJS debugging tools, none of them used such during the study.

```{.include}
content/figures/result-observational-study.tex
```

The results of the interviews, the analysis of the war story reports, and the interpretation of the observed behaviors during the observational study combined lead to the following two key take-aways:

1. The most significant challenge software engineers face when debugging RxJS-based programs, is to know *when* they should apply *what* tool to resolve their current problem in the *most efficient way*
2. Can one find a way to improve the developer experience by providing RxJS-specific debugging utilities where software engineers expect them the most, ready to hand, and fully integrated, with their IDE?

The main artifact produced during the Exploration phase is the research paper "Debugging of RxJS-Based Applications," [@Alabor_Stolze_2020] published with the proceedings of the 7th ACM SIGPLAN International Workshop
on Reactive and Event-Based Languages and Systems (REBLS '20) and available in [Appendix @sec:paper-1].

## Proof Of Concept

Based on the learnings from the first phase, I started to compile ideas to help software engineers in the process of debugging RxJS programs. It was essential that a potential solution:

1. Integrates with an IDE
2. Requires minimal to no additional learning effort for its users

Imperative debuggers provide log points, a utility to print a log statement once the program execution processes as specific statement in the source code. I adopted this established concept and transferred it to the world of RP with RxJS: An *operator log point*, enabled for a specific operator in an Observables `pipe` shows in realtime, when related operator emits relevant events. I did a PoC implementation in form of an extension to Microsoft Visual Studio Code (vscode). To verify that the PoC actually solves the problem of manual code modifications in order to debug RxJS programs, I used a cognitive walkthrough [@Wharton_Rieman_Clayton_Polson_1994] ([Appendix @sec:paper-2-supplementary]). Further, I created a user journey comparing the debugging workflow with and without the PoC debugging extension (see [Appendix @sec:user-journey]).

Using the two inspection methods, I could successfully verify that operator log points fulfill the requirements stated at the beginning of this section. The cognitive walkthrough further revealed several usability issues as documented in [Appendix @sec:paper-2-supplementary]. These results provided valuable input for the upcoming Prototype phase.

## Prototype

After I had confidence in the concept of operator log points, I started to rebuild the PoC debugging extension from ground up focusing on functionality, maintainability, and extensibility. This resulted in the v0.1.0 release of "RxJS Debugging for Visual Studio Code" [@rxjs-debugging], the first fully integrated RxJS debugger for vscode.

The initial version of the extension enables engineers to debug RxJS-based applications running with Node.js. There are no additional setup steps necessary: Once the extension is installed, it suggests operator log points with a small, diamond-shaped icon next to the respective operator. The engineer launches their application using the built-in JavaScript debugger. By doing so, the RxJS debugger augments RxJS automatically to provide life-cycle events to vscode. The extension displays these life-cycle events for operators having an enabled log point in-line with the operator in the source code editor.

TODO Screenshot of Prototype

There were various interesting challenges and tasks to solve during the Prototype phase. The following two sub-sections present two highlights.

### Communicate with Node.js

One of the biggest challenges during the Prototype phase was to build a reliable way to communicate with RxJS running in Node.js. I used a WebSocket to exchange messages with the JavaScript runtime in the PoC. This proofed to be tedious in multiple was (e.g., how can the extension know the host and/or port where the WebSocket is running, or what if network infrastructure prevents WebSocket connections etc.) and so I wanted to replace this key element in my system.

One of my main goals was to integrate the RxJS debugger with already known debugging tools seamlessly. What if I would not reuse only established UX patterns, but also already established communication ways? vscode-js-debug^[https://github.com/microsoft/vscode-js-debug], vscodes built-in JavaScript debugger, uses the Chrome DevTools Protocol^[https://chromedevtools.github.io/devtools-protocol/] (CDP) to communicate with arbitrary JavaScript runtimes. Unfortunately, vscode-js-debug did not offer its CDP connection to be reused by other extensions. I contributed this particular functionality to the project, which then was released with vscodes April 2021 [@vscode-cdp] release officially.

Now that vscode-js-debug provides a way to reuse its CDP connection, my extension did no longer rely on any extraneous communication channels in order to exchange messages with the JavaScript runtime. A welcome side-effect of using CDP is that the RxJS debugger requires minimal integration efforts to support additional JavaScript runtimes, as long as they support CDP as well.

A complete overview of the system components and communication channels is available in [@fig:architecture].

```{.include}
content/figures/architecture.tex
```

### Moderated Remote Usability Test

Once I got the main elements of the new debugger working, I conducted a remote usability test with three subjects. The goals of this study were (i) to verify that the operator log point utility can replace manual print statements in an actual programming scenario, (ii) to identify usability issues not detected during development, and (iii) to collect feedback and ideas for the prototype and its further development.

All three goals were successfully verified: No subject used manual print statements during the test sessions. Further, 10 usability issues were identified and I could compile valuable feedback which I translated to tasks for the feature backlog on GitHub^[[https://github.com/swissmanu/rxjs-debugging-for-vscode/issues](https://github.com/swissmanu/rxjs-debugging-for-vscode/issues?q=is%3Aopen+is%3Aissue+label%3Afeature%2Cimprovement)]. The complete result set of the usability test is available in [Appendix @sec:paper-2-supplementary].

## Finalize

With the results from the usability test and a roadmap^[[https://github.com/swissmanu/rxjs-debugging-for-vscode/milestone/2](https://github.com/swissmanu/rxjs-debugging-for-vscode/milestone/2?closed=1)] for version 1.0.0 of my RxJS debugger, I was prepared for the last phase. The most crucial improvements I was able to implement included:

- Support for the latest RxJS 7.x versions (only 6.6.7 with the prototype)
- Debugging of web applications bundled with Webpack (only Node.js with the prototype)

The first major release v1.0.0 of "RxJS Debugging for Visual Studio Code" was finally released in Fall 2021, followed by three smaller bugfix releases.

Beside the practical effort done, I wrote another research paper documenting the latest proceedings on RP debugging for RxJS. At the time of writing this thesis, the latest version of this paper, containing revisions based on the feedback of a double-blind review with three reviewers, was submitted to the technical papers track of the 31st ACM SIGSOFT International Symposium on Software Testing and Analysis 2022 (ISSTA). The paper, along with the submitted supplementary material, is available in [Appendix @sec:paper-2] as part of this thesis.

# Future Work {#sec:future-work}





## Sustainability of Work

- Open Science
	- Why?
	- Where to get data?
- Where to pick things up
- Sustainability of Work
	- Testing
	- Open Source Community
	- Analytics Data Collection
- Project ideas for other student contributors?

# Conclusion {#sec:conclusion}

- Recap
- Contributions


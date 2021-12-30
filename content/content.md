# Introduction

Debugging [@CITE IEEE] is an important part of a software engineers daily job. Various techniques, some better suited for the task than others, help engineers to explore the functionality of an unknown and/or malfunctioning program. Rather traditional debugging is done by the interpretation of memory dumps or the analysis of log entries. Sophisticated debugging solutions hook into a program at runtime and allow more involved inspection and control.

Imperative programming languages like Java, C#, or Python dominated the mainstream software engineering industry over the last decades [@CITE]. Because of the prevalence of imperative programming languages, integrated development environments (IDE) like Eclipse, Microsoft Visual Studio, or the JetBrains IDE platform provide specialized debugging utilities specifically tailored to imperative programming languages. This results in an excellent, fully integrated developer experience, where tool supported debugging is only one or two clicks away.

This experience degrades rapidly when software engineers start using programming languages and tools based on different programming paradigms such as reactive programming (RP). Because traditional debugging utilities apparently cannot provide answers to what engineers are interested in, engineers tend to use simpler debugging techniques instead.

Within the scope of my master studies research, I examined the necessity of paradigm-specific debugging utilities, when software engineers debug programs based on RxJS^[https://rxjs.dev/], a library for RP in JavaScript. During my research, I explored how professionals debug RxJS programs, what tools and techniques they employ, and why most of them prefer to use print statements instead of specialized debugging utilities. In doing so, I identified a key factor for the success of a debugging tool: It needs to be "ready to hand", or its users will not use it at all.

Based on the premise of "readiness to hand", I finally conceptualized with *operator log points* a novel debugging utility for RP. The implementation of an extension for Microsoft Visual Studio named "RxJS Debugging vor Visual Studio Code", in conjunction with a usability inspection and a usability test allowed me to verify that the concept can successfully replace manual print statements for debugging RxJS-based applications and indeed is ready to the hands of software engineers.

In this summative thesis, I consolidate my research results documented and published in two research papers. I will complete this introduction with an overview on relevant programming paradigms, a quick glance on RP with RxJS, and the challenges RP provides for imperative-focused debuggers. Relevant work will be discussed in [@sec:related-work], followed by an overview on the full research process and its results in [@sec:research-process]. [@sec:future-work] presents a list of opportunities for future work and highlights provisions taken to ensure sustainability of the demonstrated results. Before the reader is left with the study of the research papers in the appendix, I will wrap up on the topic of debugging support for RP with RxJS in [@sec:conclusion].

## Programming Paradigms

A program implemented in an imperative language (e.g., Java or C#) modifies implicit state using side-effects, achieved with assignment and various flow control statements like `while` or `if` [@Hudak_1989]. With a declarative programming language, computational results (i.e., state) are carried explicitly from one unit of the program to the next [@Hudak_1989]. The source code of a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually, whereas its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

The Functional (FP) as well as the Data-Flow Programming (DFP) paradigm belongs to the family of declarative languages.

FP languages (e.g., Haskell or Erlang) are based on the concept of expression evaluation: Flow control statements are replaced with recursive function calls and conditional expressions [@Hudak_1989]. Thus, a programs final outcome is the result of its full evaluation rather than its implicit state. With DFP, a program is modeled as a directed graph where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004]. Examples for DFP can be found in visual programming environments like Node-RED^[https://nodered.org/].

Reactive Programming (RP) combines FP and DFP. Software engineers describe time-changing values and how they depend on each other [@Salvaneschi_Mezini_2016], i.e. a data-flow graph, using a Domain Specific Language (DSL). A runtime environment interprets the graph description and establishes a deterministic system state [@Bainomugisha_Carreton_Cutsem_Mostinckx_Meuter_2013] by executing necessary computations and propagating values through the data-flow graph [@Alabor_Stolze_2020]. RP is usually not part of programming languages themselves. Instead, libraries and language extensions (e.g., Reactive for Haskell [@Elliott_2009] or REScala for Scala [@Salvaneschi_Hintz_Mezini_2014]) provide RP features to their respective host programming language.

## Reactive Programming with RxJS

RxJS provides RP features for JavaScript and TypeScript. It is an implementation of the ReactiveX API specification, where the *Observable*, "[..] a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming" [@reactivex], is the core concept.

Similar to the observer in the Observer pattern [@gof], an RxJS observer subscribes and consumes events emitted from an *Observable*:

1. A `next` event carries a produced value, e.g., the result of an HTTP request
2. The `complete` event indicates that the observable finished its processing and will not emit any other events in the future
3. If the observable encountered a problem, the `error` event notifies its subscribers about the underlying error

Observables are push-based, thus the observable actively calls the callback handler of its subscriber(s)^[The Iterator pattern [@gof] is an example for pull-based processing. The consumer has to actively poll the iterators `next` function to receive a value.].

We can compose observables with other observables using the `pipe` function and operators. An operator is a factory returning a function that subscribes to an observable, maps its events, and returns a new observable. Two basic operators, `filter` and `map`, are used in [@lst:example-rxjs] on Lines 4-5 to manipulate the stream of emitted values. There are more complex operators like `mergeMap`^[https://rxjs.dev/api/operators/mergeMap] allowing composition with higher-order observables or `retryWhen`^[https://rxjs.dev/api/operators/retryWhen] to recover an observable after it emitted an `error` event.

```{
	#lst:example-rxjs
	.typescript
	caption="An observable emitting integers 1...8. Two operators process each integer before they are handed to subscriber, printing each to the console."
}
import { of, map, filter } from 'rxjs'

of(1, 2, 3, 4, 5, 6, 7, 8).pipe(
  filter(i => i % 2 === 0),       // Skip odd ints
  map(i => i * 2),                // Multiply int with 2
).subscribe(i => console.log(i)); // Logs: 4, 8, 12, 16
```

## Debugging Challenges of Reactive Programming

[@lst:imperative-program] shows a basic JavaScript program written using an imperative programming style. Software engineers use imperative-oriented debuggers in IDE's to follow the execution path of the program. They pause the execution of the program at a specific point of interest using breakpoints. Every time the debugger pauses program execution, the stackframe inspector provides details on what function calls lead to the execution of the current stackframe. Further, the values of all variables, belonging to a stackframe, are shown. Using step controls, the engineer controls further program execution manually, or resume "normal" execution eventually.

```{
	#lst:imperative-program
	.typescript
	caption="JavaScript program using imperative programming style."
}
for (let i = 0; i < 5; i++) {
  if (i < 4) {
    console.log(i * 2); // Logs: 0, 2, 4, 6
  }
}
```

[@lst:rp-program] is a reimplementation of [@lst:imperative-program] with RP using RxJS. Using the same, imperative debugging techniques and utilities as before, we can add a breakpoint to the anonymous function passed to the `map` operator on Line 5 and start the program.

```{
	#lst:rp-program
	.typescript
	caption="JavaScript program using RP programming style with RxJS."
}
import { of, filter, map } from 'rxjs';

of(0, 1, 2, 3, 4).pipe(
  filter(i => i < 4),
  map(i => i * 2)
).subscribe(console.log) // Logs: 0, 2, 4, 6
```

The stacktrace ([@fig:rxjs-stacktrace]) provided by the imperative debugger reveals its major flaw when used with an RP program: The stacktrace does not match the model of the data-flow graph described using the DSL. Instead, it reveals the inner, imperative implementation of RxJS' RP runtime. Furthermore, the debuggers step controls render ineffective, since they operate on the imperative level as well. In this example, stepping to the next statement would not result in the debugger halting at Line 6, instead it would lead the engineer somewhere into the inner implementation details of RxJS.

A common practice [@Alabor_Stolze_2020] to overcome this problem is the introduction of manual print statements as shown in [@lst:rp-program-with-print-statements]. Though often cumbersome to use, they allow to trace the behavior of an observable at program execution time.

![(Shortened) stacktrace as provided by the Microsoft Visual Studio Code debugger, after pausing program execution within the anonymous function on Line 5 in [@lst:rp-program].](./content/figures/rxjs-stacktrace.png "RxJS stacktrace"){width=60% #fig:rxjs-stacktrace}

```{
	#lst:rp-program-with-print-statements
	.typescript
	caption="RxJS-based RP program showing manual print statements."
}
import { of, filter, map, tap } from 'rxjs';

of(0, 1, 2, 3, 4).pipe(
  tap(i => console.log(`A: ${i}`)), // <-- Added
  filter(i => i < 4),
  tap(i => console.log(`B: ${i}`)), // <-- Added
  map(i => i * 2),
  tap(i => console.log(`C: ${i}`))  // <-- Added
).subscribe(console.log)
```


# Related Work {#sec:related-work}

## Reactive Debugging

The mismatch between expected and actual of an imperative debugger when confronted with RP programs was subject various research efforts before. Salvaneschi et al. [@Salvaneschi_Mezini_2016, @Salvaneschi_Proksch_Amann_Nadi_Mezini_2017] coined the term *Reactive Debugging* and described a debugging utility and its requirements specifically tailored to work with RP programs for the first time. The further provided the first implementation of such a debugger for REScala with the name *Reactive Inspector* further.

Banken et al. [@Banken_Meijer_Gousios_2018] transferred former findings to RxJS. Their browser-based visualizer *RxFiddle* takes a piece of isolated RxJS source code and allows software engineer to display its runtime behavior in two dimensions: A flow-graph shows when observables got created, and how they depend on and interact with each other. The utility further renders a marble diagram ([@fig:marble-diagram]) for each observable, showing what events got emitted at which point in time.

```{.include}
content/figures/marble-diagram.tex
```

## Debugging as a Process

I used the iterative process model after Layman et al. [@Layman_Diep_Nagappan_Singer_Deline_Venolia_2013] to conceptualize a new



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

After I had confidence in the concept of operator log points, I started to rebuild the PoC debugging extension from ground up focusing on functionality, maintainability, and extensibility. This resulted in the v0.1.0 release of "RxJS Debugging for Visual Studio Code"^[https://marketplace.visualstudio.com/items?itemName=manuelalabor.rxjs-debugging-for-vs-code], the first fully integrated RxJS debugger for vscode.

The initial version of the extension enables engineers to debug RxJS-based applications running with Node.js. There are no additional setup steps necessary: Once the extension is installed, it suggests operator log points with a small, diamond-shaped icon next to the respective operator. The engineer launches their application using the built-in JavaScript debugger. By doing so, the RxJS debugger augments RxJS automatically to provide life-cycle events to vscode. The extension displays these life-cycle events for operators having an enabled log point in-line with the operator in the source code editor.

TODO Screenshot of Prototype

There were various interesting challenges and tasks to solve during the Prototype phase. The following two sub-sections present two highlights.

### Communicate with Node.js

One of the biggest challenges during the Prototype phase was to build a reliable way to communicate with RxJS running in Node.js. I used a WebSocket to exchange messages with the JavaScript runtime in the PoC. This proofed to be tedious in multiple was (e.g., how can the extension know the host and/or port where the WebSocket is running, or what if network infrastructure prevents WebSocket connections etc.) and so I wanted to replace this key element in my system.

One of my main goals was to integrate the RxJS debugger with already known debugging tools seamlessly. What if I would not reuse only established UX patterns, but also already established communication ways? vscode-js-debug^[https://github.com/microsoft/vscode-js-debug], vscodes built-in JavaScript debugger, uses the Chrome DevTools Protocol^[https://chromedevtools.github.io/devtools-protocol/] (CDP) to communicate with arbitrary JavaScript runtimes. Unfortunately, vscode-js-debug did not offer its CDP connection to be reused by other extensions. I contributed this particular functionality to the project, which then was released with vscodes April 2021^[https://github.com/microsoft/vscode-js-debug/pull/964] release officially.

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

### Community Reaction TODO

- Again: Verification that this is a problem
- Showing new gaps
- Verification that ux works
- https://twitter.com/rxjsdebugging/status/1466439953731182599
	- Over 77k impressions (2021-12-30)
- 952 installs (2021-12-30)
- 51 unique users (2021-12-30)

### ISSTA Research Paper

Beside the practical effort done, I wrote another research paper with Markus Stolze documenting the latest proceedings on RP debugging for RxJS. At the time of writing this thesis, the latest version of this paper, containing revisions based on the feedback of a double-blind review with three reviewers, was submitted to the technical papers track of the 31st ACM SIGSOFT International Symposium on Software Testing and Analysis 2022 (ISSTA). The paper, along with the relevant supplementary material, is available in [Appendix @sec:paper-2] as part of this thesis.

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


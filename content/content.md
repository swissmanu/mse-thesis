# Introduction

Debugging [@CITE IEEE] is an essential part of a software engineer's daily job. Various techniques, some better suited for the task than others, help engineers explore the functionality of an unknown or malfunctioning program. Rather traditional debugging is done by interpreting memory dumps or the analysis of log entries. Sophisticated debugging solutions hook into a program at runtime and allow more detailed inspection and control.

Imperative programming languages like Java, C#, or Python dominated the mainstream software engineering industry over the last decades [@CITE]. Because of the prevalence of imperative programming languages, integrated development environments (IDE) like Eclipse, Microsoft Visual Studio, or the JetBrains IDE platform provide specialized debugging utilities specifically tailored to imperative programming languages. This results in an excellent, fully integrated developer experience, where tool-supported debugging is only one or two clicks away.

This experience degrades rapidly when software engineers use programming languages and tools based on different programming paradigms such as reactive programming (RP). Because traditional debugging utilities apparently cannot answer what engineers are interested in, engineers tend to use simpler debugging techniques instead.

Within my master studies research scope, I examined the necessity of paradigm-specific debugging utilities when software engineers debug programs based on RxJS^[https://rxjs.dev/], a library for RP in JavaScript. During my research, I explored how professionals debug RxJS programs, what tools and techniques they employ, and why they prefer to use print statements instead of specialized debugging utilities. In doing so, I identified a key factor for the success of a debugging tool: It needs to be "ready to hand," or its users will not use it at all.

Based on the premise of "readiness to hand," I eventually conceptualized a novel debugging utility for RP named *operator log points*. The implementation of an extension for Microsoft Visual Studio named "RxJS Debugging for Visual Studio Code", in conjunction with a usability inspection and a usability test allowed me to verify that the concept can successfully replace manual print statements for debugging RxJS-based applications and indeed is ready to the hands of software engineers.

This summative thesis consolidates my research results documented and published in two research papers. I will complete this introduction with an overview of relevant programming paradigms, a glance at RP with RxJS, and the challenges RP provides for imperative-focused debuggers. Relevant work will be discussed in [@sec:related-work], followed by an overview of the complete research process and its results in [@sec:research-process]. [@sec:future-work] presents a list of opportunities for future work and highlights provisions taken to ensure the sustainability of the demonstrated results. Before the reader is left with the study of the research papers in the appendix, I will wrap up on the topic of debugging support for RP with RxJS in [@sec:conclusion].

## Programming Paradigms

A program implemented in an imperative language (e.g., Java or C#) modifies implicit state using side-effects, achieved with assignment and various flow control statements like `while` or `if` [@Hudak_1989]. With a declarative programming language, computational results (i.e., state) are carried explicitly from one program unit to the next [@Hudak_1989]. The source code of a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually. In contrast, its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

The Functional (FP) and the Data-Flow Programming (DFP) paradigm belong to the family of declarative languages.

FP languages (e.g., Haskell or Erlang) are based on the concept of expression evaluation: Flow control statements are replaced with recursive function calls and conditional expressions [@Hudak_1989]. Thus, a program's outcome results from its complete evaluation rather than its implicit state. With DFP, programs are modeled as a directed graph where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004]. Examples for DFP can be found in visual programming environments like Node-RED^[https://nodered.org/].

Reactive Programming (RP) combines FP and DFP. Software engineers describe time-changing values and how they depend on each other [@Salvaneschi_Mezini_2016], i.e., a data-flow graph, using a Domain Specific Language (DSL). A runtime environment interprets the graph description and establishes a deterministic system state [@Bainomugisha_Carreton_Cutsem_Mostinckx_Meuter_2013] by executing necessary computations and propagating values through the data-flow graph [@Alabor_Stolze_2020]. RP is usually not part of programming languages themselves. Instead, libraries and language extensions (e.g., Reactive for Haskell [@Elliott_2009] or REScala for Scala [@Salvaneschi_Hintz_Mezini_2014]) provide RP features to their respective host programming language.

## Reactive Programming with RxJS

RxJS provides RP features for JavaScript and TypeScript. It is an implementation of the ReactiveX API specification, where the *Observable*, "[..] a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming" [@reactivex], is the core concept.

Similar to the observer in the Observer pattern [@gof], an RxJS observer subscribes and consumes events emitted from an *Observable*:

1. A `next` event carries a produced value, e.g., the result of an HTTP request
2. The `complete` event indicates that the observable finished its processing and will not emit any other events in the future
3. If the observable encountered a problem, the `error` event notifies its subscribers about the underlying error

Observables are push-based; thus, the observable actively calls the callback handler of its subscriber(s)^[The Iterator pattern [@gof] is an example for pull-based processing. The consumer has to actively poll the iterators `next` function to receive a value.].

We can compose observables with other observables using the `pipe` function and operators. An operator is a factory that returns a function that subscribes to an observable, maps its events, and returns a new observable. Two basic operators, `filter` and `map`, are used in [@lst:example-rxjs] on Lines 4-5 to manipulate the stream of emitted values. In addition, there are more complex operators like `mergeMap`^[https://rxjs.dev/api/operators/mergeMap] allowing composition with higher-order observables or `retryWhen`^[https://rxjs.dev/api/operators/retryWhen] to recover an observable after it emitted an `error` event.

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

[@lst:imperative-program] shows a basic JavaScript program written using an imperative programming style. Software engineers use imperative-oriented debuggers in IDE's to follow the program's execution path. They pause the program's execution at a specific point of interest using breakpoints. Every time the debugger pauses program execution, the stackframe inspector provides details on what function calls lead to the execution of the current stack frame. Further, the values of all variables belonging to a stack frame are shown. Using step controls, the engineer controls further program execution manually or resumes "normal" execution eventually.

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

[@lst:rp-program] is a reimplementation of [@lst:imperative-program] with RP using RxJS. Using the same imperative debugging techniques and utilities as before, we can add a breakpoint to the anonymous function passed to the `map` operator on Line 5 and start the program.

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

The stack trace ([@fig:rxjs-stacktrace]) provided by the imperative debugger reveals its major flaw when used with an RP program: The stack trace does not match the model of the data-flow graph described using the DSL. Instead, it reveals the inner, imperative implementation of RxJS' RP runtime. Furthermore, the debugger's step controls render ineffective since they operate on the imperative level. In this example, stepping to the following statement would not result in the debugger halting at Line 6. Instead, it would lead the engineer somewhere into the inner implementation details of RxJS.

A common practice [@Alabor_Stolze_2020] to overcome this problem is the introduction of manual print statements, as shown in [@lst:rp-program-with-print-statements]. Though often cumbersome to use, they allow tracing an observable's behavior at program execution time.

![The stack trace provided by the Microsoft Visual Studio Code debugger, after pausing program execution within the anonymous function on Line 5 in [@lst:rp-program].](./content/figures/rxjs-stacktrace.png "RxJS stacktrace"){width=60% #fig:rxjs-stacktrace}

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

When confronted with RP programs, the mismatch between an imperative debugger's expected and actual behavior was subject to various research efforts before. Salvaneschi et al. [@Salvaneschi_Mezini_2016, @Salvaneschi_Proksch_Amann_Nadi_Mezini_2017] coined the term *Reactive Debugging* and described a debugging utility and its requirements specifically tailored to work with RP programs for the first time. They provided the first implementation of such a debugger for REScala with the name *Reactive Inspector* further.

Banken et al. [@Banken_Meijer_Gousios_2018] transferred former findings to RxJS. Their browser-based visualizer *RxFiddle* takes a piece of isolated RxJS source code and allows the software engineer to display its runtime behavior in two dimensions: A flow-graph shows when observables are created, and how they depend on and interact with each other. The utility further renders a marble diagram ([@fig:marble-diagram]) for each observable, showing what events got emitted at which point in time.

```{.include}
content/figures/marble-diagram.tex
```

## Debugging as a Process

Layman et al. [@Layman_Diep_Nagappan_Singer_Deline_Venolia_2013]   looked into how engineers debug programs. Based on previous models and the analysis of their data, they formalized an iterative process model for the activity of debugging. Its goal is to define and refine a hypothesis on the cause that triggered an unexpected behavior in a program. Ultimately, the process seeks to prove that hypothesis. The debugging process after Layman et al. consists of three steps: Engineers start to (i) collect context information on the current situation (e.g., which particular piece of source code might be involved or what input caused the failure). This information allows the software engineers to formulate a hypothesis on how the failure situation can be resolved. Next, with the intent to prove their hypothesis, they (ii) instrument the program, e.g., by adding breakpoints or modifying source code. They then (iii) test this modified system according to their debugging hypothesis. This step either proves their hypothesis correct, ending the debugging process, or yields new information for another iteration of hypothesis refinement and testing.

TODO REFERENCE THIS IN THE RESEARCH PROCESS

# Research Process {#sec:research-process}

```{.include}
content/figures/research-process.tex
```

The research process follows the principles of empirical software engineering and applies user-centered design methods [CITE]. The process is structured in four distinct phases: (i) Exploration, (ii) Proof of Concept (PoC), (iii) Prototype, and (iv) Finalization. This section gives an overview of every stage, presents the most important insights, and lists the developed artifacts.

```{.include}
content/tables/artifact-overview.tex
```

## Exploration

The Exploration phase was all about empirical software engineering. Based on the data collected from five informal interviews and the sentiment of five written "war story" reports, I set up a remote observational study with four subjects. The study was designed to verify the debugging tools and techniques the subjects use when confronted with an unknown, malfunctioning RxJS program. As shown in [@fig:result-observational-study], all of the subjects used manual code modifications (i.e., print statements) to understand the behavior of the presented problems. Over half of them tried to use a traditional, imperative debugger. It was surprising that, even though two subjects stated to know about specialized RxJS debugging tools, none of them used such during the study.

```{.include}
content/figures/result-observational-study.tex
```

The results of the interviews, the analysis of the war story reports, and the interpretation of the observed behaviors during the observational study combined lead to the following two key take-aways:

1. The most significant challenge software engineers face when debugging RxJS-based programs is to know *when* they should apply *what* tool to resolve their current problem in the *most efficient way*
2. Can one find a way to improve the developer experience by providing RxJS-specific debugging utilities where software engineers expect them the most, ready to hand and fully integrated, with their IDE?

The primary artifact produced during the Exploration phase is the research paper "Debugging of RxJS-Based Applications," [@Alabor_Stolze_2020] published with the proceedings of the 7th ACM SIGPLAN International Workshop
on Reactive and Event-Based Languages and Systems (REBLS' 20) and available in [Appendix @sec:paper-1].

## Proof Of Concept

Based on the learnings from the first phase, I started to compile ideas to help software engineers debug RxJS programs. It was essential that a potential solution:

1. Integrates with an IDE
2. Requires minimal to no additional learning effort for its users

Imperative debuggers provide log points, a utility to print a log statement once the program execution processes as a specific statement in the source code. I adopted this established concept and transferred it to the world of RP with RxJS: An *operator log point*, enabled for a specific operator in an Observables `pipe` shows in realtime when related operator emits relevant events. I did a PoC implementation in an extension to Microsoft Visual Studio Code (vscode). To verify that the PoC solves the problem of manual code modifications in order to debug RxJS programs, I used a cognitive walkthrough [@Wharton_Rieman_Clayton_Polson_1994] ([Appendix @sec:paper-2-supplementary]). Further, I created a user journey comparing the debugging workflow with and without the PoC debugging extension (see [Appendix @sec:user-journey]).

Using the two inspection methods, I could verify that operator log points fulfill the requirements stated at the beginning of this section. In addition, the cognitive walkthrough further revealed several usability issues as documented in [Appendix @sec:paper-2-supplementary]. These results provided valuable input for the upcoming Prototype phase.

## Prototype
Once I was confident that operator log points satisfied an RxJS software engineer's needs, I reimplemented the PoC debugger. For the prototype, I focused on functionality, maintainability, and extensibility. Eventually, I released version 0.1.0 of "RxJS Debugging for vscode," the first fully integrated RxJS debugger for an IDE.

The initial version of the extension enabled engineers to debug RxJS-based applications running with Node.js. There are no additional setup steps necessary: Once the extension is installed, it suggests operator log points with a small, diamond-shaped icon next to the respective operator. Next, the engineer launches their application using the built-in JavaScript debugger. By doing so, the debugger augments RxJS automatically to provide life-cycle events to vscode. The extension displays these life-cycle events for enabled operator log points in line with the operator in the source code editor.

TODO Screenshot of Prototype

There were various challenges and tasks to solve during the Prototype phase. The following two sub-sections present two highlights.

### Communicate with Node.js

One of the biggest challenges during the Prototype phase was to build a reliable way to communicate with RxJS running in Node.js. For example, I initially used a WebSocket to exchange messages with the JavaScript runtime. However, this proved to be tedious in numerous ways (e.g., how can the extension discover the host and port where the WebSocket is running or what if network infrastructure prevents the extension from connecting to the WebSocket), so I wanted to replace this essential component in my system.

With my intent to build a debugger that integrates with the IDE seamlessly, I started to look into how the built-in JavaScript debugger, vscode-js-debug^[https://github.com/microsoft/vscode-js-debug], communicates with the runtime environment. As it turned out, vscode-js-debug uses the Chrome DevTools Protocol^[https://chromedevtools.github.io/devtools-protocol/] (CDP) to communicate with arbitrary JavaScript runtimes. Unfortunately, vscode-js-debug did not offer its CDP connection to be reused by other extensions. So I decided to contribute this particular function to the project ([Appendix @sec:cdp-pull-request]), which then was released with vscodes April 2021 release. I could replace any extraneous communication channel for the RxJS debugger in turn. Furthermore, if a new JavaScript runtime supports CDP, it becomes automatically compatible with the RxJS debugging utility.

[@fig:architecture] provides a complete overview of the system components and communication channels.

```{.include}
content/figures/architecture.tex
```

### Moderated Remote Usability Test

Once the main elements of the debugger prototype were functioning sufficiently, I conducted a remote usability test with three subjects. The goals of this study were:
To verify that the operator log point utility can replace manual print statements in an actual programming scenario
To identify usability issues not detected during development
To collect feedback and ideas for the prototype and its further development

All three goals were successfully verified: No subject used manual print statements during the test sessions. Further, ten usability issues were identified ([Appendix @sec:paper-2-supplementary]), and I could compile valuable feedback, which I translated to tasks for the feature backlog on GitHub ([Appendix @sec:feature-backlog]). The complete result set of the usability test is available in [Appendix @sec:paper-2-supplementary].

## Finalization

With the results from the usability test and a roadmap for version 1.0.0 ([Appendix @sec:major-milestone]) of my RxJS debugger, I was prepared for the last phase. The most crucial improvements I was able to implement include:

- Support for the latest RxJS 7.x versions (only 6.6.7 with the prototype)
- Debugging of web applications bundled with Webpack (only Node.js with the prototype)

The first major release, 1.0.0 of "RxJS Debugging for vscode," was finally released in Fall 2021, followed by three minor bugfix releases.

### Community Reception

On the day of release, I announced the extension via its own Twitter account [\@rxjsdebugging](https://twitter.com/rxjsdebugging). Until the 30th of December 2021, the tweet got 77k impressions ([Appendix @sec:release-tweet-stats]). Further, the extension itself was downloaded 954 times ([Appendix @sec:marketplace]), counted 51 unique users based on collected analytics data (see [Appendices @sec:analytics; Appendices @sec:analytics-dashboard] for more details), and was featured in a Twitch stream^[[\@webdave_de](https://twitter.com/webdave_de), a Google Developer Expert specialized on Angular development, hosted the live reaction stream. Unfortunately, the recording of the stream is unavailable at this time.].

Based on the results of the studies I conducted, I could assume that there was a real need for an integrated RP debugger for RxJS. The overall positive reception on RxJS Debugging for vscode was overwhelming nonetheless. However, the release also revealed bugs and feature gaps in the extension. Nevertheless, I resolved the most critical problems within a few days (see the changelog in [Appendix @sec:changelog]). In addition, I triaged other valuable feedback via GitHub Discussions^[https://github.com/swissmanu/rxjs-debugging-for-vscode/discussions] and the feature backlog ([Appendix @sec:feature-backlog]).

### ISSTA `22 Research Paper

Besides the practical effort, I wrote another research paper with Markus Stolze documenting the latest proceedings on RP debugging for RxJS. When writing this thesis, the latest version of this paper, containing revisions based on the feedback of a double-blind review with three reviewers, was submitted to the technical papers track of the 31st ACM SIGSOFT International Symposium on Software Testing and Analysis 2022 (ISSTA `22). The submitted version of the paper, along with the relevant supplementary material, is available in [Appendix @sec:paper-2].

# Future Work {#sec:future-work}

## Empirical Software Engineering

RxJS Debugging for vscode provides a practical solution to the problems identified throughout the presented research process, and further empirical verifications can now be carried out.

Operator log points were successfully tested using usability testing methods during their development. However, a formal verification using empirical methods will yield valuable insight into the presented debugging utility. The most important research question to answer in these regards is, how effectively can operator log points replace existing debugging tools (i.e., manual print statements and the built-in, imperative debugger tools) for engineers debugging RxJS programs.

Since its major release, the debugging extension collects user behavior data, which is available for further analysis ([Appendix @sec:analytics]). The accumulated data points allow conclusions on how software engineers use the extension. The data set might be evaluated on its own to derive improvements for the existing debugging utility or provide supportive arguments for a broader study as proposed before.

### Open Science

The designs and results of all conducted studies (interviews, observational study, cognitive walkthrough, and moderated remote usability test) are documented in the respective research papers and their supplementary material available in [Appendices @sec:paper-1; Appendices @sec:paper-2; Appendices @sec:user-journey]) to encourage future research on RP debugging. In addition, a list of URLs to various GitHub repositories related to my work is available in [Appendix @sec:open-science].

## Open Source

I developed the RxJS Debugging for vscode extension with the intention to establish a sustainable open source project.

The contribution and architecture guides ([Appendices @sec:contributing; Appendices @sec:architecture]) introduce new contributors to the extension's implementation and code organization details. The transparent project governance is built around the GitHub platform: The feature backlog and bug-tracking are based on GitHub Issues, Discussions help triage inquiries from users. Unit and integration tests, automatically executed using GitHub Actions, help keep the extension's main branch stable.

A look into the feature backlog ([Appendix @sec:feature-backlog]) is a good start for practical-oriented future work. I present two features from the backlog in the following, which, depending on skill level, provide a good entry point to contribute to RxJS Debugging for vscode:

### User Onboarding after Installation ([Issue #58](https://github.com/swissmanu/rxjs-debugging-for-vscode/issues/58))

After an engineer installed the extension, they are left on their own to get started with debugging. Even though the readme file provides information to some extent, the onboarding experience for new users can be improved. With this feature, enhancing that experience should be explored and implemented eventually.

A contributor needs to understand the vscode extension API. However, profound knowledge of the extension's source code is not required; its functionality should be clear.

### Log Point History ([Issue #44](https://github.com/swissmanu/rxjs-debugging-for-vscode/issues/44))

Instead of only showing the latest emitted event from an enabled operator log point, the debugger should also display all previously emitted events. This functionality allows engineers to reconstruct the behavior of an operator without over and over replaying the failure scenario using the live system. For example, a contribution might start with a list displaying events in textual form and then gradually improve towards a graphical representation of the events using marble diagrams.

This feature requires a good understanding of the vscode extension API and the debugging extensions codebase itself.


# Conclusion {#sec:conclusion}

In this summative thesis, I presented the condensed results of my research on reactive debugging for programs based on RxJS, a popular library for reactive programming with JavaScript.

The results of interviews, war story reports, and an observational study revealed the major shortcoming of previously available RxJS debugging utilities. Even though software engineers might know them, they abstain from using them because they are not "ready to hand," i.e., not integrated with the IDE they are working in and accustomed to. Instead, they use manual print statements.

With the concept of "readiness to hand" as a guiding light, I built a proof of concept implementation for a novel debugging utility to find relief to this problem: Operator log points debug RxJS operators without requiring the engineer to leave Microsoft Visual Studio Code. While refining the debugger iteratively, I employed a cognitive walkthrough, a comparative user journey, and a usability test at different stages of development to validate the utility's capability of solving the problem of "ready-to-hand" debugging.

I documented the results of my research in two research papers: The first paper was published with the proceedings of the ACM REBLS '20 workshop. The second report is in review for the technical papers track of the ACM ISSTA '22 conference when writing this thesis. Furthermore, I released "RxJS Debugging for Visual Studio Code," the first RxJS-specific debugger that fully integrates with an IDE.

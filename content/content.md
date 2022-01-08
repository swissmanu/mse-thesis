# Introduction

Debugging is an essential part of a software engineer's daily job. Various techniques, some better suited for the task than others, help engineers explore the functionality of an unknown or malfunctioning program. Rather traditional debugging is done by interpreting memory dumps or the analysis of log entries. Sophisticated debugging solutions hook into a program at runtime and allow more detailed inspection and control [@IEEE_Glossary_1990].

Imperative programming languages like Java, C#, and Python dominated the mainstream software engineering industry over the last decades [@Yaofei_Chen_Dios_Mili_Lan_Wu_Kefei_Wang_2005; @Meyerovich_Rabkin_2013]. Because of the prevalence of imperative programming languages, integrated development environments (IDE) like Eclipse, Microsoft Visual Studio, or the JetBrains IDE platform provide specialized debugging utilities specifically tailored to imperative programming languages. This results in an excellent, fully integrated developer experience (DX), where tool-supported debugging is only one or two clicks away.

This experience degrades rapidly when software engineers use programming languages and tools based on different programming paradigms such as reactive programming (RP). Because of this, engineers tend to use simpler, less capable debugging techniques instead.

During my master studies research, I examined the necessity of paradigm-specific debugging utilities when software engineers debug programs based on RxJS^[https://rxjs.dev/], a library for RP in JavaScript. During my research, I explored how professionals debug RxJS programs, what tools and techniques they employ, and why they prefer to use print statements instead of specialized debugging utilities, which require them to switch contexts. In doing so, I identified a key factor for the success of a debugging tool: It needs to be *ready-to-hand*, or its users will not use it at all.

Based on the premise of *readiness to hand*, I designed and implemented a novel debugging utility for RP. *Operator log points* are available as an extension for Microsoft Visual Studio Code (vscode) and provide the first fully IDE-integrated debugging utility for RxJS. Using Human-Computer Interaction (HCI) methods, I examined the DX of operator log points. I successfully verified that the new utility replaces manual print statements and does not require engineers to change context. Thereby I proof that a ready-to-hand debugger for RP is feasible.

This summative thesis contextualizes my research results documented and published in two research papers. I will complete this introduction with an overview of relevant programming paradigms, a glance at RP with RxJS, and the challenges RP provides for imperative-focused debuggers. Relevant work will be discussed in [@sec:related-work], followed by an overview of the complete research process and its results in [@sec:research-process]. [@sec:future-work] presents a list of opportunities for future work and highlights provisions taken to ensure the sustainability of the demonstrated results. Before the reader is left with the study of the research papers in the [Appendix @sec:research-papers], I will wrap up on the topic of debugging support for RP with RxJS in [@sec:conclusion].

## Relevant Programming Paradigms

```{.include}
content/figures/paradigm-taxonomy.tex
```

On the way of producing the output for a given input, an imperatively implemented program keeps intermediate and final computational results in its state. The key concept of imperative programming languages like Java and C# is the assignment command to update that state. The assignment command modifies the value assigned to a variable. Execution flow control commands, e.g. `if` and `while`, allow conditional and repeated execution of commands. [@Watt_Findlay_Hughes_1990]

With a declarative programming language, computational results are carried explicitly from one program unit to the next instead of keeping them in extraneous state [@Hudak_1989]. The source code of a declaratively implemented program is the blueprint of *what* the program is expected to accomplish eventually. In contrast, its imperative sibling resembles the precise step-by-step instruction on *how* the expected result must be achieved.

The Functional (FP) and the Data-Flow Programming (DFP) paradigm belong to the family of declarative languages.

FP languages (e.g., Haskell or Erlang) are based on the concept of expression evaluation: Flow control statements are replaced with recursive function calls and conditional expressions [@Hudak_1989; @Watt_Findlay_Hughes_1990]. Thus, a program's outcome results from its complete evaluation rather than its implicit state. With DFP, programs are modeled as directed graphs where a node represents an instruction of the program. The graph's edges describe how the data flows between its nodes [@Johnston_Hanna_Millar_2004]. Contemporary examples for DFP can be found in visual programming environments like Node-RED^[https://nodered.org/].

Reactive Programming (RP) combines FP and DFP. Software engineers describe time-changing values and how they depend on each other [@Salvaneschi_Mezini_2016], i.e., a data-flow graph, using a Domain Specific Language (DSL). A runtime environment interprets the graph description and establishes a deterministic system state [@Bainomugisha_Carreton_Cutsem_Mostinckx_Meuter_2013] by executing necessary (re-)computations [@Alabor_Stolze_2020]. RP is usually not part of programming languages themselves. Instead, libraries and language extensions (e.g., Reactive for Haskell [@Elliott_2009] or REScala for Scala [@Salvaneschi_Hintz_Mezini_2014]) provide RP features to their respective host programming language.

## Reactive Programming with RxJS

RxJS provides RP features for JavaScript and TypeScript. It is an implementation of the ReactiveX API specification, where the *Observable*, "[..] a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming" [@reactivex], is the core concept.

Like the observer in the Observer pattern [@gof] subscribes to the notifications of a subject, subscribes an RxJS observer to the events of an observable. Observables *emit* the following three events:

1. A `next` event carries a produced value, e.g., the result of an HTTP request
2. The `complete` event indicates that the observable finished its processing and will not emit any other events in the future
3. If the observable encountered a problem, the `error` event notifies its subscribers about the underlying error

Observables are push-based; thus, the observable actively calls the callback handler of its subscriber(s)^[*Pull*-based is the opposite of push-based processing. E.g., the Iterator pattern [@gof] is an example for a pull-based mechanism: The consumer has to actively poll (i.e., pull) the iterators `next` function to fetch a value.].

Operator functions subscribe to an observable, modify its events, and return a  new observable emitting the modified events. Operator functions are the most powerful, yet most complex tool when working with observables. [@lst:example-rxjs] demonstrates two simple operators for filtering and mapping of values. More complex operators like `mergeMap`^[https://rxjs.dev/api/operators/mergeMap] allow the composition of higher-order observables or `retryWhen`^[https://rxjs.dev/api/operators/retryWhen] even provides a way to recover an observable from an `error` event.

```{
	#lst:example-rxjs
	.typescript
	caption="An observable emitting integers 1...8. Two operators process the integers before they are handed to the subscriber, which prints them to the console."
}
import { of, map, filter } from 'rxjs'

of(1, 2, 3, 4, 5, 6, 7, 8).pipe(
  filter(i => i % 2 === 0),       // Skip odd Integers
  map(i => i * 2),                // Multiply Integer with 2
).subscribe(i => console.log(i)); // Logs: 4, 8, 12, 16
```

## Debugging Challenges of Reactive Programming

[@lst:imperative-program] shows a reimplementation of [@lst:example-rxjs] using an imperative programming style. Software engineers use imperative-oriented debuggers in IDE's to follow the program's execution path. They pause the program's execution at a specific point of interest using breakpoints. Every time the debugger pauses program execution, the stack frame inspector provides details on what function calls lead to the execution of the current stack frame. Further, the values of all variables belonging to a stack frame are shown. Using step controls, the engineer controls further program execution manually or resumes "normal" execution eventually.

```{
	#lst:imperative-program
	.typescript
	caption="JavaScript program replicating Listing 1 using an imperative programming style."
}
for (let i = 1; i < 9; i++) {
  if (i % 2 === 0) {
    console.log(i * 2); // Logs: 4, 8, 12, 16
  }
}
```

Let's assume an engineer would debug the RP program from [@lst:example-rxjs] using the same imperative debugging techniques and utilities as before. They would add a breakpoint to the anonymous function passed to the `map` operator on Line 5 and start the program.

![The stack trace provided by the Microsoft Visual Studio Code debugger, after pausing program execution within the anonymous function on Line 5 in [@lst:example-rxjs].](./content/figures/rxjs-stacktrace.png "RxJS stack trace"){width=60% #fig:rxjs-stacktrace}

The stack trace ([@fig:rxjs-stacktrace]) provided by the imperative debugger reveals the debuggers major shortcoming when used with the RP program: The stack trace does not match the model of the data-flow graph described with the DSL. Instead, it reveals the inner, imperative implementation of RxJS' RP runtime. Furthermore, the debugger's step controls render ineffective since they too operate on the imperative level. In this example, stepping to the following statement does not result in the debugger halting at Line 6. Instead, it leads the engineer to the inner implementation details of RxJS.

A common practice to overcome this problem is the manual augmentation of the source code with print statements, as shown in [@lst:rp-program-with-print-statements]. This technique is often the last resort to debug RxJS programs. However, it is also regarded as a cumbersome and time consuming practice [@Alabor_Stolze_2020].

```{
	#lst:rp-program-with-print-statements
	.typescript
	caption="RxJS-based program from Listing 1 manually augmented with print statements."
}
import { of, filter, map, tap } from 'rxjs';

of(1, 2, 3, 4, 5, 6, 7, 8).pipe(
  tap(i => console.log(`A: ${i}`)), // <-- Added
  filter(i => i % 2 === 0),
  tap(i => console.log(`B: ${i}`)), // <-- Added
  map(i => i * 2),
  tap(i => console.log(`C: ${i}`))  // <-- Added
).subscribe(i => console.log(i));
```


# Related Work {#sec:related-work}

## Reactive Debugging

The problem of imperative debuggers interpreting RP source code using the wrong model was subject to various research before. Salvaneschi et al. [@Salvaneschi_Mezini_2016, @Salvaneschi_Proksch_Amann_Nadi_Mezini_2017] coined the term *Reactive Debugging* and described a debugging utility specifically tailored to work with RP programs for the first time in their work. They provided the first implementation of such a debugger named *Reactive Inspector* for REScala.

Banken et al. [@Banken_Meijer_Gousios_2018] transferred former findings to RxJS. *RxFiddle* is a browser-based visualizer that takes a piece of isolated RxJS source code and displays its runtime behavior in two dimensions: A flow-graph shows all observables that get created and how they depend on each other. Additionally, the utility uses marble diagrams to show what events get emitted by an observable over time. [@fig:marble-diagram] shows an example of such a diagram.

```{.include}
content/figures/marble-diagram.tex
```

## Debugging as a Process

Layman et al. [@Layman_Diep_Nagappan_Singer_Deline_Venolia_2013] looked into how engineers debug programs. They formalized an iterative process model for the activity of debugging. During this process, engineers define and refine a hypothesis on the cause that triggered an unexpected behavior in a program. Ultimately, the process tries to validate that hypothesis. The debugging process after Layman et al. consists of three steps: Engineers start to (i) collect context information on the current situation (e.g., which particular program statements might be involved or what input caused the failure). This information then allows the software engineers to formulate a hypothesis on how the failure situation might be resolved. Next, with the intent to validate their hypothesis, they (ii) instrument the program, e.g., by adding breakpoints or modifying source code. They then (iii) test this modified system according to their debugging hypothesis. This step either proves their hypothesis correct, ending the debugging process, or yields new information for another iteration of hypothesis refinement and testing.

## TODO Developer Experience

- TODO [@Goodwin_2009]
- TODO Human Computer Interaction (HCI) for software engineers
- TODO Prevent Context Switches [@Nadeem_2021]

# Research Process {#sec:research-process}

```{.include}
content/figures/research-process.tex
```

The research process is structured in four phases: (i) Exploration, (ii) Proof of Concept (PoC), (iii) Prototype, and (iv) Finalization. Various empirical software engineering [@wohlin2012experimentation] and HCI methods were applied to verify the artifacts delivered shown in [@tbl:artifact-overview]. The following four subsections highlight the most important results and deliveries of each project stage.

```{.include}
content/tables/artifact-overview.tex
```

## Exploration

The research started with an in-depth analysis of what debugging tools and techniques the user population uses in their daily jobs. Data from five informal interviews and five written "war story" reports allowed me to build a first intuition in these regards. To verify the collected data points, I set up a remote observational study with four subjects. In the study, two malfunctioning RxJS programs were presented to the subjects. The subjects were asked to locate and fix the problems in the applications source code. To do so, they should use the debugging utilities they would use in their daily jobs as well. [@fig:result-observational-study] summarizes the results. All subjects used manual code modifications (i.e., print statements) to understand the behavior of the presented problems. Over half of them tried to use the imperative debugger of their IDE. The most pivotal insight was that, even though two subjects stated to know about specialized RxJS debugging tools, none of them used such during the study.

```{.include}
content/figures/result-observational-study.tex
```

The results of the interviews, the analysis of the war story reports, and the interpretation of the observed behaviors during the observational study lead to the following two key take-aways:

1. The most significant challenge software engineers face when debugging RxJS-based programs is to know *when* they should apply *what* tool to resolve a problem the *best* way
2. Since engineers abstained from using specific RxJS debuggers, how can such tools be provided without requiring them to switch context, thus be ready to hand?

I summarized the results of this first stage in the research process in the workshop paper "Debugging of RxJS-Based Applications" [@Alabor_Stolze_2020] together with Markus Stolze. This paper was published with the proceedings of the 7th ACM SIGPLAN International Workshop
on Reactive and Event-Based Languages and Systems (REBLS' 20) and is available in [Appendix @sec:paper-1].

## Proof Of Concept

Based on the learnings from the first phase, I started to compile ideas to help software engineers debug RxJS programs. It was essential that a potential solution:

1. Integrates seamlessly with an IDE
2. Is ready to hand, i.e. requires minimal to no effort from its users to get started with debugging

McDirmid [@McDirmid_2013] proposed with the concept of "probes" for live programming environments a way to trace variable values during runtime directly in the source code editor. Similarly, imperative debuggers provide log points, a special type of "breakpoint". Instead of halting the program, they print an arbitrary log entry to the debugging console. Using the debugging process by Layman et al. [@Layman_Diep_Nagappan_Singer_Deline_Venolia_2013] as a mental model, I combined the two concepts and transferred them to the world of RP debugging for RxJS: The *operator log point*^[Inspired by McDirmid [@McDirmid_2013], operator log points* were called *probes* in the PoC and the early prototype of the extension. This name caused confusion with the test subjects in a later usability test. I renamed the utility based on the received feedback in turn.] shows the events emitted by an operator during program execution in realtime.

After establishing the PoC for operator log points as an extension for vscode, I used the cognitive walkthrough method after Wharton et al. [@Wharton_Rieman_Clayton_Polson_1994] to verify the utility. The results ([Appendix @sec:paper-2-supplementary]) demonstrated successfully that the proposed debugging utility replaces manual print statements in a scenario where engineers debug RxJS programs.

A user journey maps the touch points of a user with a product [@richardson2010using]. I used this format to show how a software engineer solves an RxJS debugging task with an imperative debugger. In addition, I created one more journey demonstrating how the same task can be solved using operator log points. I combined the two user journeys in a "comparative user journey" ([Appendix @sec:user-journey]). The resulting format allowed me to convey the improvement achieved through operator log points over imperative debuggers and manual print statements effectively.


## Prototype

I showed that operator log points satisfy all requirements defined in the previous stage of the process. According to this, I started with the actual implementation work for a production-ready vscode extension. I released version 0.1.0 of "RxJS Debugging for vscode" eventually. This marked the availability of the first complete integrated RxJS debugger for an IDE.

The prototype of the extension enabled engineers to debug RxJS-based applications running with Node.js. After they installed the extension, the debugger started to suggested operator log points with a small, diamond-shaped icon next to the respective operator. Next, the engineer launched their application using vscode's built-in JavaScript debugger. The RP debugger automatically augmented RxJS so it started to send event telemetry to vscode. The extension then displayed events for enabled operator log points in-line with the respective operator in the source code editor.

TODO Screenshot of Prototype

There were various challenges and tasks to solve during the Prototype phase. The following two sections present two highlights.

### Communication with Node.js

One of the biggest challenges implementing the prototype was to build a reliable way to communicate with RxJS running inside the Node.js process. For example, I initially used a WebSocket to exchange messages with the JavaScript runtime. However, this proved to be tedious in numerous ways: E.g., how should the extension discover the WebSocket server running in the other process, what if the network infrastructure prevents vscode from connecting to the WebSocket in the first place, or how would such a solution even work at all when RxJS is running in a browser? I decided to look for a way to replace the WebSocket-based communication with something more suitable.

With the intent to build a debugger that integrates with the IDE seamlessly, I started to look into how the built-in JavaScript debugger, vscode-js-debug^[https://github.com/microsoft/vscode-js-debug], communicates with the runtime environment. As it turned out, vscode-js-debug uses the Chrome DevTools Protocol^[https://chromedevtools.github.io/devtools-protocol/] (CDP) to communicate with arbitrary JavaScript runtimes. Unfortunately, the debugger did not offer its CDP connection for reuse to other extensions. I reached out to the project maintainer and contributed this particular functionality as a new feature ([Appendix @sec:cdp-pull-request]). By the time my contribution was released in April 2021, I had replaced the previous WebSocket-based communication channel with CDP. Furthermore, I had now a future-proof solution, which not only worked with RxJS running inside of a Node.js process, but also in any other JavaScript virtual machine that supports CDP (e.g., web browsers like Mozilla Firefox and Google Chrome).

[@fig:architecture] presents an overview on all relevant components involved in an RxJS RP debugging session. More details to the extensions architecture is available in [Appendix @sec:architecture].

TODO redo diagram so it uses the same names as in the text (vscode-js-debug)

```{.include}
content/figures/architecture.tex
```

### Moderated Remote Usability Test

Once the main elements of the prototype were working sufficiently, I conducted a remote usability test [@Nielsen_Participants_1994; @Boren_Ramey_2000; @Norgaard_Hornbaek_2006] with three subjects. The goals of this study were:

1. To verify that operator log points can replace manual print statements in an actual programming scenario
2. To identify usability issues not detected during development
3. To collect unstructured feedback on prototype and gather ideas for its further development

Unfortunately, one subject could not get the extension prototype running on their machine. With the other two subjects left, I was able to verify the first two goals nonetheless. None of them used manual print statements during the usability test. Additionally, the evaluation of the test sessions revealed ten new usability issues. Four of them prevailed for both subjects, hence I classified them as major. The complete list of identified usability issues is available in [Appendix @sec:paper-2-supplementary].

I triaged the feedback from all three subjects and created items in the feature backlog for the upcoming Finalization phase accordingly. With this, the last goal was reached as well.


## Finalization

The last process phase had two overarching goals:

1. To finalize the RP debugger prototype and release it to the community
2. To publish another research paper documenting the feasibility of an IDE-integrated RP debugger

To get started, I defined the roadmap for the extensions 1.0.0 release, which is available in [Appendix @sec:major-milestone]. The following list presents its highlights:

- Support the latest RxJS 7.x versions (only 6.6.7 was supported with the prototype)
- Debugging of web applications bundled with Webpack (only the Node.js virtual machine was supported so far)
- Resolve the four major usability issues identified during the Prototype stage

Version 1.0.0 of "RxJS Debugging for vscode" was finally released on the 2nd of December 2021 and was followed by three minor bugfix releases within six days.

### Community Reception

On the day of release, I announced the debugger extension via its own Twitter account [\@rxjsdebugging](https://twitter.com/rxjsdebugging). Until the 30th of December 2021, the tweet got 77k impressions ([Appendix @sec:release-tweet-stats]). Further, the extension was downloaded 954 times ([Appendix @sec:marketplace]), counted 51 unique users ([Appendices @sec:analytics; Appendices @sec:analytics-dashboard]), and was featured in a live stream on Twitch^[David Müllerchen aka [\@webdave_de](https://twitter.com/webdave_de), a Google Developer Expert specialized on Angular development, hosted the live reaction stream on Twitch. Unfortunately, the recording of the stream is unavailable at this time.].

Based on the results of the studies conducted before, I concluded that there was a real need for an integrated RP debugger for RxJS. The overall positive reception on RxJS Debugging for vscode was overwhelming nonetheless. However, the major release also revealed bugs and feature gaps in the extension. Nevertheless, I resolved the most critical problems within a few days (see the changelog in [Appendix @sec:changelog]). In addition, I triaged valuable feedback using GitHub Discussions^[https://github.com/swissmanu/rxjs-debugging-for-vscode/discussions] and the feature backlog ([Appendix @sec:feature-backlog]).

### ISSTA `22 Research Paper

In contrast to the delivered practical effort, I wrote a new research paper with Markus Stolze. The paper documents the latest advancements on the feasibility of an RP debugger that is ready to hand and fully integrated with an IDE. The latest version of this paper was submitted to the technical papers track of the 31st ACM SIGSOFT International Symposium on Software Testing and Analysis 2022 (ISSTA `22) at the time of publishing this thesis. The submitted paper includes revisions based on the feedback of a double-blind review with three reviewers and is available in [Appendix @sec:paper-2].

# Future Work {#sec:future-work}

## Empirical Software Engineering

RxJS Debugging for vscode provides a practical solution to the problems identified throughout the presented research process, and further empirical verifications can now be carried out.

Operator log points were successfully tested using usability testing methods during their development. However, a formal verification using empirical methods will yield useful insight into the presented debugging utility. The most important research question to answer in these regards is, how effectively operator log points can replace existing debugging tools (i.e., manual print statements and the built-in, imperative debugger tools).

The shown debugging extension collects user behavior data since its major release. This data is available for further analysis ([Appendix @sec:analytics]). The accumulated data points allow conclusions on how software engineers use the extension. The data set might be evaluated on its own to derive improvements for the presented debugging utility or provide supportive arguments for a broader study as proposed above.

### Open Science

All conducted studies (interviews, observational study, cognitive walkthrough and moderated remote usability test) and their results are documented in the respective research papers and their supplementary material available in [Appendices @sec:paper-1; Appendices @sec:paper-2; Appendices @sec:user-journey]) to encourage future research on RP debugging. In addition, a list of URLs leading to various GitHub repositories containing relevant artifacts and data sets is available in [Appendix @sec:open-science].

## Open Source

I developed the presented RxJS debugging extension with the intention to establish a sustainable open source project.

The contribution and architecture guides ([Appendices @sec:contributing; Appendices @sec:architecture]) introduce new contributors to the extension's implementation and code organization details. The transparent project governance is built around the GitHub platform: The feature backlog and bug-tracking are based on GitHub Issues, Discussions help triage inquiries from users. Unit and integration tests, automatically executed using GitHub Actions, help keep the extension's main branch stable.

The feature backlog in [Appendix @sec:feature-backlog] contains various ideas for practical-oriented future work. I present two features from this backlog in the following.

### User Onboarding after Installation ([Issue #58](https://github.com/swissmanu/rxjs-debugging-for-vscode/issues/58))

After an engineer installed the extension, they are left on their own to get started with debugging. Even though the readme file provides information to some extent, the onboarding experience for new users can be improved. With this feature, ways to enhance that experience should be explored and suitable measures be implemented eventually.

A contributor needs to understand the vscode extension API. However, profound knowledge of the extension's source code is not required.

### Log Point History ([Issue #44](https://github.com/swissmanu/rxjs-debugging-for-vscode/issues/44))

Instead of showing only the latest emitted event from an enabled operator log point, the debugger should display all previously emitted events. This functionality would allow engineers to reconstruct the behavior of an operator without over and over replaying the failure scenario using the live system.

A contribution could start simple by implementing a list displaying historic events in textual form. The list could then be gradually improved towards a graphical representation of the events using marble diagrams.

This feature requires a good understanding of the vscode extension API as well as in-depth knowledge of the debugging extensions codebase.


# Conclusion {#sec:conclusion}

In this summative thesis, I presented the condensed results of my research on reactive debugging for programs based on RxJS, a popular library for reactive programming with JavaScript.

The results of interviews, war story reports, and an observational study revealed the major shortcoming of previously available RxJS debugging utilities. Even though software engineers might know them, they abstain from using them because they are not "ready to hand," i.e., not integrated with the IDE they are working in and accustomed to. Instead, they use manual print statements.

With the concept of "readiness to hand" as a guiding light, I built a proof of concept implementation for a novel debugging utility to find relief from this problem: Operator log points debug RxJS operators without requiring the engineer to leave Microsoft Visual Studio Code. While refining the debugger iteratively, I employed a cognitive walkthrough, a comparative user journey, and a usability test at different stages of development to validate the utility's capability of solving the problem of "ready-to-hand" debugging.

I documented the results of my research together with Markus Stolze in two research papers: The first paper was published with the proceedings of the ACM REBLS '20 workshop. The second report is in review for the technical papers track of the ACM ISSTA '22 conference when publishing this thesis. Furthermore, I released "RxJS Debugging for Visual Studio Code," the first RxJS-specific debugger that fully integrates with an IDE at the end of 2021.

By providing open access to all relevant material (studies, results, papers, source code, and project governance), academical- and practical-oriented future work is encouraged. To facilitate potential contributions further, I suggested concrete topics for researchers and engineers likewise.

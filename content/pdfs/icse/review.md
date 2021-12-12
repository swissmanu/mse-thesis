<!-- build using: docker run -it --rm -v `pwd`:/data ghcr.io/swissmanu/pandoc pandoc -f markdown+raw_tex -o review.pdf ./review.md -->

# ICSE 2022 Paper #121 Reviews and Comments

Paper #121 Debugging Support for Reactive Programming: User-Centered
Development of a Debugger for RxJS


## Review #121A

### Overall merit
1. Reject

### Paper summary
This paper describes RxJS Debugging for vscode, a tool that provides a more natural debugging interface for reactive programs. The paper describes shortcomings of traditional debugging tools and demonstrates how improved tooling could help developers better understand how their programs are executing without manually inserting logging statements. The usability of the tool is evaluated through a two-user study.

### Strengths
- The paper addresses a clear weakness in existing tooling.
- Debugging reactive programs is likely to be an area of increased importance.

### Weaknesses
- While the paper describes an initial usability study, a more comprehensive evaluation is needed.
- It is not clear whether the presented tool addresses the shortcomings previously identified by Alabor et al. who found that developers did not use these tools, even if they exist.

### Comments for authors
Soundness: The paper presents a useful and complete initial validation into the usability of the proposed approach.

Significance: Conceptually, the tool relieves the developer from having to manually write (and remove) logging statements in their reactive programs. While this is helpful, and can provide developers useful information (as they currently _do_ write these statements), it is not clear that this is what developers actually want. For example, tools do not do what they want now, developers write logging statements (which this approach emulates), but do they want different functionality that is not easily approximated by inserting logging? An example of this is traditional debugging: while developers do insert logging statement in normal code too, the heavy use of breakpoints show that developers did want additional tools to interrupt the execution of their programs, despite only using log-style statements in environments that did not support breakpoints.

Verifiability: The paper clearly describes the research method followed and the feedback from the initial participants. The main shortcoming of this though is that the feedback is preliminary and small-scale, only investigating two developers working on a controlled task. Looking at non-controlled tasks, or examining more developers would provide greater insight into the strengths and weaknesses of the tool. Additionally, prior work has shown that developers do not use tools, despite knowing they exist. It is not clear that vscode integration of this log-centric approach is sufficient for developers to actually start using these tools, or if they desire more complex or tailored functionality. These insights would probably only be possible through a broader set of investigative measures.

### Questions for authors to respond to
1. Alabor et. al. found that developers did not use Rx debugging tools, despite their existence. Beyond the vscode integration, is there evidence that this approach would cause developers to start using the approach?

### Comments on the author's response
Thank you for your response comments. The added clarity around the intent of the paper (to demonstrate feasibility) is appreciated. That said, I still feel that additional validation is required to demonstrate that the tool, while feasible, can be used by developers working on reactive systems.



## Review #121B

### Overall merit
1. Reject

### Paper summary
Debugging is particularly hard in reactive programming, as the APIs it requires makes it harder for developers to use the debugger to step through code. This paper proposes using log statements to address this issues. It describes the RxJS RP debugger, a tool which identifies potential log points by finding API interactions in code and offers developers a button to log these interactions. A think-aloud usability study with two participants found 4 usability issues that were a problem for both participants.

### Strengths
- practical focus on building a programming tool which addresses developer pain points, carried out through a user-center design process engaging with developers

### Weaknesses
- very minimal change from current tools
- no argument about why this is approach is a step forward from similar existing tools
- superficial evaluation of usability rather than novel ideas

### Comments for authors

***Soundness***

The tool appears to be able to work as described.

The novel tool is evaluated solely through a think-aloud usability study. This form of study is a formative rather than summative evaluation technique. That is, it is designed to find issues with the design to enable it to be improved rather than to evaluate its overall benefits. It is not designed to offer evidence about the benefits of a technique or to compare it to another technique. As a result, the paper lacks any meaningful evaluation of the contribution.

***Novelty***

The paper argues that this tool is more effective than prior approaches in that it is ready-in-hand. That is, rather than being a standalone tool, the tool is integrated into the developer’s IDE. However, this is, by itself, not a research contribution. IDEs have for decades included a robust IDE plugin infrastructure (e.g., Eclipse), making it possible to extend these IDEs with new tool features. Modern IDEs such as VS Code include their own dedicated ecosystem (VS MarketPlace) for finding and downloading such plugins. In this way, it’s unclear what the contribution is in making an IDE plugin rather than a standalone tool.

The tool differs from prior tools in offering developers the ability to more easily add log statements to operators in data flows. However, there are a number of existing tools which already support observing data flow in reactive programming, as described in the related work. For example, Reactive Inspector [15] lets developers see the data flowing between nodes in a visualization. These tools both log data and visualize it. There is no argument made about why using log statements is better than these existing tools. So it’s unclear how just logging data is a contribution beyond these tools.

***Significance***

Making a reactive debugger integrate into a developers’ workflow so it can be quickly and easily used by developers is a laudable and important goal. But the tool does not seem to offer a step forward towards this goal, as existing reactive debuggers help address this issue. Moreover, as described in the future work section, approaches such as Record and Replay and Time Travel debugging offer a much improved logging experience beyond that offered here. Given this, it’s unclear what new generalizable knowledge this work creates.

***Verifiability & Transparency***

The paper describes the key parts of the methods used. The paper includes links to the tool, study materials, and results. But all of these links are marked with the text “WARNING: This link might reveal the author(s) identity/identities”.

***Presentation***

The paper is well-organized and easy to follow.



## Review #121C

### Overall merit
3. Weak accept

### Paper summary
This paper describes a tool to allow the debugging of dataflow-based
reactive programs for which control-flow debuggers provide
inappropriate features. Namely, the described system offers features
relevant within the RP programmers workflow, i.e. log points to log
intermediate values within the flow graph. This feature prevents
programmers for adding numerous print statements in the program that
prove difficult to manage afterwards. The system has been designed and
evaluated following a user-centered process.

### Strengths
The strong aspect of the paper lies in the user centered
methodology. It is relevant, and has been applied in a sound way. A
cognitive walkthrough has been conducted to identify main usability
issues (6), and remote usability testing has been performed to
identify UX issues (4).

Another positive aspect is the the approach which aims at
understanding the programmer workflow. This aspect is however not
enough grounded (see below).

The proposed feature (log points) seems useful and efficient
and the paper clearly describes the limitations of the system.

### Weaknesses
A first improvement is related to the structure of the paper,
which could gain in clarity.
- the problem with standard debugging tools with respect to RP
programming is explained a bit late in the paper; it could be made
easier for the reader to introduce this from the beginning
(e.g. introduction) rather than only at the end of section 2.
In the same way, describing programmers motivations for debugging
could be done in the introduction rather than in the related work
section.

Another important area for improvement is related to the main
contribution of the paper. The authors claim that the feature they
offer in their system aims at taking the programming workflow of RP
programmer more efficiently. However, no proper study (e.g interviews)
has been conducted regarding this workflow, and the paper does not
evaluate this aspect. The cognitive walkthrough is a good method at
soon as the alignement to the actual workflow is checked, but this
method provides a quite strict sequence of action. It could be
interesting to organize more informal workshops with programmers
observing their actual use of the tool without being prescribed a
sequence of tasks.

More details could be provided regarding the study participants: how
many were there? with their approximate level of experience.

Related work:
References to the field of psychology of programming and programming
tools usability could be relevant.

----

## Author-Comments Response by Manuel Alabor <manuel.alabor@ost.ch> (389 words)

### Rebuttal

Thank you for taking the time to review our submission thoroughly.

One important point (that somehow has not become clear enough) is that we do **not** try to make any claims regarding our presented tool's efficiency for RxJS debugging. Rather our claim (and innovation) is, that we provide the first RxJS-specific debugger that is ready-to-hand for software engineers acquainted with debugging tools for "regular" (i.e., non-reactive) programs.

Alabor et al. identified the lack of readiness-to-hand as the main problem in their analysis of RxJS debugging practices. Thus, this is what we provide a solution for: An RxJS debugging tool with the necessary features that make it readily usable for software engineers -- without any introduction or training. The HCI-methods (Cognitive Walkthrough and small scale Usability Test) where employed exclusively with the goal to ensure and demonstrate immediate readiness-to-hand and usability of the provided tool during first-use.

Thus, the contribution and innovation we present is the **feasibility** of a debugging support tool which blends seamlessly with other debugging tools for non-reactive programming. Log points allow us to demonstrate this feasibility in a simple and tangible way while providing certainty for future research projects searching to weave other known debugging concepts (e.g., breakpoints) for reactive debugging with established IDE UI patterns.

We are confident, that our demonstrated approach forms the conceptual and technical blueprint for other researchers and practitioners to integrate reactive debugging tools in a seamless and ready-to-hand way.

In summary, our research contribution is the proof by existence of the feasibility of a ready-to-hand tool for reactive debugging of RxJS programs, seamlessly integrating with non-reactive programming debugging tools.



### Review-Specific Responses

- **Review #121B**
  - "Verifiability & Transparency"
    - We kindly ask you to have a look at the supplementary material, provided along with our submitted paper. It contains the relevant data from our usability inspection and validation without revealing authorship. Links annotated with "WARNING" lead to further, additional information with lesser relevance for the double-blind review phase.
- **Review #121C**
  - "Related Work"
    - Thank you for pointing out that we could strengthen our paper by linking to additional work from the field of psychology of programming and programming tool usability. So we are currently envisioning to add to our discussion of Layman et al., also related work by Brad Myers and follow-up work. This might indeed open an additional angle on the discussed topic.

----

## Meta-Review
The paper has been extensively discussed by the reviewers in order to come to a joined conclusion.

The reviewers see the potential merits but according to them, there is not enough argument about why this is approach is a step forward from similar existing tools and a more comprehensive evaluation is needed.

While your clarification that this is a feasibility study for the creation of the debugger, RA does not think a three-subject walkthrough is sufficient validation of an approach. Besides, RB still questions that the "ready at hand" is a research challenge rather than an engineering effort.

As a result, the reviewers agreed to recommend that this paper is rejected for ICSE 2022. We hope the reviews will help the authors to strengthen their work.

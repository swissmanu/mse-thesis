# Introduction

*Goal: Make this thesis sound plausible to the common computer science guy. They should think: That sounds plausible... Good stuff!*

## Programming Paradigms

While mutliple programming language paradigms evolved over the years since the research community established the field of computer sciences, most of todays mainstream languages are based either on the imperative and/or declarative paradigm[@CITE SOME SOURCE]^[Two examples for multi-paradigm languages are Scala or ECMAScript.]. Traditionally, a program implemented with an imperative language (e.g., Fortran, Pascal, or C) modifies implicit state using side-effects through a sequence of commands [@Hudak_1989]. The basic assignment statement binds a value to a variable (i.e., modifies state) whereas the execution-flow of the program is controlled using conditional (e.g., `if`, `while`, or `for`) and unconditional (i.e., `goto`) control-flow statements.

```{
	caption="A program implemented in C producing the 10th element of the Fibonacci sequence, 34. Implicit state is stored in the variables fib and i and modified in a for-loop control-flow statement."
	language=C
}
#include <stdio.h>

int main() {
	int fib[10];
	fib[0] = 0;
	fib[1] = 1;
	int i;
	
	for (i = 2; i <= 9; i++) {
		fib[i] = fib[i - 1] + fib[i - 2];
	}
	// fib[9] contains now the desired result: 34
}
```

With a declarative programming language, computational results must be carried explicitly from one unit of the program to the next, hence it lacks of any implicit state [@Hudak_1989]. The source code of a program implemented with a declarative language is the blueprint of *what* the program is expected to accomplish eventually, whereas its imperative sibling resembles a precise step-by-step instruction on *how* the expected result must be achieved. A functional programming (FP) language (e.g., Erlang or Haskell) is a specific type of declarative language. Its execution model is based on function and expression evaluation [@CITE FP EXECUTION MODEL], thus the programs result is the value of its evaluation rather than the value assigned to a state variable. Imperative loop statements are substituted with recursive function calls and conditional statements replaced^[Even though FP languages often provide an `if` expression (e.g., Scala), this is not equivalent with the imperative conditional statement. Being an expression, `if` is gets simply evaluated to a value rather than branching off to a guarded sequence of commands.] by mechanisms like pattern matching [@CITE PATTERN MATCHING CONDITIONALS].

```{
	caption="A (naive) implementation of the Fibonacci sequence in Haskell, producing its 10th element. All elements for n < 9 are calculated using recursive calls of fib."
	language=Haskell
}
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
fib 9 -- Yields 34
```

## Tooling




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


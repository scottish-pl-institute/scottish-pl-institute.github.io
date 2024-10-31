---
title: SPLI Distinguished Lecture -- Satnam Singh
description: As part of the SPLI Distinguished Lecture series, joint with the University of Edinburgh's institutional seminar series, Satnam Singh, Fellow at Groq, will give an SPLI Distinguished Lecture about accelerating LLMs.
---

As part of the SPLI Distinguished Lecture series, and joint with the University of Edinburgh's AIAI, ANC, ICSA, ILCC, IPAB, LFCS institutional seminar series, Satnam Singh, Fellow at Groq, will give an SPLI Distinguished Lecture about accelerating LLMs. Satnam's lecture will be held at the University of Edinburgh.

# Recording
Satnam's talk was recorded, and is now available on [YouTube](https://www.youtube.com/watch?v=_VrAhB4mCfM).

# Talk Details

**Title:** Accelerating Large Language Models with Groq’s LPU Machine Learning Chips

**Speaker:** Satnam Singh, Fellow, Groq

**Location:** Informatics Forum, G.07

**Time:** Thursday 26th September, 4PM

**Abstract:**
Groq’s Language Processing Unit (LPU) chips are reshaping the landscape of large language model (LLM) deployment at scale. By prioritizing low latency and high throughput, our hardware and software stack enables rapid and efficient inference, making it ideal for applications where LLMs must be invoked repeatedly by agents e.g. for solving mathematical problems.

In this talk I will describe the unique architecture of Groq’s LPU chips, which leverage deterministic execution and distributed SRAM to deliver remarkable performance with very low latency and high throughput. I will explain how this determinism allows us to deploy complex models such as Llama3-70B, Gemma2, and Mixtral 8x7B with predictable, scalable performance.

I will describe the architecture of our compiler which is built on the MLIR framework for the front end, and a Haskell-based backend. Further, I will discuss the network architecture that facilitates efficient multi-rack deployments of LLMs using Kubernetes, ensuring that scaling up does not compromise performance.

Finally, I will share insights from my own direct contributions to the project, including the design of special power management hardware, developing a Haskell-based domain-specific language for programming our chips, and applying formal verification techniques using temporal logic and model checking to verify the functionality of our chip designs.

Try out our LLM chatbot at http://groq.com

# Biography

Satnam Singh is a Fellow at Groq where he applies the power of functional programming languages to the design of machine learning chips and their programming models. Satnam Singh previously worked at Google (machine learning chips, cluster management, Kubernetes), Facebook (Android optimization), Microsoft (parallel and concurrent programming) and Xilinx (Lava DSL for hardware design, formal verification of hardware). He started his career as an academic at the University of Glasgow (FPGA-based application acceleration and functional programming).

His research interests include functional programming in Haskell, high level techniques for hardware design (Lava, Bluespec, DSLs in Haskell, Coq and C#), formal methods (SAT-solvers, model checkers, theorem provers), FPGAs, and concurrent and parallel programming.

# Location

The talk will be held at the [Informatics Forum](https://informatics.ed.ac.uk/about/location), University of Edinburgh.

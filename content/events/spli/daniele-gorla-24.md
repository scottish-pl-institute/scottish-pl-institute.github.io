---
title: SPLI Distinguished Lecture Series -- Prof. Daniele Gorla
description: As part of the SPLI Distinguished Lecture Series, Prof. Daniele Gorla will give a 9 hour long PhD-level course on concurrent programming.
---

## Overview

*Prof. Daniele Gorla (“Sapienza” University of Rome) will give a 9 hours PhD course
Thursday 8, 15 and 22 August from 11:00 to 15:00 in IF G.03 (Edinburgh)*

Sign up by the 1st August 2024 on [Doodle](https://doodle.com/meeting/organize/id/av96P1ge)
(or e-mail Rob van Glabbeek if you do not like Doodle).

You can also participate remotely on [Zoom](https://ed-ac-uk.zoom.us/j/83428825005) (passcode 1n3AHhVL); if you like calendar invites you can download the [.ics files](https://ed-ac-uk.zoom.us/meeting/tZcpdeGgrD4qGtGioZsfoLxmhUFy002a0Ynx/ics?icsToken=98tyKuGrqjkiEtaQsBmCRpwqBojoWfzzpiVfjbd6lRDfECZcThv7PtdkK-IvQtmA).

## Details
This mini-course is focused on the foundational aspects of concurrent systems. The aim of these lectures is to describe the main characteristics and the basilar problems of every concurrent system (mutual exclusion, synchronization, atomicity, deadlock/livelock/starvation, ...) and the relative solutions at the implementation level (semaphores, monitors, system primitives, ...). Furthermore, more evolute notions are shown, like: failure detectors, their implementation and their use to obtain wait-free implementations; universal object, consensus object and consensus number.

The detailed syllabus of the course is the following: 

  * The mutual exclusion problem; safety and liveness properties; a hierarchy of liveness properties (bounded bypass; starvation freedom; deadlock freedom).

  * Atomic read/write registers; mutex for 2 processes (Peterson algorithm) and for n processes (generalized Peterson algorithm). Other lock/unlock protocols with better time performances.

  * From Deadlock freedom to Starvation freedom (and bounded bypass) using atomic r/w-registers.

  * Mutex with specialized HW primitives (test &amp; set; swap; compare &amp; fetch &amp; add).

  * Mutex with safe registers: Lamport's Bakery algorithm and Aravind bounded algorithm.

  * Higher-level programming constructs for Mutex: semaphores and monitors, and their application for solving standard problems (producers/consumers; rendez-vous; dining philosophers).

  * Mutex-free concurrency: liveness conditions (obstruction freedom, non-blocking, and wait freedom).

  * Universal object, consensus object, and universality of consensus. Binary vs multivalued consensus. Consensus number (for atomic R/W registers, test &amp; set, swap, fetch &amp; add, compare &amp; swap) and consensus hierarchy.

The classes will be mostly focused on the algorithmic aspects of concurrency; they will provide the main ideas underlying the various problems and their relative solutions, without entering into many technical proofs. Full details can be found in the book by Michel Raynal “Concurrent Programming: Algorithms, Principles and Foundations” (Springer, 2013), which is the reference text for the lectures. No prior knowledge will be assumed.

The course will be organized in 6 classes of 1.5 hours each, arranged in 3 days (2 classes a day) of 3 consecutive weeks (1 day per week); the first 5 classes will provide normal lectures whereas the closing class will be a discussion on open problems and possible connections with the research topics of the attendees.

The course will take place in the Informatics Forum, Room G.03, of the University of Edinburgh. The first class will start at 11am; then, at 12.30pm there will be a 1-hour lunch break (with a light lunch provided by the University of Edinburgh); finally, from 1.30pm there will be the second class. In this way also students coming from other Scottish universities can attend the course without having to sleep in Edinburgh.

Please sign up if you plan to attend (and cancel if you change your mind). This helps planning catering. In fact, to join for lunch you should let us know by the 1st August 2024. But you will be welcome to the lectures even if you have not signed up.

## Slides

  * [Class 1](/assets/static/gorla/class1.pdf)

## Lecture Recordings

  * [Thursday 8th August, Lecture 1](https://ed-ac-uk.zoom.us/recording/detail?meeting_id=OTMrIEt2RFKYhncFWBDDMw%3D%3D)
  * [Thursday 8th August, Lecture 2](https://ed-ac-uk.zoom.us/recording/detail?meeting_id=nqqmsBW9TZeTh7As%2BKbbjA%3D%3D)

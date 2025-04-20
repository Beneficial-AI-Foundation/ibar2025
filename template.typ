#import "@preview/touying:0.6.1": *
#import "@preview/touying-unistra-pristine:1.3.1": *

#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Working on Guaranteed Safe AI],
    subtitle: [],
    author: [`quinn@beneficialaifoundation.org`],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image("images/baif.svg"),
  ),
)

#title-slide(logo: image("images/baif.svg"))

Views are my own. GSAI is fairly new and has lots of authors with internal disagreements.

#focus-slide(
    theme: "neon",
    [What is Guaranteed Safe AI?]
)

= What is Guaranteed Safe AI

Family of research agendas / AI safety strategies involving:
- *Proof certificates* over model outputs, not internals. #pause (Moreso what I work on)
- *World models* and simulations therein. (Moreso the davidad/ARIA side of the pond)

== Proof certificates over model outputs, not internals
- There was some work trying to combine proof certs with mechinterp (Gross et al 2024), but it's not cruxy for GSAI.
#pause
- Instead, we're interested in the code that the learned component is writing (i.e., a _blackbox approach_).
#pause
- We would like that code to be formally verifiable

== Proof certs over model outputs: example
Imagine Anthropic asks Claude to write a *secure cloud OS kernel*. #pause In addition to synthesizing the *implementation*, Claude should also synthesize *proofs* that the implementation is _correct_.
\ \ #pause
$P {c} Q <-> forall (s s': "State"), P(s) -> "exec"(c,s) = s' -> Q(s')$
#pause Predicate $P$ is a _precondition_ and predicate $Q$ is a _postcondition_. #pause Together, they form a *specification* for program $c$.

== World models and simulations therein
To evaluate how an *output* _effects_ the world, you could *simulate* the world. #pause One form of *probabilistic proof cert* could be a set of trajectories in a simulation with the observation that the world turns out "bad" in bounded percentage of them.
\ \ #pause #image("images/expectedvalue.png") (davidad 2024)

== World models and simulations: example
Consider the stochastic heat equation: $frac(partial u(t,x), partial t) = alpha nabla^2 u(t,x) + sigma xi(t,x)$ #pause\ \
$P_{>=p}[F^{<=t} (|u(t,x) - u_"eq"| < delta)]$: "The probability that temperature reaches near-equilibrium within time $t$ is at least $p$" \ \

This is a spec in _continuous stochastic logic_, and you can get certs about a system with model checking.

= Assumptions
- *Boxing/containment*: probably doesn't work with arbitrarily unboxing schemers
- *Swiss cheese*: "defense in depth"

== Boxing/containment
- We're *micromanaging the interface* between the AI and the world.
#pause
- The aim is to get us through _some_ stages of AGI (say, 25% of acute risk period) and hopefully our successors at that point will bootstrap it into solutions that work for arbitrary superintelligences
#pause
- But even formal methods would leave side channel attacks open for a scheming ASI to exploit

== Swiss cheese (defense in depth)
#image("images/swisscheese.png", height: 75%)

== Main position paper
#image("images/tgsai.png", height: 75%)

= Synergies with other agendas
- Cybersecurity
- Control

== GSAIxCybersecurity
=== Similarities:
- Reducing _attack surface_
- Hardening infrastructure
#pause
=== Differences:
- GSAI emphasizes _prevention_ more than _detection_

== GSAIxControl
=== Similarities:
- Blackbox as opposed to whitebox
- Containment schemes as opposed to assuming alignment
#pause
=== Differences:
- Control emphasizes insider risk more than GSAI
- GSAI looks for formal proof and subtopics where that makes sense (i.e. where there is inductive structure to be exploited)

#focus-slide(
  theme: "neon",
  [
    What is working on GSAI like (example projects)
  ],
)

= FVAPPS
Formally Verified APPS, translating Hendrycks et al 2021 into a Lean benchmark
#image("images/fvapps-abstract.png")

=== FVAPPS: Formally Verified APPS
#image("images/fvapps-fig1.png")

=== FVAPPS: Formally Verified APPS (on HuggingFace)
#image("images/fvapps-hf.png", height: 75%)

=== FVAPPS: Formally Verified APPS (example sample puzzle)
Now elections are held in Berland and you want to win them. More precisely, you want everyone to vote for you.

There are $n$ voters, and two ways to convince each of them to vote for you. The first way to convince the $i$-th voter is to pay him $p_i$ coins. The second way is to make $m_i$ other voters vote for you, and the $i$-th voter will vote for free.

Moreover, the process of such voting takes place in several steps. For example, if there are five voters with $m_1 = 1$, $m_2 = 2$, $m_3 = 2$, $m_4 = 4$, $m_5 = 5$, then you can buy the vote of the fifth voter, and eventually everyone will vote for you. Set of people voting for you will change as follows: ${5} -> {1, 5} -> {1, 2, 3, 5} -> {1, 2, 3, 4, 5}$.

Calculate the minimum number of coins you have to spend so that everyone votes for you.

=== FVAPPS: Formally Verified APPS (example sample)
```lean
def solve_elections (n : Nat) (voters : List (Nat × Nat)) : Nat := sorry

theorem solve_elections_nonnegative (n : Nat) (voters : List (Nat × Nat)) : solve_elections n voters ≥ 0 := sorry

theorem solve_elections_upper_bound (n : Nat) (voters : List (Nat × Nat)) : solve_elections n voters ≤ List.foldl (λ acc (pair : Nat × Nat) => acc + pair.2) 0 voters := sorry

theorem solve_elections_zero_votes (n : Nat) (voters : List (Nat × Nat)) : (List.all voters (λ pair => pair.1 = 0)) → solve_elections n voters = 0 := sorry

theorem solve_elections_single_zero_vote : solve_elections 1 [(0, 5)] = 0 := sorry
```

=== FVAPPS: Formally Verified APPS (for synthetic data)
A benchmark with tool use as ground truth can be a *synthetic data pipeline*
- I'm excited for using FVAPPS solutions to make finetune datasets

= RefinedC Copilot
Automating C verification (_in progress_)
#image("images/refinedc.png")

== RefinedC Copilot: A Scaffold
#image("images/refinedc-copilot-flowchart.png", height: 75%)

== RefinedC Copilot: From 99.9% to 99.999%
#pause
- Right now, gaining nines (of assurance) is not cost effective
#pause
- Because labor costs of formal verification
#pause
- Maybe we can make that cheaper with automation?
#pause
It's a live hypothesis, the project isn't super far along yet.

#focus-slide(
    theme: "neon",
    [Should you work on GSAI]
)

== Are the arguments convincing?
#pause
- Can you *poke holes* in the worldview?
  #pause
- Comparing/contrasting with competing agendas
  #pause
- Estimate $p("success")$, $p("success" | x "investment")$, etc.

== Personal fit (skills, interests, what is fun)
#pause
- Formal verification
#pause
- Programming language theory (including probabilistic semantics)
#pause
- ML/LLM stuff is mostly from a black box perspective. Lots of scaffolds.

#focus-slide(
    theme: "neon",
    [Hear more at gsai.substack.com]
)

#title-slide(logo: image("images/baif.svg"))

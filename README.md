# GitDashIt

GitHub is a free dashboard you can push plots to.

<!---
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://murrellb.github.io/GitDashIt.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://murrellb.github.io/GitDashIt.jl/dev/)
[![Build Status](https://github.com/murrellb/GitDashIt.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/murrellb/GitDashIt.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/murrellb/GitDashIt.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/murrellb/GitDashIt.jl)
--->

### Installation
```julia-repl
using Pkg
Pkg.add(url="https://github.com/MurrellGroup/GitDashIt.jl.git")
using GitDashIt
```

You'll probably need `Plots.jl`, or whatever you're using to generate the figures, installed as well.

### Example.
First, create a GitHub repo that will host your GitDashIt dashboard. Then clone the repo somewhere you'll be generating the plots. Make a file called `GitDashItSafe` at the base of the repo, to let GitDashIt know that it is safe. From within that repo, run something like this:

```julia-repl
using GitDashIt, Plots

#Initialize
gd = GitDash()

#Check saftey
@show gitdash_issafe(gd)

#If you didn't make the file, then override saftey if you're sure you're in the right repo!
GitDashIt.gd_force_allow(gd)
@show gitdash_issafe(gd)

#Add a dash of text
dashprintln(gd, "### Plots")
dashprintln(gd, "Some text")

#And some figures
pl = plot(rand(100))
savefig(pl,dashfile(gd,"plot1.svg"))
pl = plot(sort(rand(100)))
savefig(pl,dashfile(gd,"plot2.svg"))

#Write to the local README.md, overwriting whatever was in there
flush2local(gd)

#Add more figures
dashprintln(gd,"### Another Heading!")
pl = plot(sort(rand(100),rev=true))
savefig(pl,dashfile(gd,"plot3.svg"))

#Append to the local readme
flush2local(gd, append = true)

#Push to the remote repo, which is now your dashboard!
pushdash(gd)
```

One standard workflow is to run this in a loop, re-creating the plots and updating the repo at some fixed time interval.
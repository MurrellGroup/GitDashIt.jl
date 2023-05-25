# GitDashIt

GitHub is a free dashboard you can push plots to.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://murrellb.github.io/GitDashIt.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://murrellb.github.io/GitDashIt.jl/dev/)
[![Build Status](https://github.com/murrellb/GitDashIt.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/murrellb/GitDashIt.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/murrellb/GitDashIt.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/murrellb/GitDashIt.jl)

### Example.
First, create a GitHub repo that will host your GitDashIt dashboard. Then clone the repo somewhere you'll be generating the plots. Make a file called `GitDashItSafe` at the base of the repo, to let GitDashIt know that it is safe. From within that repo, run something like this:
"""
```julia-repl
#Initialize
gd = GitDash()

#Check saftey
gitdash_issafe(gd)

#If you didn't make the file, then override saftey
GitDashIt.gd_force_allow(gd)
gitdash_issafe(gd)

#Add a dash of text
dashprintln(gd, "### Plots")
dashprintln(gd, "Some text")

#And some figures
pl = plot(rand(100))
savefig(pl,dashfile(gd,"plot1.svg"))

dashprintln(gd,"### Another Heading!")
dashprintln(gd,"Another plot:")
pl = plot(sort(rand(100)))
savefig(pl,dashfile(gd,"plot2.svg"))

#Write to the local README.md, overwriting whatever was in there
flush2local(gd)

#Add more figures
dashprintln(gd,"### A Third Heading!")
pl = plot(sort(rand(100),rev=true))
savefig(pl,dashfile(gd,"plot3.svg"))

#Append to the local readme
flush2local(gd, append = true)

#Push to the remote repo, which is now your dashboard!
pushdash(gd)
```
"""
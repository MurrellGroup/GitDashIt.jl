using GitDashIt
using Documenter

DocMeta.setdocmeta!(GitDashIt, :DocTestSetup, :(using GitDashIt); recursive=true)

makedocs(;
    modules=[GitDashIt],
    authors="Ben Murrell <murrellb@gmail.com> and contributors",
    repo="https://github.com/murrellb/GitDashIt.jl/blob/{commit}{path}#{line}",
    sitename="GitDashIt.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://murrellb.github.io/GitDashIt.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/murrellb/GitDashIt.jl",
    devbranch="main",
)

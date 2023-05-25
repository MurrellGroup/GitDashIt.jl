#Should we allow a branch to be specified?
#Currently using system git, because unclear how to handle credentials on Julia git
#Need to test when running this not from withing the base of the repo
#likely a few joinpath statements missing

module GitDashIt

export GitDash, dashfile, pushdash, flush2local, dashprint, dashprintln, gitdash_issafe

function git()
    return "git"
end

mutable struct GitDash
    text::String
    plotfiles::Vector{String}
    basepath::String
    function GitDash(; basepath = ".")
        return new("", [],basepath)
    end
end

function dashprint(gd::GitDash,txt)
    gd.text *= txt
    nothing
end

function dashprintln(gd::GitDash,txt)
    gd.text *= txt * "\n"
    nothing
end

"""
    dashfile(gd::GitDash,filepath::String; width = 2000)

Injects an image link into the README.md file. The image is saved in the current directory.

# Example
```julia-repl
    Plots.savefig(pl, dashfile(gd,"plot.svg"))
```
"""
function dashfile(gd::GitDash,filepath::String; width = 2000)
    if !gitdash_issafe(gd)
        unsafe_error(gd)
    end
    push!(gd.plotfiles,filepath)
    gd.text *= "<img src=\"" * filepath * "\" style=\"width: $(width)px;\"> \n\n"
    return filepath
end

function unsafe_error(gd)
    @error "GitDashIt is not running in repo known to be safe. Currently running from $(pwd()) with a base path of $(gd.basepath)
    Add a file named `GitDashItSafe` to the base of the repo, or, if you are ABSOLUTELY sure you're in the right place, run `GitDashIt.gd_force_allow(gd)` to add this file for you."
end

function gitdash_issafe(gd::GitDash)
    return isfile(joinpath(gd.basepath,"GitDashItSafe"))
end

function gd_force_allow(gd::GitDash)
    touch(joinpath(gd.basepath,"GitDashItSafe"))
    run(`$(git()) -C $(gd.basepath) add GitDashItSafe`);
    nothing
end

function flush2local(gd::GitDash; filepath = "README.md", append = false)
    if !gitdash_issafe(gd)
        unsafe_error(gd)
    end
    f = open(filepath,append ? "a" : "w")
                    write(f, gd.text)
                    close(f)
    for p in gd.plotfiles
        run(`$(git()) -C $(gd.basepath) add $(p)`);
    end
    run(`$(git()) -C $(gd.basepath) add README.md`);
    gd.text = ""
    gd.plotfiles = []
    nothing
end

#=
function clonedash(gd::GitDash,repo::String)
    run(`$(git()) -C $(gd.basepath) clone $(repo)`)
end
=#

function pushdash(gd::GitDash; message = "Updating...")
    if !gitdash_issafe(gd)
        unsafe_error(gd)
    end
    run(`$(git()) -C $(gd.basepath) commit -m "$(message)"`);
    run(`$(git()) -C $(gd.basepath) push`);
    nothing
end


end
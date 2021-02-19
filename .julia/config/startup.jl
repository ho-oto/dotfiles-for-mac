using Pkg
atreplinit() do repl
    ENV["PLOTS_DEFAULT_BACKEND"] = "unicodeplots"
    if any(pkg.name == "OhMyREPL" for (id, pkg) in Pkg.dependencies())
        @eval using OhMyREPL
    else
        @warn("OhMyREPL not installed")
    end
end

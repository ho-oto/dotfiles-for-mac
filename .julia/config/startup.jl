using Pkg
atreplinit() do repl
    ENV["PLOTS_DEFAULT_BACKEND"] = "unicodeplots"
    if any(pkg.name == "OhMyREPL" for (id, pkg) in Pkg.dependencies())
        @eval using OhMyREPL
    else
        @warn("OhMyREPL not installed")
    end
    if any(pkg.name == "BenchmarkTools" for (id, pkg) in Pkg.dependencies())
        @eval using BenchmarkTools
    else
        @warn("BenchmarkTools not installed")
    end
    if any(pkg.name == "TerminalPager" for (id, pkg) in Pkg.dependencies())
        @eval using TerminalPager
    else
        @warn("TerminalPager not installed")
    end
end

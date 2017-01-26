#!usr/bin/env julia

# Julia is extremely Matlab-like, even down to confusing the crap out of me
# with the one-indexed arrays

using Gadfly
using DataFrames

indices = collect(0:5)
x = linspace(-1, 1, 100)
legendre = Array{Float64, 2}()
for index in indices
    y = Float64[]
    for point in x
        # Generate the sum term first
        suml = 0
        if index % 2 != 0
            sumto = (index - 1) / 2
        else
            sumto = index / 2
        end
        for i in 0:sumto
            suml += (-1)^i * factorial(2 * index - 2 * i) / (factorial(i) *
                factorial(index - i) * factorial(index - 2 * i)) *
                point^(index - 2*i)
        end
        # Now generate the polynomial point
        val = 1 / 2^index * suml
        y = [y; val]
    end
    if size(legendre, 1) == 0
        legendre = y
    else
        legendre = [legendre y]
    end
end

# Plotting can done with Gadfly package, which is R-like, but not dependent on R
# Julia can also interface with Python's PyPlot using MatPlotLib,
# if you don't mind cross-execution for your scripts
# Matlab-like plotting available through Winston, but is independent of Matlab
# Gaston will interface with gnuplot
# General purpose plotting from GR, which is about as "native" as Julia gets
# UnicodePlots writes directly to the terminal REPL, building a plot out of
# unicode characters
# Similarly, ASCIIPlots will write to straight-up ASCII text files
# Vega writes to JavaScript and allows plotting to a web browser window, and
# works with IPython and Jupyter notebooks
# Bokeh writes to JavaScript, but through a Python visualization library
# Plots can be used to interface with all of them

# For Gadfly, set up a dataframe to get multiple plots
df0 = DataFrame(x=x, y=legendre[:, 1], Legend="P_0")
df1 = DataFrame(x=x, y=legendre[:, 2], Legend="P_1")
df2 = DataFrame(x=x, y=legendre[:, 3], Legend="P_2")
df3 = DataFrame(x=x, y=legendre[:, 4], Legend="P_3")
df4 = DataFrame(x=x, y=legendre[:, 5], Legend="P_4")
df5 = DataFrame(x=x, y=legendre[:, 6], Legend="P_5")

datf = vcat(df0, df1, df2, df3, df4, df5)

legendreplot = plot(datf, x="x", y="y", color="Legend", Geom.line,
    Scale.color_discrete_manual("red", "black", "green",
    "blue", "cyan", "magenta"))
draw(PNG("legendre.png", 6inch, 6inch), legendreplot)
println("Done drawing")

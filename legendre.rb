#!usr/bin/env ruby
require 'gnuplot'

# Linspace command
def linspace(low, high, num)
    [*0..num].collect {|i| low + i.to_f * (high - low) / num}
end

# Factorial command by exending Integer class
class Integer
    def fact
        (1..self).reduce(:*) || 1
    end
end

# Plot P_0 through P_5
indices = (0..5).to_a
# Set up range for which to plot over -1 to 1
x = linspace(-1, 1, 100)
legendre = []
for index in indices
    y = []
    for point in x
        sum = 0.0
        sumto = index.to_f / 2.0
        sumto = (index.to_f - 1.0) / 2.0 unless index % 2.0 == 0
        for i in 0..sumto
            sum += (-1.0)**i * (2 * index - 2 * i).fact / ((i).fact * (index - i).fact * (index - 2*i).fact) * point**(index.to_f - 2.0*i)
        end
        # Now generate the polynomial point
        val = 1.0 / 2.0**index * sum
        y.push(val)
    end
    legendre.push(y)
end

# Now plot
Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
        plot.terminal "png"
        plot.output File.expand_path("../legendre.png", __FILE__)
        plot.title "Legendre Polynomials"
        plot.ylabel "y"
        plot.xlabel "x"
        plot.yrange "[-1:1.1]"
        
        plot.data = [
            Gnuplot::DataSet.new([x, legendre[0]]) { |ds|
                ds.with = "lines"
                ds.title = "P_0"
            },

            Gnuplot::DataSet.new([x, legendre[1]]) { |ds|
                ds.with = "lines"
                ds.title = "P_1"
            },
            
            Gnuplot::DataSet.new([x, legendre[2]]) { |ds|
                ds.with = "lines"
                ds.title = "P_2"
            },

            Gnuplot::DataSet.new([x, legendre[3]]) { |ds|
                ds.with = "lines"
                ds.title = "P_3"
            },

            Gnuplot::DataSet.new([x, legendre[4]]) { |ds|
                ds.with = "lines"
                ds.title = "P_4"
            },

            Gnuplot::DataSet.new([x, legendre[5]]) { |ds|
                ds.with = "lines"
                ds.title = "P_5"
            }
        ]
    end
end

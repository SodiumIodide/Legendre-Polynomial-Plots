package main

import (
    "math"

    "github.com/gonum/plot"
    "github.com/gonum/plot/plotter"
    "github.com/gonum/plot/plotutil"
    "github.com/gonum/plot/vg"
)

// Range between two numbers
// Really see the use of Go's C-Like pointer system here
func xrange(start, end, step *float64, gen *[]float64) {
    init := *start / *step
    fin := *end / *step
    // Assuming evenly divisible: No error checking
    endnum := (fin - init)
    for i := 0.0; i <= endnum; i++ {
        *gen = append(*gen, *start + i * *step)
    }
}

// Factorial
// I would mess around with the pointer system, but I know I'm not taking the
// factorial of any large numbers, so this is not a memory concern, and the
// recursive nature of my definition makes that an incredible pain without
// actually much performance benefit outside of a different schema
func fact(x int64) int64 {
    if x == 0 {
        return 1
    }
    return x * fact(x - 1)
}

func main() {
    // Plot P_0 through P_5
    indices := []int64{0, 1, 2, 3, 4, 5}
    // Set up range for which to plot over -1 to 1
    start := -1.0
    end := 1.0
    step := 0.1
    // Void function called to create x
    x := []float64{}
    xrange(&start, &end, &step, &x)
    // Could set up a global number of points and use that as arguments for
    // range to reduce array reallocation, but I don't care, memory is cheap
    // for this level of program
    legendre := [][]float64{}
    for _, index := range(indices) {
        // Causes for reallocation each time, but guarantees clean and
        // garbage-collected array
        y := []float64{}
        for _, point := range(x) {
            // Generate the sum term first
            sum := 0.0
            var sumto int64;
            if index % 2 != 0 {
                sumto = (index - 1) / 2
            } else {
                sumto = index / 2
            }
            for i := int64(0); i <= sumto; i++ {
                sum += math.Pow(-1, float64(i)) * float64(fact(2*index - 2*i)) / float64((fact(i) * fact(index - i) * fact(index - 2*i))) * math.Pow(point, float64(index - 2*i))
            }
            // Now generate the polynomial point
            val := 1 / math.Pow(2, float64(index)) * sum
            y = append(y, val)
        }
        legendre = append(legendre, y)
    }

    p, err := plot.New()
    if err != nil {
        panic(err)
    }

    p.Title.Text = "Legendre Polynomials"
    p.X.Label.Text = "x"
    p.Y.Label.Text = "y"

    // This is made slightly annoying by the perceived lack of macros in Go
    // I could be wrong, and there might be a way to macro this, but as of
    // the time of writing I don't know of one and I kind of hate this
    numpoints := len(x)
    pts0 := make(plotter.XYs, numpoints)
    // Goes against Forrest's rule and defaults to int32, but that shouldn't
    // be a huge problem
    for i := range pts0 {
        pts0[i].X = x[i]
        pts0[i].Y = legendre[0][i]
    }
    pts1 := make(plotter.XYs, numpoints)
    for i := range pts1 {
        pts1[i].X = x[i]
        pts1[i].Y = legendre[1][i]
    }
    pts2 := make(plotter.XYs, numpoints)
    for i := range pts2 {
        pts2[i].X = x[i]
        pts2[i].Y = legendre[2][i]
    }
    pts3 := make(plotter.XYs, numpoints)
    for i := range pts3 {
        pts3[i].X = x[i]
        pts3[i].Y = legendre[3][i]
    }
    pts4 := make(plotter.XYs, numpoints)
    for i := range pts4 {
        pts4[i].X = x[i]
        pts4[i].Y = legendre[4][i]
    }
    pts5 := make(plotter.XYs, numpoints)
    for i := range pts5 {
        pts5[i].X = x[i]
        pts5[i].Y = legendre[5][i]
    }

    err = plotutil.AddLinePoints(p,
        "P_0", pts0,
        "P_1", pts1,
        "P_2", pts2,
        "P_3", pts3,
        "P_4", pts4,
        "P_5", pts5)
    if err != nil {
        panic(err)
    }

    // Save the plot to a PNG file
    if err := p.Save(4*vg.Inch, 4*vg.Inch, "legendre.png"); err != nil {
        panic(err)
    }
}

extern crate gnuplot;

use gnuplot::*;
use common::*;

mod common;

fn plot(c: Common, data: Data) {
    let Data {xs: x, ys: yvec} = data;
    let x = x.iter2();
    let y0 = yvec[0].iter2();
    let y1 = yvec[1].iter2();
    let y2 = yvec[2].iter2();
    let y3 = yvec[3].iter2();
    let y4 = yvec[4].iter2();
    let y5 = yvec[5].iter2();

    let mut fg = Figure::new();
    c.set_term(&mut fg);

    fg.axes2d()
        .set_size(0.75, 1.0)
        .set_title("Legendre Polynomials", &[])
        .set_x_ticks(Some((Fix(1.0), 1)), &[Mirror(false)], &[])
        .set_y_ticks(Some((Fix(1.0), 1)), &[Mirror(false)], &[])
        .set_legend(Graph(1.0), Graph(0.5), &[Placement(AlignLeft, AlignCenter)],
            &[TextAlign(AlignRight)])
        .set_border(true, &[Left, Bottom], &[LineWidth(2.0)])
        .set_x_label("x", &[])
        .set_y_label("y", &[])
        .lines(x, y0, &[Caption("P_0(x)"), LineWidth(1.5), Color("red")])
        .lines(x, y1, &[Caption("P_1(x)"), LineWidth(1.5), Color("black")])
        .lines(x, y2, &[Caption("P_2(x)"),
        LineWidth(1.5), Color("green")])
        .lines(x, y3, &[Caption("P_3(x)"),
        LineWidth(1.5), Color("blue")])
        .lines(x, y4, &[Caption("P_4(x)"),
        LineWidth(1.5), Color("cyan")])
        .lines(x, y5, &[Caption("P_5(x)"),
        LineWidth(1.5), Color("purple")]);

    c.show(&mut fg, "legendre.gnuplot");

    if !c.no_show{
        fg.set_terminal("pdfcairo", "legendre.pdf");
        fg.show();
        fg.set_terminal("pngcairo", "legendre.png");
        fg.show();
    }
}

// Factorial
fn fact(n: i64) -> i64 {
    match n {
        0 => 1,
        _ => n * fact(n-1),
    }
}

struct Data {
    xs: Vec<f64>,
    ys: Vec<Vec<f64>>,
}

fn clonevector<T: Clone>(vec: &Vec<T>) -> Vec<T> {
    let v = vec.clone();
    v
}

fn xrange(start: f64, end: f64, step: f64) -> Vec<f64> {
    let init: f64 = start / step;
    let fin: f64 = end / step;
    // Assuming evenly divisible
    let endnum: i32 = (fin - init) as i32 + 1;
    let mut gen: Vec<f64> = Vec::with_capacity(endnum as usize);
    for i in 0..endnum {
        gen.push(start + (i as f64 * step));
    }
    gen
}

fn builddata() -> Data {
    // Plot P_0 through P_5
    let indices: Vec<i64> = vec![0, 1, 2, 3, 4, 5];
    // Set up range for which to plot over -1 to 1
    let x: Vec<f64> = xrange(-1.0f64, 1.0f64, 0.01f64);
    let mut legendre: Vec<Vec<f64>> = Vec::new(); // Reallocates, I don't want to optimize this
    for index in indices {
        let mut y: Vec<f64> = Vec::with_capacity(x.len());
        for point in &x {
            // Generate the sum term first
            let mut sum: f64 = 0.0f64;
            let sumto: i64;
            if index % 2i64 != 0i64 {
                sumto = (index - 1i64) / 2i64;
            } else {
                sumto = index / 2i64;
            }
            for i in 0i64 .. (sumto + 1i64) {
                let pointpow: i32 = (index as i32) - 2i32 * (i as i32);
                sum += ((-1i64).pow(i as u32) * fact(2i64 * index - 2i64 * i)) as f64 /
                    (fact(i) * fact(index - i) * fact(index - 2i64 * i)) as f64 *
                    point.powi(pointpow);
            }
            // Now generate the polynomial point
            let val = 1.0f64 / (2.0f64).powi(index as i32) as f64 * sum;
            y.push(val);
        }
        legendre.push(clonevector(&y));
    }
    Data {xs: x, ys: legendre}
}

fn main() {
    let data: Data = builddata();
    Common::new().map(|c| plot(c, data));
}

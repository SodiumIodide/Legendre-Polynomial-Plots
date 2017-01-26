# Legendre Polynomial Generator
library(ggplot2)
library(reshape)

indices <- c(0:5)
numpoints <- 100
x <- seq(-1, 1, length=numpoints)
legendre <- c()
for (index in indices) {
  y <- c()
  for (point in x) {
    # Generate the sum term first
    suml <- 0
    if (index %% 2 != 0) {
      sumto <- (index - 1) / 2
    } else {
      sumto <- index / 2
    }
    for (i in 0:sumto) {
      suml <- suml + (-1)^i * factorial(2*index - 2*i) / (factorial(i) * factorial(index - i) * factorial(index - 2*i)) * point^(index - 2 * i)
    }
    # Now generate the polynomial point
    val <- 1 / 2^index * suml
    y = c(y, val)
  }
  legendre <- c(legendre, y)
}
legendre <- matrix(legendre, nrow=numpoints)

df <- data.frame(x=x, P_0=legendre[,1], P_1=legendre[,2], P_2=legendre[,3], P_3=legendre[,4], P_4=legendre[,5], P_5=legendre[,6])
df.melted <- melt(df, id="x")

legendreplot <- ggplot(data = df.melted, aes(x=x, y=value, color=variable))
legendreplot <- legendreplot + geom_line()
legendreplot <- legendreplot + labs(title="Legendre Polynomials", x="x", y="y", colour="Legend")
print(legendreplot)
ggsave(file="legendre.png")
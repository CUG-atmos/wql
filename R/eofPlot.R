eofPlot <- function(x, type = c("coef", "amp"), 
    rev = FALSE, ord = FALSE) {

    ### Plots REOFs or amplitudes from x, the output of eof().
    ### Args:
    ###  type: plot REOF coefficients or amplitudes?
    ###  ord: If TRUE, coefficients of 1st eof are displayed in order of size
    ###  rev: If TRUE, then coefficients and amplitudes are multiplied by -1
    ### Returns: ggplot object

    require(ggplot2)

    ## Validate args
    type <- match.arg(type)
    num <- ncol(x$REOF) - 1

    ## Plot
    if (type == "coef") {
        d1 <- x$REOF
        if (ord) 
            d1[, "id"] <- reorder(levels(d1[, "id"]), d1[, 
                "EOF1"])
        if (rev) {
            for (k in 1:num) d1[, k + 1] <- -d1[, k + 1]
        }
        m1 <- melt(d1, id = "id")
        ggplot(m1, aes(x = value, y = id)) + 
            geom_vline(xintercept = c(-0.35, -0.2, 0.2, 0.35), colour = "red", size = 0.2) + 
            geom_point(colour = "blue") + 
            facet_wrap(~variable, ncol = num) + 
            labs(y = "", x = "Coefficient")
    }
    else {
        d1 <- x$amplitude
        if (rev) {
            for (k in 1:num) d1[, k + 1] <- -d1[, k + 1]
        }
        d1 <- transform(d1, id = as.numeric(as.character(d1$id)))
        m1 <- melt(d1, id = "id")
        ggplot(m1, aes(x = id, y = value)) + 
            geom_hline(aes(yintecept = 0), colour = "red", size = 0.2) +
            geom_line(colour = "blue") + 
            geom_point(colour = "blue") + 
            facet_wrap(~variable, nrow = num) + 
            labs(x = "", y = "Amplitude")
    }
} 
#' PCA + Mahalanobis para detección de atípicos
#'
#' Calcula PCA sobre columnas numéricas y etiqueta atípicos por distancia Mahalanobis
#' en las primeras `n_comp` componentes.
#' @param data Tibble con columnas numéricas (al menos `valor`) y `fecha`.
#' @param n_comp Número de componentes a usar (default 2).
#' @param percentil Percentil del umbral (ej. 0.99).
#' @return Tibble con `PC1`, `PC2` (si aplica), `mahala`, `outlier_pca`.
#' @export
pca_outliers <- function(data, n_comp = 2, percentil = 0.99) {
  stopifnot(all(c("fecha","valor") %in% names(data)))
  num_cols <- sapply(data, is.numeric)
  X <- as.data.frame(data[, num_cols, drop = FALSE])
  X <- X[, colSums(!is.na(X)) > 0, drop = FALSE]
  X <- stats::na.omit(X)

  if (ncol(X) < 1) stop("No hay columnas numéricas suficientes para PCA.")

  pr <- stats::prcomp(X, center = TRUE, scale. = TRUE)
  k <- min(n_comp, ncol(pr$x))
  Z <- pr$x[, seq_len(k), drop = FALSE]

  S <- stats::cov(Z)
  invS <- tryCatch(solve(S), error = function(e) MASS::ginv(S))
  m <- colMeans(Z)
  d2 <- apply(Z, 1, function(z) {
    dz <- z - m
    as.numeric(t(dz) %*% invS %*% dz)
  })
  thr <- stats::quantile(d2, probs = percentil, na.rm = TRUE, names = FALSE)

  out <- data
  idx_valid <- which(complete.cases(data[, num_cols, drop = FALSE]))
  out$mahala <- NA_real_
  out$mahala[idx_valid] <- d2
  out$outlier_pca <- FALSE
  out$outlier_pca[idx_valid] <- d2 > thr

  if (k >= 1) { out$PC1 <- NA_real_; out$PC1[idx_valid] <- Z[,1] }
  if (k >= 2) { out$PC2 <- NA_real_; out$PC2[idx_valid] <- Z[,2] }
  attr(out, "pca_model") <- pr
  out
}

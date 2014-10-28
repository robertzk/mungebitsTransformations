context("information_gain")

test_that("it (mostly) correctly filters out noisy variables in a simulated data set", {
  
  mungebits_loaded <- 'mungebits' %in% loadedNamespaces(); require(mungebits)
  set.seed(20141028)
  
  # create 20 numeric vectors
  v <- list()
  for (i in 1:20) v[[i]] <- rnorm(1000)
  names(v) <- paste0('var',1:20)
  
  # "true" predictor is a linear combination of the first 10 variables
  lp <- v$var1 - v$var2 + v$var3 - v$var4 + v$var5 - v$var6 + v$var7 - v$var8 + v$var9 - v$var10
  
  # simulate response
  p <- 1/(1+exp(-lp))
  y <- rbinom(1000, 1, p)
  
  # make a data.frame
  df <- as.data.frame(v)
  df$dep_var <- y
  
  # make a mungeplane and mungebit
  mp <- mungebits:::mungeplane(df)
  mb <- mungebits:::mungebit(infogain)
  
  # run the algorithm
  mb$run(mp, topN=10)
  
  # test
  expect_identical(names(mp$data), 
                   c("var1", "var2", "var3", "var4", "var6", 
                     "var7", "var8", "var9", "var10", "var17", "dep_var"), 
                   "It filtered the wrong variables")
  
  if (!mungebits_loaded) unloadNamespace('mungebits')
})

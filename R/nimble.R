# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

sample_empty <- function(model, monitor, nchains){
  model_mcmc <- buildMCMC(model, monitors = monitor)
  
  invisible(capture.output({
    samples <- runMCMC(model_mcmc,
                       niter = 0,
                       nburnin = 0,
                       thin = 1,
                       nchains = nchains,
                       samplesAsCodaMCMC = TRUE, 
                       progressBar = FALSE
    )
  }, type = "output"))
  samples
}

sample_some <- function(model, monitor, inits, niters, nburnin, nthin, nchains, quiet){
  cmodel <- compileNimble(model, showCompilerOutput = FALSE)
  model_mcmc <- buildMCMC(cmodel, monitors = monitor)
  cmodel_mcmc <- compileNimble(model_mcmc, project = model, resetFunctions = TRUE)
  if (!is.null(inits)) {
    cmodel$setInits(inits)
  }
  
  runMCMC(cmodel_mcmc,
          niter = niters, nburnin = nburnin,
          thin = nthin, nchains = nchains,
          samplesAsCodaMCMC = TRUE, progressBar = !quiet
  )
}

run_nimble <- function(model, monitor, inits, niters, nchains, nthin, quiet) {
  verbose <- nimbleOptions("verbose")
  nimbleOptions(verbose = FALSE)

  niters <- niters * nthin * 2
  nburnin <- niters / 2

  if(niters == 0){
    samples <- sample_empty(model, monitor = monitor, nchains = nchains)
  } else {
    samples <- sample_some(model, monitor = monitor, inits = inits,
                           niters = niters, nburnin = nburnin, 
                           nthin = nthin, nchains = nchains, quiet = quiet)
  }
  
  nimbleOptions(verbose = verbose)
  samples <- mcmcr::as.mcmcr(samples)
  list(model = model, samples = samples)
}

run_nimble_ml <- function(model, inits, prior_inits, quiet) {
  verbose <- nimbleOptions("verbose")
  nimbleOptions(verbose = FALSE)

  cmodel <- compileNimble(model, resetFunctions = TRUE)
  params <- setupMargNodes(model)$paramNodes
  chk_subset(names(inits), params, x_name = "Names in `inits`")

  # need to deal with special case when estimating adult_female_proportion
  # nimble does not guess default param nodes correctly
  cows <- map_lgl(params, function(x) grepl("Cows", x))
  if (any(cows)) {
    calc_other <- params[cows]
    params <- params[!cows]
    laplace <- buildLaplace(model, paramNodes = params, calcNodesOther = calc_other)
  } else {
    laplace <- buildLaplace(model)
  }

  claplace <- compileNimble(laplace, project = model, resetFunctions = TRUE)

  inits_default <- rep(1, length(params))
  names(inits_default) <- params
  prior_inits <- prior_inits[names(prior_inits) %in% params]
  inits_default <- unlist(replace_priors(inits_default, prior_inits))
  inits <- unlist(replace_priors(inits_default, inits))

  mle <- claplace$findMLE(inits)
  summ <- claplace$summary(mle, randomEffectsStdError = TRUE, originalScale = FALSE)

  nimbleOptions(verbose = verbose)

  list(summary = summ, mle = mle, model = model)
}

quiet_run_nimble_ml <- purrr::quietly(run_nimble_ml)

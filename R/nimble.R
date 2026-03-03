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

# Expand scalar inits to match indexed param names.
# e.g., list(b0 = 5) with params = c("b0[1]", "sAnnual") becomes c("b0[1]" = 5)
.expand_inits <- function(inits, params, params_base) {
  if (is.null(inits) || length(inits) == 0) {
    return(inits)
  }
  expanded <- numeric(0)
  for (nm in names(inits)) {
    matching <- params[params_base == nm]
    if (length(matching) > 0) {
      vals <- rep(inits[[nm]], length(matching))
      names(vals) <- matching
      expanded <- c(expanded, vals)
    }
  }
  expanded
}

sample_empty <- function(model, monitor, nchains) {
  model_mcmc <- buildMCMC(model, monitors = monitor)

  invisible(capture.output(
    {
      samples <- runMCMC(
        model_mcmc,
        niter = 0,
        nburnin = 0,
        thin = 1,
        nchains = nchains,
        samplesAsCodaMCMC = TRUE,
        progressBar = FALSE
      )
    },
    type = "output"
  ))
  samples
}

sample_some <- function(
  model,
  monitor,
  inits,
  niters,
  nburnin,
  nthin,
  nchains,
  quiet
) {
  cmodel <- compileNimble(model, showCompilerOutput = FALSE)
  model_mcmc <- buildMCMC(cmodel, monitors = monitor)
  cmodel_mcmc <- compileNimble(
    model_mcmc,
    project = model,
    resetFunctions = TRUE
  )
  if (!is.null(inits)) {
    cmodel$setInits(inits)
  }

  runMCMC(
    cmodel_mcmc,
    niter = niters,
    nburnin = nburnin,
    thin = nthin,
    nchains = nchains,
    samplesAsCodaMCMC = TRUE,
    progressBar = !quiet
  )
}

run_nimble <- function(model, monitor, inits, niters, nchains, nthin, quiet) {
  verbose <- nimbleOptions("verbose")
  nimbleOptions(verbose = FALSE)

  niters <- niters * nthin * 2
  nburnin <- niters / 2

  if (niters == 0) {
    samples <- sample_empty(model, monitor = monitor, nchains = nchains)
  } else {
    samples <- sample_some(
      model,
      monitor = monitor,
      inits = inits,
      niters = niters,
      nburnin = nburnin,
      nthin = nthin,
      nchains = nchains,
      quiet = quiet
    )
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
  params_base <- unique(gsub("\\[.*", "", params))
  chk_subset(names(inits), params_base, x_name = "Names in `inits`")

  # need to deal with special case when estimating adult_female_proportion
  # nimble does not guess default param nodes correctly
  cows <- map_lgl(params, function(x) grepl("Cows", x))

  # nimble >= 1.4.0 moved Laplace approximation to nimbleQuad.
  # Must use nimbleQuad::buildLaplace and compile in globalenv so that
  # nimbleQuad's internal functions (e.g. drop_algorithm) are found by
  # the nimble compiler via the search path.
  build_laplace <- getExportedValue("nimbleQuad", "buildLaplace")
  if (any(cows)) {
    calc_other <- params[cows]
    params <- params[!cows]
    laplace <- build_laplace(
      model,
      paramNodes = params,
      calcNodesOther = calc_other
    )
  } else {
    laplace <- build_laplace(model)
  }

  claplace <- evalq(
    compileNimble(laplace, project = model, resetFunctions = TRUE),
    envir = list(laplace = laplace, model = model),
    enclos = globalenv()
  )

  inits_default <- rep(1, length(params))
  names(inits_default) <- params
  # Expand scalar inits (e.g., b0 = 5) to all matching indexed params (e.g., b0[1] = 5)
  prior_inits <- .expand_inits(prior_inits, params, params_base)
  inits_default <- unlist(replace_priors(inits_default, prior_inits))
  inits <- .expand_inits(inits, params, params_base)
  inits <- unlist(replace_priors(inits_default, inits))

  mle <- claplace$findMLE(inits)
  summ <- claplace$summary(
    mle,
    randomEffectsStdError = TRUE,
    originalScale = FALSE
  )

  # nimbleQuad >= 1.4.0 returns generic names (param_trans_1, re_trans_1) on

  # the transformed scale. Get proper names from the original-scale summary.
  summ_names <- claplace$summary(
    mle,
    randomEffectsStdError = TRUE,
    originalScale = TRUE
  )
  summ$params$names <- summ_names$params$names
  summ$randomEffects$names <- summ_names$randomEffects$names

  nimbleOptions(verbose = verbose)

  list(summary = summ, mle = mle, model = model)
}

quiet_run_nimble_ml <- purrr::quietly(run_nimble_ml)

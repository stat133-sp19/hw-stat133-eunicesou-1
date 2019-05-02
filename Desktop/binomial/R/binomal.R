# R Functions
## 1.1) Private Checker Functions

# check_prob()
check_prob <- function(prob) {
  if (prob >= 0 & prob <= 1) {
   return(TRUE)
  } else {
    stop(paste("invalid prob value", prob))
  }
}

#check_trials()
check_trials <- function(trials) {
  if (trials %% 1 != 0 | trials < 0 | length(trials) != 1) {
    stop(paste("invalid trials value", trials))
  }
  return(TRUE)
}


#check_success()
check_success <- function(trials, success){
  is_valid <- FALSE
  if((success >= 0) & (success <= trials)){
    is_valid <- TRUE
  }
  if(is_valid == FALSE){
    if(success < 0) {
      stop('invalid success value')
    } else {
      stop('success cannot be greater than trials')
    }
  }
  return(is_valid)
}

## 1.2) Private Auxiliary Functions
aux_mean <- function(trials,prob) {
  return(trials*prob)
}

aux_variance <- function(trials,prob) {
  return(trials*prob*(1-prob))
}

aux_mode <- function(trials, prob) {
  m <- trials * prob + prob
  if (m == floor(m)) {
    return(c(m, m - 1))
  }
  return(floor(m))
}

aux_skewness <- function(trials,prob) {
  return((1-(2*prob))/sqrt(trials*prob*(1-prob)))
}

aux_kurtosis <- function(trials,prob) {
  return((1-(6*prob)*(1-prob))/(trials*prob*(1-prob)))
}

## 1.3) Function bin_choose()
#' @title Binomial Choose Function
#' @description Calculates the number of combinations in which k successes can occur in n trials
#' @param trials Total number of trials
#' @param success Total number of successes
#' @return The number of combinations in which k successes can occur in n trials
#' @export
#' @examples
#' bin_choose(n = 5, k = 2)
#' bin_choose(5, 0)
#' bin_choose(5, 1:3)

bin_choose <- function(trials,success) {
  for(i in success)
  if(trials < i) {
    stop(paste(" k cannot be greater than n", trials,success))
  } else {
    return(factorial(trials)/(factorial(success)*(factorial(trials-success))))
  }
}

## 1.4) Function bin_probability()
#' @title Binomial Probability Function
#' @description Computes the probability of getting k successes in n trials with prob of success p
#' @param success Total number of successes
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return The probability of getting k successes in n trials with prob of success p
#' @export
#' @examples
#' bin_probability(success = 2, trials = 5, prob = 0.5)
#' bin_probability(success = 0:2, trials = 5, prob = 0.5)
#' bin_probability(success = 55, trials = 100, prob = 0.45)

bin_probability <- function(success,trials,prob) {
  if(check_trials(trials) == TRUE) {
    return(bin_choose(trials,success)*(prob^success)*(1-prob)^(trials-success))
  } else {
    stop("invalid trials value")
  }

  if(check_prob(prob) == TRUE) {
    return(bin_choose(trials,success)*(prob^success)*(1-prob)^(trials-success))
  } else {
    stop("invalid probability value")
  }
  if (check_success(trials,success) == TRUE) {
    return(bin_choose(trials,success)*(prob^success)*(1-prob)^(trials-success))
  } else {
    stop("invalid success value")
  }
}

## 1.5) bin_distribution()
#' @title Binomial distribution Function
#' @description Creates a binomial distribution data frame using the binomial probability function with successes and probabilities as columns
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return A dataframe representing the binomial distribution with two classes ("bindis" and "data.frame)
#' @export
#' @examples
#' bin_distribution(trials = 5, prob = 0.5)

bin_distribution <- function(trials, prob) {
  success <- 0:trials
  probability <- bin_probability(success, trials, prob)
  df <- data.frame(success, probability)
  class(df) <- c("bindis", "data.frame")
  return(df)
}

#' @export
plot.bindis <- function(x) {
  barplot(x$probability,
          xlab = "successes", ylab = "probability",
          names.arg = x$success)
}

## 1.6) bin_cumulative()
#' @title Binomial Cumulative Function
#' @description Creates a binomial distribution data frame using the binomial probability function with successes, probabilities, and cumulative probabilities as columns
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return A data frame of the computed binomial distribution with classes ("bincum" and "data.frame")
#' @export
#' @examples
#' bin_cumulative(trials = 5, prob = 0.5)

bin_cumulative <- function(trials, prob) {
  df <- bin_distribution(trials, prob)
  cumulative <- c()
  for (i in 1:(trials + 1)) {
    cumulative[i] <- sum(df$probability[1:i])
  }
  df$cumulative <- cumulative
  class(df) <- c("bincum", "data.frame")
  return(df)
}

#' @export
plot.bincum <- function(x) {
  plot(x$success, x$cumulative, type = "p",
       xlab = "successes", ylab = "probability")
  lines(x$success, x$cumulative)
}

## 1.7) bin_variable()
#' @title Binomial Variable Function
#' @description Creates an object that is a binomial variable object with class "binvar"
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return A binomial random variable object
#' @export
#' @examples
#' # Create a binomial variable
#' bin_variable(trials = 5, prob = 0.5)
#' # Get summary statistics of the binomial variable
#' summary_var <- summary(var)
#' # Print summary statistics
#' summary_var

bin_variable <- function(trials, prob) {
  check_prob(prob)
  check_trials(trials)
  object <- list(
    trials = trials,
    prob = prob)
  class(object) <- "binvar"
  return(object)
}

#' @export
print.binvar <- function(x) {
  cat('"Binomial variable"\n\n')
  cat('Parameters\n')
  cat(sprintf('- number of trials: %s', x$trials), "\n")
  cat(sprintf('- prob of success: %s', x$prob), "\n")
}

#' @export
summary.binvar <- function(x) {
  object <- list(
    trials = x$trials,
    prob = x$prob,
    mean = aux_mean(x$trials, x$prob),
    variance = aux_variance(x$trials, x$prob),
    mode = aux_mode(x$trials, x$prob),
    skewness = aux_skewness(x$trials, x$prob),
    kurtosis = aux_kurtosis(x$trials, x$prob)
  )
  class(object) <- "summary.binvar"
  return(object)
}

#' @export
print.summary.binvar <- function(x) {
  cat('"Summary Binomial"\n\n')
  cat('Parameters\n')
  cat(sprintf('- number of trials: %s', x$trials), "\n")
  cat(sprintf('- prob of success: %s', x$prob), "\n\n")
  cat('Measures\n')
  cat(sprintf('- mean    : %s', x$mean), "\n")
  cat(sprintf('- variance: %s', x$variance), "\n")
  cat(sprintf('- mode    : %s', x$mode), "\n")
  cat(sprintf('- skewness: %s', x$skewness), "\n")
  cat(sprintf('- kurtosis: %s', x$kurtosis), "\n")
}

## 1.8) Functions of measures
#' @title Binomial Mean Function
#' @description Calculates the mean of a binomial distribution based on their parameter values
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return Calculates the mean of a binomial distribution
#' @export
#' @examples
#' bin_mean(10,0.3)
bin_mean <- function(trials, prob) {
  check_trials(trials)
  check_prob(prob)
  return(aux_mean(trials, prob))
}

#' @title Binomial Variance Function
#' @description Calculates the variance of a binomial distribution
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return Calculates the variance of a binomial distribution
#' @export
#' @examples
#' bin_variance(10, 0.3)
bin_variance <- function(trials, prob) {
  check_trials(trials)
  check_prob(prob)
  return(aux_variance(trials, prob))
}

#' @title Binomial Mode Function
#' @description Calculates the mode of a binomial distribution
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return Calculates the mode of a binomial distribution
#' @export
#' @examples
#' bin_mode(10,0.3)
bin_mode <- function(trials, prob) {
  check_trials(trials)
  check_prob(prob)
  return(aux_mode(trials, prob))
}

#' @title Binomial Skewness Function
#' @description Calculates the skewness of a binomial distribution
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return Calculates the skewness of a binomial distribution
#' @export
#' @examples
#' bin_skewness(10, 0.3)
bin_skewness <- function(trials, prob) {
  check_trials(trials)
  check_prob(prob)
  return(aux_skewness(trials, prob))
}

#' @title Binomial Kurtosis
#' @description Calculates the kurtosis of a binomial distribution
#' @param trials Total number of trials
#' @param prob Probability of success
#' @return Calculates the kurtosis of a binomial distribution
#' @export
#' @examples
#' bin_kurtosis(10, 0.3)
bin_kurtosis <- function(trials, prob) {
  check_trials(trials)
  check_prob(prob)
  return(aux_kurtosis(trials, prob))
}

#' Replace arbitrary values in your data
#' 
#' @param x an atomic vector. The column to transform.
#' @param values_map a list. If named, the names get replaced w/ the values.
#'    Otherwise, the list elements are lists of 2 elements, the first of
#'    which are the values to be replaced and the second the replacement value.
#' @return the replaced column
#' @examples
#' \dontrun{
#' # replace A, B, D with 1 and NA with 0.
#' value_replacer(c("A", "B", NA, "D"), list(list(c("A","B","D"), 1), list(NA, 0)))
#' value_replacer(c("A", "B", NA, "D"), list(A = 1, B = 1, D = 1, list(NA, 0)))
#' }
value_replacer_fn <- function(x, values_map) { 
  replaced <- x
  is_factor <- is.factor(replaced)
  if (is_factor) {
    replaced <- as.character(replaced)
    rep_levels <- unique(unlist(lapply(values_map, function(value_map) value_map[[2]]))) 
  }
  unnamed_indices <- names(values_map) == ""
  if (is.null(unnamed_indices) || length(unnamed_indices) == 0)
    unnamed_indices <- TRUE
  lapply(
    values_map[unnamed_indices]
    , function(value_map) {
      replaced[x %in% value_map[[1]]] <<-
        if (is_factor) as.character(value_map[[2]]) else value_map[[2]]
    }
  )
  lapply(
    names(values_map)[!unnamed_indices]
    , function(name) {
      replaced[x == name] <<- 
        if (is_factor) as.character(values_map[[name]]) else values_map[[name]]
    }
  )
  if (is_factor) factor(replaced, levels =
    if (!exists('inputs')) unique(replaced)
    else if ('levels' %in% names(inputs)) inputs$levels
    else inputs$levels <<- union(unique(replaced), rep_levels))
  else replaced
}

#' @export
value_replacer <- column_transformation(value_replacer_fn, mutating = TRUE)


#' @name rviewgraph-package
#' @aliases rviewgraph-package rviewgraph
#' @docType package
#' @title  Animated Graph Layout Viewer
#' @description
#' for graph viewing, manipulation and plotting.
#' 
#' @details
#' \tabular{ll}{
#' Package: \tab rviewgraph\cr
#' Type: \tab Package\cr
#' Version: \tab 1.4.2\cr
#' Date: \tab 2021-10-25\cr
#' License: \tab GPL-2 \cr
#' LazyLoad: \tab yes\cr
#' SystemRequirements: \tab 'Java' >= 8\cr
#' }
#' Provides 'Java' graphical user interfaces (GUI) for viewing, manipulating
#' and plotting graphs. Graphs may be directed or undirected. 
#'
#' The original program, \code{rViewGraph} takes
#' a graph specified as an incidence matrix, array of edges, or in \code{igraph} format
#' and runs a graphical user interface that shows an
#' animation of a force directed algorithm positioning the vertices in two dimensions.
#' If run from a non-interactive R session, \code{rViewGraph} prints an
#' error message and returns \code{NULL}.
#'
#' A new program, \code{vg}, is an alternative interface to the underlying 
#' 'Java' program that provides a more coherent way of specifying the graph,
#' and more control over how the vertices appear in the GUI. Specifically, 
#' \code{vg} allows for arbitrary integer indices to identify the vertices,
#' and allows changes to the graph's vertex and edge sets. The text labels,
#' colours, shapes and sizes of the vertices can also be specified, either before
#' or after vertices are added to the graph. These changes can be made while the
#' vertex positioning animation is running. \code{vg} also provides 
#' functions for saving and restoring the state of the graph including
#' vertices and edges,
#' vertex positions, and vertex appearances.
#' \code{vg()} can be run non-interactively without a GUI which allows a 
#' graph structure to be built and saved for a future interactive session.
#'
#' Both programs can also start a dialog box to print the current view of the graph.
#'
#' The underlying positioning methods works well for graphs of various structure
#' of up to a few thousand vertices. It's not fazed by graphs that comprise several
#' components. 
#'
#' 
#' @seealso vg rViewGraph
#' @seealso #' There is a vignette on 'Building a simple graph sampler'.
#' 
#' @keywords internal
"_PACKAGE"
#> [1] "_PACKAGE"

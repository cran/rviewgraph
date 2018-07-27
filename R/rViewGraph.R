#' @name rviewgraph-package
#' @aliases rviewgraph-package rviewgraph
#' @docType package
#' @title  Animated Graph Layout Viewer
#' @description
#' rviewgraph provides an 'R' interface to Alun Thomas's 'ViewGraph' 'Java' graph viewing program.
#' 
#' @details
#' \tabular{ll}{
#' Package: \tab rviewgraph\cr
#' Type: \tab Package\cr
#' Version: \tab 1.2\cr
#' Date: \tab 2012-03-30\cr
#' License: \tab GPL-2 \cr
#' LazyLoad: \tab yes\cr
#' }
#' This package provides an 'R' interface to Alun Thomas's 'ViewGraph' 'Java' graph viewing program.
#' It takes a graph specified as an incidence matrix, array of edges, or in \code{igraph} format
#' and runs a graphical user interface that shows an
#' animation of a force directed algorithm positioning the vertices in two dimensions.
#' It works well for graphs of various structure
#' of up to a few thousand vertices. It's not fazed by graphs that comprise several
#' components. The coordinates can be read as an \code{igraph} style layout matrix at any time.
#' The user can mess with the layout using a mouse, preferably one with 3 buttons,
#' and some keyed commands.
#' 
#' The only function that the user needs to know about in this package is 
#' \code{rViewGraph()}. It launches the GUI by delegating to specific functions depending
#' on the class of the arguments.
#'
#' The 'Java' program 'ViewGraph' is contained in Alun Thomas's 'JPSGCS' collection of 'Java' programs for
#' statistical genetics and computational statistics. The
#' homepage for 'JPSGCS' is <http://www-genepi.med.utah.edu/~alun/software/index.html>. 
#' The documentation page for 'ViewGraph' is at <http://www-genepi.med.utah.edu/~alun/software/docs/ViewGraph.html>.
#' 
NULL

#' This is a function to create and start the 'Java' graph animation GUI.
#' 
#' Creates and starts an animated GUI for positioning the vertices of a graph in 2 dimensions.
#' 
#' @param object Object to plot graph for
#' @param names names of the nodes
#' @param layout layout to start
#' @param directed is the graph directed or not
#' @param running run the graph
#' @param ...  passed along extra arguments.
#' 
#' @author Alun Thomas
#' @details
#' Creates and starts a 'Java' GUI showing a real time animation of a Newton-Raphson
#' optimization of a force function specified between the vertices of an arbitrary graph.
#' There are attractive forces between 
#' adjacent vertices and repulsive forces between all vertices.
#' The repulsions go smoothly to zero for a finite distance between vertices so that,
#' unlike some other methods, different components don't send each other off to infinity.
#' 
#' This is a generic function that delegates its work to specific functions depending on
#' the class of the first argument. It can handle an incidence matrix, a list of 
#' edges, and an \code{igraph} graph object.
#' 
#' Full information about mouse and key operations for manipulating the graph are given on
#' the documentation page for the 'Java' version of 'ViewGraph' at 
#' <http://www-genepi.med.utah.edu/~alun/software/docs/ViewGraph.html>.
#' 
#' @return
#' All versions of \code{rViewGraph} return a list of functions that control the actions of 
#' the viewer. None of the functions in the list take an argument.
#' \item{run()}{Starts the GUI running if it's not already doing so.}
#' \item{stop()}{Stops the GUI running if it's running.}
#' \item{hide()}{Stops the GUI and hides it.}
#' \item{show()}{Shows the GUI. If it was running when \code{hide} was called, it starts running again.}
#' \item{getLayout()}{Returns the coordinates of the vertices that are currently shown in the GUI. These are in the format that \code{igraph} expects for layouts.}
#' 
#' @source A full description of the force function and algorithm used 
#' is given by
#' C Cannings and A Thomas, 
#' Inference, simulation and enumeration of genealogies.
#' In D J Balding, M Bishop, and C Cannings, editors, The Handbook of Statistical
#' Genetics. Third Edition, pages 781-805. John Wiley & Sons, Ltd, 2007.
#' 
#' @examples
#' # 
#' # Viewing an Erdos Renyui random graph specified by random edges.
#' f = sample(100,size=200,replace=TRUE)
#' t = sample(100,size=200,replace=TRUE)
#' vft = rViewGraph(cbind(f,t))
#' #
#' # Edges can also be specified in \code{igraph} style.
#' e = c(t,f)
#' ve = rViewGraph(e)
#' @keywords graph 
#' @import rJava
#' @export

rViewGraph <- function (object, names, layout, directed, running, ...) 
{
	UseMethod("rViewGraph")
}


rViewGraphCore <- function (from, to, names=seq(max(from,to)), layout=NULL, directed=FALSE, running=TRUE) 
	# Expects from and to to be 0 based arrays.
{
	n <- length(names)

	stopifnot(all(0 <= from && from < n) && all(0 <= to && to < n))
    
    # default layout is random in a square
	if (is.null(layout))
		layout <- matrix(100*stats::runif(2 * n), ncol = 2)
    
    	vg = NULL

    	init = function() 
	{
        	if (is.jnull(vg)) 
		{
            		v = as.vector(names, mode = "character")
            		f = as.vector(from, mode = "integer")
            		t = as.vector(to, mode = "integer")
            		x = as.vector(layout[, 1], mode = "double")
            		y = as.vector(layout[, 2], mode = "double")
            		vg <<- .jnew("rviewgraph/RViewGraph", v, f, t, x, y, directed, running)
        	}
    	}
    
	run = function() 
	{
        	init()
        	.jcall(vg, "V", "run")
    	}
    
	stop = function() 
	{
        	init()
        	.jcall(vg, "V", "stop")
    	}

	show = function() 
	{
        	init()
        	.jcall(vg, "V", "myshow")
    	}

    	hide = function() 
	{
        	init()
        	.jcall(vg, "V", "myhide")
    	}

    	getLayout = function() 
	{
        	x = .jcall(vg, "[D", "getXCoords")
        	y = -.jcall(vg, "[D", "getYCoords")
        	cbind(x, y)
    	}

    	setLayout = function(l) 
	{
        	init()
        	x = as.vector(l[, 1], mode = "double")
        	y = as.vector(l[, 2], mode = "double")
        	.jcall(vg, "V", "setCoords", x, y)
    	}

    	init()

    	list(init = init, run = run, getLayout = getLayout, setLayout = setLayout, 
        	stop = stop, show = show, hide = hide)
}

#' @rdname rViewGraph
#' @method rViewGraph default
#' @export

rViewGraph.default <- function(object, names=seq(max(object)), layout=NULL, directed=FALSE, running=TRUE, ...) 
{
    	if(length(dim(object)) < 2 || dim(object)[2] != 2)
	{
      		message("Reformating the object as a 2 column array.")
      		object = matrix(object, ncol = 2) 
    	}

	f = object[,1]-1
	t = object[,2]-1

    	rViewGraphCore(from=f, to=t, names=names, layout=layout , directed=directed , running=running)
}

#' @rdname rViewGraph
#' @method rViewGraph Matrix
#' @export

rViewGraph.Matrix <- function(object ,names=1:max(dim(object)), layout=NULL, directed=FALSE, running=TRUE, ...) 
{
    	d <- dim(object)
    	if (!all(d==d[1]))
      		warning("Matrix not square. Expecting an incidence matrix, which should be square.")
    
    	arr <- Matrix::which(object != 0, arr.ind=TRUE)

    	rViewGraph.default(arr, names=names, layout=layout, directed=directed, running=running)
}


#' @rdname rViewGraph
#' @method rViewGraph igraph
#' @export

rViewGraph.igraph <- function(object, names=igraph::V(object)$name 
	, layout=igraph::layout.random(object), directed=igraph::is.directed(object), running=TRUE, ...) 
{
    	if (is.null(names) || length(names) == 0) 
        	names = as.vector(0:(igraph::vcount(object) - 1), mode = "character")
    	n = length(names)
    	e = igraph::get.edges(object, igraph::E(object))
    	f = as.vector(e[, 1], mode = "integer")
    	t = as.vector(e[, 2], mode = "integer")
	arr = cbind(f,t)

    	rViewGraph.default(arr, names=names, layout=layout, directed=directed, running=running)
}

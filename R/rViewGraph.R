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
#' Version: \tab 1.3.2\cr
#' Date: \tab 2021-03-03\cr
#' License: \tab GPL-2 \cr
#' LazyLoad: \tab yes\cr
#' SystemRequirements: \tab 'Java' >= 8\cr
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
#' The main function that the user needs to know about in this package is 
#' \code{rViewGraph()}. It launches the graphical user interface by delegating to specific functions depending
#' on the class of the arguments. The returned structure has function elements that control
#' the view of the graph.
#'
#' 
NULL

#' This is a function to create and start a 'Java' graph animation GUI.
#' 
#' Creates and starts an animated graphical user interface (GUI) for 
#' positioning the vertices of a graph in 2 dimensions.
#' 
#' @param object the object specifying the graph. This can be specified in various ways:
#' \itemize{
#' \item A square \code{n = dim(object)[1]} by \code{n} real valued incidence matrix. 
#' This will create a graph with \code{n} vertices indexed
#' by \code{1:n} and edges between vertices with indices \code{i} and \code{j} if \code{object[i,j] != 0}.
#' If the graph is directed edges are directed from \code{i} to \code{j} if the entry is positive,
#' and from \code{j} to \code{i} if the entry is negative.
#' \item An \code{m = dim(object)[1]} by 2 matrix of strictly positive integers
#' specifying the indexes of the vertices at the ends of \code{m} edges. This will create a graph with
#' \code{n = max(object)} vertices indexed by \code{1:max(object)} and edges connecting the vertex
#' indexed by  \code{object[i,1]} to 
#' the vertex indexed by  \code{object[i,2]} for each \code{i} in \code{1:m}.
#' If the graph is directed, the edges are directed from \code{object[i,1]} to \code{object[i,2]}.
#' NOTE: A 2 by 2 matrix will be interpreted as an incidence matrix, not an array of edges.
#' \item A vector of \code{2*m} positive integers specifying the indexes of the vertices at 
#' the ends of \code{m = length(object)/2} edges. This is the way in which \code{igraph}
#' specifies edges. If \code{x} is such a vector, calling \code{rViewGraph{x}} is equivalent
#' to calling \code{rViewGraph(matrix(x,ncol=2,byrow=F))}.
#' \item An \code{igraph} graph object.
#' }
#' @param names the names of the vertices. This is an object that can be interpreted
#' as a vector of 
#' strings that will be used to label the vertices. If the length is less than the number of
#' vertices, the names will be cycled. The default is \code{names = 1:n}, where \code{n}
#' is the number of vertices. If unlabeled vertices are required use, for example, \code{names=" "}.
#' The size of the string is used to determine the size of the vertex so, for instance,
#' \code{names = " A "} will produce bigger vertices than \code{names = "A"}.
#' @param cols the colours of the vertices. This is on object that can be 
#' interpreted as a vector of colours specified in the usual \code{R} ways. 
#' If the length is less than the number of vertices, the colours
#' will be cycled. The default is \code{cols = "yellow"}.
#' @param shapes the shapes of the vertices. This is a vector of integers specifying the shapes
#' of the vertices. The available shapes are:
#' \itemize{
#' \item 0 = rectangle
#' \item 1 = oval
#' \item 2 = diamond
#' \item any other values are taken as 0.
#' }
#' The default is \code{shapes = 0}.
#' @param layout the starting positions of the vertices. This is an \code{n} by 2 array
#' of reals with \code{layout[i,]} specifying the horizontal and vertical coordinates
#' for the starting point 
#' of the \code{i}th vertex. By default this is set to \code{NULL} in which case
#' random starting points are used.
#' @param directed indicates whether or not the graph is directed.
#' @param running indicates whether or not to start with the animation running.
#' @param ...  passed along extra arguments.
#' 
#' @author Alun Thomas
#' @details
#' Creates and starts a 'Java' GUI showing a real time animation of a Newton-Raphson
#' optimization of a force function specified between the vertices of an arbitrary graph.
#' There are attractive forces between 
#' adjacent vertices and repulsive forces between all vertices.
#' The repulsions go smoothly to zero in a finite distance between vertices so that,
#' unlike some other methods, different components don't send each other off to infinity.
#' 
#' The program is controlled by a slide bar, some buttons, the arrow, home and
#' shift keys, but mostly by mouse operations. All three mouse buttons are used.
#' 
#' \itemize{
#' \item The slide bar at the bottom controls the repulsive force in the energy
#' equation used to set the coordinates.
#'
#' \item Mouse operations without shift key and without control key pressed.
#' \enumerate{
#' \item Left mouse: Drags a vertex. Vertex is free on release. 
#' \item Middle mouse: Drags a vertex. Vertex is fixed at release position. 
#' \item Right mouse: Translates the view by the amount dragged. A bit like putting
#' your finger on a piece of paper and moving it. 
#' \item Double click with any mouse button in the background: 
#' Resets the vertices to new random positions. 
#' }
#'
#' \item Mouse operations with shift key but without control key pressed.
#' \enumerate{
#' \item Left mouse: Drags a vertex and the component it is in. 
#' Vertex and component free on release.
#' \item Middle mouse: Drags a vertex and the component it is in. 
#' Vertex and component are fixed at release positions.
#' \item Right mouse: Translates the positions of the vertices relative to 
#' the position of the canvas by the amount dragged. This is useful to center 
#' the picture on the canvas ready for outputting.
#' }
#'
#' \item Mouse operations without shift key but with control key pressed.
#' \enumerate{
#' \item Left mouse: Click on a vertex to un-delete any deleted neighbours.
#' \item Middle mouse: Click on a vertex to delete it from the graph.
#' \item Double click left mouse: Replaces all deleted vertices in the graph.
#' \item Double click middle mouse: Deletes all vertices from the graph.
#' }
#'
#' \item Mouse operations with shift key and with control key pressed.
#' \enumerate{
#' \item Left mouse: Click on a vertex to replace all vertices in the same component to the graph.
#' \item Middle mouse: Click on a vertex to delete it and the component it is in from the graph.
#' }
#'
#' \item Key functions without shift key pressed. Mouse has to be in the picture canvas.
#' \enumerate{
#' \item Up arrow: Increases the scale of viewing by 10\%.
#' \item Down arrow: Decreases the scale of viewing by 10\%.
#' \item Left arrow: Rotates the view by 15 degrees clockwise.
#' \item Right arrow: Rotates the view by 15 degrees anticlockwise.
#' \item Home key: Undoes all scalings and rotations and places the origin at
#' the top left corner of the canvas.
#' }
#'
#' \item Key functions with shift key pressed. Mouse has to be in the picture canvas.
#' \enumerate{
#' \item Up arrow: Increases the vertex positions by 10\% relative to the scale of the canvas.
#' \item Down arrow: Decreases the vertex positions by 10\% relative to the scale of the canvas.
#' \item Left arrow: Rotates the vertex positions by 15 degrees clockwise relative to the canvas orientation.
#' \item Right arrow: Rotates the vertex positions by 15 degrees anticlockwise relative to the canvas orientation.
#' }
#' }
#'
#' @return
#' \code{rViewGraph} is intended only for interactive use. When used in a non-interactive environment
#' it immediately exits returning the value \code{NULL}.
#' Otherwise, all versions of \code{rViewGraph} return a list of functions that control the actions of 
#' the interactive viewer. 
#' \item{run()}{Starts the GUI running if it's not already doing so.}
#' \item{stop()}{Stops the GUI running if it's running.}
#' \item{hide()}{Stops the GUI and hides it.}
#' \item{show()}{Shows the GUI. If it was running when \code{hide} was called, it starts running again.}
#' \item{getLayout()}{Returns the coordinates of the vertices as currently shown in the GUI.
#' These are given as an \code{n} by 2 array as required for the \code{layout} parameter
#' of \code{rViewGraph} itself.}
#' \item{setLayout(layout = NULL)}{Sets the coordinates of the vertices to the given values. \code{layout}
#' is specified in the same way as required for the \code{layout} parameter of \code{rViewGraph}
#' itself. The default has \code{layout} set to \code{NULL}, and new random coordinates are generated.}
#' \item{hidePaper()}{By default the GUI indicates, with a different colour, the portion
#' of the plane that corresponds to the current choice of paper for printing. This function
#' removes that area.}
#' \item{showPaper(size = "letter", landscape = TRUE)}{Indicates, with a different colour, the portion of the
#' plane corresponding to a choice of paper for printing. \code{size} can be any of 
#' \code{letter}, \code{A4}, \code{A3}, \code{A2}, \code{A1}, \code{A0}, \code{C1}, or \code{C0}.
#' \code{landscape} can be either \code{TRUE} or \code{FALSE}, in which case portrait orientation
#' is used. The default is to show the portion of the plane that would be printed on
#' US letter in landscape orientation.}
#' \item{hideAxes()}{By default, axes are shown to indicate the origin. This
#' function hides them.}
#' \item{showAxes()}{Shows the axes if they are hidden.}
#' \item{writePostScript()}{This starts a \code{Java} PostScript print job dialog box that can be
#' used send the current view of the graph to a printer or to write a PostScript file. The plot
#' produced should closely match what is indicated by \code{showPaper}.}
#' \item{ps()}{Alias for \code{writePostScript}.}
#' 
#' @source A full description of the force function and algorithm used 
#' is given by
#' C Cannings and A Thomas, 
#' Inference, simulation and enumeration of genealogies.
#' In D J Balding, M Bishop, and C Cannings, editors, The Handbook of Statistical
#' Genetics. Third Edition, pages 781-805. John Wiley & Sons, Ltd, 2007.
#' 
#' @examples
#' 
#' # First generate the random edges of an Erdos Renyi random graph.
#' f = sample(100,size=200,replace=TRUE)
#' t = sample(100,size=200,replace=TRUE)
#'
#' # The following should all show the same graph:
#' # ... specified as a two column matrix.
#' v1 = rViewGraph(cbind(f,t))
#'
#' # ... in 'igraph' preferred format.
#' v2 = rViewGraph(c(f,t))
#'
#' # ... as an adjacency matrix.
#' x = matrix(0,ncol=max(f,t),nrow=max(f,t))
#' for (i in 1:length(f)) x[f[i],t[i]] = 1
#' v3 = rViewGraph(x)
#' 
#'
#' # Specifying names, colours and shapes.
#'
#' # Use unlabeled vertices, as red, green and blue diamonds.
#' v4 = rViewGraph(cbind(f,t), names = "  ", cols = c(2,3,4), shapes=2)
#'
#' # Use yellow vertices with random shapes, labeled with capital letters.
#' y = matrix(sample(1:26,100,TRUE),ncol=2)
#' v5 = rViewGraph(y,names=LETTERS,cols="cyan",shapes=sample(0:2,26,TRUE))
#'
#'
#' # Controlling a currently active GUI.
#' if (!is.null(v5))
#' {
#' 	# Shift the coordinates, although this is more 
#'	# easily done with mouse controls.
#' 	v5$setLayout(100 + v5$getLayout())
#'
#'	# Reset the coordinates to random values.
#'	v5$setLayout()
#'
#' 	# Pepare a plot for printing, fix it, and start a PostScript print job.
#' 	v5$hideAxes()
#' 	v5$showPaper("A3",F)
#' 	v5$stop()
#' 	v5$writePostScript()
#' }
#'
#'
#' @keywords graph 
#' @import rJava
#' @import grDevices
#' @export

rViewGraph <- function (object, names, cols, shapes, layout, directed, running, ...) 
{
	UseMethod("rViewGraph")
}

rViewGraphCore <- function (from, to, names=seq(max(from,to)), 
			cols = "yellow", shapes = 0,
			layout=NULL, directed=FALSE, running=TRUE) 
	# Expects from and to to be 0 based arrays.
{
	if (!interactive())
	{
		print("rViewGraph only runs in interactive mode.")
		return(NULL)
	}

	.jinit()

	jv <- .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")

	if (substr(jv, 1L, 2L) == "1.") 
	{
  		jvn <- as.numeric(paste0(strsplit(jv, "[.]")[[1L]][1:2], collapse = "."))
  		if (jvn < 1.8) 
			stop("Java >= 8 is needed for this package but not available.")
	}

	if (min(to,from) < 0)
	{
		stop("All vertex indexes must be non negative.")
	}

	n <- max(to,from)+1

	if (length(names) <= n)
		names = rep(names,length.out=n)

    	# default layout is uniformly at random centered on landscape US letter paper 
	randomLayout = function()
	{
		w = 11*72/2
		h = 8.5*72/2
		l = matrix(stats::runif(2*n),ncol=2) - 0.5
		l[,1] = w + w*l[,1]
		l[,2] = h + h*l[,2]
		l
	}

	if (is.null(layout))
	{
		layout <- randomLayout()
	}

	cols = col2rgb(rep(cols,length.out=n))
	red = cols["red",]
	green = cols["green",]
	blue = cols["blue",]

	shapes = rep(shapes,length.out=n)

	# Cluges to fix up R not realizing that vectors of size 1 are vectors.
	if (n == 1)
	{
		names = c(names,names)
		red = c(red,red)
		green = c(green,green)
		blue = c(blue,blue)
		shapes = c(shapes,shapes)
		layout = rbind(layout,layout)
	}
	if (length(from) == 1)
	{
		from = c(from,from)
		to = c(to,to)
	}

    	vg = NULL

    	init = function() 
	{
        	if (is.jnull(vg)) 
		{
            		v = as.vector(names, mode = "character")
            		f = as.vector(from, mode = "integer")
            		t = as.vector(to, mode = "integer")
			r = as.vector(red, mode = "integer")
			g = as.vector(green, mode = "integer")
			b = as.vector(blue, mode = "integer")
			s = as.vector(shapes, mode = "integer")
            		x = as.vector(layout[, 1], mode = "double")
            		y = as.vector(layout[, 2], mode = "double")
            		vg <<- .jnew("rviewgraph/RViewGraph", as.integer(n), 
				v, f, t, r, g, b, s, x, y, directed, running)
        	}
    	}
    
	run = function() 
	{
        	.jcall(vg, "V", "run")
    	}
    
	stop = function() 
	{
        	.jcall(vg, "V", "stop")
    	}

	show = function() 
	{
        	.jcall(vg, "V", "show")
    	}

    	hide = function() 
	{
        	.jcall(vg, "V", "hide")
    	}

    	getLayout = function() 
	{
        	x = .jcall(vg, "[D", "getXCoords")
        	y = .jcall(vg, "[D", "getYCoords")
        	cbind(x, y)
    	}

    	setLayout = function(l = NULL) 
	{
		if (is.null(l))
			l = randomLayout()

        	x = as.vector(l[, 1], mode = "double")
        	y = as.vector(l[, 2], mode = "double")
        	.jcall(vg, "V", "setCoords", x, y)
    	}

	writePostScript = function()
	{

		error = .jcall(vg,"I","writePostScript","")
		
		message = "Done."
		if (error == 1)
			message = "Cannot find Java Toolkit."
		if (error == 2)
			message = "PostScript job canceled."
		if (error == 3)
			message = "Null Java Graphics error."
		message
	}

	showPaper = function(size="letter", landscape=T)
	{

		i = 0

		if (size=="Letter" || size=="letter")
			i = 1
		if (size=="A4" || size=="a4")
			i = 2
		if (size=="A3" || size=="a3")
			i = 3
		if (size=="A2" || size=="a2")
			i = 4
		if (size=="A1" || size=="a1")
			i = 5
		if (size=="A0" || size=="a0")
			i = 6
		if (size=="C1" || size=="c1")
			i = 7
		if (size=="C0" || size=="c0")
			i = 8

		i = 2*i - 1 

		if (landscape)
			i = i+1
		
		.jcall(vg,"V","showPaper",as.integer(i))
	}

	hidePaper = function()
	{
		.jcall(vg,"V","showPaper",as.integer(0))
	}

	showAxes = function()
	{
		.jcall(vg,"V","showAxes")
	}

	hideAxes = function()
	{
		.jcall(vg,"V","hideAxes")
	}
		
    	init()
	setLayout(layout)
	showPaper("letter")
	showAxes()

    	list	( init = init, 
		run = run, 
		stop = stop, 
		show = show, 
		hide = hide,
		getLayout = getLayout, 
		setLayout = setLayout,
		showPaper = showPaper,
		hidePaper = hidePaper,
		showAxes = showAxes,
		hideAxes = hideAxes,
		writePostScript = writePostScript,
		ps = writePostScript
	) 
}

#' @rdname rViewGraph
#' @method rViewGraph default
#' @export

rViewGraph.default <- function(object, names=NULL, cols="yellow", shapes=0, layout=NULL, directed=FALSE, running=TRUE, ...) 
{
	vectr = length(dim(object)) < 2
	pairs = length(dim(object)) == 2 && dim(object)[2] == 2
	matrx = length(dim(object)) == 2 && dim(object)[1] == dim(object)[2]

	if (vectr)
	{
		object = matrix(object,ncol=2,byrow=F)
		pairs = T
	}

	if (matrx)
	{
		if (is.null(names))
			names = 1:max(dim(object))

		e = NULL
		for (i in 1:nrow(object))
			for (j in 1:nrow(object))
			{
				if (object[i,j] > 0)
					e = rbind(e,c(i,j))
				if (object[i,j] < 0)
					e = rbind(e,c(j,i))
			}
		if (is.null(e))
			e = c(1,1)
		f = e[,1]-1
		t = e[,2]-1
	}
	else if (pairs)
	{
		if (is.null(names))
			names = seq(max(object))
		f = object[,1]-1
		t = object[,2]-1
	}
	else
	{
		print("Graph must be specified as a square incidence matrix,")
		print("or as n rows by 2 columns giving ends of edges,")
		print("or as a vector giving ends of edges.")
		return(NULL)
	}
	
    	rViewGraphCore(from=f, to=t, names=names, cols=cols, shapes=shapes, layout=layout, directed=directed, running=running)
}

#' @rdname rViewGraph
#' @method rViewGraph igraph
#' @export

rViewGraph.igraph <- function(object, names=igraph::V(object)$name, cols="yellow", shapes=0
	, layout=igraph::layout.random(object), directed=igraph::is.directed(object), running=TRUE, ...) 
{
    	if (is.null(names) || length(names) == 0) 
        	names = as.vector(0:(igraph::vcount(object) - 1), mode = "character")
    	n = length(names)
    	e = igraph::get.edges(object, igraph::E(object))
    	f = as.vector(e[, 1], mode = "integer")
    	t = as.vector(e[, 2], mode = "integer")
	arr = cbind(f,t)

    	rViewGraph.default(arr, names=names, cols=cols, shapes=shapes, layout=layout, directed=directed, running=running)
}

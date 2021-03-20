
#' Animated graph viewer
#' 
#' \code{vg} creates and starts an animated graphical user interface for 
#' positioning the vertices of a graph in 2 dimensions.
#'
#'
#' @author Alun Thomas
#' 
#'
#' @param grob is a graphical object state saved as a \code{list}
#' from a previous run 
#' of \code{vg} using the \code{save()} function.
#' If \code{grob} is \code{NULL} or not a \code{list},
#' \code{vg} starts with an empty graph.
#'
#' @param directed indicates whether or not the graph is directed. By default
#' \code{directed = FALSE}.
#' If the graph is directed, the edges have arrows indicating direction, and 
#' there are three slide bars to control the repulsion parameters. For an 
#' undirected graph there is a single control.
#'
#' @param running indicates whether or not the viewer is started 
#' with the animation running. By default \code{running = TRUE}.
#' 
#' 
#' @details
#' Creates and starts a 'Java' graphical user interface
#' (GUI) showing a real time animation of a 
#' Newton-Raphson optimization of a force function specified 
#' between the vertices of an arbitrary graph.
#' There are attractive forces between 
#' adjacent vertices and repulsive forces between all vertices.
#' The repulsions go smoothly to zero in a finite distance between 
#' vertices so that, unlike some other methods, different 
#' components don't send each other off to infinity.
#' 
#' The program is controlled by a slide bar, some buttons, the arrow, home and
#' shift keys, but mostly by mouse operations. All three mouse buttons are used.
#' These operations are described below.
#'
#' \code{vg} will replace \code{rViewGraph}, although the latter is
#' still currently available.
#' \code{vg} allows for far more control of the graph than \code{rViewGraph}, 
#' including adding and removing vertices and edges, and changing 
#' the appearance of the vertices,
#' all of which can be done while the animation is running.
#' It has a different set of force parameter controls that are useful for 
#' directed acyclic graphs (DAGs) specifically, but also, 
#' to a lesser extent, for arbitrary directed graphs. 
#' It also provides functions for saving and restoring a graphical state
#' including vertices and edges, vertex positions, and vertex appearances.
#' 
#' \code{vg} is intended only for interactive use. 
#' When used in a non-interactive environment
#' it immediately exits returning the value \code{NULL}.
#' Otherwise, it returns a list of functions that 
#' specify and query the graph, and control the viewer.
#'
#' @return
#'
#' \item{add(i)}{If the graph does not contain vertices indexed by \code{i},
#' they are added to it. \code{i} may be any integer or integer vector.}
#'
#' \item{remove(i)}{If the graph contains vertices indexed by \code{i}, 
#' they are disconnected from
#' their neighbours and removed from the graph. \code{i} may be 
#' any integer or integer vector.}
#'
#' \item{connect(i,j)}{If the graph does not have edges between vertices 
#' indexed by \code{i}
#' and \code{j}, they are made. 
#' If \code{i} and \code{j} are of different lengths, only the 
#' first \code{min(length(i),length(j))} values are used.
#' If the relevant vertices are are not already in the graph,
#' they are first made and added.
#' \code{i} and \code{j} 
#' may be any integers or integer vectors.}
#'
#' \item{disconnect(i,j)}{If the graph has edges between vertices 
#' indexed by \code{i} and 
#' \code{j} they are removed. If \code{i} and \code{j} are of 
#' different lengths, only the 
#' first \code{min(length(i),length(j))} values are used.
#' The vertices themselves are not removed, even if they have no
#' other neighbours. \code{i} and \code{j} may be any integers 
#' or integer vectors.}
#'
#' \item{clear()}{All vertices and edges are removed from the graph, 
#' however, any customizations
#' made to the appearance of the vertices will persist 
#' until \code{clearMap()} is called.}
#'
#'
#' \item{isDirected()}{Returns \code{TRUE} if the graph's edges are directed,
#' \code{FALSE} otherwise.}
#'
#' \item{getIds()}{Returns a vector of all the vertex 
#' indices that the viewer has 
#' encountered, whether or not they are currently in the graph.}
#'
#' \item{contains(id)}{Returns a vector of booleans indicating whether the
#' vertices corresponding to the given indices are currently in the graph.}
#'
#' \item{connects(i,j)}{Returns a vector of booleans indicating whether the
#' vertices with the indices in vector \code{i} are 
#' connected to the corresponding
#' vertices in \code{j}. If \code{i} and \code{j} are of 
#' different lengths, only 
#' first \code{min(length(i),length(j))} values are queried.}
#'
#' \item{neighbours(i)}{Returns a list of vectors containing
#' the neighbours of the vertices indexed by \code{i}. If the graph is
#' directed, both in and out neighbours are included. If a vertex is
#' unconnected, an empty vector is returned. If an index is for a vertex
#' that is not currently in the graph, \code{NULL} is returned.}
#'
#' \item{neighbors(i)}{Alias for \code{neighbours(i)}.}
#'
#' \item{inNeighbours(i)}{Returns a list of vectors containing the
#' indices of vertices with edges from them to the ones in \code{i}.
#' If the graph is undirected, this is the same as \code{neighbours(i)}.}
#' 
#' \item{inNeighbors(i)}{Alias for \code{inNeighbours(i)}.}
#'
#' \item{outNeighbours(i)}{Returns a list of vectors containing the
#' indices of vertices with edges to them from the ones in \code{i}.
#' If the graph is undirected, this is the same as \code{neighbours(i)}.}
#' 
#' \item{outNeighbors(i)}{Alias for \code{outNeighbours(i)}.}
#'
#'
#' \item{getVertices()}{Returns a vector of the indices of 
#' all vertices currently 
#' in the graph.}
#'
#' \item{getEdges()}{Returns a matrix with 2 columns and a row for each edge
#' in the current graph. Each row gives the indices of the vertices that the
#' edge connects. If the edges are directed, 
#' the connections are oriented from vertices
#' in the first column to those in the second.}
#'
#'
#' \item{getX(id)}{Returns the current horizontal 
#' coordinates of the vertices with
#' indices in \code{id}. Returns 0 if an index has not previously been seen.}
#'
#' \item{getY(id)}{Returns the current vertical coordinates of the vertices with
#' indices in \code{id}. Returns 0 if an index has not previously been seen.}
#'
#' \item{setXY(id, x, y)}{Sets the horizontal and vertical coordinates for the
#' vertices with indices in \code{id}. If \code{x} or \code{y} are not as long
#' as \code{id} their values are repeated cyclically to get vectors of the
#' right length.}
#'
#'
#' \item{label(i,lab=i)}{Sets the strings shown on the 
#' vertices indexed by \code{i} to those specified
#' by \code{lab}. If \code{lab} is not as long as \code{i}, 
#' its values are repeated cyclically to
#' get a vector of the right length. 
#' An error will occur if \code{lab} can't be interpreted as 
#' a vector of strings.}
#'
#' \item{colour(i,col="yellow")}{Sets the colours of the 
#' vertices indexed by \code{i} to those specified
#' by \code{col}. If \code{col} is not as long as \code{i}, 
#' its values are repeated cyclically to 
#' get a vector of the right length. 
#' Colours can be specified in the usual \code{R} ways.}
#'
#' \item{color(i,col="yellow")}{Alias for \code{colours(i,col)}.}
#'
#' \item{shape(i,shp=0)}{Sets the shapes of the vertices 
#' indexed by \code{i} to those specified by 
#' \code{shp}. If \code{shp} is not as long as \code{i}, 
#' its values are repeated cyclically to
#' get a vector or the right length. Shapes are specified as integers:
#' \itemize{
#' \item 0 = rectangle
#' \item 1 = oval
#' \item 2 = diamond
#' \item any other values are taken as 0.
#' }}
#'
#' \item{size(i,width=-1,height=width)}{Sets the sizes of the 
#' vertices indexed by \code{i} to those specified by 
#' \code{width} and \code{height}. 
#' If, for a certain index, both \code{width} and \code{height} are
#' non-negative, the size of the vertex is fixed.
#' If either of \code{width} or \code{height} is negative, 
#' the size of the vertex
#' is chosen adaptively to fit the current label.
#' If \code{width} or \code{height} are not as long as \code{i},
#' their values are repeated cyclically to get vectors of the right length.
#' }
#'
#' \item{map(i,lab=i,col="yellow",shp=0,width=-1,height=width}{Combines 
#' \code{label()}, \code{colour()}, \code{shape()} and \code{size()} in a 
#' single index-to-appearance mapping function. 
#' These functions can be called before or
#' after the vertices have been added to the graph, 
#' and the representations will persist for
#' vertices removed from, and replaced in, the graph until 
#' until they are explicitly changed or \code{clearMap()} is called.}
#'
#' \item{clearMap()}{Resets all vertices to the default 
#' appearance of yellow rectangle labeled
#' with the index.}
#'
#'
#' \item{run()}{Starts the GUI running if it's not already doing so.}
#'
#' \item{stop()}{Stops the GUI running if it's running.}
#'
#' \item{isRunning()}{Returns \code{TRUE} if the animation is running, 
#' \code{FALSE} otherwise.}
#'
#' \item{show()}{Shows the GUI. If it was running 
#' when \code{hide()} was called, it starts running again.}
#'
#' \item{hide()}{Stops the GUI and hides it.}
#'
#' \item{showPaper(size = "letter", landscape = TRUE)}{Indicates, 
#' with a different colour, the portion of the
#' plane corresponding to a choice of paper for printing. 
#' \code{size} can be any of 
#' \code{letter}, \code{A4}, \code{A3}, \code{A2}, \code{A1}, 
#' \code{A0}, \code{C1}, or \code{C0}.
#' \code{landscape} can be either \code{TRUE} or \code{FALSE}, 
#' in which case portrait orientation
#' is used. The default is to show the portion of the plane 
#' that would be printed on
#' US letter in landscape orientation.}
#'
#' \item{hidePaper()}{By default the GUI indicates, 
#' with a different colour, the portion
#' of the plane that corresponds to the current 
#' choice of paper for printing. This function
#' removes that area.}
#'
#' \item{showAxes()}{Shows the axes if they are hidden.}
#'
#' \item{hideAxes()}{By default, axes are shown to indicate the origin. This
#' function hides them.}
#'
#' \item{ps()}{Starts a \code{Java} PostScript print job dialog box that can be
#' used send the current view of the graph to a printer or to write a 
#' PostScript file. The plot
#' produced should closely match what is indicated by \code{showPaper}.}
#'
#' \item{save()}{Returns a \code{list} specifying the current state of the
#' graph structure, vertex coordinates, and vertex appearance map.}
#'
#' \item{restore(grob)}{Restores a saved graph and map state.}
#'
#' 
#' @section Interactive mouse, key and slide bar controls:
#'
#' \itemize{
#' \item Slide bars at the bottom of the GUI control the 
#' repulsive force in the energy
#' equation used to set the coordinates.
#' If the graph is undirected, there is a single 'Repulsion' parameter, 
#' if directed, there
#' are 'X-Repulsion' and 'Y-Repulsion' parameters, 
#' and a 'Gravity' parameter that influences
#' how these are combined.
#'
#' \item Mouse operations without shift key and without control key pressed.
#' \enumerate{
#' \item Left mouse: Drags a vertex. Vertex is free on release. 
#' \item Middle mouse: Drags a vertex. Vertex is fixed at release position. 
#' \item Right mouse: Translates the view by the amount dragged. 
#' A bit like putting
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
#' \item Left mouse: Click on a vertex to un-hide any hidden neighbours.
#' \item Middle mouse: Click on a vertex to hide it.
#' \item Double click left mouse: Un-hides all hidden vertices.
#' \item Double click middle mouse: Hides all vertices.
#' }
#'
#' \item Mouse operations with shift key and with control key pressed.
#' \enumerate{
#' \item Left mouse: Click on a vertex to un-hide all vertices 
#' in the same component.
#' \item Middle mouse: Click on a vertex to hide it and the component it is in.
#' }
#'
#' \item Key functions without shift key pressed. 
#' Mouse has to be in the picture canvas.
#' \enumerate{
#' \item Up arrow: Increases the scale of viewing by 10\%.
#' \item Down arrow: Decreases the scale of viewing by 10\%.
#' \item Left arrow: Rotates the view by 15 degrees clockwise.
#' \item Right arrow: Rotates the view by 15 degrees anticlockwise.
#' \item Home key: Undoes all scalings and rotations and places the origin at
#' the top left corner of the canvas.
#' }
#'
#' \item Key functions with shift key pressed. 
#' Mouse has to be in the picture canvas.
#' \enumerate{
#' \item Up arrow: Increases the vertex positions by 10\% 
#' relative to the scale of the canvas.
#' \item Down arrow: Decreases the vertex positions by 10\% 
#' relative to the scale of the canvas.
#' \item Left arrow: Rotates the vertex positions by 15 
#' degrees clockwise relative to the canvas orientation.
#' \item Right arrow: Rotates the vertex positions by 15 
#' degrees anticlockwise relative to the canvas orientation.
#' }
#' }
#'
#' 
#'
#' @references 
#' A full description of the force function and algorithm used is given by
#' C Cannings and A Thomas, 
#' Inference, simulation and enumeration of genealogies.
#' In D J Balding, M Bishop, and C Cannings, editors, 
#' The Handbook of Statistical
#' Genetics. Third Edition, pages 781-805. John Wiley & Sons, Ltd, 2007.
#'
#'
#' @seealso rViewGraph
#' 
#' 
#' @examples
#' 
#' # Start the viewer.
#' require(rviewgraph)
#' v = vg()
#'
#' # Check that the viewer was made. 
#' # Not usually necessary in interactive mode.
#' if (!is.null(v))
#' {
#' 	# Generate some random vertices to connect with edges.
#' 	from = sample(1:20,15,TRUE)
#' 	to = sample(1:20,15,TRUE)
#' 
#' 	# Connect these edges in the viewer.
#' 	v$connect(from,to)
#' 
#' 	# Negative vertex indices are also allowed.
#' 	v$connect(-from,-to)
#' 
#' 	# Add some new vertices, unconnected to any others.
#' 	v$add(30:35)
#' 
#' 	# Remove some vertices.
#' 	v$rem((-5:5)*2)
#'
#' 	# Query some of the structure of the graph.
#' 	v$contains(1)
#' 	v$contains(-1)
#' 	v$connects(1,-1)
#' 	v$contains(1:50)
#' 	v$connects(from,to)
#' 	v$connects(from,-to+2)
#'	v$neighbours(from)
#' 
#' 	# Change what some of the vertices look like.
#' 	v$map(-10:10, lab = "", col=1, shp=1, width=1:15)
#' 	v$label(10:36, lab=LETTERS)
#' 	v$colour((-1000:-1),"cyan")
#' 	v$shape((-1000:-1)*2,2)
#'
#' 	# Hide the axes.
#' 	v$hideAxes()
#'
#' 	# Stop the animation. 
#' 	# Not necessary for outputting but sometimes helpful.
#' 	v$stop()
#'	
#' 	# Change the paper size and orientation to A4 portrait.
#' 	v$showPaper("A4",F)
#'
#' 	# Start the print dialog box.
#' 	v$ps()
#'
#' 	# Restart the animation, and check that it's running.
#' 	v$run()
#' 	v$isRunning()
#'
#' 	# Save the application.
#' 	s = v$save()
#'
#' 	# Change the graph and appearance.
#' 	v$colour(-1000:1000,"red")
#' 	v$connect(rep(1,100),1:100)
#'
#' 	# Then decide you didn't like the changes so restore 
#' 	# the saved state.
#' 	v$restore(s)
#'
#' 	# Can also restore a state in a new GUI.
#' 	v2 = vg(s)
#'
#' 	# Get a vector of all the indices that the viewer has seen.
#' 	ids = v$getIds()
#'	
#' 	# Get a vector of the indices of the vertices currently 
#' 	# in the graph.
#' 	verts = v$getVertices()
#'
#' 	# Get a matrix with 2 columns specifying the current edges 
#' 	# of the graph.
#' 	edges = v$getEdges()
#'
#' 	# Get the current coordinates of the specified vertices. 
#' 	x = v$getX(verts)
#' 	y = v$getY(verts)
#'
#' 	# Change the current coordinates of the vertices.
#' 	v$setXY(verts,2*x,0.5*y+2)
#'
#' }
#'
#'
#' @keywords graph animation edges vertices 
#' @import rJava
#' @import grDevices
#' @export

vg <- function(grob, directed, running)
{
	UseMethod("vg")
}

#' @rdname vg
#' @method vg list
#' @export

vg.list <- function(grob, directed = grob$directed, running = grob$running)
{
	if (!is.logical(directed))
	{
		warning("Argument 'directed' must be logical. Setting to 'FALSE'.")
		directed = FALSE
	}
	if (length(directed) > 1)
	{
		warning("Using only first element of argument 'directed'.")
		directed = directed[1]
	}

	if (!is.logical(running))
	{
		warning("Argument 'running' must be logical. Setting to 'TRUE'.")
		running = TRUE
	}
	if (length(running) > 1)
	{
		warning("Using only first element of argument 'running'.")
		running = running[1]
	}

	vgCore(grob,directed,running)
}

#' @rdname vg
#' @method vg NULL
#' @export

vg.NULL <- function(grob = NULL, directed = FALSE, running = TRUE)
{
	vg.list(NULL,directed,running)
}

#' @rdname vg
#' @method vg default
#' @export

vg.default <- function(grob = NULL, directed = FALSE, running = TRUE)
{
	if (missing(grob))
	{
	}
	else if (is.logical(grob) && is.logical(directed))
	{
		running = directed
		directed = grob
		message = paste("Argument 'grob' should be a 'list' or 'NULL'.",
			"\n\tUsing: grob = NULL, directed = ",directed,", running = ",running,".",sep="")
#		warning(message)
	}
	else
	{
		warning("Argument 'grob' must be 'list' or 'NULL'. Setting to 'NULL'.")
	}

	vg.NULL(NULL,directed,running)
}

# Core graph viewing method.

vgCore <- function (saved, directed=FALSE, running=TRUE) 
{
	# Check that this is running in an interactive session.
	if (!interactive())
	{
		print("vg only runs in interactive mode.")
		return(NULL)
	}

	# Start Java.
	.jinit()

	# Check the Java version.
	jv <- .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")

	if (substr(jv, 1L, 2L) == "1.") 
	{
  		jvn <- as.numeric(paste0(strsplit(jv, "[.]")[[1L]][1:2], collapse = "."))
  		if (jvn < 1.8) 
			stop("Java version >= 8 is needed for this package but not available.")
	}

	# Define the functions that run the GUI.

    	init = function() 
	{
		if (is.jnull(viewer)) 
		{
	    		viewer <<- .jnew("rviewgraph/Rvg", directed, running)
		}
    	}

	map = function(i, lab = i, col = "yellow", shp = 0, width = -1, height = width)
	{
		x = as.vector(i, mode = "integer")
		n = length(x)

		lab = as.vector(rep(lab,length.out=n), mode = "character")

		col = col2rgb(rep(col,length.out=n))
		r = as.vector(col["red",], mode = "integer")
		g = as.vector(col["green",], mode = "integer")
		b = as.vector(col["blue",], mode = "integer")
	
		shp = as.vector(rep(shp,length.out=n), mode = "integer")

		width = as.vector(rep(width,length.out=n), mode = "integer")
		height = as.vector(rep(height,length.out=n), mode = "integer")

		.jcall(viewer,"V","map",.jarray(x),.jarray(lab),
			.jarray(r),.jarray(g),.jarray(b),.jarray(shp),.jarray(width),.jarray(height))
	}

	clearMap = function()
	{
		.jcall(viewer, "V", "clearMap")
	}

	label = function(i, lab = i)
	{
		x = as.vector(i, mode = "integer")
		n = length(x)
		lab = as.vector(rep(lab,length.out=n), mode = "character")
		.jcall(viewer,"V","name",.jarray(x),.jarray(lab))
	}

	colour = function(i, col = "yellow")
	{
		x = as.vector(i, mode = "integer")
		n = length(x)
		col = col2rgb(rep(col,length.out=n))
		r = as.vector(col["red",], mode = "integer")
		g = as.vector(col["green",], mode = "integer")
		b = as.vector(col["blue",], mode = "integer")
		.jcall(viewer,"V","colour",.jarray(x),.jarray(r),.jarray(g),.jarray(b))
	}

	size = function(i, width = -1, height = width)
	{
		x = as.vector(i, mode = "integer")
		n = length(x)
		width = as.vector(rep(width,length.out=n), mode = "integer")
		height = as.vector(rep(height,length.out=n), mode = "integer")
		.jcall(viewer,"V","size",.jarray(x),.jarray(width),.jarray(height))
	}

	shape = function(i, shp = 0)
	{
		x = as.vector(i, mode = "integer")
		n = length(x)
		shp = as.vector(rep(shp,length.out=n), mode = "integer")
		.jcall(viewer,"V","shape",.jarray(x),.jarray(shp))
	}

	add = function(i)
	{
		x = as.vector(i, mode="integer")
		.jcall(viewer,"V","add",.jarray(x))
	}

	contains = function(i)
	{
		x = as.vector(i, mode="integer")
		.jcall(viewer,"[Z","contains",.jarray(x))
	}

	neighbours = function(i)
	{
		l = NULL
		for (x in as.vector(i, mode="integer"))
			l = append(l,list(.jcall(viewer,"[I","neighbours",x)))
		l
	}

	inNeighbours = function(i)
	{
		l = NULL
		for (x in as.vector(i, mode="integer"))
			l = append(l,list(.jcall(viewer,"[I","inNeighbours",x)))
		l
	}

	outNeighbours = function(i)
	{
		l = NULL
		for (x in as.vector(i, mode="integer"))
			l = append(l,list(.jcall(viewer,"[I","outNeighbours",x)))
		l
	}

	rem = function(i)
	{
		x = as.vector(i, mode="integer")
		.jcall(viewer,"V","remove",.jarray(x))
	}

	connect = function(i,j)
	{
		n = min(length(i),length(j))
		x = as.vector(i, mode="integer")[1:n]
		y = as.vector(j, mode="integer")[1:n]
		.jcall(viewer,"V","connect",.jarray(x),.jarray(y))
	}

	connects = function(i,j)
	{
		n = min(length(i),length(j))
		x = as.vector(i, mode="integer")[1:n]
		y = as.vector(j, mode="integer")[1:n]
		.jcall(viewer,"[Z","connects",.jarray(x),.jarray(y))
	}

	disconnect = function(i,j)
	{
		n = min(length(i),length(j))
		x = as.vector(i, mode="integer")[1:n]
		y = as.vector(j, mode="integer")[1:n]
		.jcall(viewer,"V","disconnect",.jarray(x),.jarray(y))
	}

	clear = function()
	{
		.jcall(viewer,"V","clear")
	}

	run = function() 
	{
		.jcall(viewer, "V", "run")
    	}
    
	stop = function() 
	{
		.jcall(viewer, "V", "stop")
    	}

	show = function() 
	{
		.jcall(viewer, "V", "show")
    	}

    	hide = function() 
	{
		.jcall(viewer, "V", "hide")
    	}

	writePostScript = function()
	{
		error = .jcall(viewer,"I","writePostScript")
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
		
		.jcall(viewer,"V","showPaper",as.integer(i))
	}

	hidePaper = function()
	{
		.jcall(viewer,"V","showPaper",as.integer(0))
	}

	showAxes = function()
	{
		.jcall(viewer,"V","showAxes")
	}

	hideAxes = function()
	{
		.jcall(viewer,"V","hideAxes")
	}

	getIds = function()
	{
		.jcall(viewer,"[I","getIndexes")
	}

	getVertices = function()
	{
		.jcall(viewer,"[I","getVertices")
	}

	getEdges = function()
	{
		f = .jcall(viewer,"[I","getFrom")
		t = .jcall(viewer,"[I","getTo")
		cbind(f,t)
	}

	getX = function(id)
	{
		id = as.vector(id, mode="integer")
		.jcall(viewer,"[D","getXCoords",.jarray(id))
	}

	getY = function(id)
	{
		id = as.vector(id, mode="integer")
		.jcall(viewer,"[D","getYCoords",.jarray(id))
	}

	setXY = function(id, x, y)
	{
		id = as.vector(id, mode="integer")
		x = as.vector(rep(x,length.out=length(id)))
		y = as.vector(rep(y,length.out=length(id)))
		.jcall(viewer,"V","setCoords",.jarray(id),.jarray(x),.jarray(y))
	}

	isDirected = function()
	{
		.jcall(viewer,"Z","isDirected")
	}

	isRunning = function()
	{
		.jcall(viewer,"Z","isRunning")
	}

	save = function()
	{
		id = .jcall(viewer,"[I","getIndexes")
				
		list (
			running = .jcall(viewer,"Z","isRunning"),
			directed = .jcall(viewer,"Z","isDirected"),

			id = id,

			v = .jcall(viewer,"[I","getVertices"),

			f = .jcall(viewer,"[I","getFrom"),
			t = .jcall(viewer,"[I","getTo"),

			l = .jcall(viewer,"[Ljava/lang/String;","getNames",.jarray(id)),
			#l = .jcall(viewer,"[S","getNames",.jarray(id)),

			r = .jcall(viewer,"[I","getRed",.jarray(id)),
			g = .jcall(viewer,"[I","getGreen",.jarray(id)),
			b = .jcall(viewer,"[I","getBlue",.jarray(id)),

			s = .jcall(viewer,"[I","getShape",.jarray(id)),

			w = .jcall(viewer,"[I","getWidth",.jarray(id)),
			h = .jcall(viewer,"[I","getHeight",.jarray(id)),

			x = .jcall(viewer,"[D","getXCoords",.jarray(id)),
			y = .jcall(viewer,"[D","getYCoords",.jarray(id)),

			NULL
		)
	}

	restore = function(g)
	{
		if (!is.null(g))
		{
			stop()
			clear()
			clearMap()
			add(g$v)
			connect(g$f,g$t)
			setXY(g$id,g$x,g$y)
			map(g$id,g$l,rgb(g$r/255,g$g/255,g$b/255),g$s,g$w,g$h)
			if (g$running)
				run()
		}
	}


	# Create the GUI and set the state.

   	viewer = NULL
    	init()
	stop()
	restore(saved)
	if (running)
		run()
	else
		stop()

	showPaper("letter")
	showAxes()

	# Return the GUI object.

    	list	(
		add = add,
		remove = rem,
		connect = connect,
		disconnect = disconnect,
		clear = clear,

		contains = contains,
		connects = connects,
		neighbours = neighbours, neighbors = neighbours,
		outNeighbours = outNeighbours, outNeighbors = outNeighbours,
		inNeighbours = inNeighbours, inNeighbors = inNeighbours,
		getIds = getIds,
		getVertices = getVertices,
		getEdges = getEdges,
		
		getX = getX,
		getY = getY,
		setXY = setXY,
		isDirected = isDirected,
		isRunning = isRunning,

		map = map,
		clearMap = clearMap,
		label = label,
		colour = colour, color = colour,
		size = size,
		shape = shape,

		run = run, 
		stop = stop, 
		show = show, 
		hide = hide,
		showPaper = showPaper,
		hidePaper = hidePaper,
		showAxes = showAxes,
		hideAxes = hideAxes,
		ps = writePostScript,

		save = save,
		restore = restore
	)
}


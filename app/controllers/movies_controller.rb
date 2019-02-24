class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:order] = params[:order] unless params[:order].nil?
    
    # if params[:ratings]
	   #   @checked_ratings = params[:ratings].keys
	      
	 if session[:ratings]
	      @checked_ratings = params[:ratings].keys
	    else
	      @checked_ratings = @all_ratings
	    end

	    @checked_ratings.each do |rating|
        # params[rating] = true
        session[rating] = true
      end
    
    # if params[:sort]
	   #   @movies = Movie.order(params[:sort])
	 if session[:sort]
	      @movies = Movie.order(session[:sort])
	    else
	      @movies = Movie.where(:rating => @checked_ratings)
	    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

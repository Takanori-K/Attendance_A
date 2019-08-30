class BasesController < ApplicationController
  def new
    @base = Base.new
  end
  
  def index
    @bases = Base.all
  end
  
  def edit
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
end

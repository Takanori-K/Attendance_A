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
    @base = Base.new(base_params)
    if @base.save
      flash[:notice] = "拠点情報を追加しました。"
    else
      flash[:danger] = "拠点情報の追加は失敗しました。</br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to bases_url  
  end
  
  def update
  end
  
  def destroy
  end
  
  private
    
    def base_params
      params.require(:base).premit(:base_number, :base_name, :attendance_type)
    end
end

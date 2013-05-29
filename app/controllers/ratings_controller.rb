class RatingsController < ApplicationController

  # auto completes rating perspectives
  # Params:
  # +q+:: the parameter is  a string passed through auttocomplete field
  # Author: muhammed hassan
  def ajax
    r=Rating.find(:all, conditions:{:name => params[:q]})
    @ratings = Rating.find(:all, :select =>'DISTINCT name', conditions: ['name LIKE(?)', "%#{ params[:q] }%"]).uniq
    if r.empty?
      @ratings << Rating.new(name: params[:q])
    end
    render :json => @ratings , only: [:name,:id]
  end

end

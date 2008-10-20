class Admin::FormDatasController < ApplicationController

  LIST_PARAMS_BASE = [:page, :sort_by, :sort_order]

  def index
    @urls = FormData.find_all_group_by_url
    filter_by_params(DATABASE_MAILER_COLUMNS.keys + [:url])
    @saved_items = FormData.form_paginate(list_params)
  end
  
  def list_params
    @list_params ||= {}
  end
  helper_method :list_params
  
  protected
    def filter_by_params(args)
      args = args + LIST_PARAMS_BASE
      args.each do |arg|
        list_params[arg] = params[:reset] ? params[arg] : params[arg] || cookies[arg]
      end
      list_params[:page] ||= "1"
    
      update_list_params_cookies(args)
    
      # pentru will_paginate
      params[:page] = list_params[:page]
    end
  
    def update_list_params_cookies(args)
      args.each do |key|
        cookies[key] = { :value => list_params[key], :path => "/#{controller_path}" }
      end
    end
end
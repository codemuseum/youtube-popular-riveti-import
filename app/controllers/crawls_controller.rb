class CrawlsController < ApplicationController
  protect_from_forgery :except => [:create, :destroy]

  # GET /crawls
  # GET /crawls.xml
  def index
    @crawls = Crawl.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crawls }
    end
  end

  # GET /crawls/1
  # GET /crawls/1.xml
  def show
    @crawl = Crawl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crawl }
    end
  end

  # GET /crawls/new
  # GET /crawls/new.xml
  def new
    @crawl = Crawl.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crawl }
    end
  end

  # GET /crawls/1/edit
  def edit
    @crawl = Crawl.find(params[:id])
  end

  # POST /crawls
  # POST /crawls.xml
  def create
    @crawl = Crawl.update_crawl

    respond_to do |format|
      flash[:notice] = 'Crawl was successfully created.'
      format.html { redirect_to(@crawl) }
      format.xml  { render :xml => @crawl, :status => :created, :location => @crawl }
      format.json { render :json => @crawl }
    end
  end

  # PUT /crawls/1
  # PUT /crawls/1.xml
  def update
    @crawl = Crawl.find(params[:id])

    respond_to do |format|
      if @crawl.update_attributes(params[:crawl])
        flash[:notice] = 'Crawl was successfully updated.'
        format.html { redirect_to(@crawl) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crawl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /crawls/1
  # DELETE /crawls/1.xml
  def destroy
    Crawl.clear_crawl

    respond_to do |format|
      format.html { redirect_to(crawls_url) }
      format.xml  { head :ok }
    end
  end
end

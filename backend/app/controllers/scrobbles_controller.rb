require 'open-uri'

class ScrobblesController < ApplicationController
  # skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token
  
  before_action :set_scrobble, only: [:show, :edit, :update, :destroy]

  # GET /scrobbles
  def index
    @scrobbles = Scrobble.all
  end

  # GET /scrobbles/1
  def show
  end

  # GET /scrobbles/new
  def new
    @scrobble = Scrobble.new
  end

  # GET /scrobbles/1/edit
  def edit
  end


  # since vlc addon cannot make POST request right now, refer to ticket: https://trac.videolan.org/vlc/ticket/9495
  # i'm making temp url for adding scrobbles by GET
  # GET /scrobbles/fix/new
  def create_tmp
    params.require(:filename)
    filename = params[:filename]
    filename_history = FilenameHistory.create(user_id: current_user.id, filename: filename)
    
    info = JSON.parse(`python guess.py #{filename}`)
    puts info
    if info["type"] == "episode"
      # ok, so we got some show info from guessit (python module), but lets try to fix the name
      # if e.g. casing is wrong, like "how i met your mother"
      tvdb = TvdbParty::Search.new("D7C9209F467E2C24")
      name = info["series"]
      results = tvdb.search(name)
      first_match = tvdb.get_series_by_id(results.first["seriesid"])

      show = Show.find_or_create_by(name: first_match.name)
      unless show.banner?
        show_img_url = first_match.posters('en').first.url
        uri = URI.parse(show_img_url)

        if show_img_url
          File.open("#{::Rails.root}/tmp/" + File.basename(uri.path), "wb") do |file|
            file.write open(show_img_url).read

            show.banner = file
            show.save
          end
        end
      end

      season = Season.find_or_create_by(number: info["season"], show_id: show.id)
      episode = Episode.find_or_create_by(number: info["episodeNumber"], season_id: season.id)

      unless episode.name?
        tvdb_episode = first_match.get_episode(season.number, episode.number)
        if tvdb_episode && !tvdb_episode.name.nil?
          episode.name = tvdb_episode.name
          episode.save
        end
      end
      
      @scrobble = Scrobble.new(user_id: current_user.id, episode_id: episode.id)
      
      respond_to do |format|
        if @scrobble.save
          filename_history.scrobble_id = @scrobble.id
          filename_history.save
          @scrobble.create_activity action: 'create', owner: current_user
          
          format.any { render json: @scrobble, status: :ok }
        else
          format.any { render json: @scrobble, status: :unprocessable_entity }
        end      
      end
      return
    else
      puts "Movies are unsupported right now"
    end
    
    respond_to do |format|
      format.json { render json: "bok" }
    end
  end


  # POST /scrobbles
  # def create
  #   params.require(:filename)
    
  #   info = JSON.parse(`python guess.py #{params[:filename]}`)
  #   puts info
  #   if info["type"] == "episode"
  #     show = Show.find_or_create_by(name: info["series"])
  #     season = Season.find_or_create_by(number: info["season"], show_id: show.id)
  #     episode = Episode.find_or_create_by(number: info["episodeNumber"], season_id: season.id)
      
  #     @scrobble = Scrobble.new(user_id: current_user.id, episode_id: episode.id)
      
  #     respond_to do |format|
  #       if @scrobble.save
  #         @scrobble.create_activity action: 'create', owner: current_user
          
  #         format.json { render json: @scrobble, status: :created }
  #         format.xml  { render xml:  @scrobble, status: :created }
  #       else
  #         format.json { render json: @scrobble, status: :unprocessable_entity }
  #         format.xml  { render xml:  @scrobble, status: :unprocessable_entity }
  #       end      
  #     end
  #     return
  #   else
  #     puts "Movies are unsupported right now"
  #   end
    
  #   # @scrobble = Scrobble.new(scrobble_params)
  #   # 
  #   respond_to do |format|
  #     format.json { render json: "bok" }
  #   #   if @scrobble.save
  #   #     format.json { render json: @scrobble, status: :created }
  #   #     format.xml  { render xml:  @scrobble, status: :created }
  #   #     # redirect_to @scrobble, notice: 'Scrobble was successfully created.'
  #   #   else
  #   #     format.json { render json: @scrobble, status: :unprocessable_entity }
  #   #     format.xml  { render xml:  @scrobble, status: :unprocessable_entity }
  #   #     
  #   #     # render action: 'new'
  #   #   end      
  #   end
  # end

  # PATCH/PUT /scrobbles/1
  def update
    if @scrobble.update(scrobble_params)
      redirect_to @scrobble, notice: 'Scrobble was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /scrobbles/1
  def destroy
    @scrobble.destroy
    redirect_to scrobbles_url, notice: 'Scrobble was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scrobble
      @scrobble = Scrobble.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def scrobble_params
      params.require(:scrobble).permit(:user_id, :episode_id)
    end
end

class GameEntries < Application
  before :ensure_authenticated
  before :find_game, :only=>:new
  before :find_team, :only=>:new
  before :find_entry, :exclude =>:new
  before :ensure_author, :only => [:accept, :reject]
  before :ensure_captain, :exclude => [:accept, :reject]

  def new
    if @game.can_request?
      @game_entry = GameEntry.new
      @game_entry.status = "new"
      @game_entry.game = @game
      @game_entry.team_id = @team.id
      @game_entry.save
      @game.reserve_place_for_team!
    end
    redirect url(:dashboard)
  end

  def reopen
    if @game.can_request?
      if @entry.status != "accepted"
        @entry.status = "new"
        @entry.save
      end
      @game.reserve_place_for_team!
    end
    redirect url(:dashboard)
  end
  
  def accept
    if @entry.status == "new"
       @entry.status = "accepted"
       @entry.save
    end
    redirect url(:dashboard)
  end
  
  def reject
    if @entry.status == "new"
       @entry.status = "rejected"
       @entry.save
    end
    @game.free_place_of_team!
    redirect url(:dashboard)
  end

  def recall
    if @entry.status == "new"
       @entry.status = "recalled"
       @entry.save
    end
    @game.free_place_of_team!
    redirect url(:dashboard)
  end

  def cancel
    if @entry.status == "accepted"
      @entry.status = "canceled"
      @entry.save
    end
    @game.free_place_of_team!
    redirect url(:dashboard)
  end

protected
  def find_game
    @game = Game.find(params[:game_id])
  end
  
  def find_team
    @team = Team.find(params[:team_id])
  end

  def find_entry
    @entry = GameEntry.find(params[:id])
    if @entry
      @game = Game.find(@entry.game.id)
    end
  end

  def ensure_captain
    if current_user.captain? && @game.created_by?(current_user)
      return true
    else
      return false
    end
  end
end
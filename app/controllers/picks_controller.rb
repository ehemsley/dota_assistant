class PicksController < ApplicationController
  COMPOSITION = {
    'ideal_balanced_vector' => '2-1-2',
    'ideal_jungling_vector' => 'Jungling',
    'ideal_trilane_vector' => 'Trilane'
  }

  respond_to :html, :js

  def hero_picker
    @heroes = Hero.all
  end

  def recommendation
    @friendlies = Hero.where(id: params[:friendlies])
    @enemies = Hero.where(id: params[:enemies])
    @bans = Hero.where(id: params[:bans])

    @recommendation, @worst = Recommendations.pick_recommendations @friendlies, @enemies, @bans, params[:composition].upcase
    @ban_recommendations = (Recommendations.pick_recommendations @enemies, @friendlies, @bans, 'IDEAL_BALANCED_VECTOR').first

    @composition = COMPOSITION[params[:composition]]

    respond_to do |format|
      format.json
    end
  end

  def remaining_heroes
    @remaining = Hero.where.not(id: params[:friendlies] + params[:enemies] + params[:bans])
    respond_to do |format|
      format.json
    end
  end
end

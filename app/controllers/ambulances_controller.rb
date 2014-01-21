class AmbulancesController < ApplicationController
  before_action :set_ambulance, only: [:show, :edit, :update, :destroy]


  def home
  end

  def search
    @dest_loc                 = params[:patient_loc]
    emergency_type            = params[:emergency_type].to_i
    @emergency_label          = Ambulance.emergency_label(emergency_type)
    free_ambs                 = Ambulance.select { |a| a.free? }

    @ambs                     = free_ambs.select {|a| emergency_type <= a.equipment_level }
    @amb_prox_pairs           = @ambs.zip( @ambs.map {|a| a.proximity(@dest_loc) } )
    @amb_prox_pairs.sort! { |ap1, ap2| ap1[1] <=> ap2[1] }

    if @amb_prox_pairs.nil? or @amb_prox_pairs.first[1] > 30
      @amb_prox_pairs         = free_ambs.zip( free_ambs.map {|a| a.proximity(@dest_loc) } )
      @amb_prox_pairs.sort! { |ap1, ap2| (emergency_type-ap1[0].equipment_level)*10 + ap1[1] <=> (emergency_type-ap2[0].equipment_level)*10 + ap2[1] }
    end

    render 'results'
  end

  # GET /ambulances
  # GET /ambulances.json
  def index
    @ambulances = Ambulance.all
  end

  # GET /ambulances/1
  # GET /ambulances/1.json
  def show
  end

  # GET /ambulances/new
  def new
    @ambulance = Ambulance.new
  end

  # GET /ambulances/1/edit
  def edit
  end

  # POST /ambulances
  # POST /ambulances.json
  def create
    @ambulance = Ambulance.new(ambulance_params)
    respond_to do |format|
      if @ambulance.save
        format.html { redirect_to @ambulance, notice: 'Ambulance was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ambulance }
      else
        format.html { render action: 'new' }
        format.json { render json: @ambulance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ambulances/1
  # PATCH/PUT /ambulances/1.json
  def update
    respond_to do |format|
      if @ambulance.update(ambulance_params)
        format.html { redirect_to @ambulance, notice: 'Ambulance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ambulance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ambulances/1
  # DELETE /ambulances/1.json
  def destroy
    @ambulance.destroy
    respond_to do |format|
      format.html { redirect_to ambulances_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ambulance
      @ambulance = Ambulance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ambulance_params
      params[:ambulance].permit(:current_loc, :free, :equipment_level)
    end
end

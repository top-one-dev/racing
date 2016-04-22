class StageEffortsController < ApplicationController
	before_action :set_stage_effort

	def new
		@stage_effort = StageEffort.new		
	end

	def create
		@stage_effort = @stage.stage_efforts.build(stage_effort_params)
		@stage_effort.cyclist = @cyclist

	    respond_to do |format|
	      if @stage_effort.save
	      	update_points1
	        format.html { redirect_to stage_results_path(@race, @stage), notice: 'Stage Effort was successfully created.' }
	        format.json { render :show, status: :created, location: @segment }
	      else
	        format.html { render :new }
	        format.json { render json: @segment.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit

	end

	def update				
		respond_to do |format|
	      if @stage_effort.update(stage_effort_params)	      		      	
	      	update_points1	      		      	
	        format.html { redirect_to stage_results_path(@race, @stage), notice: 'Stage Effort was successfully updated.' }
	        format.json { render :show, status: :ok, location: @segment }
	      else
	        format.html { render :edit }
	        format.json { render json: @segment.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@stage_effort.destroy
	    respond_to do |format|
	      #update_points1
	      format.html { redirect_to stage_results_path(@race, @stage), notice: 'Segment was successfully destroyed.' }
	      format.json { head :no_content }
	    end
	end

	#private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_stage_effort      	      
		    @race = Race.find(params[:race_id])
		    @stage = @race.stages.find(params[:stage_id]) unless @race.nil?
		    @cyclist = @race.cyclists.find(params[:cyclist_id]) unless @race.nil?
			@cyclists = @race.cyclists
			@cyclists = sort_cyclists_stage(@cyclists, @stage)

		    if params[:id].present?
		    	@stage_effort = @cyclist.stage_efforts.find(params[:id]) unless @cyclist.nil?
		    end
	    end

	    def update_points1
	    	@cyclists = @race.cyclists
			@cyclists = sort_cyclists_stage(@cyclists, @stage)			
			index_temp = 0
			elapsed_time_temp = 0
	    	@cyclists.each_with_index do |cyclist, index|	  	    	  	
	    		stage_effort = cyclist.stage_efforts.find_by(stage_id: @stage)	    		
	    		if stage_effort
		    		#elapsed_time = 0
		    		elapsed_time = stage_effort.elapsed_time.to_i #if stage_effort
		    		#To dispaly 1,1, 3, 4, ..
		    		if elapsed_time > elapsed_time_temp
		    			index_temp = index + 1
		    			elapsed_time_temp = elapsed_time
		    		end
		    		if index_temp > 0	    			
		    			#stage_effort.update! points: points_in_stage(index_temp)
		    			stage_effort.update! points: index_temp	    			
		    		end
		    	end
	    	end
	    end

		def update_points(race, stage)
		    cyclists = race.cyclists
		    cyclists = sort_cyclists_stage(cyclists, stage)      
		    index_temp = 0
		    elapsed_time_temp = 0
		    cyclists.each_with_index do |cyclist, index|               
		      stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)          
		      if stage_effort
		        elapsed_time = 0
		        elapsed_time = stage_effort.elapsed_time.to_i #if stage_effort
		        if elapsed_time > elapsed_time_temp
		          index_temp = index + 1
		          elapsed_time_temp = elapsed_time
		        end
		        if index_temp > 0           
		          #stage_effort.update! points: points_in_stage(index_temp)
		          stage_effort.update! points: index_temp       
		        end
		      end
		    end
		end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def stage_effort_params
	    	params.require(:stage_effort).permit(:strava_activity_url)
	    end
end
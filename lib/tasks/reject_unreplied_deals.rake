desc "Reject all deals when are unreaponded even on the start day"
task :reject_unreplied_deals => :enviroment do
	@deals = Deal.state(0).where(:start_date => Date.current)

	@deals.each do |deal|
		deal.state = 2
		deal.save
	end
end
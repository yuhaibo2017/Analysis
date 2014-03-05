type Vector3{T}
	x::T
	y::T
	z::T
end

type CellError <: Exception

end

typealias TimePoints{T<:Real} AbstractArray{T,1}


##############################
type Spike
	channel::Uint64
	fs::Float64
	value::Vector{Float64}
	time::Float64
	delay::Float64
	sort
end

type SpikeTrain
	name::String
	spikes::Vector{Spike}
end

type Channel
	name::String
	index::Uint64
	coordinate::Vector3{Float64}
	signal
	spiketrains::Vector{SpikeTrain}
end

type ChannelCluster
	name::String
	channels::Vector{Channel}
end

type AnalogSignal
	name::String
	description
	channel::Uint64
	fs::Float64
	value::Vector{Float64}
	startime::Float64
end

type Event
	name::String
	value
	time::Float64
end

type EventSeries
	name::String
	events::Vector{Event}
end

type Epoch
	name::String
	time::Float64
	duration::Float64
	value
end

type EpochSeries
	name::String
	epochs::Vector{Epoch}
end

type Cell
	name::String
	celltype
	coordinate::Vector3{Float64}
	spiketrain::Vector{Float64}
end

type CellAssemble
	name::String
	cells::Vector{Cell}
end

type Block
	name::String
	description
	source
	startime
	stoptime
	duration
	settings::Dict
	eventseriesgroup::Vector{EventSeries}
	epochseriesgroup::Vector{EpochSeries}
	cellassemblegroup::Vector{CellAssemble}
	channelclustergroup::Vector{ChannelCluster}
end

type RecordSession
	name::String
	description
	region
	date
	experimenters::Vector{String}
	blocks::Vector{Block}
end

type Subject
	name::String
	description
	contact
	gender
	age
	height
	weight
	recordsessions::Vector{RecordSession}
end

type Experiment
	name::String
	description
	designers::Vector{String}
	subjects::Vector{Subject}
end

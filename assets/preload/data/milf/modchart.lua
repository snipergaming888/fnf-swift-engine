function start(song) -- do nothing

end

function update(elapsed)
        local currentBeat = (songPos / 1000)*(bpm/60)
		setWindowPos(math.sin((currentBeat + i*0.25) * math.pi),math.cos((currentBeat + i*0.25) * math.pi))
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing

end
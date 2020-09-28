-- Copy and paste these snippets into the console to respawn a deck
-- lua spawnOpportunities()
function spawnOpportunities(n)
    local random_url_arg = "&v=" .. math.random() -- break the image cache on TTS
    spawnObject({
        type = "DeckCustom",
        position = {x=0, y=10, z=0},
        rotation = {x=0, y=180, z=0}
    }).setCustomObject({
        face = "https://dl.dropbox.com/s/0qnpj6c504lsrkg/tts_sheet_opportunities_00.png?dl=1" .. random_url_arg,
        back = "https://dl.dropbox.com/s/3aaaw3h8smj92ts/tts_opportunity_back_00.png?dl=1" .. random_url_arg,
        width = 10,
        height = 7,
        number = n,
        unique_back = false,
        back_is_hidden = true
    })
end

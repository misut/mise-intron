local http = require("http")
local json = require("json")

function PLUGIN:Available(ctx)
    local resp, err = http.get({
        url = "https://api.github.com/repos/misut/intron/releases",
    })
    if err ~= nil or resp.status_code ~= 200 then
        error("failed to fetch releases: " .. (err or ("HTTP " .. resp.status_code)))
    end

    local releases = json.decode(resp.body)
    local result = {}

    for _, release in ipairs(releases) do
        if not release.draft and not release.prerelease then
            local version = release.tag_name:gsub("^v", "")
            table.insert(result, { version = version })
        end
    end

    return result
end

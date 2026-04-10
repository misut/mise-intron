local http = require("http")
local json = require("json")

function PLUGIN:Available(ctx)
    local headers = {}
    local token = os.getenv("GITHUB_TOKEN") or os.getenv("GH_TOKEN")
    if token then
        headers["Authorization"] = "token " .. token
    end

    local resp, err = http.get({
        url = "https://api.github.com/repos/misut/intron/releases",
        headers = headers,
    })
    if err ~= nil or resp.status_code ~= 200 then
        local msg = "failed to fetch releases: " .. (err or ("HTTP " .. resp.status_code))
        if resp and resp.status_code == 403 then
            msg = msg .. "\nhint: set GITHUB_TOKEN to avoid rate limiting"
        end
        error(msg)
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

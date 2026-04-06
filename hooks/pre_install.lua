local platform_map = {
    ["darwin-arm64"]  = "aarch64-apple-darwin",
    ["linux-amd64"]   = "x86_64-linux-gnu",
    ["linux-arm64"]   = "aarch64-linux-gnu",
    ["windows-amd64"] = "x86_64-pc-windows-msvc",
}

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local key = RUNTIME.osType .. "-" .. RUNTIME.archType
    local platform = platform_map[key]
    if not platform then
        error("unsupported platform: " .. key)
    end

    local ext = (RUNTIME.osType == "windows") and ".zip" or ".tar.gz"
    local filename = "intron-v" .. version .. "-" .. platform .. ext

    return {
        version = version,
        url = "https://github.com/misut/intron/releases/download/v"
            .. version .. "/" .. filename,
    }
end

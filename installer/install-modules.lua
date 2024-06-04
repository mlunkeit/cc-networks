-- Modules to download
local files = {
    lan = "https://github.com/mlunkeit/cc-networks/raw/main/modules/lan.lua",
    netutil = "https://github.com/mlunkeit/cc-networks/raw/main/modules/netutil.lua",
    json = "https://github.com/rxi/json.lua/raw/master/json.lua"
}

function download(url, path)
    local response = http.get(url)
    local content = response.getAll()
    local file = fs.open(path, "w+")
    file.write(content)
    file.close()
    response.close()
end

for name, url in pairs(files) do
    download(url, "/rom/modules/main/"..name..".lua")
end
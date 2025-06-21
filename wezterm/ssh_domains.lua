local M = {}

-- make a file in this this folder and call it "doms.lua"
-- this file is gitignored
-- return {
--   {
--     name = "production-server",
--     remote_address = "user@prod.company.com",
--     multiplexing = "WezTerm",
--   },
--   {
--     name = "dev-environment",
--     remote_address = "user@dev.company.com",
--     multiplexing = "None",
--   },
-- }
local success, domains = pcall(require, "doms")

-- Need to fill these in per machine
M.ssh_domains = {}
if success then
	M.ssh_domains = domains
end

return M

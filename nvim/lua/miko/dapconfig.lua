local dap = require("dap")
dap.configurations.java = {
    {
        name = "Debug Launch (2GB)",
        type = "java",
        request = "launch",
        vmArgs = "" .. "-Xmx2g ",
    },
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote 5005",
        hostName = "127.0.0.1",
        port = 5005,
    },
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 8000,
    },
    {
        name = "",
        type = "java",
        request = "launch",

        -- classPaths = {},

        mainClass = "main.class",

        vmArgs = "" .. "-Xmx2g ",
    },
}

local home = vim.env.HOME

-- dotnet dap
dap.adapters.coreclr = {
    type = "executable",
    command = home .. "/.local/share/nvim/mason/bin/netcoredbg",
    args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
        cwd = function()
            return vim.fn.getcwd()
        end,
    },
    {
        type = "coreclr",
        name = "launch - sfm server",
        request = "launch",
        program = home .. "/gitlab/SFM/src/web/SFM.Server/SFM.Server/bin/Debug/net10.0/SFM.Server.dll",
        cwd = home .. "/gitlab/SFM/src/",
        env = vim.tbl_extend("force", vim.env, {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_CONTENTROOT = home .. "/gitlab/SFM/src/web/SFM.Server/SFM.Server",
            ASPNETCORE_URLS = "http://localhost:5010",
            SFM_DIAGNOSTICS_ON = "true",
        }),
    },
}

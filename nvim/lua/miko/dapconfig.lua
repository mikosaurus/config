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
